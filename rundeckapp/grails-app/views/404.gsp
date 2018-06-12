%{--
  - Copyright 2016 SimplifyOps, Inc. (http://simplifyops.com)
  -
  - Licensed under the Apache License, Version 2.0 (the "License");
  - you may not use this file except in compliance with the License.
  - You may obtain a copy of the License at
  -
  -     http://www.apache.org/licenses/LICENSE-2.0
  -
  - Unless required by applicable law or agreed to in writing, software
  - distributed under the License is distributed on an "AS IS" BASIS,
  - WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  - See the License for the specific language governing permissions and
  - limitations under the License.
  --}%

<%--
  Created by IntelliJ IDEA.
  User: greg
  Date: 3/12/14
  Time: 11:36 AM
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head><title><g:appTitle/> - <g:message code="request.error.notfound.title" /></title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="SHORTCUT" href="${g.resource(dir: 'images', file: 'favicon-152.png')}"/>
    <link rel="favicon" href="${g.resource(dir: 'images', file: 'favicon-152.png')}"/>
    <link rel="shortcut icon" href="${g.resource(dir: 'images', file: 'favicon.ico')}"/>
    <link rel="apple-touch-icon-precomposed" href="${g.resource(dir: 'images', file: 'favicon-152.png')}"/>
    <asset:stylesheet href="bootstrap.min.css"/>
    <asset:stylesheet href="app.scss.css"/>
    <!--[if lt IE 9]>
    <asset:javascript src="respond.min.js"/>
    <![endif]-->
    <asset:javascript src="jquery.js"/>
    <asset:javascript src="bootstrap.js"/>
    <asset:javascript src="prototype.min.js"/>
    <style>
        @keyframes riseup {
            0% {bottom: -480px;}
            50% {bottom: -5px;}
            100% {bottom: -40px;}
        }
        svg{
            position: fixed;
            right: calc(50% - 150px);
            bottom: -40px;
            z-index: 9;
            animation: riseup 6s ease-in-out;
        }
        .grumpy{
            fill: #69000c;
        }
    </style>
</head>
<body id="fourohfour">
<div class="wrapper wrapper-full-page">
  <div class="full-page four-oh-four">
  <!-- <div class="full-page login-page" data-color="" data-image="static/img/background/background-2.jpg"> -->
    <div class="content">
      <div class="container">
        <div class="row">
          <div class="col-md-4 col-sm-6 col-md-offset-4 col-sm-offset-3">
              <div class="card" data-background="color" data-color="blue">
                <div class="card-header">
                  <h3 class="card-title">
                    <div class="logo">
                        <a href="${grailsApplication.config.rundeck.gui.titleLink ? enc(attr:grailsApplication.config.rundeck.gui.titleLink) : g.createLink(uri: '/')}"
                           title="Home">
                            <g:set var="appTitle"
                                   value="${grailsApplication.config.rundeck?.gui?.title ?: g.message(code: 'main.app.name',default:'')}"/>
                            <g:set var="appDefaultTitle" value="${g.message(code: 'main.app.default.name',default:'')}"/>
                            <g:set var="brandHtml"
                                   value="${grailsApplication.config.rundeck?.gui?.brand?.html ?: g.message(code: 'main.app.brand.html',default:'')}"/>
                            <g:set var="brandDefaultHtml"
                                   value="${g.message(code: 'main.app.brand.default.html',default:'')}"/>
                            <i class="rdicon app-logo"></i>
                            <g:if test="${brandHtml}">
                                ${enc(sanitize:brandHtml)}
                            </g:if>
                            <g:elseif test="${appTitle}">
                                ${appTitle}
                            </g:elseif>
                            <g:elseif test="${brandDefaultHtml}">
                                ${enc(sanitize:brandDefaultHtml)}
                            </g:elseif>
                            <g:else>
                                ${appDefaultTitle}
                            </g:else>
                        </a>
                    </div>
                  </h3>
                </div>
                <div class="card-content text-center">
                  <div class="h3"><g:message code="request.error.notfound.title"/></div>
                  <div class="text-danger h5">
                      <g:message code="page.notfound.message"/>
                  </div>
                </div>
                <div class="card-footer text-center">
                  URI: <g:enc>${request.forwardURI}</g:enc>

                </div>
              </div>
            </div>
        </div>
      </div>
    </div>
    <g:render template="/common/footer"/>
  </div>
</div>
<svg
        xmlns:dc="http://purl.org/dc/elements/1.1/"
        xmlns:cc="http://creativecommons.org/ns#"
        xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
        xmlns:svg="http://www.w3.org/2000/svg"
        xmlns="http://www.w3.org/2000/svg"
        xmlns:sodipodi="http://sodipodi.sourceforge.net/DTD/sodipodi-0.dtd"
        xmlns:inkscape="http://www.inkscape.org/namespaces/inkscape"
        width="248.07378"
        height="256"
        id="svg2"
        version="1.1"
        inkscape:version="0.48.2 r9819"
        inkscape:export-xdpi="1773.33"
        inkscape:export-ydpi="1773.33"
        sodipodi:docname="grumpy2.svg">
    <sodipodi:namedview
            pagecolor="#ffffff"
            bordercolor="#666666"
            borderopacity="1"
            objecttolerance="10"
            gridtolerance="10"
            guidetolerance="10"
            inkscape:pageopacity="0"
            inkscape:pageshadow="2"
            inkscape:window-width="640"
            inkscape:window-height="480"
            id="namedview7"
            showgrid="false"
            fit-margin-top="0"
            fit-margin-left="0"
            fit-margin-right="0"
            fit-margin-bottom="0"
            inkscape:zoom="2.1015624"
            inkscape:cx="124.03688"
            inkscape:cy="127.99999"
            inkscape:current-layer="layer1"/>
    <defs
            id="defs4"/>
    <metadata
            id="metadata7">
        <rdf:RDF>
            <cc:Work
                    rdf:about="">
                <dc:format>image/svg+xml</dc:format>
                <dc:type
                        rdf:resource="http://purl.org/dc/dcmitype/StillImage"/>
                <dc:title/>
            </cc:Work>
        </rdf:RDF>
    </metadata>
    <g
            inkscape:label="Layer 1"
            inkscape:groupmode="layer"
            id="layer1"
            transform="translate(0.1,-503.17702)">
        <path class="grumpy"
              d="m 243.69019,758.77688 c -1.57432,-27.87542 -23.40854,-49.92084 -24.33312,-77.99689 -5.69318,-22.60054 -13.13223,-45.10327 -14.70782,-68.47356 -5.61562,-6.76459 -15.35946,-10.48255 -15.65971,-19.50135 4.5861,-7.84661 -5.18038,3.00259 -0.50092,-5.73162 4.02678,-9.60967 -6.67057,-5.38418 -3.10273,-12.76257 4.386,-3.10669 -7.02881,-0.53696 -7.44528,-5.06551 -7.56152,3.67406 2.38265,-3.74217 -4.92951,-1.12189 4.32486,-3.06313 -4.15908,-0.88083 0.9519,-3.09368 -3.01346,0.16743 -8.53201,2.95928 -4.31758,-1.93782 -7.98965,-2.55509 -4.57526,-2.37449 -7.60357,-5.42512 -9.26244,-0.79467 -16.14502,-4.39259 -25.78117,-8.92147 -20.58696,-6.61349 -42.996114,-3.39446 -63.807515,0.77714 -5.601757,3.95167 -13.89118,-1.6033 -12.927238,4.93429 -3.423227,1.21931 -3.961349,-2.63901 -5.605202,1.69984 -6.100652,-5.13373 0.77224,3.11869 -4.368574,-0.9859 2.682366,8.43882 -11.166825,-5.95489 -14.900642,-8.73609 -2.641432,-3.72151 -19.797226,-11.62266 -7.296936,-4.19175 5.438327,4.10994 19.127114,13.95099 17.217061,16.87145 3.077371,5.4325 -7.185795,0.30272 -1.831571,6.48912 -1.571078,-1.04972 -22.687581,-18.91404 -10.035728,-7.18651 6.606804,4.19017 15.305401,14.63167 6.869787,19.46356 -0.302728,5.43504 -1.671515,12.22165 6.515879,5.09844 4.338794,-4.69359 8.466993,-10.99901 14.987024,-6.74303 5.418679,-6.2963 8.875053,0.75307 15.927445,-3.82888 3.592802,-3.57211 8.325291,-8.57457 6.385003,0.39096 -2.97441,6.02003 -6.92389,10.52031 -5.467093,17.79726 -1.109169,-9.95564 -2.452826,9.80735 -1.141549,12.51343 -2.317423,10.09362 -6.177504,17.17728 -14.632914,23.19158 -7.338999,3.34034 -15.88822,13.35648 -22.635131,12.47266 -9.175226,-6.22826 -27.216571,-5.92548 -20.315425,-21.30117 0.220748,-13.23248 4.972397,-26.04145 12.353543,-36.96502 -0.142492,-9.70427 -6.291958,-19.60619 -8.29519,-28.93967 -5.493182,-8.43449 -11.141193,-19.80542 -9.070739,-30.16727 6.047532,-6.26633 15.745078,6.12757 20.935581,9.80326 7.851898,5.85782 15.802402,14.10851 24.025127,17.70641 30.037043,-7.92592 63.409407,-12.07753 92.753467,0.78778 16.4562,-8.22777 23.90977,-26.73618 37.88953,-38.0627 8.17629,-8.90695 26.62171,-13.17961 30.77426,1.90438 4.87167,15.00136 4.05251,31.64223 0.43233,46.81575 -4.43874,9.02709 -8.22821,27.63406 -9.60193,31.80443 2.82008,-4.77065 4.73783,-10.24833 3.11547,-1.37528 -1.04339,9.96178 -4.78575,18.93605 0.69216,27.82469 0.29108,12.33468 1.18079,24.66018 4.32607,36.7451 3.86069,20.52665 7.72821,41.2952 17.32471,60.08485 6.0934,13.76141 12.11497,28.27773 11.12202,43.64434 -1.29099,-0.0757 -3.85721,0.46952 -4.28358,-0.30597 z M 50.419067,614.63095 c 21.075047,-3.28453 -3.121609,-26.28207 -12.009324,-12.85074 -4.756205,8.37037 3.951431,15.39688 12.009324,12.85074 z m -4.997512,-3.60365 c -9.0223,-8.17811 6.418647,-18.52504 4.284179,-3.70417 0.0114,2.29865 -1.577501,5.49091 -4.284179,3.70417 z M 206.22585,593.55301 c -1.18132,-2.58892 -5.84852,0.89037 0,0 z m 1.0539,-9.96103 c 2.08518,-3.54831 -8.1213,-14.54338 -2.13328,-4.42275 3.46416,1.40703 -1.22917,7.52912 2.13328,4.42275 z m -11.59287,-11.2189 c -4.73878,-2.60609 -3.14834,-6.03114 0.84142,-3.89687 -6.30884,-4.26107 -5.5896,-6.67625 0.96041,-1.81457 10.19235,6.27176 0.17461,-1.023 -2.00156,-5.41398 6.46542,3.27477 3.22456,-3.6236 7.58976,-3.77363 2.5151,-3.45254 -1.89155,-9.10659 1.61909,-7.13081 -2.41513,-6.19365 -12.85763,-11.49955 -6.36588,-11.29965 -2.61501,-6.95962 -10.84138,-4.1891 -6.20014,0.66294 -4.3879,-1.87738 -6.09002,-4.08965 -3.16169,0.87116 -8.21124,-6.12401 6.4437,10.154 -3.34443,3.57815 -5.16871,3.50863 -5.37161,1.82349 -12.93148,5.26099 -1.31791,0.79114 10.6678,1.79961 0.59069,4.1221 1.76817,1.66215 14.22299,3.06611 4.0711,1.98455 0.71461,1.4878 -3.95039,2.19587 -4.39189,2.47285 5.49709,5.83546 15.00488,7.8504 20.6508,13.52684 0.40331,1.54679 1.30125,0.61554 2.0738,0.84993 z m 2.24378,-21.92786 c -8.80631,-6.99523 7.66317,4.50464 0.034,0.034 l -0.034,-0.034 z m -5.1335,-4.04561 c -7.79021,-5.02607 2.78482,-2.8688 -1.75029,-3.27165 1.01013,1.54644 6.6816,4.48375 1.75029,3.27165 z m -157.676599,7.2073 c -4.280502,-4.9189 -6.418746,-0.87835 0,0 z m 168.113579,-8.32919 c -3.58005,-6.77904 -2.15261,0.40766 0,0 z m -22.19983,-0.54394 c -2.08236,-3.48841 -5.9159,0.50927 0,0 z m 27.23134,-2.37977 c 7.10026,-3.16418 8.02955,-10.28913 4.30057,-18.49844 -8.95121,-6.79934 -5.56981,6.64317 -7.78949,13.62841 -0.18954,1.53211 1.26417,6.75678 3.48892,4.87003 z m -11.59286,-10.30099 c -6.96438,-6.7391 -6.32484,-1.16595 0,0 z m 4.35157,-0.98591 c -2.75505,-6.49902 -7.73905,-5.6888 -0.9859,-0.27197 2.86283,3.45603 0.20973,0.2213 0.9859,0.27197 z M 33.28474,756.26112 C 22.159526,755.99743 11.065424,755.29076 -0.1,755.71717 c 5.9612553,-10.08904 12.499231,-20.1871 13.176469,-32.27987 1.534756,-18.66682 3.344825,-37.48393 2.801971,-56.17949 -0.90502,-10.08661 11.190949,-9.71036 18.810129,-11.70688 4.489375,2.58738 4.496242,12.29909 13.910616,11.52309 0.59048,10.00697 13.199228,17.62034 23.535265,18.74173 7.029006,4.65279 22.259943,-3.24323 24.724085,3.16594 -8.159216,4.25747 -23.474924,2.70358 -28.49453,4.14175 9.915361,7.02666 21.453238,11.84786 33.830865,9.98237 5.89948,7.05042 -6.145396,12.809 -12.403395,11.05467 -7.188577,-1.70063 -16.904604,-2.04236 -22.816022,0.18274 10.286646,2.41716 -3.667322,4.28657 -3.467661,4.31757 2.150555,4.76891 -16.475389,6.76001 -4.061538,7.21261 8.41982,0.39645 23.240273,12.94301 6.496221,11.59878 -4.392026,0.0235 -23.678208,1.70634 -9.20002,2.47054 7.044114,-0.0701 11.2014,5.25832 16.046433,4.75953 1.235551,2.60986 23.900236,0.10388 10.378549,5.5165 -8.876686,-1.11925 -0.814835,8.85782 -10.782168,6.17616 -12.958577,0.10749 -26.601996,0.11539 -39.100529,-0.13379 z M 66.023543,713.4593 c -1.769006,-4.47601 -12.545734,1.9898 -1.529851,0.30597 l 1.74658,0.31872 -0.216729,-0.62469 0,0 z m 70.237137,-27.94527 c -11.37362,-2.97027 -23.99494,-7.65541 -29.20633,-19.20547 -6.07492,-10.36644 -12.833014,-23.08365 -26.882876,-22.21205 -12.317545,-3.03967 -31.004988,7.24199 -26.590716,21.32548 -5.989885,7.38509 -5.870238,-14.82038 0.349529,-17.94865 2.07361,-7.19543 27.802856,-9.11384 13.284733,-14.9187 -15.906609,-6.65068 6.830487,-19.05629 14.582983,-9.32253 11.444536,5.62785 -1.73031,7.16676 -3.059702,13.08872 12.826341,3.63574 23.260269,12.38544 29.033169,24.6136 0.0381,9.12337 11.41863,15.41013 19.24584,10.12676 5.68508,-12.48529 17.86408,7.60279 27.45438,6.66362 12.6907,4.68383 -16.40084,10.01504 -18.21101,7.78922 z m 19.58209,-9.07711 c -7.39691,-2.97649 -22.55939,-7.99312 -23.81467,-14.29986 4.32442,-6.38356 17.44292,-1.04798 22.38681,3.99886 0.89077,1.75755 8.46431,13.19913 1.42786,10.301 z m -3.50166,-14.61858 c -7.15078,-4.19461 -18.71748,-2.88654 -20.34276,-8.03012 8.16183,-0.19419 16.32692,-0.11441 24.49036,-0.16308 -2.39658,1.80582 -2.08783,8.45441 -4.1476,8.1932 z M 16.59237,657.87473 c -2.454658,-7.78059 -1.470421,-13.7689 8.004226,-10.56733 6.854075,-1.96832 19.280433,4.88518 6.59197,7.20418 -4.55767,0.10856 -11.441847,4.28235 -14.596196,3.36315 z m 113.41293,-6.56136 c 0.72278,-11.19182 -18.68404,-13.7544 -25.43377,-22.0511 -9.032573,-4.63971 -6.182778,-14.37248 -9.157443,-21.10647 -4.467463,-8.86967 -2.247727,-17.6258 -3.757051,-28.94939 2.096793,2.25442 3.123923,-12.65636 6.357379,-3.5739 1.802642,14.05302 8.908805,-2.33543 12.340795,-5.23124 6.51559,1.24982 2.49819,6.46843 8.90713,8.77115 7.04915,1.64723 9.62875,7.06574 7.10531,12.03483 11.10175,7.65347 27.4061,-0.67251 35.24075,11.60614 7.88108,2.43555 12.90384,13.46238 4.28039,15.99915 -2.6447,10.62261 6.44055,23.46579 -6.21289,31.07297 -2.72789,4.4118 -8.92345,1.39106 -13.30262,2.27778 -5.44466,0 -10.88933,0 -16.33399,0 l 0,-0.67994 -0.034,-0.16998 z m 0.37396,-32.36484 c 14.06015,-2.25432 13.72904,-24.24589 -0.76068,-16.72211 5.20897,6.12237 -3.23994,17.64736 -5.90268,6.38712 2.40899,-18.53093 -18.06862,6.24091 -2.57153,9.20673 2.86116,0.67957 6.47284,1.91165 9.23489,1.12826 z M 29.885072,646.11188 c -7.512738,-0.83104 -18.482383,2.52354 -14.491085,-9.60832 -2.850435,-14.62311 16.229529,0.98387 22.52705,3.17445 -2.235982,5.79929 -0.570903,8.67069 -8.035965,6.43387 z m 48.037309,-54.80265 c -0.543458,-5.12755 3.69799,-10.75135 5.099502,-15.06053 6.579568,2.32308 2.103593,16.88769 -5.099502,15.06053 z M 53.376778,555.10276 c -3.653107,-6.72089 4.13286,3.55308 0,0 z"
              id="path3050"
              inkscape:connector-curvature="0"/>
    </g>
</svg>
</body>
</html>
