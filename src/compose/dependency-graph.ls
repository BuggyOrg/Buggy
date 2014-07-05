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

define ["ls!src/graph"] (Graph) ->

  /*generate-dependency-graph-old = (generic-name, resolve, match-function) ->
    # TODO: implement 'if main is output' (single output selected, we are not running a whole program)
      # this case should be dealt with somewhere .. probably here

      grp = match-function generic-name, resolve
      grp-graph = Graph.from-group grp
      sub-graphs = grp-graph.nodes |> map (n) ->
        generate-dependency-graph n.name, resolve, match-function

      fold Graph.union, grp-graph, sub-graphs*/

  generate-dependency-graph = (generic-name, semantics, options) ->
    # TODO: implement 'if main is output' (single output selected, we are not running a whole program)
      # this case should be dealt with somewhere .. probably here

      match-function = options.best-match
      grp = match-function generic-name, semantics, options, "implementations"
      if !grp?
        throw new Error "[Dependency Graph] Couldn't resolve the group '#generic-name'"
      grp-graph = Graph.from-group grp
      sub-graphs = grp-graph.nodes |> map (n) ->
        generate-dependency-graph n.name, semantics, options

      fold Graph.union, grp-graph, sub-graphs

  {

    generate: (semantics, options) ->
      # create the graph for the group described in output.parent
      # todo: use the real output node not the group containing the node
      dep-graph = generate-dependency-graph options.output.parent, semantics, options

      Graph.add-node dep-graph, options.output.parent

      dep-graph.nodes |> fold ((id,n) ->
        n.mangle = id
        id + 1), 0

      #name mangling for global connection graph
      dep-graph.connections |> map (c) ->
        node-from = first (dep-graph.nodes |> filter (n) -> n.name == c.from.generic)
        node-to = first (dep-graph.nodes |> filter (n) -> n.name == c.to.generic)
        c.from.mangle = node-from.mangle
        c.to.mangle = node-to.mangle

      return dep-graph

    optimize: (graph) ->
      graph
  }
