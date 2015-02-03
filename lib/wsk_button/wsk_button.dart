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
import 'package:wsk_angular/wsk_angular.dart';

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

/// ButtonComponent-Componente
@Component(selector: 'wsk-button', useShadowDom: false, templateUrl: 'packages/wsk_angular/wsk_button/wsk_button.html')
class WskButtonComponent extends WskAngularComponent {
    final _logger = new Logger('wsk_angular.wsk_button.WskButtonComponent');

    WskButtonComponent(final html.Element component)
        : super(component,materialButtonConfig(),[ materialRippleConfig() ]) {
        Validate.notNull(component);
    }

    // - EventHandler -----------------------------------------------------------------------------

    /**
     * Sample:
     *     <button id="sendButton" name="sendButton" ng-click="handleEvent($event)">Send</button>
     */
    void handleEvent(final html.Event e) {
        _logger.info("Event: handleEvent");
    }

    // - private ----------------------------------------------------------------------------------
}
        