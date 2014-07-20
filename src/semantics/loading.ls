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
    if (file.indexOf "!") != -1
      file
    else if (file.indexOf "/") != -1
      "json!#file"
    else
      "json!semantics/#file"

  load-files = (files, loaded) ->
    #%%#[TODO: Better loading mechanism]
    requirejs files, loaded

  load-json = (files, loaded) ->
    load-files files, loaded

  # filters 'filter-num' many arguments from an argument 'map'
  filter-arguments = (argument-map, filter-num) ->
    (obj-to-pairs argument-map)
    |> filter -> it.0 >= filter-num
    |> map -> it.1

  process-file = (semantics, load-function, callback, json) -->
    pf-callback = process-file semantics, load-function, callback
    #perform a bfs to know when the async loading process is finished
    file-paths = (filter-arguments arguments, 2) |> map ->
      new-sources = load-function it
      file-sources = new-sources |> filter Sources.loadable
      file-sources |> map -> file-path Sources.file-uri it
    file-paths = flatten file-paths
    if empty file-paths
      callback semantics
    else
      load-json file-paths, pf-callback

  {
    load-file-recursively: (files, semantics, load-function, callback) ->
      file-paths = files |> map file-path
      loaded = process-file semantics, load-function, callback
      load-json file-paths, loaded

    load-template-file: (filepath, callback) ->
      load-files ["text!#filepath"], callback

  }
