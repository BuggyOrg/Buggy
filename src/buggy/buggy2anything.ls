#!/usr/bin/env lsc

require! yargs
beautify = (require "js-beautify").js_beautify
global <<< require \prelude-ls

require "../require.js"


yargs = yargs.usage "Usage: $0 -i <buggy-file> -l <language-definition> -o <executable> [ -m <module-file> ]"
yargs = yargs.describe "s", "semantic modules that will be loaded including language definition"
#yargs = yargs.describe "o", "output file of the executable (which file type it produces depends on the chosen language"
#yargs = yargs.describe "d", "prints the dependcy graph only"
yargs = yargs.describe "g", "result prints debug information"
yargs = yargs.demand <[ s ]>
args = yargs.argv

options = {
  debug: args.g?
}

Compose = requirejs "ls!src/compose"
Semantics = requirejs "ls!src/semantics"

Semantics.load-semantic-files args.s, (semantics) ->
  Compose.compose semantics, options
