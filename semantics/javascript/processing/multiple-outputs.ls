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

#######  CSP Multiple Outputs
###  CSP can only have one distinct output for every node
###  this method creates nodes that clone each stream if a Connector
###  is connector to more than one other node

# creates a uniqe name for the output connector of a node
c-name = (c) ->
  cname = c.from.generic + "__" + c.from.mangle + "__" + c.from.connector
  if c.type == "Inverse"
    cname = cname + "_INV"
  return cname

# creates a unique new name for the clone node
clone-name = (mangle) ->
  "Clone__" + mangle

node-connectors-with-multiple-outputs = (graph) ->
  # group nodes by their output connector
  node-outs = (graph.connections |> group-by (c) -> c-name c)
  # filter all with only one output those are okay for csp
  node-outs |> Obj.filter -> it.length > 1

return (graph) ->

  # further mangling requires the current maximum
  max-mangle = maximum (graph.nodes |> map (n) -> n.mangle)

  mult-nodes = node-connectors-with-multiple-outputs graph

  # create clone nodes
  new-nodes = (values mult-nodes) |> map ->
    {
      name: "Clone" + it.length  # length encoding is resolved in later postprocessing steps
      id: clone-name it.0.from.mangle
      parent-group: it.0.parent-group
      mangle: it.0.from.mangle
    }

  old-connections = graph.connections |> filter (c) ->
    cname = c-name c
    not (cname of mult-nodes)

  new-connections = (values mult-nodes) |> map (c-list) ->
    c-stream = 0
    cn = clone-name c-list.0.from.mangle
    connections = c-list |> map (c) ->
      c-stream := c-stream + 1
      {
        from: {
          generic: cn
          connector: "Stream#c-stream"
          mangle: c.from.mangle
        }
        to: c.to
        type: "Normal"
        parent-group: c.parent-group
      }
    union connections, [{
      from: c-list.0.from
      to: {
        generic: cn
        connector: "Stream"
        mangle: c-list.0.from.mangle
      }
      type: "Normal"
      parent-group: c-list.0.parent-group
    }]


  new-graph = {
    nodes: union graph.nodes, new-nodes
    connections: union old-connections, (flatten new-connections)
  }
  return new-graph
