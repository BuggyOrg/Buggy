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
            from: c.from
            to: c.to
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

    nodes-out-edges: (graph, v) ->
      graph.connections |> filter -> it.from.generic == v.id

    connectors-out-edges: (graph, c) ->
      graph.connections |> filter ->
        (it.from.generic == v.generic and it.from.connector == v.connector)

    remove-double-connections: (graph) ->
      on-removal-line = {}
      line-counts = {}
      graph.connections |> fold ((id,c) ->
        c.id-num = id
        on-removal-line[id] = []
        id + 1), 0

      graph.connections |> each (c) ->
        graph.connections |> each (c2) ->
          if (c.to.generic == c2.from.generic and c.to.connector == c2.from.connector)
            on-removal-line[c.id-num].push c2.id-num

      # partition by double connections and non double connections
      rem-partition = on-removal-line |> Obj.partition -> it.length > 0
      doubles = rem-partition[0]
      non-doubles = rem-partition[1]
      (keys non-doubles) |> each (key) ->
        non-doubles[key] = [ [key] ]

      get-predecessors = (key) ->
        keys (doubles |> Obj.filter (p) ->
          Number(key) in p)

      get-paths = (paths,n) ->
        if n < 1
          return paths
        new-paths = paths |> concat-map (path) ->
          key = last path
          preds = get-predecessors key
          if preds.length == 0
            then [path]
          else
            preds |> map (pred) ->
              union path, [pred]
        get-paths new-paths, n-1

      n = (keys doubles).length
      paths = (values non-doubles) |> concat-map ->
        get-paths it, n
      paths = paths |> filter -> it.length > 1

      new-connections = paths |> map (path) ->
        from = graph.connections[Number(last path)].from
        to = graph.connections[Number(first path)].to
        {
          from: from
          to: to
          type: "Normal"
        }

      con-list = unique (flatten paths)

      old-connections = graph.connections |> reject ->
        "#{it.id-num}" in con-list

      old-connections |> map (c) ->
        delete c.id-num

      {
        nodes: graph.nodes
        connections: union old-connections, new-connections
      }

    add-node: (graph, node) ->
      node-graph = { nodes: [{ name: node, id: node }], connections: []}
      Graph.union graph, node-graph
  }

  return Graph
