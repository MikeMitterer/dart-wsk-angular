part of wsk_angular.wsk_dialog;

/// Creates html.Element from {htmlString}. This {htmlString} must contain wsk-dialog that defines the
/// root-Element for this Dialog
html.Element _createDialogElementFromString(final String htmlString,{ final String rootTag: "wsk-dialog" }) {
    Validate.notBlank(htmlString);
    Validate.isTrue(htmlString.contains(rootTag),"The HTML-String must contain '${rootTag}'!");

    final html.HtmlElement baseElement = new html.DivElement();
    baseElement.setInnerHtml(htmlString, treeSanitizer: new NullTreeSanitizer());

    //final List<html.Node> nodes = new List<html.Node>();
    for (final html.Node node in baseElement.nodes) {
        if (node is html.Element) {
            if ((node as html.Element).tagName.toLowerCase() == rootTag) {
                return node as html.Element;
            }
        }
    }
    throw new ArgumentError("Could not find <${rootTag}>...</${rootTag}> in '$htmlString'!");
}

final Logger _logger = new Logger('wsk_angular.wsk_dialog._waitForComponentToLoad');
Future<html.HtmlElement> _waitForComponentToLoad(final String selector, { Completer completer,
html.Element parent, final int inMilliSeconds: 10, final int TIMEOUT_IN_MS: 1000 }) {

    Validate.notBlank(selector);

    if (completer == null) {
        completer = new Completer<html.HtmlElement>();
    }
    if (parent == null) {
        parent = html.document.querySelector("body");
    }

    if (inMilliSeconds >= TIMEOUT_IN_MS) {
        throw new TimeoutException("Could not find an element with: ${selector} as selector!");
    }

    _logger.finer("Next check for component - in: ${inMilliSeconds}ms");
    new Future.delayed(new Duration(milliseconds: inMilliSeconds), () {
        _logger.finer(" - Selector: .${selector}");

        html.HtmlElement component = parent.querySelector(selector);
        if (component == null) {
            throw "Element with ${selector} not ready yet, try it again...";
        }
        _logger.fine("Found: $component with selector: ${selector}");
        return component;

    }).then((final html.HtmlElement component) {
        completer.complete(component);

    }).catchError((_) {

        // next round...
        _waitForComponentToLoad(selector, completer: completer,
        parent: parent, inMilliSeconds: inMilliSeconds < 100 ? inMilliSeconds + 5 : inMilliSeconds * 2);

    });

    return completer.future;
}
