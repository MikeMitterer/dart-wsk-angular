library wsk_angular.wsk_nav_pills;

import 'dart:html' as html;

import "package:angular/angular.dart";
import 'package:angular/core/annotation_src.dart';

import 'package:logging/logging.dart';
import 'package:validate/validate.dart';

import 'package:wsk_material/wskcomponets.dart';
import 'package:wsk_angular/wsk_angular.dart';

/**
 * WskNavPills Module.
 *    Weitere Infos: https://docs.angulardart.org/#di.Module
 */
class WskNavPillsModule extends Module {
    WskNavPillsModule() {
    
        bind(WskNavPillsComponent);
        bind(WskNavPillComponent);

        //- Services ---------------------------
    }
}

/// Store strings for class names defined by this component that are used in Dart.
class _WskNavPillsCssClasses {

    final String PILLS = 'wsk-nav-pills';
    final String PILL = 'wsk-nav-pill';

    const _WskNavPillsCssClasses();
}
   
/// WskNavPillsComponent
@Component( selector: 'wsk-nav-pills', useShadowDom: false)
class WskNavPillsComponent {
    final Logger _logger = new Logger('wsk_angular.wsk_nav_pills.WskNavPillsComponent');

    static const _cssClasses = const _WskNavPillsCssClasses();

    final html.Element _component;
    
    WskNavPillsComponent(this._component) {
        Validate.notNull(_component);
        _component.classes.add(_cssClasses.PILLS);
    }    

    // - EventHandler -----------------------------------------------------------------------------
    
    // - private ----------------------------------------------------------------------------------
}

/// WskNavPillComponent
@Component( selector: 'wsk-nav-pill', useShadowDom: false)
class WskNavPillComponent {
    final Logger _logger = new Logger('wsk_angular.wsk_nav_pill.WskNavPillComponent');

    static const _cssClasses = const _WskNavPillsCssClasses();

    final html.Element _component;

    WskNavPillComponent(this._component) {
        Validate.notNull(_component);
        _component.classes.add(_cssClasses.PILL);
    }

    // - EventHandler -----------------------------------------------------------------------------

    // - private ----------------------------------------------------------------------------------
}
