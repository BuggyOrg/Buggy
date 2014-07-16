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
    pred[cnid] = [id u]

    (out-edges graph, id v) |> map (c) ->
      ccnid = (id c.to) + ":" + c.to.connector
      if not (ccnid of pred)
        dfs-recursive c.from, c.to
      else if not (ccnid of finished)
        loop-list.push { generic: (id v), connector: v.connector, from: u.generic, from-conn: u.connector }

    finished[cnid] = true

  graph.nodes |> map (v) ->
    (out-edges graph, v.id) |> map (c) ->
      ccnid = (id c.to) + ":" + c.to.connector
      if (not (ccnid of pred))
        dfs-recursive c.from , c.to


  new-nodes = loop-list |> map (n) ->
    {
      name: "NoLast",
      id: n.generic + "NoLast",
    }

  connections = graph.connections |> filter (c) ->
    not (loop-list |> any (n) ->
      n.generic == c.to.generic and n.connector == c.to.connector
      and n.from == c.from.generic and n.from-conn == c.from.connector)

  new-connections = loop-list |> map (n) ->
    [
      {
        from: { generic: n.generic + "NoLast", connector: "OutStream" }
        to: {  generic: n.generic,  connector: n.connector }
        type: "Normal"
      }
      {
        from: { generic: n.from, connector: n.from-conn }
        to: {  generic: n.generic + "NoLast", connector: "Stream" }
        type: "Normal"
      }
    ]

  {
    nodes: union graph.nodes, new-nodes
    connections: union connections, (flatten new-connections)
  }

return (graph) ->
  #console.warn graph.nodes
  #console.warn graph.connections
  loops graph
