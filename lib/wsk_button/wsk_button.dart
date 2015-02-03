library wsk_angular.wsk_button;

import 'dart:html' as html;
import "dart:async";

import "package:angular/angular.dart";
import 'package:angular/core/annotation_src.dart';

import 'package:logging/logging.dart';

//---------------------------------------------------------
// Extra packages (piepag) (http_utils, validate, signer)
//---------------------------------------------------------
import 'package:validate/validate.dart';

//---------------------------------------------------------
// WebApp-Basis (piwab) - webapp_base_dart
//---------------------------------------------------------

//---------------------------------------------------------
// UI-Basis (pibui) - webapp_base_ui
//---------------------------------------------------------
//import 'package:webapp_base_ui/events.dart';

// __ interfaces

// __ tools
//   __ conroller
//   __ decorators
//   __ services

//   __ component

//---------------------------------------------------------
// MobiAd UI (pimui) - mobiad_rest_ui
//---------------------------------------------------------

// __ interfaces
// __ tools
//   __ conroller
//   __ decorators
//   __ services
//   __ component
import 'package:wsk_material/wskcomponets.dart';


/**
 * Button Module.
 *    Weitere Infos: https://docs.angulardart.org/#di.Module
 */
class WskButtonModule extends Module {
    WskButtonModule() {
        // install(new XYModule());

        bind(WskButtonComponent);

        //- Services ---------------------------
    }
}

// @formatter:off    
/// ButtonComponent-Componente
@Component(
    selector: 'wsk-button',
    useShadowDom: true,
    templateUrl: 'wsk_button.html',
    cssUrl: "wsk_button.css")
// @formatter:on    
class WskButtonComponent implements AttachAware , ShadowRootAware  {
    final _logger = new Logger('wsk_angular.wsk_button.WskButtonComponent');

    final html.Element _component;
    final VmTurnZone _zone;

    WskButtonComponent(this._component,this._zone) {
        Validate.notNull(_component);
    }

    // - EventHandler -----------------------------------------------------------------------------

    /**
     * Sample:
     *     <button id="sendButton" name="sendButton" ng-click="handleEvent($event)">Send</button>
     */
    void handleEvent(final html.Event e) {
        _logger.info("Event: handleEvent");
    }

    void attach() {
//   1.)
//        _zone.run(() {
//            componenthandler.upgradeElement(_component.querySelector("button"), () {
//                return [ materialButtonConfig(), materialRippleConfig() ];
//            });
//        });

//   2.)
//        new Future(() {
//            componenthandler.upgradeElement(_component.querySelector("button"), () {
//                return [ materialButtonConfig(), materialRippleConfig() ];
//            });
//        });

//   3.)
//        new Timer(new Duration(milliseconds: 50),() {
//            componenthandler.upgradeElement(_component.querySelector("button"), () {
//                return [ materialButtonConfig(), materialRippleConfig() ];
//            });
//        });

//   4.)
//        new Future.delayed(new Duration(milliseconds: 50), () {
//            componenthandler.upgradeElement(_component.querySelector("button"), () {
//                return [ materialButtonConfig(), materialRippleConfig() ];
//            });
//        });

    }

    // 5.)
    void onShadowRoot(final html.ShadowRoot shadowRoot) {
        componenthandler.upgradeElement(shadowRoot.querySelector("button"), () {
            return [ materialButtonConfig(), materialRippleConfig() ];
        });
    }


    // - private ----------------------------------------------------------------------------------
}
        