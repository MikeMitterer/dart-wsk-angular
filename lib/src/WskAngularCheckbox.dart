part of wsk_angular;

/// Use by WskCheckboxComponent and WskIconToggleComponent
abstract class WskAngularCheckbox extends WskAngularComponent {

    @NgTwoWay("ngInternalModel")
    dynamic ngInternalModel;

    WskAngularCheckbox(final html.Element component, final WskConfig mainConfig,[ final List<WskConfig> additionalConfigs = const [], final bool autoUpgrade = true ] )
        : super(component,mainConfig,additionalConfigs,autoUpgrade);

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

    /// Template-Helper to find out if Control is disabled
    bool get isDisabled => WskAngularUtils.isDisabled(disabled);

    // - private ----------------------------------------------------------------------------------

    bool _isSet(final dynamic value) => (value != null);
}