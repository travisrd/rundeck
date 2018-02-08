package rundeck.services

import com.dtolabs.rundeck.app.support.trigger.TriggerCreate
import com.dtolabs.rundeck.app.support.trigger.TriggerUpdate
import com.dtolabs.rundeck.core.authorization.UserAndRolesAuthContext
import com.dtolabs.rundeck.plugins.ServiceNameConstants
import com.dtolabs.rundeck.server.plugins.ConfiguredPlugin
import com.dtolabs.rundeck.server.plugins.DescribedPlugin
import com.dtolabs.rundeck.server.plugins.ValidatedPlugin
import grails.transaction.Transactional
import groovy.transform.ToString
import org.rundeck.core.triggers.*
import org.springframework.context.ApplicationContext
import org.springframework.context.ApplicationContextAware
import rundeck.TriggerEvent
import rundeck.TriggerRep

import java.time.ZoneId

@Transactional
class TriggerService implements ApplicationContextAware, TriggerActionInvoker<RDTriggerContext> {

    def pluginService
    def frameworkService
    ApplicationContext applicationContext
    private Map<String, TriggerConditionHandler<RDTriggerContext>> condRegistrationMap = [:]
    private Map<String, TriggerActionHandler<RDTriggerContext>> actRegistrationMap = [:]
    /**
     * handle defined triggers needing system startup hook
     */
    void init() {
        log.info("Startup: initializing trigger Service")
        def serverNodeUuid = frameworkService.serverUUID
        Map<String, TriggerConditionHandler<RDTriggerContext>> startupHandlers = triggerConditionHandlerMap?.findAll {
            it.value.onStartup()
        }
        log.debug("Startup: TriggerService: startupHandlers: ${startupHandlers}")
        def triggers = listEnabledTriggersForMember(serverNodeUuid)
        //TODO: passive mode behavior
        log.debug("Startup: TriggerService: triggers: ${triggers}")
        triggers.each { TriggerRep trigger ->
            def validation=validateTrigger(trigger)
            if(validation.error) {
                log.warn("Validation failed for Trigger ${trigger.uuid} at startup: " + validation.validation)
                return
            }
            def condition = conditionFor(trigger)
            RDTriggerContext triggerContext = contextForTrigger(trigger)
            TriggerConditionHandler<RDTriggerContext> bean = startupHandlers.find {
                it.value.handlesConditionChecks(condition, triggerContext)
            }?.value
            if (bean) {
                def action = actionFor(trigger)
                bean.registerConditionChecksForAction(
                        trigger.uuid,
                        triggerContext,
                        condition,
                        action,
                        this
                )
                condRegistrationMap[trigger.uuid] = bean
                log.warn("Startup: registered condition handler for: ${trigger.uuid} with conditionType: ${trigger.conditionType}")
            } else {
                log.warn("Startup: No TriggerConditionHandler instance found to handle this trigger: ${trigger.uuid} with conditionType: ${trigger.conditionType}")
            }
        }

    }

    public RDTriggerContext contextForTrigger(TriggerRep trigger) {
        UserAndRolesAuthContext authContext = frameworkService.getAuthContextForUserAndRolesAndProject(
                trigger.authUser,
                trigger.authRoleList.split(',').toList(),
                trigger.project
        )
        new RDTriggerContext(clusterContextInfo + [project: trigger.project, authContext: authContext])
    }

    public Map<String, DescribedPlugin<TriggerCondition>> getTriggerConditionPluginDescriptions() {
        pluginService.listPlugins(TriggerCondition)
    }

    public Map<String, DescribedPlugin<TriggerAction>> getTriggerActionPluginDescriptions() {
        pluginService.listPlugins(TriggerAction)
    }

    public DescribedPlugin<TriggerAction> getTriggerActionPlugin(String provider) {
        pluginService.getPluginDescriptor(provider, TriggerAction)
    }

    public ConfiguredPlugin<TriggerAction> getConfiguredActionPlugin(String provider, Map config) {
        //TODO: project scope
        pluginService.configurePlugin(provider, config, TriggerAction)
    }

    public ValidatedPlugin getValidatedActionPlugin(String provider, Map config) {
        //TODO: project scope
        pluginService.validatePluginConfig(provider, TriggerAction, config)
    }

    public DescribedPlugin<TriggerCondition> getTriggerConditionPlugin(String provider) {
        pluginService.getPluginDescriptor(provider, TriggerCondition)
    }

    public ConfiguredPlugin<TriggerCondition> getConfiguredConditionPlugin(String provider, Map config) {
        //TODO: project scope
        pluginService.configurePlugin(provider, config, TriggerCondition)
    }

