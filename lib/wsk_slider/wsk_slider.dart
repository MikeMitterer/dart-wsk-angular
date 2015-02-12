library wsk_angular.wsk_slider;

import 'dart:html' as html;

import "package:angular/angular.dart";
import 'package:angular/core/annotation_src.dart';

import 'package:logging/logging.dart';
import 'package:validate/validate.dart';

import 'package:wsk_material/wskcomponets.dart';
import 'package:wsk_angular/wsk_angular.dart';

/**
 * WskSlider Module.
 *    Weitere Infos: https://docs.angulardart.org/#di.Module
 */
class WskSliderModule extends Module {
    WskSliderModule() {

        bind(WskSliderComponent);

        //- Services ---------------------------
    }
}

/// WskSliderComponent
@Component(selector: 'wsk-slider', useShadowDom: false, templateUrl: 'packages/wsk_angular/wsk_slider/wsk_slider.html')
class WskSliderComponent extends WskAngularComponent {
    final Logger _logger = new Logger('wsk_angular.wsk_slider.WskSliderComponent');

    final html.Element _component;

    WskSliderComponent(final html.Element component)
    : super(component, materialSliderConfig()), _component = component {
        Validate.notNull(component);
    }

    dynamic _min;
    @NgAttr("min")
    set min(final dynamic value) => _min = value;
    get min => WskAngularUtils.asInt(_min == null ? 0 : _min);

    dynamic _max;
    @NgAttr("max")
    set max(final dynamic value) => _max = value;
    get max => WskAngularUtils.asInt(_max == null ? 100 : _max,defaultValue: 100);

    @NgTwoWay('ng-model')
    dynamic model;

    @NgOneWay('ng-value')
    void set value(final val) { model = val; }
    get value => WskAngularUtils.asInt(model == null ? _component.attributes["value"] : model);

    dynamic _disabled;
    @NgTwoWay('ng-disabled')
    set disabled(dynamic value) => _disabled = value;
    dynamic get disabled => WskAngularUtils.isDisabled(
        _disabled == null ? _component.attributes['disabled'] : _disabled);

    @NgTwoWay('ng-change')
    dynamic change;

    // - private ----------------------------------------------------------------------------------
}
        