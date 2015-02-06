// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library wsk_angular;

import 'dart:html' as html;
import "dart:async";

import 'package:logging/logging.dart';
import 'package:validate/validate.dart';

import 'package:wsk_material/wskcore.dart';
import 'package:wsk_material/wskcomponets.dart';

abstract class WskAngularComponent {
    final _logger = new Logger('wsk_angular.WskAngularComponent');

    static const int _TIMEOUT_IN_MS = 2000;

    final html.Element _component;
    final List<WskConfig> _configs = new List<WskConfig>();

    WskAngularComponent(this._component, final WskConfig mainConfig, [ final List<WskConfig> additionalConfigs = const [] ]) {
        Validate.notNull(_component);
        Validate.notNull(mainConfig);
        Validate.notNull(additionalConfigs);

        _configs.add(mainConfig);
        _configs.addAll(additionalConfigs);

        _upgrade();
    }

    WskConfig get mainconfig => _configs[0];

    /// Informs component about the final upgrade-state
    void upgraded() {}

    // - private ----------------------------------------------------------------------------------

    void _upgrade({ final int inMilliSeconds: 200} ) {
        if (inMilliSeconds >= _TIMEOUT_IN_MS) {
            throw new TimeoutException("Could not find a component with css-class: .${mainconfig.cssClass}");
        }

        _logger.info("Next check for component - in: ${inMilliSeconds}ms");
        new Future.delayed(new Duration(milliseconds: inMilliSeconds), () {
            _logger.info(" - cssClass: .${mainconfig.cssClass}");

            final html.HtmlElement component = _component.querySelector(".${mainconfig.cssClass}");
            if (component == null) {
                throw "Component for .${mainconfig.cssClass} not ready yet, try it again...";
            }
            return component;

        }).then((final html.HtmlElement component) {
            _logger.info("Found $component with class '${mainconfig.cssClass}'");

            componenthandler.upgradeElement(component, () {
                return _configs;
            });
            upgraded();

        }).catchError((_) {
            _upgrade(inMilliSeconds: inMilliSeconds < 100 ? inMilliSeconds + 5 : inMilliSeconds * 2);
        });
    }
}
