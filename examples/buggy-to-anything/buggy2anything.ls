#!/usr/bin/env lsc

require! yargs
beautify = (require "js-beautify").js_beautify
global <<< require \prelude-ls

requirejs = require \../../node_modules/requirejs/bin/r.js

requirejs.config {
  nodeRequire: require
  paths: {
    'text': "../../lib/text"
    'json': "../../lib/json"
    'src': "../../src"
    'livescript': "../../lib/livescript"
    'ls': "../../lib/ls"
    'prelude': "../../lib/prelude-browser"
  }
}


yargs = yargs.usage "Usage: $0 -i <buggy-file> -l <language-definition> -o <executable> [ -m <module-file> ]"
yargs = yargs.describe "m", "additional (optional) module that will be loaded into the language definition (currently only one module is possible due to lazyness)"
yargs = yargs.describe "l", "expects a language definition file containing compilation information"
yargs = yargs.describe "o", "output file of the executable (which file type it produces depends on the chosen language"
yargs = yargs.describe "d", "prints the dependcy graph only"
yargs = yargs.describe "g", "result prints debug information"
yargs = yargs.demand <[ m l ]>
args = yargs.argv

ld-file = requirejs "json!" + args.l

debug = args.g?

compose = requirejs "ls!src/compose"
LD = requirejs "ls!src/language-definition"


ld = LD.load-from-json ld-file
if args.m?
  if typeof! args.m != "Array"
    module-file = requirejs "json!" + args.m
    ld-module = LD.load-module-from-json module-file
    ld.add-module ld-module
  else if typeof! args.m == "Array"
    args.m |> map (file) ->
      module-file = requirejs "json!" + file
      ld-module = LD.load-module-from-json module-file
      ld.add-module ld-module
if args.d?
  compose.create-dependency-graph ld, (graph) ->
    console.log JSON.stringify graph
else
  compose.compose ld, debug, (program) ->
    output = "";
    output += "var csp = require('js-csp');var merge = require('object-merge')\nfunction* id(input, out){\n  while(true){yield csp.put(out, yield csp.take(input));}\n}\n"
    output += program
    output += "Group_main();\n";
    console.log beautify output, indent_size: 2