    public ValidatedPlugin getValidatedConditionPlugin(String provider, Map config) {
        //TODO: project scope
        pluginService.validatePluginConfig(provider, TriggerCondition, config)
    }
    /**
     * Map of installed trigger handlers
     * @return
     */
    public Map<String, TriggerConditionHandler<RDTriggerContext>> getTriggerConditionHandlerMap() {
        return pluginService.listPlugins(TriggerConditionHandler).collectEntries { [it.key, it.value.instance] }
    }

    /**
     * Map of installed trigger handlers
     * @return
     */
    public Map<String, TriggerActionHandler<RDTriggerContext>> getTriggerActionHandlerMap() {
        pluginService.listPlugins(TriggerActionHandler).collectEntries { [it.key, it.value.instance] }

    }

    public Map getClusterContextInfo() {
        [
                clusterModeEnabled: frameworkService.isClusterModeEnabled(),
                serverNodeUUID    : frameworkService.serverUUID
        ]
    }

    public List<TriggerRep> listEnabledTriggers() {
        TriggerRep.findAllByEnabled(true)
    }

    public List<TriggerRep> listEnabledTriggersForMember(String serverNodeUuid) {
        if (serverNodeUuid) {
            TriggerRep.findAllByEnabledAndServerNodeUuid(true, serverNodeUuid)
        } else {
            listEnabledTriggers()
        }
    }

    public List<TriggerRep> listEnabledTriggersByProject(String project) {
        TriggerRep.findAllByEnabledAndProject(true, project)
    }

    TriggerCondition conditionFor(TriggerRep rep) {
        def condition = getConfiguredConditionPlugin(rep.conditionType, rep.conditionConfig)
        if (!condition) {
            throw new IllegalArgumentException("Unknown condition type: ${rep.conditionType}")
        }
        return condition.instance
    }

    TriggerAction actionFor(TriggerRep rep) {
        def action = getConfiguredActionPlugin(rep.actionType, rep.actionConfig)
        if (!action) {
            throw new IllegalArgumentException("Unknown action type: ${rep.actionType}")
        }
        return action.instance
    }

    ValidatedPlugin validateActionFor(TriggerRep rep) {
        rep.actionType ? getValidatedActionPlugin(rep.actionType, rep.actionConfig) : null
    }

    ValidatedPlugin validateConditionFor(TriggerRep rep) {
        rep.conditionType ? getValidatedConditionPlugin(rep.conditionType, rep.conditionConfig) : null
    }

    private def registerTrigger(TriggerRep trigger, boolean enabled) {

        def condition = conditionFor(trigger)
        def action = actionFor(trigger)
        def triggerContext = contextForTrigger(trigger)
        TriggerConditionHandler condHandler = getConditionHandlerForTrigger(trigger, condition, triggerContext)

        if (!condHandler) {
            log.warn("No TriggerConditionHandler instance found to handle this trigger: ${trigger.uuid} with conditionType: ${trigger.conditionType}")
            return
        }

        if (enabled) {
            condHandler.registerConditionChecksForAction(
                    trigger.uuid,
                    triggerContext,
                    condition,
                    action,
                    this
            )
            condRegistrationMap[trigger.uuid] = condHandler

        } else {

            condHandler.deregisterConditionChecksForAction(
                    trigger.uuid,
                    triggerContext,
                    condition,
                    action,
                    this
            )
            condRegistrationMap.remove trigger.uuid
        }
    }

    public TriggerConditionHandler<RDTriggerContext> getConditionHandlerForTrigger(TriggerRep trigger, TriggerCondition condition, RDTriggerContext triggerContext) {
        condRegistrationMap[trigger.uuid] ?: triggerConditionHandlerMap.find {
            it.value.handlesConditionChecks(condition, triggerContext)
        }?.value
    }

    public TriggerActionHandler<RDTriggerContext> getActionHandlerForTrigger(TriggerRep trigger, TriggerAction action, RDTriggerContext triggerContext) {
        actRegistrationMap[trigger.uuid] ?: triggerActionHandlerMap.find {
            it.value.handlesAction(action, triggerContext)
        }?.value
    }

    def createTrigger(
            UserAndRolesAuthContext authContext,
            TriggerCreate input,
            Map conditionMap,
            Map actionMap,
            Map userData
    ) {
        def rep = new TriggerRep(
                uuid: UUID.randomUUID().toString(),
                name: input.name,
                description: input.description,
                project: input.project,
                conditionType: input.conditionType,
                conditionConfig: conditionMap,
                actionType: input.actionType,
                actionConfig: actionMap,
                userData: userData,
                enabled: input.enabled,
                userCreated: authContext.username,
                userModified: authContext.username,
                authUser: authContext.username,
                authRoleList: authContext.roles.join(','),
                serverNodeUuid: frameworkService.serverUUID
        )
        def result = validateTrigger(rep)
        if (result.error) {
            return result
        }
        rep.save(flush: true)
        registerTrigger rep, rep.enabled
        return [error: false, trigger: rep]
    }

