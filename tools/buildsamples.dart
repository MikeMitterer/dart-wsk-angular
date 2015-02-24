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

            if (argResults.wasParsed(Options._ARG_HELP) || (config.dirstoscan.length == 0 && args.length == 0)) {
                options.showUsage();
                return;
            }

            if(argResults.wasParsed(Options._ARG_SETTINGS)) {
                config.printSettings();
                return;
            }

            if(argResults.wasParsed(Options._ARG_SHOW_SAMPLES)) {
                _iterateThroughDirSync(config.samplesfolder,new List<String>(),_onlyDirs,(final File file) {
                    _logger.info(" - ${file.path}");
                });
                return;
            }

            if(argResults.wasParsed(Options._ARG_BUILD )) {
                _iterateThroughDirSync(config.samplesfolder,new List<String>(),_onlyDirs,(final File file) {
                    buildSampleInFolder(new File(file.path));
                });
                return;
            }

            if(argResults.wasParsed(Options._ARG_CPY_BUILD )) {
                _iterateThroughDirSync(config.samplesfolder,new List<String>(),_onlyDirs,(final File file) {
                    copyExampleBuildToRootBuild(new File(file.path));
                });
                return;
            }

            if(argResults.wasParsed(Options._ARG_RSYNC)) {
                rsyncBuildWeb();
                return;
            }

            options.showUsage();
        }

        on FormatException
        catch (error) {
            options.showUsage();
        }
    }

    void buildSampleInFolder(final File file) {
        Validate.notNull(file);
        Validate.isTrue(FileSystemEntity.isDirectorySync(file.path));

        final String folder = file.path;
        _logger.info("Building sample in ${folder}");

        final ProcessResult result = Process.runSync( "sh", [ '-c', '(cd $folder && pub build)' ]);
        if(result.exitCode != 0) {
            _logger.severe("run faild with: ${(result.stderr as String).trim()}!");
        }
        _logger.info("Done!\n");
    }

    void copyExampleBuildToRootBuild(final File file) {
        Validate.notNull(file);
        Validate.isTrue(FileSystemEntity.isDirectorySync(file.path));

        final Directory webDir = new Directory("${file.path}/build/web");
        final Directory buildDir = new Directory("build/${file.path}");

        if(!webDir.existsSync()) {
            _logger.severe("${webDir.path} does not exist!");
            return;
        }

        if(buildDir.existsSync()) {
            buildDir.deleteSync(recursive: true);
        }

        _logger.info("copy ${webDir.path} -> ${buildDir.path}");

        final File src = new File(webDir.path);
        final File target = new File(buildDir.path);
        _copySubdirs(src,target);

        _logger.info(" - done!");
    }

    /// More infos about rsync without PW:
    ///     http://www.thegeekstuff.com/2011/07/rsync-over-ssh-without-password/
    ///     http://www.thegeekstuff.com/2008/06/perform-ssh-and-scp-without-entering-password-on-openssh/
    void rsyncBuildWeb() {
        _logger.info("RSync build/web...");

        // rsync -avz -e ssh build/example/ bcadmin@vhost2.mikemitterer.at:/home/wskan82301/www/
        Process.start("rsync", [ '-avz', '-e', 'ssh', 'build/example/', 'bcadmin@vhost2.mikemitterer.at:/home/wskan82301/www/' ],
        runInShell: false).then((final Process process) {

            process.stdout.transform(UTF8.decoder).listen((final String data) {
                print(data);
            });

            // Get the exit code from the new process.
            process.exitCode.then((exitCode) {
                print('Exit code: $exitCode'); // Prints 'exit code: 0'.
            });

        });
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

    void _copySubdirs(final File sourceDir, final File targetDir, { int level: 0 } ) {
        Validate.notNull(sourceDir);
        Validate.notNull(targetDir);

        _logger.fine("Start!!!! ${sourceDir.path} -> ${targetDir.path} , Level: $level");
        final Directory directory = new Directory(sourceDir.path);
        directory.listSync(recursive: false).where((final FileSystemEntity entity) {
            // _logger.info("Check ${entity.path}");

            if(entity.path.startsWith(".") || entity.path.contains("/.")) {
                return false;
            }
            if(FileSystemEntity.isLinkSync(entity.path)) {
                return false;
            }

            return true;

        }).forEach((final FileSystemEntity entity) {
            //_logger.info("D ${entity.path}");

            if (FileSystemEntity.isDirectorySync(entity.path)) {
                final File src = new File(entity.path);
                final File target = new File(entity.path.replaceFirst(sourceDir.path,""));
                _copySubdirs(new File("${entity.path}"),new File("${targetDir.path}${target.path}"),level: ++level);

            } else {
                if(level >= 0) {
                    final File src = new File(entity.path);
                    final File target = new File("${targetDir.path}${entity.path.replaceFirst(sourceDir.path,"")}");
                    if(!target.existsSync()) {
                        target.createSync(recursive: true);
                    }
                    _logger.fine("    copy ${src.path} -> ${target.path} (Level $level)...");
                    src.copySync(target.path);
                }
            }
        });
    }

    bool _onlyDirs(final FileSystemEntity entity) {
        return FileSystemEntity.isDirectorySync(entity.path);
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
    static const _ARG_BUILD                 = 'build';
    static const _ARG_CPY_BUILD             = 'copybuild';
    static const _ARG_RSYNC                 = 'rsync';

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

//        print("");
//        print("Sample:");
//        print("    Sample sample:           '$APPNAME your sample");
        print("");
    }

    // -- private -------------------------------------------------------------

    static ArgParser _createParser() {
        final ArgParser parser = new ArgParser()

            ..addFlag(_ARG_HELP,            abbr: 'h', negatable: false, help: "Shows this message")
            ..addFlag(_ARG_SETTINGS,        abbr: 's', negatable: false, help: "Prints settings")
            ..addFlag(_ARG_SHOW_SAMPLES,    abbr: 'x', negatable: false, help: "Show samples")
            ..addFlag(_ARG_BUILD,           abbr: 'b', negatable: false, help: "Build your samples")
            ..addFlag(_ARG_CPY_BUILD,       abbr: 'c', negatable: false, help: "Copy example-build to root-build")
            ..addFlag(_ARG_RSYNC,           abbr: 'r', negatable: false, help: "RSync's build/web")

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

