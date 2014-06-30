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

define ["ls!src/compose/dependency-graph",
        "ls!src/resolve",
        "ls!src/compose/source",
        "ls!src/semantics"
        "ls!src/util/clone"], (DependencyGraph, Resolve, Source, Semantics, Clone) ->

  get-best-match = (id, semantics, options, type) -->
    res = Semantics.query semantics, id, options, type
    # TODO: currently the best match is the first match ;)
    res.0

  default-options = {
    output: {parent: "main", what: "Output"},
  }

  {
    /*compose: (ld, debug, done) ->
      Resolve.resolve ld, (resolve) ->
        source = Source.generate-for "main", resolve, ld, debug
        done? source*/

    compose: (semantics, options) ->
      # use default options where no options are set
      compose-options = Clone default-options
      compose-options <<< options

      if !compose-options.best-match?
        compose-options.best-match = get-best-match

      d-graph = DependencyGraph.generate semantics, compose-options
      console.log d-graph
      SanityCheck semantics, d-graph
      o-graph = DependencyGraph.optimize d-graph
      source = Source.generate-source semantics, o-graph, compose-options



    create-dependency-graph: (ld, done) ->
      Resolve.resolve ld, (resolve) ->
        done? DependencyGraph.generate-for "main", resolve, get-best-match

  }
