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

define ["ls!src/compose/dependency-graph", "ls!src/resolve", "ls!src/compose/source"], (DependencyGraph, Resolve, Source) ->

  get-best-match = (id, resolve) ->
    r = resolve[id]
    # TODO: currently the best match is the first match ;)
    if typeof! r == "Array"
      r.0
    else
      r

  {
    compose: (ld, done) ->
      Resolve.resolve ld, (resolve) ->
        source = Source.generate-for "main", resolve, ld
        done? source


    create-dependency-graph: (ld, done) ->
      Resolve.resolve ld, (resolve) ->
        done? DependencyGraph.generate-for "main", resolve, get-best-match

  }
