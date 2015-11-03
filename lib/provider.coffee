fs = require 'fs'
path = require 'path'

keywordSelectorPrefixPattern = /([a-zA-Z]+)\s*$/
docURL = "https://www.gnu.org/software/gawk/manual/gawk.html"

module.exports =
  selector: '.source.awk'
  disableForSelector: '.source.awk .comment, source.awk .string'
  filterSuggestions: true

  getSuggestions: (request) ->
    completions = null
    scopes = request.scopeDescriptor.getScopesArray()

    if @isCompletingKeywordSelector(request)
      # console.log "DBG::getSuggestions[request]: " + request
      keywordCompletions = @getKeywordCompletions(request)
      # console.log "DBG::getSuggestions[completionsLength]: " + keywordCompletions.length
      if keywordCompletions?.length
        completions ?= []
        completions = completions.concat(keywordCompletions)

    completions

  onDidInsertSuggestion: ({editor, suggestion}) ->
    setTimeout(@triggerAutocomplete.bind(this, editor), 1) if suggestion.type is 'property'

  triggerAutocomplete: (editor) ->
    atom.commands.dispatch(atom.views.getView(editor), 'autocomplete-plus:activate', {activatedManually: false})

  loadKeywords: ->
    @keywords = {}
    fs.readFile path.resolve(__dirname, '..', 'completions.json'), (error, content) =>
      {@keywords} = JSON.parse(content) unless error?
      return

  isCompletingKeywordSelector: ({editor, scopeDescriptor, bufferPosition}) ->
    # console.log "DBG::isCompletingKeywordSelector[scopeDesc]: " + scopeDescriptor
    # console.log "DBG::isCompletingKeywordSelector[editor]: " + editor
    # console.log "DBG::isCompletingKeywordSelector[bufferPos]: " + bufferPosition
    scopes = scopeDescriptor.getScopesArray()
    keywordSelectorPrefix = @getKeywordSelectorPrefix(editor, bufferPosition)
    # console.log "DBG::isCompletingKeywordSelector[prefix]: " + keywordSelectorPrefix
    return false unless keywordSelectorPrefix?.length

    true

  getKeywordCompletions: ({bufferPosition, editor, prefix}) ->
    # console.log "DBG::getKeywordCompletions[bufferPos] " + bufferPosition
    # console.log "DBG::getKeywordCompletions[prefix] " + prefix
    completions = []
    for keyword, options of @keywords when firstCharsEqual(keyword, prefix)
      # console.log "DBG::getKeywordCompletions[keyword] " + keyword
      # console.log "DBG::getKeywordCompletions[options] " + options
      completions.push(@buildKeywordCompletion(keyword, options))
    completions

  getKeywordSelectorPrefix: (editor, bufferPosition) ->
    line = editor.getTextInRange([[bufferPosition.row, 0], bufferPosition])
    # console.log "DBG::getKeywordSelectorPrefix[line]: " + line
    keywordSelectorPrefixPattern.exec(line)?[1]

  buildKeywordCompletion: (keyword, {type, snippet, displayText, description, docAnchor, leftLabel, rightLabel}) ->
    # console.log "DBG::buildKeywordCompletion[snippetLength]: " + snippet.length
    # console.log "DBG::buildKeywordCompletion[displayText]: " + displayText
    # console.log "DBG::buildKeywordCompletion[leftLabel]: " + leftLabel
    # console.log "DBG::buildKeywordCompletion[rightLabel]: " + rightLabel
    completion =
      type: type
      description: description
      descriptionMoreURL: "#{docURL}##{docAnchor}"

    if displayText?.length
      completion.displayText = displayText

    if leftLabel?.length
      completion.leftLabel = leftLabel

    if rightLabel?.length
      completion.rightLabel = rightLabel

    if snippet?.length
      completion.snippet = snippet
    else
      completion.text = "#{keyword}"

    completion

firstCharsEqual = (str1, str2) ->
  str1[0].toLowerCase() is str2[0].toLowerCase()
