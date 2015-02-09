library wsk_angular.wsk_animation;

import 'dart:html' as html;

import "package:angular/angular.dart";
import 'package:angular/core/annotation_src.dart';

import 'package:logging/logging.dart';
import 'package:validate/validate.dart';

import 'package:wsk_material/wskcomponets.dart';
import 'package:wsk_angular/wsk_angular.dart';

/**
 * Animation Module.
 *    Weitere Infos: https://docs.angulardart.org/#di.Module
 */
class WskAnimationModule extends Module {
    WskAnimationModule() {

        bind(WskAnimationComponent);

        //- Services ---------------------------
    }
}

// @formatter:off    
/// WskAnimationComponent
@Component( selector: 'wsk-animation', useShadowDom: false,  templateUrl: 'packages/wsk_angular/wsk_animation/wsk_animation.html')
// @formatter:on    
class  WskAnimationComponent extends WskAngularComponent {
    final Logger _logger = new Logger('wsk_angular.wsk_animation.AnimationComponent');

    WskAnimationComponent(final html.Element component)
        : super(component,materialAnimationConfig()) {
        Validate.notNull(component);
    }

    // - EventHandler -----------------------------------------------------------------------------

    // - private ----------------------------------------------------------------------------------
}
        