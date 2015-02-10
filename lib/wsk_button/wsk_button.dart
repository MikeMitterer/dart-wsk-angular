library wsk_angular.wsk_button;

import 'dart:html' as html;
import "dart:async";

import "package:angular/angular.dart";
import 'package:angular/core/annotation_src.dart';

import 'package:logging/logging.dart';
import 'package:validate/validate.dart';

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
class WskButtonComponent extends WskAngularComponent implements AttachAware {
    final _logger = new Logger('wsk_angular.wsk_button.WskButtonComponent');

    WskButtonComponent(final html.Element component)
        : super(component,materialButtonConfig(),[ materialRippleConfig() ],false) {
        Validate.notNull(component);
    }

    @NgAttr('ripple')
    String ripple = "";
    bool get withRippleEffect => (ripple == null || ripple != "off");

    @NgAttr('raised')
    String raised = "";
    bool get isRaised => (raised != null);

    @NgAttr('colored')
    String colored = "";
    bool get isColored => (colored != null);

    @NgAttr('fab')
    String fab = "";
    bool get isFabButton => (fab != null || isMiniFabButton);

    @NgAttr('minifab')
    String minifab = "";
    bool get isMiniFabButton => (minifab != null);

    @NgAttr('icon')
    String icon = "";
    bool get withIcon => (icon != null);

    @NgAttr('disabled')
    String disabled = "";
    bool get isDisabled => (disabled != null);

    // - EventHandler -----------------------------------------------------------------------------

    /**
     * Sample:
     *     <button id="sendButton" name="sendButton" ng-click="handleEvent($event)">Send</button>
     */
    void handleEvent(final html.Event e) {
        _logger.info("Event: handleEvent");
    }

    void attach() {
        upgrade();
    }


// - private ----------------------------------------------------------------------------------
}
        