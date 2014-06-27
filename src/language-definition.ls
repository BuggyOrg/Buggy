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

  ld = {
    create: (query-function) ->
      modules = []
      query-f = (name, type) ->
        module-q-functions = modules |> map -> it.query
        q-functions = concat [query-function, module-q-functions]

        # remove all null values and return first non null value
        if type == "search"
          flatten (filter (-> it?), (q-functions |> map -> it name, type))
        else
          first (filter (-> it?), (q-functions |> map -> it name, type))
      {
        # '## LanguageName' is a special function implemented by every language
        # that simply gives the name of the implemented language
        name: query-function "## LanguageName"
        query: query-f
        search: (name) ->
          query-f name, "search"
        add-module: (module) ->
          modules.push module
      }

    # returns a query function for a json specification
    load-query-from-json: (json) ->
      # TODO: perform a sanity check !!
      # sanity-check json
      # return the query function that uses the json
      # to look up entries/symbols
      (name, type) ->
        if (name.indexOf "## ") == 0 and json.meta?
          json.meta[name.substring 3]
        else if  (name.indexOf "--> ") == 0 and json.construction?
          json.construction[name.substring 4]
        else if type != "search" && name of json.symbols
          # TODO: also check distributed sources...
          json.symbols[name]
        else if type == "search"
          capName = name.toLowerCase!
          result = (keys json.symbols) |> map ->
            if ((it.toLowerCase!).search capName) != -1
              json.symbols[it]
          filter (-> it?), result
        else
          null

    # returns a query function for a json specification
    load-from-json: (json) ->
      query = ld.load-query-from-json json
      ld.create query

    # returns a query function for a json specification
    load-module-from-json: (json) ->
      query = ld.load-query-from-json json
      ld-module = ld.create query
      ld-module.is-module = true
      return ld-module

  }

  return ld
