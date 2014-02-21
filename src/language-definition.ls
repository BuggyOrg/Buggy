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


# a language definition can try to resolve every symbol by querying it
# against the language specification and (probably) the distributed specification
# of arbitrary sources (depending on the query function selected)
define (...) ->

  {
    create-definition: (query-function) ->
      { 
        # '## LanguageName' is a special function implemented by every language
        # that simply gives the name of the implemented language
        name: query-function "## LanguageName"
        query: (name) ->
          query-function name
      }

    # returns a query function for a json specification
    load-specification-from-json: (json) ->
      # return the query function that uses the json
      # to look up entries/symbols
      (name) ->
        if (name.indexOf "## ") == 0
          json.meta[name.substring 3]
        else
          # also check distributed sources...
          json.symbols[name]
  }
