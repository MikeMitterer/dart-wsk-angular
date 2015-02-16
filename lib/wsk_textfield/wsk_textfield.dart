library wsk_angulart.wsk_textfield;

import 'dart:html' as html;

import "package:angular/angular.dart";
import 'package:angular/core/annotation_src.dart';

import 'package:logging/logging.dart';
import 'package:validate/validate.dart';

import 'package:wsk_material/wskcomponets.dart';
import 'package:wsk_angular/wsk_angular.dart';

/**
 * WskTextfield Module.
 *    Weitere Infos: https://docs.angulardart.org/#di.Module
 */
class WskTextfieldModule extends Module {
    WskTextfieldModule() {

        bind(WskTextfieldContainerComponent);
        bind(WskTextfieldComponent);
        bind(WskTextfieldErrorComponent);
        bind(WskTextfieldExpandableIconComponent);

        //- Services ---------------------------
    }
}

/// WskTextfieldContainerComponent
@Decorator(selector: "wsk-textfield-container")
class WskTextfieldContainerComponent {
    final Logger _logger = new Logger('wsk_angulart.wsk_textfield.WskTextfieldComponent');

    final html.Element _component;
    WskTextfieldErrorComponent _textfielderror = null;
    WskTextfieldExpandableIconComponent _expandableIcon = null;

    WskTextfieldContainerComponent(this._component) {
        _component.classes.add("wsk-input");

        if(WskAngularUtils.hasAttributeOrClass(_component,[ 'right' ])) {
            _component.classes.add("wsk-input--right");
        }
        if(WskAngularUtils.hasAttributeOrClass(_component,[ 'large' ])) {
            _component.classes.add("wsk-input--large");
        }
    }

    // - private ----------------------------------------------------------------------------------

    bool get _hasErrorTag => (_textfielderror != null);
    bool get _hasIcon => (_expandableIcon != null);

    void _setErrorTag(final WskTextfieldErrorComponent textfielderror) {
        Validate.notNull(textfielderror);
        _textfielderror = textfielderror;
    }

    void _setIcon(final WskTextfieldExpandableIconComponent icon) {
        Validate.notNull(icon);
        _expandableIcon = icon;
    }
}

/// WskTextfieldComponent
@Component(selector: 'wsk-textfield', useShadowDom: false, templateUrl: 'packages/wsk_angular/wsk_textfield/wsk_textfield.html')
class WskTextfieldComponent extends WskAngularComponent {
    final Logger _logger = new Logger('wsk_angulart.wsk_textfield.WskTextfieldComponent');

    final html.Element _component;
    final WskTextfieldContainerComponent _container;

    WskTextfieldComponent(final WskTextfieldContainerComponent container, final html.Element component)
    : super(component, materialTextfieldConfig(), [ materialRippleConfig() ]),
    _component = component, _container = container {

        Validate.notNull(_container,"You must have a surrounding wsk-textfield-container if you use wsk-textfield");
        Validate.notNull(component);
    }

    String get pattern => _component.attributes.containsKey("pattern") ?
        _component.attributes["pattern"] : ".*";

    bool get isDisabled => WskAngularUtils.hasAttributeOrClass(_component, [ "disabled" , "is-disabled"]);

    bool get hasFloatingLabel => WskAngularUtils.hasAttributeOrClass(_component, [ "floating-label" ]);

    bool get hasRows => _component.attributes.containsKey("rows");

    bool get hasIcon => _container._hasIcon;

    String get rows => _component.attributes["rows"];

    String get maxRows => _component.attributes.containsKey("maxrows") ? _component.attributes["maxrows"] : "";

    String get name => _component.attributes.containsKey("name") ? _component.attributes["name"] : hashCode.toString();

    String get id => name;

    /// Moves wsk-textfield-error and wsk-textfield-expandable-icon into its right place
    void preUpgrade(final html.Element component) {
        if(_container._hasErrorTag) {
            _moveErrorTagIntoDiv();
        }

        if(_container._hasIcon) {
            _moveIconIntoFirstLabel();
        }
    }


    // - EventHandler -----------------------------------------------------------------------------

    // - private ----------------------------------------------------------------------------------

    void _moveErrorTagIntoDiv() {
        final html.Element error = _container._component.querySelector("wsk-textfield-error");
        error.remove();
        final html.DivElement div = _component.querySelector("div");
        div.append(error);
    }

    void _moveIconIntoFirstLabel() {
        final html.Element icon = _container._component.querySelector("wsk-textfield-expandable-icon");
        icon.remove();
        final html.Element label = _component.querySelector(".wsk-textfield-expandable-icon");
        label.append(icon);
    }
}

/// WskTextfieldErrorComponent
@Decorator(selector: "wsk-textfield-error")
class WskTextfieldErrorComponent {
    final Logger _logger = new Logger('wsk_angulart.wsk_textfield.WskTextfieldErrorComponent');

    final html.Element _component;
    final WskTextfieldContainerComponent _container;

    WskTextfieldErrorComponent(this._container,this._component) {
        Validate.notNull(_container,"You must have a surrounding wsk-textfield-container if you use wsk-textfield-error");
        Validate.notNull(_component);

        _component.classes.add("wsk-input__error");
        _container._setErrorTag(this);
    }
}


/// WskTextfieldErrorComponent
@Decorator(selector: "wsk-textfield-expandable-icon")
class WskTextfieldExpandableIconComponent {
    final Logger _logger = new Logger('wsk_angulart.wsk_textfield.WskTextfieldExpandableIconComponent');

    final html.Element _component;
    final WskTextfieldContainerComponent _container;

    WskTextfieldExpandableIconComponent(this._container,this._component) {
        Validate.notNull(_container,"You must have a surrounding wsk-textfield-container if you use wsk-textfield-expandable-icon");
        Validate.notNull(_component);

        _container._setIcon(this);
    }
}