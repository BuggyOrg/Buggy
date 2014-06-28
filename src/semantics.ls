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
        "ls!src/semantics/loading"], (Sources, Symbols, Impl, Loading) ->

  Semantics = {
    create-semantics: (...) ->
      {
        sources: []
        symbols: []
        implementations: []
      }


    # loads a semantic file and recursively loads all dependencies
    load-semantic-file: (file, semantics-loaded) ->
      Semantics.load-semantic-files([file], semantics-loaded)

    load-semantic-files: (files, semantics-loaded) ->
      if typeof! files != "Array"
        throw "Files Array has wrong format"
      s = Semantics.create-semantics!
      load-file = (json) ->
        Symbols.add-symbols-from-json s, json
        Impl.add-implementations-from-json s, json
        # this must be the last call (currently) as it returns the
        # new sources added
        Sources.add-sources-from-json s, json

      console.log Loading
      Loading.load-file-recursively files, s, load-file, semantics-loaded

    query: (semantics, what, query-type = "Symbol") ->
      switch query-type
      | "Symbol"     => Symbols.query semantics, what
      | otherwise    => ...
  }
