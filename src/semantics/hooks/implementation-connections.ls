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


define ["ls!src/connection", "ls!src/generic"], (Connection, Generic) ->

  * name: "connection translator"
    descrption: "translates connections stored in generics into the standardized format"
    process: (impl) ->
      if impl.generics?
        if !impl.connections
          impl.connections = []
        n-connections = flatten (impl.generics |> map (generic) ->
            obj-to-pairs generic.inputs |> map (inputPair) ->
              inputID = inputPair.0
              inputGeneric = inputPair.1
              Connection.create (Generic.identifier generic), inputID, inputGeneric)
        impl.connections = union impl.connections, n-connections
      return impl
