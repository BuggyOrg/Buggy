/* This file is part of Buggy.

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

define ->
  Sources = {
    add-source: (semantics, source) -->
      if !(semantics.sources?)
        semantics.sources = [source]
      else
        semantics.sources.push source
      source

    add-sources-from-json: (semantics, json) ->
      if json.sources?
        json.sources |> map Sources.add-source semantics
      else
        []

    loadable: (source) ->
      source.type == "load"

    file-uri: (source) ->
      source.uri
  }
