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


/** a group should be a semantic 'unit' that describes a process on a appropiate
 * abstraction level (sound a bit vague, but for low abstraction layers the group
 * can adress technical problems, wheres on a high level the group shouldn't adress
 * low level / technical issues as those aren't vital for the semantics)
 *
 * Groups shouldn't define exactly how everything works in detail, but should reference to
 * other generics that solve problems on a lower abstraction level.
 */
define ["ls!src/generic","ls!src/util/clone"], (Generic, Clone) ->
  empty-group = {
    name: "Unnamed"
    # generics are a concept that be an object that
    # is further specified by its name / type / meta
    # e.g. this could be a group, an atomic, a note or similar
    generics: []
    connections: []
    symbol: ""
    meta: {
      type: "group"
      description: "Buggy Group"
    }
  }
  
  get-new-unique-id = (group) ->
    ids = ["id"+i for i to group.generics.length]
    new-ids = ids |> drop-while (id) -> 
      (group.generics |> filter -> (Generic.identifier it) == id).length > 0
    first new-ids
    
  id-filter = (id, generic) -->
    (Generic.identifier generic) == id

  
  Group = {
    /** creates a group from the details using the minimum empty group to fill
      * empty fields
      */
    create: (group-details) ->
      new-group = Clone empty-group
      new-group <<< Clone group-details
      
    symbol: (group) ->
      group.symbol
      
    set-symbol: (group, symbol) ->
      group.symbol = symbol

    /** adds the generic to the group and returns the id of that generic
      * the id is an optional argument, if none is given a unique id
      * will be used automatically
      * throws an Error if the given id is already used
      */
    add-generic: (group, generic, id) ->
      # make a copy of it to ensure that no side effects can change
      # the value of the generic
      if id? and (Group.get-generic group, id)
        throw new Error "[Group.add-generic]: Generic with id #id already exists in #{group.name}"
      else
        id = get-new-unique-id group
      new-generic = Generic.copy generic
      new-generic.id = id
      group.generics.push new-generic
      return id
      
    generics: (group) ->
      group.generics
    
    remove-generic: (group, id) ->
      group.generics = group.generics |> reject id-filter id

    get-generics-by-name: (group, name) ->
      group.generics |> filter (g) -> (Generic.name g) == name
      
    get-generic: (group, id) ->
      first (group.generics |> filter id-filter id)
    
    /** adds a connection in group starting at the generic described by from
      * going to the generic described by to. The descriptions should contain
      * the id and the connector of the start/endpoint.
      */
    add-connection: (group, from, to) ->
      if Group.get-generic group, from.id and
        Group.get-generic group, to.id
        group.connections.push from: from, to: to
    
    connections: (group) ->
      group.connections
    
    remove-connection: (group, from, to) ->
      group.connections = 
        group.connections |> reject ->
          it.from.id == from.id and
          it.from.connector == from.connector and
          it.to.id == to.id and
          it.to.connector == to.connector
          
    connections-to: (group, to-id) ->
      group.connections |> filter ->
        it.to.id == to-id
    
    connections-from: (group, from-id) ->
      group.connections |> filter ->
        it.from.id == form-id
  }
