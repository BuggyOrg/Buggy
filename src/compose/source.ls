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

define ["ls!src/compose/dependency-graph", "ls!src/compose/templating"] (DependencyGraph, Templating) ->

  get-best-match = (id, resolve) ->
    r = resolve[id]
    # TODO: currently the best match is the first match ;)
    if typeof! r == "Array"
      r.0
    else
      r

  get-source-for-generic = (name, resolve, ld) ->
    node-group = get-best-match name, resolve
    console.log name
    if node-group.atomic? and node-group.atomic or node-group.implemented? && node-group.implemented
      ld.query "--> atomic"

  get-source-for-node = (node, resolve, ld) ->
    ld.query "--> node"

  get-source-for-group = (name, resolve, ld) ->
    console.log name
    node-group = get-best-match name, resolve
    if (!node-group.atomic? and !node-group.atomic) and (!node-group.implemented? and !node-group.implemented)
      # shorties should be replaced by some uri form..
      console.log name  + " is a group"
      Templating.process (ld.query "--> group"), node-group

  generate-source-map-for = (d-graph, resolve, ld) ->
    valid-source = (src) -> typeof! src != "Undefined"

    console.log "########### atomics"
    name-source = d-graph.nodes |> map (n) ->
      src = get-source-for-generic n.name, resolve, ld
      if valid-source src
        then [n.name, id: n.id, source: src]
    console.log "########### nodes"
    node-source = d-graph.nodes |> map (n) ->
      src = get-source-for-node n.name, resolve, ld
      if valid-source src
        then [n.id, id: n.id, source: src]
    console.log "########### groups"
    group-source = d-graph.nodes |> map (n) ->
      src = get-source-for-group n.name, resolve, ld
      if valid-source src
        then [n.id, id: n.id, source: src]

    console.log "###########"

    c-source = d-graph.connections |> map (c) ->
      [c.id, ""]

    {
      implementations: pairs-to-obj (name-source |> filter -> it?)
      nodes: pairs-to-obj (node-source |> filter -> it?)
      groups: pairs-to-obj (group-source |> filter -> it?)
      connections: pairs-to-obj c-source
    }

  {

    # generates source code for the program and resolved objects
    generate-for: (entry, resolve, ld) ->
      dependency-graph = DependencyGraph.generate-for entry, resolve, get-best-match
      
      # TODO: calculate "distance" from entry-point to generate source in the right order (for languages that require that)
      console.log dependency-graph.nodes
      console.log dependency-graph.connections
      sources = generate-source-map-for dependency-graph, resolve, ld

      console.log sources

  #    keys sources |> map (id) !->
  #      source += "// begin source for #id \n"
  #      source += sources[id]
  #      source += "\n// end source for #id \n"

      source = ""
      return source
  }
