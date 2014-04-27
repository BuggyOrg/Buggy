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

define [\ls!src/connection, \ls!src/generic, \ls!src/group], (Connection, Generic, Group) ->

  Graph = { 
    from-group: (grp) ->
      {
        nodes: if !grp.generics? then [] else
            grp.generics |> map (g) ->
              { 
                name: Generic.name g
                id: Generic.identifier g
                parent-group: Group.identifier grp
              }
        connections: (Connection.gather grp) |> map (c) ->
          {
            from: c.output
            to: c.input
            parent-group: Group.identifier grp
          }
      }

    union: (graph1, graph2) ->
      {
        nodes: union graph1.nodes, graph2.nodes
        connections: union graph1.connections, graph2.connections
      }

    add-node: (graph, node) ->
      node-graph = { nodes: [{ name: node, id: node }], connections: []}
      Graph.union graph, node-graph
  }

  return Graph
