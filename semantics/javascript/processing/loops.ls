/* This file is part of Buggy.

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

#######  Loops
###  This post processing module finds loops and adds groups that
###  stop looping after the last element.


# unique representation of an node
id = (v) ->
  v.generic

# gets the outgoing edges of an vertex
out-edges = (graph, v) ->
  graph.connections |> filter -> (id it.from) == v

# find loops in a graph and returns an array of every loop
loops = (graph) ->
  # use DFS to find loops
  pred = {}
  finished = {}
  loop-list = []

  dfs-recursive = (u, v) ->
    cnid = (id v)  + ":" + v.connector
    pred[cnid] = [{generic: (id u), connector: u.connector, to: (id v), to-conn: v.connector}]

    (out-edges graph, id v) |> map (c) ->
      ccnid = (id c.to) + ":" + c.to.connector
      if not (ccnid of pred)
        dfs-recursive c.from, c.to
      else if not (ccnid of finished)
        pred[ccnid].push generic: (id v), connector: c.from.connector, to: (id c.to), to-conn: c.to.connector
        loop-list.push { generic: (id v), connector: v.connector, from: u.generic, from-conn: u.connector }

    finished[cnid] = true

  graph.nodes |> map (v) ->
    (out-edges graph, v.id) |> map (c) ->
      ccnid = (id c.to) + ":" + c.to.connector
      if (not (ccnid of pred))
        dfs-recursive c.from , c.to

  double-connection = (values pred) |> filter (c) ->
    c.length == 2

  generic-id = (dc) ->
    conn_id = join "_", (words dc.0.to-conn)
    dc.0.to + "__" + conn_id + "CSPLoopControl"

  new-nodes = (double-connection) |> map (dc) ->
    {
      name: "CSPLoopControl",
      id: generic-id dc,
    }

  connections = graph.connections |> filter (c) ->
    not (double-connection |> any (dc) ->
      dc.0.to == c.to.generic and dc.0.to-conn == c.to.connector)

  new-connections = double-connection |> map (dc) ->
    [
      {
        from: { generic: (generic-id dc), connector: "OutStream" }
        to: {  generic: dc.0.to,  connector: dc.0.to-conn }
        type: "Normal"
      }
      {
        from: { generic: dc.0.generic, connector: dc.0.connector }
        to: {  generic: (generic-id dc), connector: "Initial" }
        type: "Normal"
      }
      {
        from: { generic: dc.1.generic, connector: dc.1.connector }
        to: { generic: (generic-id dc), connector: "Stream" }
        type: "Normal"
      }
    ]

  {
    nodes: union graph.nodes, new-nodes
    connections: union connections, (flatten new-connections)
  }

return (graph) ->
  loops graph
