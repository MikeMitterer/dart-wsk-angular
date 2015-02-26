library wsk_angular.wsk_accordion;

import 'dart:html' as html;

import "package:angular/angular.dart";
import 'package:angular/core/annotation_src.dart';

import 'package:logging/logging.dart';
import 'package:validate/validate.dart';

import 'package:wsk_angular/services/LoadChecker.dart';

import 'package:wsk_material/wskcomponets.dart';
import 'package:wsk_angular/wsk_angular.dart';

/**
 * WskAccordion Module.
 *    Weitere Infos: https://docs.angulardart.org/#di.Module
 */
class WskAccordionModule extends Module {
    WskAccordionModule() {

        bind(WskAccordionComponent);
        bind(WskAccordionGroupComponent);
        bind(WskAccordionLabelComponent);

        bind(LoadChecker);

        //- Services ---------------------------
    }
}

/// WskAccordionComponent
@Component(selector: 'wsk-accordion-group', useShadowDom: false, templateUrl: 'packages/wsk_angular/wsk_accordion/wsk_accordion_group.html')
class WskAccordionGroupComponent {
    final Logger _logger = new Logger('wsk_angular.wsk_accordion.WskAccordionGroupComponent');

    final html.Element _component;

    WskAccordionGroupComponent(final html.Element component)
    :  _component = component {
        Validate.notNull(component);
    }

    @NgAttr('ripple')
    String ripple = "";
    bool get withRippleEffect => (ripple == null || ripple != "off");

    String _name;
    @NgAttr("name")
    void set name(final String value) { _name = value; }
    String get name {
        if(_name != null && _name.isNotEmpty) {
            return _name;
        }
        _logger.fine("No name provided for wsk-accordion-group - is this really what you want?");
        return "group-hash-${hashCode}";
    }

    String _type;
    @NgAttr("type")
    void set type(final String t) { _type = t; }
    dynamic get type => _type != null && _type.isNotEmpty && _type == "radio" ? "radio" : "checkbox";

    // - EventHandler -----------------------------------------------------------------------------

    // - private ----------------------------------------------------------------------------------
}

/// WskAccordionGroupComponent
@Component(selector: 'wsk-accordion', useShadowDom: false, templateUrl: 'packages/wsk_angular/wsk_accordion/wsk_accordion.html')
class WskAccordionComponent extends WskAngularComponent implements AttachAware {
    final Logger _logger = new Logger('wsk_angular.wsk_accordion.WskAccordionComponent');

    final html.Element _component;
    final WskAccordionGroupComponent _parent;
    WskAccordionLabelComponent _extendedLabel = null;

    WskAccordionComponent(final html.Element component, this._parent, final LoadChecker loadchecker )
    : super(component, materialRippleConfig() , [ ], false ), _component = component {
        Validate.notNull(_component);
        Validate.notNull(_parent,"You must have a surrounding wsk-accordion-group if you use wsk-accordion");
        Validate.notNull(loadchecker);

        loadchecker.check(_component);
    }

    @NgAttr('header')
    String header = "";
    bool get hasHeader => (header != null && header.isNotEmpty);

    @NgAttr('label')
    String label = "";
    bool get hasLabel => (label != null && label.isNotEmpty);

    String get name => (type == "radio" ? _parent.name : "${_parent.name}-${hashCode}");
    String get id => hashCode.toString();
    String get type => _parent.type;
    bool get withRippleEffect => _parent.withRippleEffect;

    /// WskAccordionGroupComponent added some ripples to this component
    void attach() {
        _logger.info("attach accordion");

        if(withRippleEffect) {
            autoUpgrade();
        }
    }

    @override
    void upgraded() {
        _logger.info("Upgrade accordion");
        _moveExtendedLabelIntoLabel();
    }


    // - EventHandler -----------------------------------------------------------------------------

    // - private ----------------------------------------------------------------------------------

    void _moveExtendedLabelIntoLabel() {
        if(_extendedLabel != null && hasLabel == false) {
            final html.Element extendedLabel = _component.querySelector("wsk-accordion-label");
            extendedLabel.remove();

            final html.Element label = _component.querySelector(".wsk-accordion__extended_label");
            label.append(extendedLabel);
        }
    }

}

/// WskAccordionLabelComponent
@Decorator(selector: "wsk-accordion-label")
class WskAccordionLabelComponent {
    final Logger _logger = new Logger('wsk_angulart.wsk_textfield.WskAccordionLabelComponent');

    final html.Element _component;
    final WskAccordionComponent _parent;

    WskAccordionLabelComponent(this._parent,this._component) {
        Validate.notNull(_parent,"You must have a surrounding wsk-accordion-group if you use wsk-accordion-label");
        Validate.notNull(_component);
        _parent._extendedLabel = this;
    }
}