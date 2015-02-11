library wsk_angular.wsk_item;

import 'dart:html' as html;

import "package:angular/angular.dart";
import 'package:angular/core/annotation_src.dart';

import 'package:logging/logging.dart';
import 'package:validate/validate.dart';

import 'package:wsk_material/wskcomponets.dart';
import 'package:wsk_angular/wsk_angular.dart';

/**
 * WskItem Module.
 *    Weitere Infos: https://docs.angulardart.org/#di.Module
 */
class WskItemModule extends Module {
    WskItemModule() {

        //bind(WskItemComponent);
        bind(WskItemDecorator);

        //- Services ---------------------------
    }
}

// @formatter:off    
/// WskItemComponent
@Component( selector: 'wsk-item', useShadowDom: false,  templateUrl: 'packages/wsk_angular/wsk_item/wsk_item.html')
// @formatter:on    
class WskItemComponent extends WskAngularComponent {
    final Logger _logger = new Logger('wsk_angular.wsk_item.WskItemComponent');

    WskItemComponent(final html.Element component)
    : super(component, materialItemConfig(), [  ]) {
        Validate.notNull(component);
    }

    @NgAttr("disabled")
    String disabled;

    @NgOneWay("isDisabled")
    bool get isDisabled => (_isSet(disabled) && (disabled.isEmpty || disabled == "true"));

    // - EventHandler -----------------------------------------------------------------------------

    // - private ----------------------------------------------------------------------------------

    bool _isSet(final dynamic value) => (value != null);
}

/// WskItemDecorator
@Decorator(selector: '[wsk-item]')
class WskItemDecorator extends WskAngularComponent implements AttachAware {
    final _logger = new Logger('wsk_anuglar.wsk_item.WskItemDecorator');

    final html.Element _component;

    WskItemDecorator(final html.Element component)
        : super(component,materialItemConfig(), [ materialRippleConfig() ] ,false), _component = component {
        Validate.notNull(_component);
    }

    attach() {
        _component.classes.add("wsk-item");
        _component.classes.add("wsk-js-ripple-effect");
        autoUpgrade();
    }
}
