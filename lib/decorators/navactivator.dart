library wsk_angular.decorators.navactivator;

import 'dart:html' as html;
import 'package:angular/angular.dart';

import 'package:logging/logging.dart';
// Handlers that are shared between client and server
//import 'package:logging_handlers/logging_handlers_shared.dart';

/**
 * Schaltet die Menüpunkte in der Navbar ein aus.
 */
@Decorator(selector: '[navactivator]')
class NavActivator {
    final _logger = new Logger('wsk_angular.decorators.navactivator');

    static const String _classActive = "active";
    static const String _classEnabled = "enabled";
    static const String _dataAttribute = "data-route";

    final Router _router;
    final html.Element _element;
    String _routeToCheck;

    NavActivator(this._element, this._router) {
        _logger.fine("NavActivator");

        _routeToCheck = _element.getAttribute(_dataAttribute);
        _logger.fine("Route-Name: to check: ${_routeToCheck}");

        _addListener(compareAttribute: (_routeToCheck != null && _routeToCheck.isNotEmpty));
    }

    //--------------------------------------------------------------------------------
    // private

    String _route() {
        final List<String> names = new List();
        _router.activePath.forEach((final Route element) {
            names.add(element.name);
        });
        return names.join("/");
    }

    void _addListener({final bool compareAttribute }) {
        _router.onRouteStart.listen( (final RouteStartEvent event) {
            event.completed.then( (final bool success) {
                if (success) {
                    final String route = _route();

                    Function check = () => _compareRoutePath();
                    if (!compareAttribute) {
                        check = () => _compareFragment(event.uri);
                    }

                    if (check()) {
                        _element.classes.add(_classActive);
                        _queryAllParents(_element,until: "nav")
                            .where((final html.Element element) => element.tagName.toLowerCase() == "a")
                                .forEach((final html.Element element) {
                            element.classes.add(_classEnabled);
                        });
                    }
                    else {
                        _element.classes.remove(_classActive);
                        _queryAllParents(_element,until: "nav")
                            .where((final html.Element element) => element.tagName.toLowerCase() == "a")
                                .forEach((final html.Element element) {
                            element.classes.remove(_classEnabled);
                        });
                    }
                }
            });
        });
    }

    bool _compareRoutePath() {
        final String route = _route();

        _logger.fine("Changed, Route-Name to check: ${_routeToCheck}, Route-Name: $route");
        return (_routeToCheck == route);
    }

    bool _compareFragment(final String uri) {
        _logger.fine("Changed, Uri: ${uri}");

        final String attribHref = _element.attributes["href"];

        final html.AnchorElement anchor = (_element.querySelector("a") as html.AnchorElement);
        if (attribHref != null && attribHref.indexOf("#") != -1) {
            try {
                final String fragment = attribHref.substring(attribHref.indexOf("#") + 1);
                _logger.fine("  -> Fragment: ${fragment}, Route-Name: ${_route()}, Uri: $uri");
                if (fragment == uri) {
                    return true;
                }
            }
            on RangeError
            catch(e) {
                _logger.fine("No fragment in ${attribHref}");
            }
        }
        return false;
    }

    List<html.Element> _queryAllParents(final html.Element element,{ final String until }) {
        final parents = new List<html.Element>();

        html.Element parent = element.parent;
        while(parent != null) {
            if(parent.id != null && until != null && parent.id.toLowerCase() == until.toLowerCase()) {
                break;
            }

            if(until != null && parent.tagName.toLowerCase() == until.toLowerCase()) {
                break;
            }

            parents.add(parent);
            //_logger.fine("Parent: ${parent.tagName.toLowerCase()}");

            parent = parent.parent;
        }

        return parents;
    }
}
