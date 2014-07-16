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
    from-group: (grp-sym, grp-impl) ->
      graph = {
        nodes: if !grp-impl.generics? then [] else
            grp-impl.generics |> map (g) ->
              {
                name: Generic.name g
                id: Generic.identifier g
                parent-group: Group.identifier grp-impl
                meta: g.meta
              }
        connections: (Connection.gather grp-sym, grp-impl) |> map (c) ->
          {
            from: c.output
            to: c.input
            type: c.type
            parent-group: Group.identifier grp-impl
          }
      }

    get-group-connections: (graph, grp) ->
      grp-id = Group.identifier grp
      graph.connections |> filter (c) -> c.parent-group == grp-id

    get-group-nodes: (graph, grp) ->
      grp-id = Group.identifier grp
      graph.nodes |> filter (n) -> n.parent-group == grp-id

    union: (graph1, graph2) ->
      {
        nodes: union graph1.nodes, graph2.nodes
        connections: union graph1.connections, graph2.connections
      }

    remove-double-connections: (graph) ->
      new-connections = graph.connections |> map (c) ->
        throughput = graph.connections |> filter (c2) ->
          (c.to.generic == c2.from.generic and c.to.connector == c2.from.connector)

        inputs = graph.connections |> any (c2) ->
          (c2.to.generic == c.from.generic and c2.to.connector == c.from.connector)

        if inputs
          []
        else if throughput.length == 0
          c
        else
          throughput |> map (t) ->
            {
              from: c.from
              to: t.to
              type: "Normal"
              parent-group: c.parent-group
            }

      {
        nodes: graph.nodes
        connections: flatten new-connections
      }

    add-node: (graph, node) ->
      node-graph = { nodes: [{ name: node, id: node }], connections: []}
      Graph.union graph, node-graph
  }

  return Graph
