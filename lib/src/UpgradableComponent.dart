part of wsk_angular;

/**
 * Informs the a Component about the loading-state.
 * If a HtmlElement is found within {_component} three functions are called:
 * {preUpgrade}, {upgrade} and {upgraded}
 */
abstract class UpgradableComponent {
    final _logger = new Logger('wsk_angular.UpgradableComponent');

    static const int _TIMEOUT_IN_MS = 2000;

    final html.Element _component;

    UpgradableComponent(this._component,[ final bool upgradeAutomatically = true ] ) {

        Validate.notNull(_component);

        if(upgradeAutomatically) {
            autoUpgrade();
        }
    }

    /// called before componentHandler takes place
    void preUpgrade(final html.Element component) { }

    /// Callback after Angular has loaded it's template
    void upgrade(final html.HtmlElement component) { }

    /// Informs component about the final upgrade-state
    void upgraded() {}

    /// Waits for Angular to load the template, search for the component defined in mainConfig (CTOR)
    void autoUpgrade() {
        _waitForComponentToLoad();
    }

    // - private ----------------------------------------------------------------------------------

    /// If autoUpgrade in the Constructor is false you can upgrade the component manually
    void _waitForComponentToLoad({ final int inMilliSeconds: 30} ) {
        if (inMilliSeconds >= _TIMEOUT_IN_MS) {
            throw new TimeoutException("Could not find a component to upgrade!");
        }

        _logger.finer("Next check for component - in: ${inMilliSeconds}ms");
        new Future.delayed(new Duration(milliseconds: inMilliSeconds), () {

            html.HtmlElement firstelement = _component.querySelector("*");
            if (firstelement == null) {
                _logger.finer("Classes: ${_component.classes}");
                throw "Could not find a HtmlElement in ${_component}, try it again...";
            }
            _logger.fine("Found componentToUpgrade: $firstelement");
            return firstelement;

        }).then((final html.HtmlElement component) {
            preUpgrade(component);
            upgrade(component);
            upgraded();

        }).catchError((_) {
            _waitForComponentToLoad(inMilliSeconds: inMilliSeconds < 100 ? inMilliSeconds + 5 : inMilliSeconds * 2);
        });
    }

}
