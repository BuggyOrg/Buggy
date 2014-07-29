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

set-id-for-group-connectors = (generic, connection) ->
  if "id" of generic
    if connection.from.generic == generic.name
      connection.from.generic = generic.id
    if connection.to.generic == generic.name
      connection.to.generic = generic.id
  return connection

define ["ls!src/generic", "ls!src/util/clone"], (Generic, Clone) ->

  connections = {
    create: (in-generic, in-connector, out) ->
      if out.0 == ">"
        out-string = (out[1 til].join "")
        [out-generic, out-connector] = out-string.split ":"
        connections.create(in-generic, in-connector, { generic: out-generic, connector: out-connector })
      else
        out-generic = out.generic
        out-connector = out.connector
        type = if out.type? then out.type else "Normal"
        return {
          id: "#out-generic:#out-connector -> #in-generic:#in-connector"
          to: {
            generic: in-generic
            connector: in-connector
          }
          from: {
            generic: out-generic
            connector: out-connector
          }
          type: type
        }

    gather: (group-symbols, group-implementation, generic) ->
      Connection = this
      connections = []
      if group-implementation.connections?
        connections = union connections, Clone group-implementation.connections

      return (connections |> map -> set-id-for-group-connectors generic, it)

  }

  return connections
