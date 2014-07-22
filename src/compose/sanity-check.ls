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

# Sanity Check...
define ["ls!src/resolve"] (Resolve) ->

  validate-connector = (semantics, graph, connector, id, options) ->
    nodes = graph.nodes |> filter -> it.id == id
    if empty nodes
      throw new Error "Connector #connector points to non existent generic with ID #id"
    if nodes.length > 1
      throw new Error "Ambiguous ID #id. More then one generic use this ID"

    res = Resolve.resolve nodes.0, semantics, options
    sym-connectors = res.symbol.connectors
    con = sym-connectors |> filter -> it.name == connector
    if empty con
      throw new Error "Connector #connector is no connector of #{res.symbol.name}"
    if con.length > 1
      throw new Error "Symbol #{res.symbol.name} has multiple connectors with the same name"


  (semantics, graph, options) ->
    graph.connections |> each (c) ->
      validate-connector semantics, graph, c.from.connector, c.from.generic, options
      validate-connector semantics, graph, c.to.connector, c.to.generic, options
