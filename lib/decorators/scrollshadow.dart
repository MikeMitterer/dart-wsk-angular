library wsk_angular.decorators.scrollshadow;

import 'dart:html' as dom;
import 'package:angular/angular.dart';

import 'package:logging/logging.dart';
import 'package:validate/validate.dart';

/// Store strings for class names defined by this component that are used in Dart.
class _ScrollShadowCssClasses {
    final String ADD_SCROLLSHADOW_HERE = 'wsk-add-scrollshadow-here';
    final String SHADOW = "wsk-shadow--z2";

    const _ScrollShadowCssClasses();
}

@Decorator(selector: '[scrollshadow]')
class ScrollShadow {
    final _logger = new Logger('wsk_angular.decorators.navactivator');

    static const _ScrollShadowCssClasses _cssClasses = const _ScrollShadowCssClasses();
    /// Number of pixels scrolled down where a shadow should be added
    static const int _DEFAULT_STEP_FOR_SHADOW = 25;

    final dom.Element _element;

    int _cachedNrOfPixels = -1;

    ScrollShadow(this._element) {
        Validate.notNull(_element);
        _addScrollListener(_element);
    }

    @NgAttr('nr-of-pixels')
    String attributeNrOfPixels;

    // - private -------------------------------------------------------------------------------------------------------

    void _addScrollListener(final dom.HtmlElement element) {
        Validate.notNull(element);

        final dom.HtmlElement _elementWithShadow = dom.querySelector(".${_cssClasses.ADD_SCROLLSHADOW_HERE}");
        if(_elementWithShadow == null) {
            _logger.warning("You've add [scrollshadow] but you've not defined where to add it. " +
                                    "Add the ${_cssClasses.ADD_SCROLLSHADOW_HERE} to the corresponding element");
            return;
        }

        element.onScroll.listen((final dom.Event event) {
            final int top = element.scrollTop;

            _logger.fine("scrollTop: $top");
            if(top >= _nrOfPixels) {
                _elementWithShadow.classes.add(_cssClasses.SHADOW);
            } else {
                _elementWithShadow.classes.remove(_cssClasses.SHADOW);
            }
        });
        _logger.info("Listener for 'scrollshadow' added! ($element)");
    }

    int get _nrOfPixels {
        if(_cachedNrOfPixels != -1) {
            return _cachedNrOfPixels;
        }

        if(attributeNrOfPixels == null || attributeNrOfPixels.isEmpty) {
            return _DEFAULT_STEP_FOR_SHADOW;
        }

        _cachedNrOfPixels = int.parse(attributeNrOfPixels);
        if(_cachedNrOfPixels < 0) {
            _cachedNrOfPixels = _DEFAULT_STEP_FOR_SHADOW;
        }
        return _cachedNrOfPixels;
    }
}