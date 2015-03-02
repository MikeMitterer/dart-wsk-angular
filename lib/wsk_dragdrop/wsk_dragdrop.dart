library wsk_angular.wsk_dragdrop;

import 'dart:html' as html;

import "package:angular/angular.dart";
import 'package:angular/core/annotation_src.dart';

import 'package:logging/logging.dart';
import 'package:validate/validate.dart';

import 'package:wsk_angular/wsk_angular.dart';

import 'package:dnd/dnd.dart';

part 'src/wsk_draggable.dart';
part 'src/wsk_dropzone.dart';

/// Store strings for class names defined by this component that are used in
/// Dart. This allows us to simply change it in one place should we
/// decide to modify at a later date.
class _DNDCssClasses {

    final String WSK_DROPZONE   = 'wsk-dropzone';
    final String WSK_DRAGGABLE  = 'wsk-draggable';

    final String DRAGGABLE      = 'dnd-draggable';
    final String OVER           = 'dnd-over';
    final String INVALID        = 'dnd-invalid';

    const _DNDCssClasses();
}



@Injectable()
class DragInfo {
    var data;
    List<String> allowedDropZones = [];
}

class WskDragDropModule extends Module {
    WskDragDropModule() {
        bind(DragInfo);

        bind(WskDraggableComponent);
        bind(WskDropZoneComponent);
    }
}