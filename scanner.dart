import 'token.dart';
import 'tokenType.dart';
import 'lox.dart';

class Scanner {
  final String source;
  final List<Token> tokens = List<Token>();

  int start = 0;
  int current = 0;
  int line = 1;

  Scanner(this.source);

  List<Token> scanTokens() {
    while (!isAtEnd()) {
      start = current;
      scanToken();
    }
    tokens.add(Token(TokenType.eof, "", null, line));
    return tokens;
  }

  void scanToken() {
    String c = advance();
    switch (c) {
      case '(':
        addToken(TokenType.leftParen);
        break;
      case ')':
        addToken(TokenType.rightParen);
        break;
      case '{':
        addToken(TokenType.leftBrace);
        break;
      case '}':
        addToken(TokenType.rightBrace);
        break;
      case ',':
        addToken(TokenType.comma);
        break;
      case '.':
        addToken(TokenType.dot);
        break;
      case '-':
        addToken(TokenType.minus);
        break;
      case '+':
        addToken(TokenType.plus);
        break;
      case ';':
        addToken(TokenType.semicolon);
        break;
      case '*':
        addToken(TokenType.star);
        break;
      case '!':
        addToken(match('=') ? TokenType.bangEqual : TokenType.bang);
        break;
      case '=':
        addToken(match('=') ? TokenType.equalEqual : TokenType.equal);
        break;
      case '<':
        addToken(match('=') ? TokenType.lessEqual : TokenType.less);
        break;
      case '>':
        addToken(match('=') ? TokenType.greaterEqual : TokenType.greater);
        break;
      case '/':
        if (match('/')) {
          // double-slash comment style
          while (peek() != '\n' && !isAtEnd()) advance();
        } else if (match('*')) {
          // traditional /* ... */ comment style
          while (!(match('*') && match('/'))) advance();
        } else {
          addToken(TokenType.slash);
        }
        break;
      case ' ':
      case '\r':
      case '\t':
        // Ignore whitespace
        break;
      case '\n':
        line++;
        break;
      case '"':
        string();
        break;
      default:
        if (isDigit(c)) {
          number();
        } else if (isAlpha(c)) {
          identifier();
        } else {
          reportError(line, '', 'Unexpected character.');
        }
        break;
    }
  }

  void identifier() {
    while (isAlphanumeric(peek())) advance();

    final text = source.substring(start, current);
    var type = keywords[text];
    if (type == null) {
      type = TokenType.identifier;
    }
    addToken(type);
  }

  void number() {
    while (isDigit(peek())) advance();

    // Look for a fractional part
    if (peek() == '.' && isDigit(peekNext())) {
      // Consume the '.'
      advance();

      while (isDigit(peek())) advance();
    }

    addToken(TokenType.number, double.parse(source.substring(start, current)));
  }

  void string() {
    while (peek() != '"' && !isAtEnd()) {
      if (peek() == '\n') line++;
      advance();
    }

    // Unterminated string
    if (isAtEnd()) {
      reportError(line, '', 'Unterminated string.');
      return;
    }

    // The closing "
    advance();

    final value = source.substring(start + 1, current - 1);
    addToken(TokenType.string, value);
  }

  bool match(String expected) {
    if (isAtEnd()) return false;
    if (source[current] != expected) return false;

    current++;
    return true;
  }

  String peek() {
    if (isAtEnd()) return null;
    return source[current];
  }

  String peekNext() {
    if (current + 1 >= source.length) return null;
    return source[current + 1];
  }

  bool isAlpha(String c) =>
      ('a'.compareTo(c) <= 0 && 'z'.compareTo(c) >= 0) ||
      ('A'.compareTo(c) <= 0 && 'Z'.compareTo(c) >= 0) ||
      c == '_';

  bool isAlphanumeric(String c) => isAlpha(c) || isDigit(c);

  bool isDigit(String c) =>
      ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'].contains(c);

  bool isAtEnd() => current >= source.length;

  String advance() {
    current++;
    return source[current - 1];
  }

  void addToken(TokenType type, [Object literal = null]) {
    final text = source.substring(start, current);
    tokens.add(Token(type, text, literal, line));
  }
}
