library wsk_angular.wsk_switch;

import 'dart:html' as html;

import "package:angular/angular.dart";
import 'package:angular/core/annotation_src.dart';

import 'package:logging/logging.dart';
import 'package:validate/validate.dart';

import 'package:wsk_material/wskcomponets.dart';
import 'package:wsk_angular/wsk_angular.dart';

/**
 * WskSwitch Module.
 *    Weitere Infos: https://docs.angulardart.org/#di.Module
 */
class WskSwitchModule extends Module {
    WskSwitchModule() {

        bind(WskSwitchComponent);

        //- Services ---------------------------
    }
}

/// WskSwitchComponent
@Component(selector: 'wsk-switch', useShadowDom: false, templateUrl: 'packages/wsk_angular/wsk_switch/wsk_switch.html')
class WskSwitchComponent extends WskAngularComponent {
    final Logger _logger = new Logger('wsk_angular.wsk_switch.WskSwitchComponent');

    final html.Element _component;

    WskSwitchComponent(final html.Element component)
    : super(component, materialSwitchConfig(), [ materialRippleConfig() ]), _component = component {
        Validate.notNull(component);
    }

    @NgTwoWay('ng-model')
    dynamic model;

    dynamic get isDisabled => WskAngularUtils.hasAttributeOrClass( _component, [ "is-disabled", "disabled" ]);

    // - EventHandler -----------------------------------------------------------------------------

    // - private ----------------------------------------------------------------------------------
}
        