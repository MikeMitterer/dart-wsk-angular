library wsk_angular.wsk_checkbox;

import 'dart:html' as html;

import "package:angular/angular.dart";
import 'package:angular/core/annotation_src.dart';

import 'package:logging/logging.dart';
import 'package:validate/validate.dart';

import 'package:wsk_material/wskcomponets.dart';
import 'package:wsk_angular/wsk_angular.dart';


/**
 * WskCheckbox Module.
 *    Weitere Infos: https://docs.angulardart.org/#di.Module
 */
class WskCheckboxModule extends Module {
    WskCheckboxModule() {

        bind(WskCheckboxComponent);

        //- Services ---------------------------
    }
}

// @formatter:off    
/// WskCheckboxComponent
@Component( selector: 'wsk-checkbox', useShadowDom: false,  templateUrl: 'packages/wsk_angular/wsk_checkbox/wsk_checkbox.html')
// @formatter:on    
class WskCheckboxComponent extends WskAngularComponent {
    final Logger _logger = new Logger('wsk_angular.wsk_checkbox.WskCheckboxComponent');

    dynamic ngInternalModel;

    WskCheckboxComponent(final html.Element component)
        : super(component,materialCheckboxConfig(), [ materialRippleConfig() ]) {
        Validate.notNull(component);
    }

    @NgTwoWay("ng-model")
    void set ngModel(final dynamic value) {
        if(value is bool) {
            ngInternalModel = value;
            return;
        }

        ngInternalModel = (value == ngTrueValue);
    }
    dynamic get ngModel {
        if(_isSet(ngTrueValue) && (ngInternalModel == ngTrueValue || ngInternalModel == true)) {
            return ngTrueValue;
        }
        else if(_isSet(ngFalseValue) && (ngInternalModel == ngFalseValue || ngInternalModel == false)) {
            return ngFalseValue;
        }
        return ngInternalModel;
    }

    @NgOneWay("ng-true-value")
    dynamic ngTrueValue;

    @NgOneWay("ng-false-value")
    dynamic ngFalseValue;

    @NgAttr("disabled")
    String disabled;

    @NgOneWay("isDisabled")
    bool get isDisabled => (_isSet(disabled) && (disabled.isEmpty || disabled == "true"));

    // - private ----------------------------------------------------------------------------------

    bool _isSet(final dynamic value) => (value != null);
}
        