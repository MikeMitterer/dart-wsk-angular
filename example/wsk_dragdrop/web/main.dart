library wsk_angular.example.wsk_dragdrop;

//import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular/application_factory.dart';

import 'package:logging/logging.dart';
import 'package:console_log_handler/console_log_handler.dart';

import 'package:wsk_angular/wsk_dragdrop/wsk_dragdrop.dart';


final bool _useLocalDevices = false;

class _Language {
    final String name;
    final String type;

    _Language(this.name, this.type);
}

class _Programming extends _Language {
    _Programming(final String name) : super(name,"programming");
}
class _Natural extends _Language {
    _Natural(final String name) : super(name,"natural");
}

@Injectable()
class AppController {
    final _logger = new Logger('wsk_angular.example.wsk_dragdrop.AppController');

    final List<_Language> languages = new List<_Language>();
    final List<_Language> natural = new List<_Language>();
    final List<_Language> programming = new List<_Language>();

    AppController() {
        _logger.info("AppController");

        languages.add(new _Natural("English"));
        languages.add(new _Natural("German"));
        languages.add(new _Natural("Italian"));
        languages.add(new _Natural("French"));
        languages.add(new _Natural("Spanish"));

        languages.add(new _Programming("CPP"));
        languages.add(new _Programming("Dart"));
        languages.add(new _Programming("Java"));
    }

    void addToProgrammingLanguages(final _Language language) {
        if(language.type == "programming") {
            if(!programming.contains(language)) {
                programming.add(language);
            }
        }
    }

    void addToNaturalLanguages(final _Language language) {
        if(language.type == "natural") {
            if(!natural.contains(language)) {
                natural.add(language);
            }
        }
    }

    void moveToTrash(final _Language language) {
        if(language.type == "programming" && programming.contains(language)) {
            programming.remove(language);

        } else if(language.type == "natural" && natural.contains(language)) {
            natural.remove(language);
        }
    }

    //-----------------------------------------------------------------------------
    // private

}


class SampleModule extends Module {
    SampleModule() {
        install(new DragDropModule());

        // -- controllers

        // -- services

        // -- decorator

        //factory(NgRoutingUsePushState, (_) => new NgRoutingUsePushState.value(false));
    }
}

/// Entry point into app.
main() {
    configLogger();
    applicationFactory().addModule(new SampleModule()).rootContextType(AppController).run();
}


// Weitere Infos: https://github.com/chrisbu/logging_handlers#quick-reference
void configLogger() {
    //hierarchicalLoggingEnabled = false; // set this to true - its part of Logging SDK

    // now control the logging.
    // Turn off all logging first
    Logger.root.level = Level.INFO;
    Logger.root.onRecord.listen(new LogConsoleHandler());
}