import 'generated/expr.dart';
// import 'token.dart';
// import 'tokenType.dart';

class AstPrinter extends Visitor<String> {
  String print(Expr expr) => expr.accept(this);

  @override
  String visitBinaryExpr(Binary expr) =>
      parenthesize(expr.op.lexeme, [expr.left, expr.right]);

  @override
  String visitGroupingExpr(Grouping expr) =>
      parenthesize('group', [expr.expression]);

  @override
  String visitLiteralExpr(Literal expr) =>
      expr.value == null ? 'nil' : expr.value.toString();

  @override
  String visitUnaryExpr(Unary expr) =>
      parenthesize(expr.op.lexeme, [expr.right]);

  String parenthesize(String name, [List<Expr> exprs]) {
    var output = '($name';
    for (final expr in exprs) {
      output += ' ';
      output += expr.accept(this);
    }
    output += ')';
    return output;
  }
}

// void main() {
//   Expr expr = Binary(Unary(Token(TokenType.minus, '-', null, 1), Literal(123)),
//       Token(TokenType.star, '*', null, 1), Grouping(Literal(45.67)));

//   print(AstPrinter().print(expr));
// }
