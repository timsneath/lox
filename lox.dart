import 'dart:io';
import 'package:dart_console/dart_console.dart';

import 'token.dart';
import 'scanner.dart';
import 'parser.dart';
import 'interpreter.dart';

final interpreter = Interpreter();
bool hadError = false;
bool hadRuntimeError = false;

final console = Console();

void main(List<String> args) {
  if (args.length > 1) {
    console.writeLine('Usage: lox [script]');
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
  if (hadRuntimeError) exit(70);
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

  interpreter.interpret(expr);
}

void reportRuntimeError(RuntimeError error) {
  stderr.writeln('${error.message} [line ${error.token.line}]');
  hadRuntimeError = true;
}

void reportError(int line, String where, String message) {
  stderr.writeln('[line $line] Error$where: $message');
  hadError = true;
}
