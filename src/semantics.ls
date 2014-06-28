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
        "ls!src/semantics/loading"] (Sources, Symbols, Loading) ->

  Semantics = {
    create-semantics: (...) ->
      {
        sources: []
        symbols: []
      }


    # loads a semantic file and recursively loads all dependencies
    load-semantic-file: (file, semantics-loaded) ->
      s = Semantics.create-semantics!
      load-file = (json) ->
        Symbols.add-symbols-from-json s, json
        # this must be the last call (currently) as it returns the
        # new sources added
        Sources.add-sources-from-json s, json

      Loading.load-file-recursivly file, s, load-file, semantics-loaded

    query: (semantics, what, query-type = "Symbol") ->
      switch query-type
      | "Symbol"     => Symbols.query semantics, what
      | otherwise    => ...
  }
