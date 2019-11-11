import 'generated/expr.dart';
import 'tokenType.dart';
import 'token.dart';
import 'lox.dart';

class RuntimeError extends Error {
  final Token token;
  final String message;

  RuntimeError(this.token, this.message);
}

class Interpreter extends Visitor<Object> {
  void interpret(Expr expr) {
    try {
      final value = evaluate(expr);
      console.writeLine(value == null ? 'nil' : value.toString());
    } on RuntimeError catch (error) {
      reportRuntimeError(error);
    }
  }

  @override
  Object visitBinaryExpr(Binary expr) {
    final left = evaluate(expr.left);
    final right = evaluate(expr.right);

    switch (expr.op.type) {
      case TokenType.minus:
        checkNumberOperands(expr.op, left, right);
        return (left as double) - (right as double);
      case TokenType.slash:
        checkNumberOperands(expr.op, left, right);
        return (left as double) / (right as double);
      case TokenType.star:
        checkNumberOperands(expr.op, left, right);
        return (left as double) * (right as double);
      case TokenType.plus:
        if (left is String && right is String) {
          return left + right;
        }
        if (left is double && right is double) {
          return left + right;
        }
        throw new RuntimeError(
            expr.op, 'Operands must be two numbers or two strings.');
      case TokenType.greater:
        checkNumberOperands(expr.op, left, right);
        return (left as double) > (right as double);
      case TokenType.greaterEqual:
        checkNumberOperands(expr.op, left, right);
        return (left as double) >= (right as double);
      case TokenType.less:
        checkNumberOperands(expr.op, left, right);
        return (left as double) < (right as double);
      case TokenType.lessEqual:
        checkNumberOperands(expr.op, left, right);
        return (left as double) <= (right as double);
      case TokenType.bangEqual:
        return !isEqual(left, right);
      case TokenType.equalEqual:
        return isEqual(left, right);
      default:
        return null;
    }
  }

  @override
  Object visitGroupingExpr(Grouping expr) => evaluate(expr.expression);

  @override
  Object visitLiteralExpr(Literal expr) => expr.value;

  @override
  Object visitUnaryExpr(Unary expr) {
    final right = evaluate(expr.right);

    switch (expr.op.type) {
      case TokenType.minus:
        checkNumberOperand(expr.op, right);
        return -double.parse(right);
      case TokenType.bang:
        return !isTruthy(right);
      default:
        return null;
    }
  }

  void checkNumberOperand(Token op, Object operand) {
    if (operand is double) return;
    throw RuntimeError(op, 'Operand must be a number.');
  }

  void checkNumberOperands(Token op, Object left, Object right) {
    if (left is double && right is double) return;
    throw RuntimeError(op, 'Operands must be numbers.');
  }

  bool isTruthy(Object object) {
    if (object == null) return false;
    if (object is bool) return object;
    return true;
  }

  bool isEqual(Object a, Object b) {
    if (a == null && b == null) return true;
    if (a == null) return false;
    return a == b;
  }

  Object evaluate(Expr expr) => expr.accept(this);
}
