# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "LanguageAwk", ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage('language-awk')

    runs ->
      grammar = atom.grammars.grammarForScopeName('source.awk')

  it "parses the grammar", ->
    expect(grammar).toBeDefined()
    expect(grammar.scopeName).toBe "source.awk"

  it "tokensizes function definition", ->
    {tokens} = grammar.tokenizeLine("function foobar(param) {")

    expect(tokens[0]).toEqual value: 'function', scopes: ['source.awk', 'meta.function.awk', 'storage.type.function.awk']
    expect(tokens[1]).toEqual value: ' ', scopes: ['source.awk', 'meta.function.awk']
    expect(tokens[2]).toEqual value: 'foobar', scopes: ['source.awk', 'meta.function.awk', 'entity.name.function.awk']
    expect(tokens[3]).toEqual value: '(', scopes: ['source.awk', 'meta.function.awk']
    expect(tokens[4]).toEqual value: 'param', scopes: ['source.awk', 'meta.function.awk', 'variable.parameter.awk']
    expect(tokens[5]).toEqual value: ')', scopes: ['source.awk', 'meta.function.awk']

  it "tokensizes array", ->
    {tokens} = grammar.tokenizeLine("arr[0]")

    expect(tokens[0]).toEqual value: 'arr[', scopes: ['source.awk', 'variable.other.awk']
    expect(tokens[1]).toEqual value: '0', scopes: ['source.awk', 'variable.other.awk', 'constant.numeric.awk']
    expect(tokens[2]).toEqual value: ']', scopes: ['source.awk', 'variable.other.awk']

  it "tokensizes regexp", ->
    {tokens} = grammar.tokenizeLine('sub(/^[[:alpha:]]+/, "")')

    expect(tokens[0]).toEqual value: 'sub', scopes: ['source.awk', 'support.function.builtin.awk']
    expect(tokens[1]).toEqual value: '(', scopes: ['source.awk']
    expect(tokens[2]).toEqual value: '/', scopes: ['source.awk', 'string.regexp.awk', 'string.regexp.begin.awk']
    expect(tokens[3]).toEqual value: '^', scopes: ['source.awk', 'string.regexp.awk', 'constant.character.awk']
    expect(tokens[4]).toEqual value: '[', scopes: ['source.awk', 'string.regexp.awk']
    expect(tokens[5]).toEqual value: '[:alpha:]', scopes: ['source.awk', 'string.regexp.awk', 'support.class.awk']
    expect(tokens[6]).toEqual value: ']', scopes: ['source.awk', 'string.regexp.awk']
    expect(tokens[7]).toEqual value: '+', scopes: ['source.awk', 'string.regexp.awk', 'constant.character.awk']
    expect(tokens[8]).toEqual value: '/', scopes: ['source.awk', 'string.regexp.awk', 'string.regexp.end.awk']
    expect(tokens[9]).toEqual value: ', ', scopes: ['source.awk']
    expect(tokens[10]).toEqual value: '"', scopes: ['source.awk', 'string.quoted.double.awk']
    expect(tokens[11]).toEqual value: '"', scopes: ['source.awk', 'string.quoted.double.awk']
    expect(tokens[12]).toEqual value: ')', scopes: ['source.awk']
