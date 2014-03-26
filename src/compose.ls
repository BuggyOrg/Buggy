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

define ["ls!src/resolve", "ls!src/group", "ls!src/generic", "ls!src/graph"], (Resolve, Group, Generic, Graph) ->
  
  get-best-match = (id, resolve) ->
    r = resolve[id]
    if typeof! r == "Array"
      r.0
    else
      r

  get-source-for-generic = (name, resolve, ld) ->
    node-group = get-best-match name, resolve
    console.log name
    console.log node-group
    if node-group.atomic? and node-group.atomic or node-group.implemented && node-group.implemented
      ld.query "--> atomic"

  get-source-for-node = (node, resolve, ld) ->
    ld.query "--> group"

  generate-source-map-for = (d-graph, resolve, ld) ->
    name-source = d-graph.nodes |> map (n) ->
      [n.name, id: n.id, tag: n.tag, source: get-source-for-generic n.name, resolve, ld]
    node-source = d-graph.nodes |> map (n) ->
      [n.id, id: n.id, tag: n.tag, source: get-source-for-node n, resolve, ld]

    c-source = d-graph.connections |> map (c) ->
      [c.id, ""]

    {
      implementations: pairs-to-obj name-source
      groups: pairs-to-obj node-source
      connections: pairs-to-obj c-source
    }

  generate-dependency-graph = (generic-name, resolve) ->
    # TODO: implement 'if main is output' (single output selected, we are not running a whole program)
    # this case should be dealt with somewhere .. probably here

    grp = get-best-match generic-name, resolve
    grp-graph = Graph.from-group grp
    sub-graphs = grp-graph.nodes |> map (n) ->
      generate-dependency-graph n.name, resolve

    fold Graph.union, grp-graph, sub-graphs

  # generates source code for the program and resolved objects
  generate-source-for = (entry, resolve, ld) ->
    dependency-graph = generate-dependency-graph entry, resolve
    console.log dependency-graph
    # TODO: calculate distance from entry to generate source in the right order (for languages that require that)
    sources = generate-source-map-for dependency-graph, resolve, ld

    console.log sources

#    keys sources |> map (id) !->
#      source += "// begin source for #id \n"
#      source += sources[id]
#      source += "\n// end source for #id \n"

    return source

  {
    compose: (ld, done) ->
      Resolve.resolve ld, (resolve) ->
        source = generate-source-for "main", resolve, ld
        done? source
      
  }
