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

/** An implementation is the concrete description of how a symbol ( generic )
  * is implemented. It can either be a group that itself consits of generics
  * or it can be an atomic that is implemented in a specific language
  */
define ["ls!src/generic", 
        "ls!src/group",
        "ls!src/util/clone"] (Generic, Group, Clone) ->
  
  # or it can be an atomic
  empty-atomic = {
    name: "Unnamed Atomic"
    atomic: true
    language: ""
    implementation: ""
    symbol: ""
  }
  
  
  Implementation = {
    /** creates a new group with the given details
     * all necessary fields are defined in the empty-group
     * so create-group can be run without an argument
     */
    create-group: (group-details) ->
      Group.create group-details
      
    create-atomic: (atomic-details) ->
      
    
    is-group: (implementation) ->
      !implementation.atomic? or !implementation.atomic
        
    is-atomic: (implementation) ->
      implementation.atomic? and implementation.atomic

    /** creates an implementation using the information in the details field
     */
    create: (details) ->
      if details.atomic
        Implementation.create-atomic details
      else
        Implementation.create-group details

    /** gets the identifier for the implementation */
    identifier: (impl) ->
      # currently the implementation is identified by its name, but that
      # should change somewhen to an unique identifier
      impl.name

    smybol-name: (impl) ->
      impl.symbol
  }
