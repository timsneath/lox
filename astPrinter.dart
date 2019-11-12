import 'generated/expr.dart';

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
