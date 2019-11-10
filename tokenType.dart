enum TokenType {
  // Single-character tokens
  leftParen,
  rightParen,
  leftBrace,
  rightBrace,
  comma,
  dot,
  minus,
  plus,
  semicolon,
  slash,
  star,

  // One or two character tokens
  bang,
  bangEqual,
  equal,
  equalEqual,
  greater,
  greaterEqual,
  less,
  lessEqual,

  // Literals
  identifier,
  string,
  number,

  // Keywords
  andKeyword,
  classKeyword,
  elseKeyword,
  falseKeyword,
  funKeyword,
  forKeyword,
  ifKeyword,
  nilKeyword,
  orKeyword,
  printKeyword,
  returnKeyword,
  superKeyword,
  thisKeyword,
  trueKeyword,
  varKeyword,
  whileKeyword,

  eof
}

const keywords = {
  'and': TokenType.andKeyword,
  'class': TokenType.classKeyword,
  'else': TokenType.elseKeyword,
  'false': TokenType.falseKeyword,
  'for': TokenType.forKeyword,
  'fun': TokenType.funKeyword,
  'if': TokenType.ifKeyword,
  'nil': TokenType.nilKeyword,
  'or': TokenType.orKeyword,
  'print': TokenType.printKeyword,
  'return': TokenType.returnKeyword,
  'super': TokenType.superKeyword,
  'this': TokenType.thisKeyword,
  'true': TokenType.trueKeyword,
  'var': TokenType.varKeyword,
  'while': TokenType.whileKeyword
};
