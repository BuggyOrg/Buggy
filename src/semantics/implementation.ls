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

define ["ls!src/semantics/loading"], (Loading) ->

  Implementation = {
    add-implementation: (semantics, implementation) -->
      if implementation["implementation-file"]?
        if implementation.implementation?
          throw "Conflicting 'implemenation' and 'implemenation-file' definition for :\n" +
              JSON.stringify implementation

        Loading.load-template-file implementation["implementation-file"], ->
          console.log "Implemetation: \n" + it
          implementation.implementation = it
      if !(semantics.implementations?)
        semantics.implementations = [implementation]
      else
        semantics.implementations.push implementation
      implementation

    add-implementations-from-json: (semantics, json) ->
      if json.implementations?
        json.implementations |> map Implementation.add-implementation semantics
      else
        []

    query: (semantics, what, language="javascript") ->
      semantics.implementations |> filter -> it.name == what && it.language == language
  }
