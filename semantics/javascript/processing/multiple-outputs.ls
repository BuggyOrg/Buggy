(graph) ->
  # creates a uniqe name for the connection node
  c-name = (c) ->
    cname = c.from.generic + "__" + c.from.mangle + "__" + c.from.connector
    if c.type == "Inverse"
      cname = cname + "_INV"
    return cname

  # creates a unique new name for the clone node
  clone-name = (mangle) ->
    "Clone__" + mangle

  max-mangle = maximum (graph.nodes |> map (n) -> n.mangle)
  console.warn max-mangle

  node-outs = {}
  graph.connections |> map (c) ->
    cname = c-name c
    if cname of node-outs
      node-outs[cname].push c
    else
      node-outs[cname] = [c]

  mult-nodes = (values node-outs) |> filter -> it.length > 1
  console.warn JSON.stringify mult-nodes, null, 2

  new-nodes = mult-nodes |> map ->
    max-mangle := max-mangle + 1
    {
      name: "Clone"
      id: clone-name it.0.from.mangle
      parent-group: it.0.from.parent-group
      mangle: max-mangle
    }
  console.warn graph.nodes
  console.warn new-nodes
#  connections = graph.connections |> map (c) ->
#    cname = c-name c
#    if c-name of mult-nodes
#      {
#        id: clone-name mangle + ": Cloned -> " +
#      }

  graph
