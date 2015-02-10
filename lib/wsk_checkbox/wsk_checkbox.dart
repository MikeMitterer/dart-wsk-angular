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
class WskCheckboxComponent extends WskAngularCheckbox {
    final Logger _logger = new Logger('wsk_angular.wsk_checkbox.WskCheckboxComponent');

    WskCheckboxComponent(final html.Element component)
        : super(component,materialCheckboxConfig(), [ materialRippleConfig() ]) {
        Validate.notNull(component);
    }
}
        