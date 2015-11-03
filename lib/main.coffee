provider = require './provider'

module.exports =
  activate: ->
    provider.loadKeywords()
    console.log "DBG::main: Hello from autocomplete provider awk"

  getProvider: -> provider
