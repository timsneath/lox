import 'generated/expr.dart';
import 'lox.dart';
import 'token.dart';
import 'tokenType.dart';

class ParseError extends Error {}

class Parser {
  final List<Token> tokens;
  int current = 0;

  Parser(this.tokens);

  Expr parse() {
    try {
      return expression();
    } catch (ParseError) {
      return null;
    }
  }

  Expr expression() => equality();

  Expr equality() {
    var expr = comparison();

    while (match([TokenType.bangEqual, TokenType.equalEqual])) {
      final op = previous();
      final right = comparison();
      expr = Binary(expr, op, right);
    }

    return expr;
  }

  Expr comparison() {
    var expr = addition();

    while (match([
      TokenType.greater,
      TokenType.greaterEqual,
      TokenType.less,
      TokenType.lessEqual
    ])) {
      final op = previous();
      final right = addition();
      expr = Binary(expr, op, right);
    }

    return expr;
  }

  Expr addition() {
    var expr = multiplication();

    while (match([TokenType.plus, TokenType.minus])) {
      final op = previous();
      final right = multiplication();
      expr = Binary(expr, op, right);
    }

    return expr;
  }

  Expr multiplication() {
    var expr = unary();

    while (match([TokenType.star, TokenType.slash])) {
      final op = previous();
      final right = unary();
      expr = Binary(expr, op, right);
    }

    return expr;
  }

  Expr unary() {
    if (match([TokenType.bang, TokenType.minus])) {
      final op = previous();
      final right = unary();
      return Unary(op, right);
    }

    return primary();
  }

  Expr primary() {
    if (match([TokenType.falseKeyword])) return Literal(false);
    if (match([TokenType.trueKeyword])) return Literal(true);
    if (match([TokenType.nilKeyword])) return Literal(null);

    if (match([TokenType.number, TokenType.string])) {
      return Literal(previous().literal);
    }

    if (match([TokenType.leftParen])) {
      final expr = expression();
      consume(TokenType.rightParen, "Expect ')' after expression.");
      return Grouping(expr);
    }

    throw error(peek(), 'Expect expression.');
  }

  bool match(List<TokenType> types) {
    for (final type in types) {
      if (check(type)) {
        advance();
        return true;
      }
    }
    return false;
  }

  Token consume(TokenType type, String message) {
    if (check(type)) return advance();

    throw error(peek(), message);
  }

  bool check(TokenType type) {
    if (isAtEnd()) return false;

    return peek().type == type;
  }

  Token advance() {
    if (!isAtEnd()) current++;

    return previous();
  }

  bool isAtEnd() => (peek().type == TokenType.eof);

  Token peek() => tokens[current];
  Token previous() => tokens[current - 1];

  ParseError error(Token token, String message) {
    if (token.type == TokenType.eof) {
      report(token.line, ' at end ', message);
    } else {
      report(token.line, " at '${token.lexeme}'", message);
    }

    return ParseError();
  }
}
