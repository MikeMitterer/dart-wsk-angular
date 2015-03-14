library wsk_angular.wsk_badge;

import 'dart:html' as dom;

import "package:angular/angular.dart";
import 'package:angular/core/annotation_src.dart';

import 'package:logging/logging.dart';
import 'package:validate/validate.dart';

import 'package:wsk_material/wskcomponets.dart';
import 'package:wsk_angular/wsk_angular.dart';

/**
 * WskBadge Module.
 *    Weitere Infos: https://docs.angulardart.org/#di.Module
 */
class WskBadgeModule extends Module {
    WskBadgeModule() {

        bind(WskBadgeComponent);

        //- Services ---------------------------
    }
}

/// Store strings for class names defined by this component that are used in Dart.
class _WskBadgeCssClasses {

    final String BADGE = 'wsk-badge';

    const _WskBadgeCssClasses();
}

/// WskBadgeComponent
@Decorator(selector: 'wsk-badge')
class WskBadgeComponent {
    final Logger _logger = new Logger('wsk_angular.wsk_badge.WskBadgeComponent');

    static const _cssClasses = const _WskBadgeCssClasses();

    final dom.Element _component;

    WskBadgeComponent(this._component) {
        Validate.notNull(_component);
        _component.classes.add(_cssClasses.BADGE);
    }

    // - EventHandler -----------------------------------------------------------------------------

    // - private ----------------------------------------------------------------------------------
}
        