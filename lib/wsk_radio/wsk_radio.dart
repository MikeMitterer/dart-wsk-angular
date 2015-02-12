library wsk_angular.wsk_radio;

import 'dart:html' as html;

import "package:angular/angular.dart";
import 'package:angular/core/annotation_src.dart';

import 'package:logging/logging.dart';
import 'package:validate/validate.dart';

import 'package:wsk_material/wskcomponets.dart';
import 'package:wsk_angular/wsk_angular.dart';

/**
 * WskRadio Module.
 *    Weitere Infos: https://docs.angulardart.org/#di.Module
 */
class WskRadioModule extends Module {
    WskRadioModule() {

        bind(WskRadioGroupComponent);
        bind(WskRadioComponent);

        //- Services ---------------------------
    }
}

/// WskRadioGroupComponent
@Decorator(selector: 'wsk-radio-group')
class WskRadioGroupComponent  {
    final Logger _logger = new Logger('wsk_angular.wsk_radio.WskRadioGroupComponent');

    String _name;

    @NgTwoWay("ng-model")
    dynamic ngModel;

    @NgAttr("name")
    void set name(final String value) { _name = value; }
    String get name {
        if(_name != null && _name.isNotEmpty) {
            return _name;
        }
        _logger.info("No name provided for wsk-radio-goup - is this really what you want?");
        return "parentHash${hashCode}";
    }

    // - private ----------------------------------------------------------------------------------
}

/// WskRadioComponent
@Component(selector: 'wsk-radio', useShadowDom: false, templateUrl: 'packages/wsk_angular/wsk_radio/wsk_radio.html')
class WskRadioComponent extends WskAngularComponent implements ScopeAware {
    final Logger _logger = new Logger('wsk_angular.wsk_radio.WskRadioComponent');

    /// Parent tag in HTML
    /// Sample:
    ///     <wsk-radio-group>  <wsk-radio>Always</wsk-radio> <wsk-radio>Only when plugged in</wsk-radio> </wsk-radio-group>
    final WskRadioGroupComponent _group;

    final html.Element _component;

    Scope scope;
    dynamic _value;

    WskRadioComponent(this._group, final html.Element component)
    : super(component, materialRadioConfig(), [ materialRippleConfig() ]), _component = component {
        Validate.notNull(component);
    }

    dynamic _disabled;
    @NgOneWay('ng-disabled')
    dynamic get disabled => _disabled == null ? _component.attributes['disabled'] : _disabled;
    set disabled(dynamic value) => _disabled = value;

    @NgOneWay('ng-value')
    void set nGValue(val) { _value = val; }
    dynamic get nGValue => _value;

    @NgAttr("value")
    void set value(final String v) { _value = v; }
    dynamic get value => _value;

    /// Template-Helper to find out if Control is disabled
    bool get isDisabled => WskAngularUtils.isDisabled(disabled);

    void set ngModel(final dynamic value) {
        _logger.fine("Value: $value");

        if(_isSet(_group)) {
            _group.ngModel = value;
        }
    }
    dynamic get ngModel {
        if(_isSet(_group)) {
            return _group.ngModel;
        }
        return null;
    }

    /// Set name after everything else is done!
    void upgraded() {
        _component.querySelector("input").attributes["name"] = _name;
    }

    // - private ----------------------------------------------------------------------------------

    bool _isSet(final dynamic value) => (value != null);

    String get _name {
        if(_isSet(_group)) {
            return "${_group.name}[]";
        }
        return hashCode;
    }

}
        