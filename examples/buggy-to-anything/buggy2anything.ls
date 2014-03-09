#!/usr/bin/env lsc

require! yargs
global <<< require \prelude-ls

requirejs = require \../../node_modules/.bin/r.js

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


yargs = yargs.usage "Usage: $0 -i [buggy-file] -l [language-definition] -o [executable]"
yargs = yargs.describe "i", "the input file containing the buggy programm"
yargs = yargs.describe "l", "expects a language definition file containing compilation information"
yargs = yargs.describe "o", "output file of the executable (which file type it produces depends on the chosen language"
yargs = yargs.demand <[ i l o ]>
args = yargs.argv

file = requirejs "json!" + args.i
ld-file = requirejs "json!" + args.l

environment = requirejs "ls!src/environment"
compose = requirejs "ls!src/compose"
LD = requirejs "ls!src/language-definition"

ld = LD.load-from-json ld-file
env = environment.load file
compose.compose env, ld

