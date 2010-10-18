-- Copyright 2006-2010 Mitchell mitchell<att>caladbolg.net. See LICENSE.
-- IDL LPeg Lexer

local l = lexer
local token, style, color, word_match = l.token, l.style, l.color, l.word_match
local P, R, S = l.lpeg.P, l.lpeg.R, l.lpeg.S

module(...)

local ws = token(l.WHITESPACE, l.space^1)

-- comments
local line_comment = '//' * l.nonnewline_esc^0
local block_comment = '/*' * (l.any - '*/')^0 * P('*/')^-1
local comment = token(l.COMMENT, line_comment + block_comment)

-- strings
local sq_str = l.delimited_range("'", '\\', true, false, '\n')
local dq_str = l.delimited_range('"', '\\', true, false, '\n')
local string = token(l.STRING, sq_str + dq_str)

-- numbers
local number = token(l.NUMBER, l.float + l.integer)

-- preprocessor
local preproc_word = word_match {
  'define', 'undef', 'ifdef', 'ifndef', 'if', 'elif', 'else', 'endif',
  'include', 'warning', 'pragma'
}
local preproc =
  token(l.PREPROCESSOR, #P('#') * l.starts_line('#' * preproc_word) *
        l.nonnewline^0)

-- keywords
local keyword = token(l.KEYWORD, word_match {
  'abstract', 'attribute', 'case', 'const', 'context', 'custom', 'default',
  'exception', 'enum', 'factory', 'FALSE', 'in', 'inout', 'interface', 'local',
  'module', 'native', 'oneway', 'out', 'private', 'public', 'raises',
  'readonly', 'struct', 'support', 'switch', 'TRUE', 'truncatable', 'typedef',
  'union', 'valuetype'
})

-- types
local type = token(l.TYPE, word_match {
  'any', 'boolean', 'char', 'double', 'fixed', 'float', 'long', 'Object',
  'octet', 'sequence', 'short', 'string', 'unsigned', 'ValueBase', 'void',
  'wchar', 'wstring'
})

-- identifiers
local identifier = token(l.IDENTIFIER, l.word)

-- operators
local operator = token(l.OPERATOR, S('!<>=+-/*%&|^~.,:;?()[]{}'))

_rules = {
  { 'whitespace', ws },
  { 'keyword', keyword },
  { 'type', type },
  { 'identifier', identifier },
  { 'string', string },
  { 'comment', comment },
  { 'number', number },
  { 'preprocessor', preproc },
  { 'operator', operator },
  { 'any_char', l.any_char },
}
