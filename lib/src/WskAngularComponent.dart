part of wsk_angular;

class WskAngularComponent {
    final _logger = new Logger('wsk_angular.WskAngularComponent');

    static const int _TIMEOUT_IN_MS = 2000;

    final html.Element _component;
    final List<WskConfig> _configs = new List<WskConfig>();

    WskAngularComponent(this._component,
                        final WskConfig mainConfig,[ final List<WskConfig> additionalConfigs = const [],
                        final bool upgradeAutomatically = true ] ) {

        Validate.notNull(_component);
        Validate.notNull(mainConfig);
        Validate.notNull(additionalConfigs);

        _configs.add(mainConfig);
        _configs.addAll(additionalConfigs);

        if(upgradeAutomatically) {
            autoUpgrade();
        }
    }

    WskConfig get mainconfig => _configs[0];

    String get classToUpgrade => mainconfig.cssClass;

    /// Informs component about the final upgrade-state
    void upgraded() {}

    /// Callback if Angular has loaded it's template
    void upgrade(final html.HtmlElement component) {
        _logger.fine("Found $component with class '${classToUpgrade}'");

        componenthandler.upgradeElement(component, () {
            return _configs;
        });
    }

    /// Waits for Angular to load the template, search for the component defined in mainConfig (CTOR)
    void autoUpgrade() {
        _waitForComponentToLoad();
    }

    /// returns the component to upgrade
    html.HtmlElement get componentToUpgrade {
        // 1 - check if _component HAS children (at least one...) with _classToUpgrade
        html.HtmlElement component  = _component.querySelector(".$classToUpgrade");

        if (component == null) {

            // 2 - check if _component IS!!! the element to upgrade
            if (_component.classes.contains(classToUpgrade)) {
                component = _component;
            }
        }
        //_logger.info("componentToUpgrade: $component");
        return component;
    }

    // - private ----------------------------------------------------------------------------------

    /// If autoUpgrade in the Constructor is false you can upgrade the component manually
    void _waitForComponentToLoad({ final int inMilliSeconds: 30} ) {
        if (inMilliSeconds >= _TIMEOUT_IN_MS) {
            throw new TimeoutException("Could not find a component with css-class: ${classToUpgrade}");
        }

        _logger.finer("Next check for component - in: ${inMilliSeconds}ms");
        new Future.delayed(new Duration(milliseconds: inMilliSeconds), () {
            _logger.finer(" - cssClass: .${mainconfig.cssClass}");

            html.HtmlElement component = componentToUpgrade;
            if (component == null) {
                _logger.finer("Classes: ${_component.classes}");
                throw "Component for .${classToUpgrade} not ready yet, try it again...";
            }
            _logger.fine("Found componentToUpgrade: $component");
            return component;

        }).then((final html.HtmlElement component) {
            upgrade(component);
            upgraded();

        }).catchError((_) {
            _waitForComponentToLoad(inMilliSeconds: inMilliSeconds < 100 ? inMilliSeconds + 5 : inMilliSeconds * 2);
        });
    }
}
