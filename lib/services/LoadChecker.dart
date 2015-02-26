library wsk_angular.services.loadchecker;

import 'dart:html' as html;
import "dart:async";
import 'package:angular/angular.dart';

import 'package:logging/logging.dart';

/**
 * Waits until Document + all Elements added with {check} have loaded
 * Loaded means - visible in DOM
 * Sample:
 *      <body class="ng-cloak loadchecker-checking">
 */
@Injectable()
class LoadChecker {
    final _logger = new Logger('wsk_angular.services.loadchecker.LoadChecker');

    static const String _CLASS_TO_REMOVE   = "loadchecker";
    static const String _CLASS_TO_ADD      = "loadchecker-checked";

    static const int _DELAY_TO_CHECK_FOR_LOADED_DOCUMENT_IN_MS = 200;
    static const int _TIMEOUT_FOR_LOAD_CHECK_IN_MS = 2000;

    int _itemsToCheck = 0;

    LoadChecker() {
        _waitForDocumentToLoad();
    }

    /// Checks if {element} has some (at lease one) children
    void check(final html.HtmlElement element) {
        if(element == null) {
            return;
        }
        new Future( () {
            _itemsToCheck++;
            _logger.fine("Check: $element Items to check: $_itemsToCheck");
            _waitForFirstChild(element);
        });
    }

    // - private ----------------------------------------------------------------------------------

    /// Waits until {parent} has at least one child!
    void _waitForFirstChild(final html.HtmlElement parent, { final int inMilliSeconds: 30, final int timeOutInMS: 1000 } ) {
        void _decrement() {
            _itemsToCheck--;
            _logger.fine("Decrement! $_itemsToCheck left.");
        }

        if (inMilliSeconds >= timeOutInMS) {
            _logger.warning("No child found in ${parent}. Timeout after ${timeOutInMS}ms");
            _decrement();
            return;
        }

        _logger.finer("Next check for child in: ${inMilliSeconds}ms");
        new Future<html.HtmlElement>.delayed(new Duration(milliseconds: inMilliSeconds), () {

            html.Element element = parent.querySelector(":first-child");
            if(element == null) {
                element = parent.querySelector("div");
                if(element == null) {
                    element = parent.querySelector("span");
                }
            }
            if(element ==  null) {
                throw "No child found, try it again later...";
            }
            _logger.fine("Child found: $element");
            return element;

        }).then((final html.HtmlElement component) {
            _decrement();

        }).catchError((_) {
            _waitForFirstChild(parent, inMilliSeconds: inMilliSeconds < 100 ? inMilliSeconds + 5 : inMilliSeconds * 2);
        });
    }

    /// Check if document has loaded and if there are no more itemsToCheck
    void _waitForDocumentToLoad({ final int inMilliSeconds: _DELAY_TO_CHECK_FOR_LOADED_DOCUMENT_IN_MS,
                                  final int timeOutInMS:    _TIMEOUT_FOR_LOAD_CHECK_IN_MS } ) {

        void _setBodyStateChecked() {
            html.querySelector("body").classes.remove(_CLASS_TO_REMOVE);
            html.querySelector("body").classes.add(_CLASS_TO_ADD);
        }

        if (inMilliSeconds >= timeOutInMS) {
            _setBodyStateChecked();
            _logger.severe("Document could not be loaded in ${timeOutInMS}ms");
            return;
        }

        _logger.fine("Next document check in: ${inMilliSeconds}ms");
        new Future.delayed(new Duration(milliseconds: inMilliSeconds), () {
            _logger.fine(" - check state and items. (Current state: ${html.document.readyState}, items left: ${_itemsToCheck})...");

            if((html.document.readyState != "loaded" && html.document.readyState != "complete") || _itemsToCheck > 0 ) {
                _logger.fine(" - current state: ${html.document.readyState}");
                throw "Document not ready yet, try it again...";
            }
            _logger.info("Document loaded, all items checked! ('.$_CLASS_TO_REMOVE' removed from body)");

        }).then((final html.HtmlElement component) {
            new Future.delayed(new Duration(milliseconds: 50), (){
                _setBodyStateChecked();
            });

        }).catchError((_) {
            _waitForDocumentToLoad(inMilliSeconds:
                inMilliSeconds < (_DELAY_TO_CHECK_FOR_LOADED_DOCUMENT_IN_MS * 2) ? inMilliSeconds : inMilliSeconds * 1.5 );
        });
    }
}