    Map validateTrigger(TriggerRep rep) {
        rep.validate()
        def validation = [:]
        //validate plugin config

        ValidatedPlugin actionValidate = validateActionFor(rep)
        if (!actionValidate && rep.actionType) {
            //plugin provider not found
            rep.errors.rejectValue(
                    'actionType',
                    'plugin.not.found.0',
                    [rep.actionType].toArray(),
                    'Plugin not found: {0}'
            )
        } else if (actionValidate && !actionValidate.valid) {
            validation[ServiceNameConstants.TriggerAction] = actionValidate.report.errors
        }

        ValidatedPlugin condValidate = validateConditionFor(rep)
        if (!condValidate && rep.conditionType) {
            //plugin provider not found
            rep.errors.rejectValue(
                    'conditionType',
                    'plugin.not.found.0',
                    [rep.conditionType].toArray(),
                    'Plugin not found: {0}'
            )
        } else if (condValidate && !condValidate.valid) {
            validation[ServiceNameConstants.TriggerCondition] = condValidate.report.errors
        }
        if (rep.hasErrors() || validation) {
            return [error: true, trigger: rep, validation: validation]
        }
        return [error: false, trigger: rep]
    }

    Map updateTrigger(
            UserAndRolesAuthContext authContext,
            TriggerRep trigger,
            TriggerUpdate input,
            Map conditionDataMap,
            Map actionDataMap,
            Map userDataMap
    ) {
        trigger.with {
            name = input.name
            description = input.description
            conditionType = input.conditionType
            conditionConfig = conditionDataMap
            actionType = input.actionType
            actionConfig = actionDataMap
            userData = userDataMap
            enabled = input.enabled
            userModified = authContext.username
            authUser = authContext.username
            authRoleList = authContext.roles.join(',')
            serverNodeUuid = frameworkService.serverUUID
        }
        def result = validateTrigger(trigger)
        if (result.error) {
            trigger.discard()

            return result
        }
        trigger.save(flush: true)
        registerTrigger trigger, trigger.enabled

        return [error: false, trigger: trigger]
    }

    boolean deleteTrigger(TriggerRep trigger) {
        registerTrigger trigger, false
        trigger.delete(flush: true)
        true
    }

    /**
     * Submit a condition to indicate a trigger
     * @param triggerId
     * @param conditionMap
     */
    void triggerConditionMet(String triggerId, RDTriggerContext contextInfo, Map conditionMap) {
        def trigger = TriggerRep.findByUuid(triggerId)

        def event = new TriggerEvent(
                eventDataMap: conditionMap,
                timeZone: ZoneId.systemDefault().toString(),
                eventType: 'fired',
                triggerRep: trigger
        )
        event.save(flush: true)

        def action = actionFor(trigger)
        def condition = conditionFor(trigger)

        TriggerActionHandler actHandler = getActionHandlerForTrigger(trigger, action, contextInfo)
        //TODO: on executor

        try {
            def result = actHandler.performTriggerAction(triggerId, contextInfo, conditionMap, condition, action)
            def event2 = new TriggerEvent(
                    eventDataMap: result,
                    timeZone: ZoneId.systemDefault().toString(),
                    eventType: 'result',
                    triggerRep: trigger,
                    associatedId: result?.associatedId,
                    associatedType: result?.associatedType,
                    associatedEvent: event
            )
            event2.save(flush: true)
        } catch (Throwable t) {
            log.error("Failed to run trigger action for $triggerId: $t.message", t)
            def event2 = new TriggerEvent(
                    eventDataMap: [error: t.message],
                    timeZone: ZoneId.systemDefault().toString(),
                    eventType: 'error',
                    triggerRep: trigger,
                    associatedEvent: event
            )
            event2.save(flush: true)
        }
    }


    Trigger createTrigger(TriggerRep triggerRep) {
        TriggerCondition conditionRep = conditionFor(triggerRep)
        TriggerAction actionRep = actionFor(triggerRep)
        new TriggerImpl(
                name: triggerRep.name,
                description: triggerRep.description,
                id: triggerRep.uuid,
                userData: triggerRep.userData,
                condition: conditionRep,
                action: actionRep
        )
    }
}

class TriggerImpl implements Trigger {
    String name
    String description
    String id
    Map userData
    TriggerCondition condition
    TriggerAction action
}


@ToString(includeFields = true, includeNames = true)
class RDTriggerContext {
    String project
    String serverNodeUUID
    boolean clusterModeEnabled
    UserAndRolesAuthContext authContext
}

