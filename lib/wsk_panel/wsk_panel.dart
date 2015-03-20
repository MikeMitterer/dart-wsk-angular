library wsk_angular.wsk_panel;

import 'dart:html' as html;

import "package:angular/angular.dart";
import 'package:angular/core/annotation_src.dart';

import 'package:logging/logging.dart';
import 'package:validate/validate.dart';

import 'package:wsk_material/wskcomponets.dart';
import 'package:wsk_angular/wsk_angular.dart';

/**
 * WskPanel Module.
 *    Weitere Infos: https://docs.angulardart.org/#di.Module
 */
class WskPanelModule extends Module {
    WskPanelModule() {
    
        bind(WskPanelComponent);
        
        //- Services ---------------------------
    }
}

/// Store strings for class names defined by this component that are used in Dart.
class _WskBadgeCssClasses {

    final String PANEL = 'wsk-panel';

    const _WskBadgeCssClasses();
}

/// WskPanelComponent
@Component( selector: 'wsk-panel', useShadowDom: false)
class WskPanelComponent  {
    final Logger _logger = new Logger('wsk_angular.wsk_panel.WskPanelComponent');

    static const _cssClasses = const _WskBadgeCssClasses();

    final html.Element _component;

    WskPanelComponent(this._component) {
        Validate.notNull(_component);
        _component.classes.add(_cssClasses.PANEL);
    }

    // - EventHandler -----------------------------------------------------------------------------
    
    // - private ----------------------------------------------------------------------------------
}
        