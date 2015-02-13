library wsk_angular.wsk_spinner;

import 'dart:html' as html;

import "package:angular/angular.dart";
import 'package:angular/core/annotation_src.dart';

import 'package:logging/logging.dart';
import 'package:validate/validate.dart';

import 'package:wsk_material/wskcomponets.dart';
import 'package:wsk_angular/wsk_angular.dart';

/**
 * WskSpinner Module.
 *    Weitere Infos: https://docs.angulardart.org/#di.Module
 */
class WskSpinnerModule extends Module {
    WskSpinnerModule() {

        bind(WskSpinnerComponent);

        //- Services ---------------------------
    }
}

/// WskSpinnerComponent
@Component(selector: 'wsk-spinner', useShadowDom: false, templateUrl: 'packages/wsk_angular/wsk_spinner/wsk_spinner.html')
class WskSpinnerComponent extends WskAngularComponent {
    final Logger _logger = new Logger('wsk_angular.wsk_spinner.WskSpinnerComponent');

    final html.Element _component;

    WskSpinnerComponent(final html.Element component)
    : super(component, materialSpinnerConfig(), [ materialRippleConfig() ]), _component = component {
        Validate.notNull(component);
    }

    String _isActive;
    @NgAttr("active")
    set active(final dynamic value) => _isActive = value;
    bool get active => WskAngularUtils.hasAttributeOrClass(_isActive,_component,"is-active");

    dynamic _singleColor;
    @NgAttr("single-color")
    set singleColor(final dynamic value) => _singleColor = value;
    bool get singleColor => WskAngularUtils.hasAttributeOrClass(_singleColor,_component,"single-color");

    void upgraded() {
        active = true;
    }

    String get activation {
        if(active) {
            return "is-active";
        }
        return "";
    }

// - EventHandler -----------------------------------------------------------------------------

    // - private ----------------------------------------------------------------------------------
}
        