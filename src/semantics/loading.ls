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

define ["ls!src/semantics/sources"], (Sources) ->

  file-path = (file) ->
    "json!semantics/#file"

  load-json = (files, loaded) ->
    requirejs files, loaded

  # filters 'filter-num' many arguments from an argument 'map'
  filter-arguments = (argument-map, filter-num) ->
    (obj-to-pairs argument-map)
    |> filter -> it.0 >= filter-num
    |> map -> it.1

  process-file = (semantics, load-function, json) -->
    (filter-arguments arguments, 2) |> map ->
      new-sources = load-function it
      file-sources = new-sources |> filter Sources.loadable
      pf-callback = process-file semantics, load-function
      file-paths = file-sources |> map -> file-path Sources.file-uri it
      load-json file-paths, pf-callback

  {
    load-file-recursively: (file, semantics, load-function, callback) ->
      load-json [file-path file], (json) ->
        process-file semantics, load-function, json
        callback semantics
  }
