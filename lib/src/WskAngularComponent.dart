part of wsk_angular;

class WskAngularComponent {
    final _logger = new Logger('wsk_angular.WskAngularComponent');

    static const int _TIMEOUT_IN_MS = 2000;

    final html.Element _component;
    final List<WskConfig> _configs = new List<WskConfig>();

    WskAngularComponent(this._component, final WskConfig mainConfig,[ final List<WskConfig> additionalConfigs = const [], final bool autoUpgrade = true ] ) {
        Validate.notNull(_component);
        Validate.notNull(mainConfig);
        Validate.notNull(additionalConfigs);

        _configs.add(mainConfig);
        _configs.addAll(additionalConfigs);

        if(autoUpgrade) {
            _upgrade();
        }
    }

    WskConfig get mainconfig => _configs[0];

    /// If autoUpgrade in the Constructor is false you can upgrade the component manually
    void upgrade() {
        _upgrade();
    }

    /// Informs component about the final upgrade-state
    void upgraded() {}

    // - private ----------------------------------------------------------------------------------

    void _upgrade({ final int inMilliSeconds: 20} ) {
        if (inMilliSeconds >= _TIMEOUT_IN_MS) {
            throw new TimeoutException("Could not find a component with css-class: .${mainconfig.cssClass}");
        }

        _logger.fine("Next check for component - in: ${inMilliSeconds}ms");
        new Future.delayed(new Duration(milliseconds: inMilliSeconds), () {
            _logger.fine(" - cssClass: .${mainconfig.cssClass}");

            final html.HtmlElement component = _component.querySelector(".${mainconfig.cssClass}");
            if (component == null) {
                throw "Component for .${mainconfig.cssClass} not ready yet, try it again...";
            }
            return component;

        }).then((final html.HtmlElement component) {
            _logger.fine("Found $component with class '${mainconfig.cssClass}'");

            componenthandler.upgradeElement(component, () {
                return _configs;
            });
            upgraded();

        }).catchError((_) {
            _upgrade(inMilliSeconds: inMilliSeconds < 100 ? inMilliSeconds + 5 : inMilliSeconds * 2);
        });
    }
}
