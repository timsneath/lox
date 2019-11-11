import 'dart:io';
import 'package:dart_console/dart_console.dart';

import 'token.dart';
import 'scanner.dart';
import 'parser.dart';
import 'astPrinter.dart';

bool hadError = false;

final console = Console();

void main(List<String> args) {
  if (args.length > 1) {
    console.writeLine('Usage lox [script]');
    exit(64);
  } else if (args.length == 1) {
    runFile(args[0]);
  } else {
    runPrompt();
  }
}

void runFile(String path) {
  final uri = Uri(path: path);
  final file = File.fromUri(uri).readAsStringSync();
  run(file);

  if (hadError) exit(65);
}

void runPrompt() {
  while (true) {
    console.write('> ');
    final input = console.readLine(cancelOnBreak: true);
    if (input == null) exit(0); // handle Ctrl+C

    run(input);
    hadError = false;
  }
}

void run(String source) {
  final scanner = Scanner(source);
  List<Token> tokens = scanner.scanTokens();
  final parser = Parser(tokens);
  final expr = parser.parse();

  if (hadError) return;

  console.writeLine(AstPrinter().print(expr));
}

void error(int line, String message) {
  report(line, "", message);
}

void report(int line, String where, String message) {
  stderr.writeln('[line $line] Error$where: $message');
  hadError = true;
}
