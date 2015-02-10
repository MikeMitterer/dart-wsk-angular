library wsk_angular.wsk_icon_toggle;

import 'dart:html' as html;

import "package:angular/angular.dart";
import 'package:angular/core/annotation_src.dart';

import 'package:logging/logging.dart';
import 'package:validate/validate.dart';

import 'package:wsk_material/wskcomponets.dart';
import 'package:wsk_angular/wsk_angular.dart';

/**
 * WskIconToggle Module.
 *    Weitere Infos: https://docs.angulardart.org/#di.Module
 */
class WskIconToggleModule extends Module {
    WskIconToggleModule() {

        bind(WskIconToggleComponent);

        //- Services ---------------------------
    }
}

// @formatter:off    
/// WskIconToggleComponent
@Component( selector: 'wsk-icon-toggle', useShadowDom: false,  templateUrl: 'packages/wsk_angular/wsk_icon_toggle/wsk_icon_toggle.html')
// @formatter:on    
class WskIconToggleComponent extends WskAngularCheckbox {
    final Logger _logger = new Logger('wsk_angular.wsk_icon_toggle.WskIconToggleComponent');

    WskIconToggleComponent(final html.Element component)
        : super(component, materialIconToggleConfig() ,  [ materialRippleConfig() ]) {
        Validate.notNull(component);
    }

    // - EventHandler -----------------------------------------------------------------------------

    // - private ----------------------------------------------------------------------------------
}
        