import 'dart:io';

import 'package:bosun/bosun.dart';
import 'package:path/path.dart' as path;

void main(List<String> args) {
  execute(
      BosunCommand('donker',
          subcommands: [MyCommand(), EditConfig(), ShowAllOpenCommand()]),
      args);
}

class EditConfig extends Command {
  EditConfig()
      : super(
            command: 'edit',
            description:
                'Open config file, user could edit the config if needed.');

  @override
  void run(List<String> args, Map<String, dynamic> flags) {
    Process.start(
            'cmd',
            [
              '/c',
              'start',
              '${path.dirname(Platform.script.toFilePath())}\\config.txt'
            ],
            runInShell: true)
        .catchError((e) {
      print("Error: $e");
    });
  }
}

class MyCommand extends Command {
  MyCommand()
      : super(
            command: 'open',
            description:
                'Open an application with a short command line. for example: open vscode');

  @override
  void run(List<String> args, Map<String, dynamic> flags) {
    var file =
        File('${path.dirname(Platform.script.toFilePath())}\\config.txt');
    List<String>? contents;

    if (file.existsSync()) {
      contents = file.readAsLinesSync();
    } else {
      print('Config File does not exist. Please reset it');
    }
    if (isExist(args[0], contents)) {
      if (contents != null) {
        for (String element in contents) {
          String value1 = element.split(';')[0];
          String value2 = element.split(';')[1].trim().replaceAll('"', '');

// Process.start('cmd', ['/c', 'start', value2], runInShell: true)

          if (value1 == args[0]) {
            // Process.start('cmd', ['/c', 'start', value2], runInShell: true)
            //     .catchError((e) {
            //   print("Error: $e");
            // });

            startProcess(value2);
          }
        }
      }
    } else {
      print(
          'Your command "${args[0]}" is not be finded, Please set it in the config.txt file. use the command "edit"');
    }
  }
}

class ShowAllOpenCommand extends Command {
  ShowAllOpenCommand()
      : super(command: 'show', description: 'Show all opencommand');

  @override
  void run(List<String> args, Map<String, dynamic> flags) {
    var file =
        File('${path.dirname(Platform.script.toFilePath())}\\config.txt');
    List<String>? contents;

    if (file.existsSync()) {
      contents = file.readAsLinesSync();
    } else {
      print('Config File does not exist. Please reset it');
    }

    var redColor = '\x1B[31m'; // ANSI escape code for red color
    var resetColor = '\x1B[0m'; // ANSI escape code to reset color

    if (contents != null) {
      print("All open command: ");
      for (var element in contents) {
        print('$redColor' + "\t open ${element.split(';')[0]}" + '$resetColor');
      }
    }

    print("Other command: ");
    print('$redColor' + "\t show" + '$resetColor');
    print('$redColor' + "\t edit" + '$resetColor');
  }
}

bool isExist(String commandLineName, List<String>? contents) {
  if (contents != null) {
    for (var element in contents) {
      String value1 = element.trim().split(';')[0];

      if (value1 == commandLineName) {
        return true;
      }
    }
  } else {
    return false;
  }
  return false;
}

void startProcess(String filePath) {
  Process.start(filePath, [],
      runInShell: false, mode: ProcessStartMode.detached);
}
