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

define ["ls!src/semantics/loading"], (Loading) ->

  # array of hooks
  hooks = [
    * name : "template file",
      description : "looks for the template files and loads them",
      process : (constrution) ->
        if constrution["templates"]?
          constrution.templates |> map (t) ->
            Loading.load-template-file t["file"], ->
              t["template-file"] = it
        return constrution
    * name : "processing file",
      description : "looks for the template files and loads them",
      process : (constrution) ->
        if constrution["postprocessing"]?
          constrution.postprocessing |> map (p) ->
            Loading.load-template-file p["procedure-file"], ->
              p["procedure"] = it
        return constrution
  ]
