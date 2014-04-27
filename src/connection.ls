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

define ["ls!src/generic"], (Generic) ->

  connections = { 
    create: (in-generic, in-connector, out) ->
      if out.0 == ">"
        # TODO: the string version  ">NODE:CONNECTOR" should be translated to { "Node" : NODE, "Connector" : CONNECTOR }
        # and the logic for doing that should be here!
        out-string = (out[1 til].join "")
        [out-generic, out-connector] = out-string.split ":"
        connections.create(in-generic, in-connector, { generic: out-generic, connector: out-connector })
      else
        out-generic = out.generic
        out-connector = out.connector;
        return {
          id: "#out-generic:#out-connector -> #in-generic:#in-connector"
          input: {
            generic: in-generic
            connector: in-connector
          }
          output: {
            generic: out-generic
            connector: out-connector
          }
        }

    gather: (group) ->
      Connection = this
      if !group.generics? then return []
      flatten (group.generics |> map (generic) ->
        obj-to-pairs generic.inputs |> map (inputPair) ->
          inputID = inputPair.0
          inputGeneric = inputPair.1
          Connection.create (Generic.identifier generic), inputID, inputGeneric)
  }

  return connections