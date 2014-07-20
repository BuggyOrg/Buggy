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

define ["ls!src/semantics/hooks/implementation-connections"
        "ls!src/semantics/loading"], (Conn, Loading) ->

  #%%#[Semantic Field/Implementations/Hooks]
  # array of hooks
  hooks =
    #%%#[Semantic Field/Implementations/Atomics]
    * name : "atomics with implementation file",
      description : "looks for implementation files and loads them",
      process : (impl) ->
        if impl["implementation-file"]?
          if impl.implementation?
            throw "Conflicting 'implemenation' and 'implemenation-file' definition for :\n" +
                JSON.stringify impl

          Loading.load-template-file impl["implementation-file"], ->
            impl.implementation = it
        return impl

    * name: "processing atomics",
      description: "adds the field 'atomic' if it isn't present and defaults it to false",
      process: ->
        if !it.atomic?
          it.atomic = false
        return it
    #%%#[Semantic Field/Implementations/NodesRef]
    * Conn
