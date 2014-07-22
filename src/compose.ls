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
        "ls!src/compose/source",
        "ls!src/semantics"
        "ls!src/compose/sanity-check",
        "ls!src/compose/postprocess"
        "ls!src/util/clone"], (DependencyGraph, Source, Semantics, SanityCheck, Postprocess, Clone) ->

  get-best-match = (id, semantics, options, type) -->
    res = Semantics.query semantics, id, options, type
    # TODO: currently the best match is the first match ;)
    res.0

  default-options = {
    output: {parent: "main", what: "Output"},
  }

  {
    compose: (semantics, options) ->
      # use default options where no options are set
      compose-options = Clone default-options
      compose-options <<< options

      if !compose-options.best-match?
        compose-options.best-match = get-best-match

      d-graph = DependencyGraph.generate semantics, compose-options
      p-graph = Postprocess.process d-graph, semantics, compose-options
      m-graph = DependencyGraph.mangle p-graph
      SanityCheck semantics, m-graph, compose-options
      o-graph = DependencyGraph.optimize m-graph
      source = Source.generate-source semantics, o-graph, compose-options



    create-dependency-graph: (semantics, options) ->
      # use default options where no options are set
      compose-options = Clone default-options
      compose-options <<< options

      if !compose-options.best-match?
        compose-options.best-match = get-best-match

      d-graph = DependencyGraph.generate semantics, compose-options
      if options.postprocessing
        p-graph = Postprocess.process d-graph, semantics, options
      else
        d-graph

  }
