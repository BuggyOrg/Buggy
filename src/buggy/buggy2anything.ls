#!/usr/bin/env lsc

require! yargs
beautify = (require "js-beautify").js_beautify
global <<< require \prelude-ls

require "../require.js"


yargs = yargs.usage "Usage: $0 -i <buggy-file> -l <language-definition> -o <executable> [ -m <module-file> ]"
yargs = yargs.describe "s", "semantic modules that will be loaded including language definition"
yargs = yargs.describe "l", "output language like 'javascript' or similar"
#yargs = yargs.describe "o", "output file of the executable (which file type it produces depends on the chosen language"
yargs = yargs.describe "d", "prints the dependcy graph only"
yargs = yargs.describe "g", "result prints debug information"
yargs = yargs.demand <[ s l ]>
args = yargs.argv

options = {
  debug: args.g?
  language: args.l
}

Compose = requirejs "ls!src/compose"
Semantics = requirejs "ls!src/semantics"

Semantics.load-semantic-files args.s, (semantics) ->
  if args.d?
    options.postprocessing = args.d>1
    console.log "dep_graph" + (args.d) + " = " + JSON.stringify (Compose.create-dependency-graph semantics, options), null, 2
  else
    console.log Compose.compose semantics, options
