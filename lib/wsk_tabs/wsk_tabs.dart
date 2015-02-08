library wsk_angular.wsk_tabs;

import 'dart:html' as html;

import "package:angular/angular.dart";
import 'package:angular/core/annotation_src.dart';

import 'package:logging/logging.dart';
import 'package:validate/validate.dart';

import 'package:wsk_material/wskcomponets.dart';
import 'package:wsk_angular/wsk_angular.dart';


/**
 * WskTabs Module.
 *    Weitere Infos: https://docs.angulardart.org/#di.Module
 */
class WskTabsModule extends Module {
    WskTabsModule() {
        // install(new XYModule());

        bind(WskTabsComponent);
        bind(WskTabBarComponent);
        bind(WskTabComponent);
        bind(WskTabsPanelComponent);

        //- Services ---------------------------
    }
}

// @formatter:off    
/// WskTabsComponent
@Component( selector: 'wsk-tabs', useShadowDom: false,  templateUrl: 'packages/wsk_angular/wsk_tabs/wsk_tabs.html')
// @formatter:on    
class WskTabsComponent extends WskAngularComponent {
    final Logger _logger = new Logger('wsk_angular.wsk_tabs.WskTabsComponent');

    WskTabsComponent(final html.Element component)
        : super(component,materialTabsConfig(), [ materialRippleConfig()]) {
    }
}

/// WskTabsTabBarComponent
@Decorator(selector: 'wsk-tab-bar')
class WskTabBarComponent implements AttachAware {
    final _logger = new Logger('wsk_anuglar.wsk_tabs.WskTabBarComponent');

    final html.Element _component;

    WskTabBarComponent(this._component) {
        Validate.notNull(_component);
    }

    attach() {
        _component.classes.add("wsk-tabs__tab-bar");
    }
}

/// WskTabComponent
@Decorator(selector: 'wsk-tab')
class WskTabComponent  extends WskAngularComponent implements AttachAware {
    final _logger = new Logger('wsk_anuglar.wsk_tabs.WskTabComponent');

    final html.Element _component;

    WskTabComponent(final html.Element component)
        : super(component,materialRippleConfig(),[],false), _component = component {
        Validate.notNull(_component);
    }

    attach() {
        _component.classes.add("wsk-tabs__tab");

        upgrade();
    }
}


/// WskTabsPanelComponent
@Decorator(selector: 'wsk-tabs-panel')
class WskTabsPanelComponent implements AttachAware {
    final _logger = new Logger('wsk_anuglar.wsk_tabs.WskTabsPanelComponent');

    final html.Element _component;

    WskTabsPanelComponent(this._component) {
        Validate.notNull(_component);
    }

    attach() {
        _component.classes.add("wsk-tabs__panel");
    }
}