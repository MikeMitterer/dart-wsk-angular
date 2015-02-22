#!/usr/bin/env dart

import 'dart:io';
import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:math';

import 'package:args/args.dart';

import 'package:logging/logging.dart';
import 'package:logging_handlers/logging_handlers_shared.dart';

import 'package:validate/validate.dart';

class Application {
    final Logger _logger = new Logger("buildsamples.Application");

    static const _ARG_HELP          = 'help';
    static const _ARG_LOGLEVEL      = 'loglevel';
    static const _ARG_SETTINGS      = 'settings';

    final Options options;

    Application() : options = new Options();

    void run(List<String> args) {

        try {
            final ArgResults argResults = options.parse(args);
            final Config config = new Config(argResults);

            _configLogging(config.loglevel);

            if (argResults[Options._ARG_HELP] || (config.dirstoscan.length == 0 && args.length == 0)) {
                options.showUsage();
                return;
            }
            if(argResults[Options._ARG_SETTINGS]) {
                config.printSettings();
                return;
            }

            if(argResults[Options._ARG_SHOW_SAMPLES]) {
                _iterateThroughDirSync(config.samplesfolder,new List<String>(),(final FileSystemEntity entity) {
                    return FileSystemEntity.isDirectorySync(entity.path);

                },(final File file) {
                    _logger.info(file.path);
                });
                return;
            }
            options.showUsage();
        }

        on FormatException
        catch (error) {
            options.showUsage();
        }
    }

    // -- private -------------------------------------------------------------


    /// Goes through the files
    void _iterateThroughDirSync(final String dir,final List<String> foldersToExclude,
        bool isEntityOK(final FileSystemEntity entity), void callback(final File file) ) {

        Validate.notNull(foldersToExclude);
        Validate.notNull(isEntityOK);
        Validate.notNull(callback);

        _logger.info("Scanning: $dir");

        // its OK if the path starts with packages but not if the path contains packages (avoid recursion)
        final RegExp regexp = new RegExp("^/*packages/*");

        final Directory directory = new Directory(dir);
        if (directory.existsSync()) {

            directory.listSync(recursive: false).where((final FileSystemEntity entity) {
                _logger.fine("Entity: ${entity}");

                for(final String folder in foldersToExclude) {
                    if(entity.path.contains(folder)) {
                        return false;
                    }
                }

                if(entity.path.contains("packages") || entity.path.contains("/.") || entity.path.startsWith(".")) {
                    // return only true if the path starts!!!!! with packages
                    //return entity.path.contains(regexp);
                    return false;
                }

                return isEntityOK(entity);

            }).any((final File file) {
                //_logger.fine("  Found: ${file}");
                callback(file);
            });
        }
    }

    void _configLogging(final String loglevel) {
        Validate.notBlank(loglevel);

        hierarchicalLoggingEnabled = false; // set this to true - its part of Logging SDK

        // now control the logging.
        // Turn off all logging first
        switch(loglevel) {
            case "fine":
            case "debug":
                Logger.root.level = Level.FINE;
                break;

            case "warning":
                Logger.root.level = Level.SEVERE;
                break;

            default:
                Logger.root.level = Level.INFO;
        }

        Logger.root.onRecord.listen(new LogPrintHandler(messageFormat: "%m"));
    }
}


class Options {
    static const APPNAME                    = 'buildsamples';

    static const _ARG_HELP                  = 'help';
    static const _ARG_LOGLEVEL              = 'loglevel';
    static const _ARG_SETTINGS              = 'settings';
    static const _ARG_SHOW_SAMPLES          = 'showsamples';

    final ArgParser _parser;

    Options() : _parser = Options._createParser();

    ArgResults parse(final List<String> args) {
        Validate.notNull(args);
        return _parser.parse(args);
    }

    void showUsage() {
        print("Usage: $APPNAME [options]");
        _parser.getUsage().split("\n").forEach((final String line) {
            print("    $line");
        });

        print("");
        print("Sample:");
        print("    Sample sample:           '$APPNAME your sample");
        print("");
    }

    // -- private -------------------------------------------------------------

    static ArgParser _createParser() {
        final ArgParser parser = new ArgParser()

            ..addFlag(_ARG_HELP,            abbr: 'h', negatable: false, help: "Shows this message")
            ..addFlag(_ARG_SETTINGS,        abbr: 's', negatable: false, help: "Prints settings")
            ..addFlag(_ARG_SHOW_SAMPLES,    abbr: 'x', negatable: false, help: "Show samples")

            ..addOption(_ARG_LOGLEVEL,      abbr: 'v', help: "[ info | debug | warning ]")
        ;

        return parser;
    }
}

/**
 * Defines default-configurations.
 * Most of these configs can be overwritten by commandline args.
 */
class Config {
    final Logger _logger = new Logger("buildsamples.Config");

    final ArgResults _argResults;
    final Map<String,dynamic> _settings = new Map<String,dynamic>();

    Config(this._argResults) {

        _settings[Options._ARG_LOGLEVEL]      = 'info';
        _settings[Options._ARG_SHOW_SAMPLES]  = 'example';

        _overwriteSettingsWithArgResults();
    }

    List<String> get dirstoscan => _argResults.rest;

    String get loglevel => _settings[Options._ARG_LOGLEVEL];

    String get samplesfolder => _settings[Options._ARG_SHOW_SAMPLES];

    Map<String,String> get settings {
        final Map<String,String> settings = new Map<String,String>();

        settings["loglevel"]                                = loglevel;
        settings["Samples folder"]                          = samplesfolder;

        if(dirstoscan.length > 0) {
            settings["Dirs to scan"]                        = dirstoscan.join(", ");
        }

        return settings;
    }


    void printSettings() {

        int getMaxKeyLength() {
            int length = 0;
            settings.keys.forEach((final String key) => length = max(length,key.length));
            return length;
        }

        final int maxKeyLeght = getMaxKeyLength();

        String prepareKey(final String key) {
            return "${key[0].toUpperCase()}${key.substring(1)}:".padRight(maxKeyLeght + 1);
        }

        print("Settings:");
        settings.forEach((final String key,final String value) {
            print("    ${prepareKey(key)} $value");
        });
    }

    // -- private -------------------------------------------------------------

    _overwriteSettingsWithArgResults() {

        /// Makes sure that path does not end with a /
        String checkPath(final String arg) {
            String path = arg;
            if(path.endsWith("/")) {
                path = path.replaceFirst(new RegExp("/\$"),"");
            }
            return path;
        }

        if(_argResults.wasParsed(Options._ARG_LOGLEVEL)) {
            _settings[Options._ARG_LOGLEVEL] = _argResults[Options._ARG_LOGLEVEL];
        }
    }
}

void main(List<String> arguments) {
    final Application application = new Application();
    application.run( arguments );
}

