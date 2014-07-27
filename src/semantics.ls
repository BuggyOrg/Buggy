/*
  This file is part of Buggy.

  Buggy is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  Buggy is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with Buggy.  If not, see <http://www.gnu.org/licenses/>.
*/

define ["ls!src/semantics/sources",
        "ls!src/semantics/symbols",
        "ls!src/semantics/implementation",
        "ls!src/semantics/construction",
        "ls!src/semantics/modules",
        "ls!src/semantics/meta",
        "ls!src/semantics/loading"], (Sources, Symbols, Impl, Construction, Modules, Meta, Loading) ->

  Semantics = {
    create-semantics: (...) ->
      {
        sources: []
        symbols: []
        modules: []
        meta: []
        implementations: []
        construction: []
      }

    # loads a semantic file and recursively loads all dependencies
    load-semantic-file: (file, semantics-loaded) ->
      Semantics.load-semantic-files([file], semantics-loaded)

    load-semantic-files: (files, semantics-loaded) ->
      if typeof! files != "Array"
        throw "[Semantics] Files Array has wrong format"
      s = Semantics.create-semantics!
      load-file = (json) ->
        Symbols.add-from-json s, json
        Impl.add-from-json s, json
        Construction.add-from-json s, json
        Modules.add-from-json s, json
        Meta.add-from-json s, json
        # this must be the last call as it returns the
        # new sources added
        return Sources.add-from-json s, json

      Loading.load-file-recursively files, s, load-file, semantics-loaded

    query: (semantics, what, options, query-type = "Symbol") ->
      switch query-type
      | "symbols"         => Symbols.query semantics, what, options
      | "implementations" => Impl.query semantics, what, options
      | "construction"    => Construction.query semantics, what, options
      | "modules"         => Modules.query semantics, what, options
      | "meta"            => Meta.query semantics, what, options
      | otherwise         => ...
  }
