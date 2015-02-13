library wsk_angular.wsk_tooltip;

import 'dart:html' as html;

import "package:angular/angular.dart";
import 'package:angular/core/annotation_src.dart';

import 'package:logging/logging.dart';
import 'package:validate/validate.dart';

import 'package:wsk_material/wskcomponets.dart';
import 'package:wsk_angular/wsk_angular.dart';

/**
 * WskTooltip Module.
 *    Weitere Infos: https://docs.angulardart.org/#di.Module
 */
class WskTooltipModule extends Module {
    WskTooltipModule() {

        bind(WskTooltipComponent);

        //- Services ---------------------------
    }
}

/// WskTooltipComponent
@Decorator(selector: 'wsk-tooltip' /*, useShadowDom: false, templateUrl: 'packages/wsk_angular/wsk_tooltip/wsk_tooltip.html' */)
class WskTooltipComponent extends WskAngularComponent implements AttachAware {

    final Logger _logger = new Logger('wsk_angular.wsk_tooltip.WskTooltipComponent');

    final html.Element _component;

    WskTooltipComponent(final html.Element component)
    : super(component, materialTooltipConfig(), [ ], false), _component = component {
        Validate.notNull(component);
    }

    void attach() {
        _component.classes.add("wsk-tooltip");
        if(_component.attributes.containsKey("large")) {
            _component.classes.add("wsk-tooltip--large");
        }
        autoUpgrade();
    }


// - EventHandler -----------------------------------------------------------------------------

    // - private ----------------------------------------------------------------------------------
}
        