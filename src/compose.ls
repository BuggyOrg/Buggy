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

define ["ls!src/resolve", "ls!src/group", "ls!src/generic", "ls!src/graph"], (Resolve, Group, Generic, Graph) ->
  
  get-best-match = (id, resolve) ->
    r = resolve[id]
    if typeof! r == "Array"
      r.0
    else
      r

  generate-source-map-for = (group, resolve, sources) ->
    id = Group.identifier group
    # if we already found the source for this group skip it
    if sources[id]?
      return

    resolved = get-best-match id, resolve
    if resolved.atomic? and resolved.atomic
      sources[id] = resolved.implementation
    else if resolved.module? and resolved.module
      sources[id] = resolved.implementation
    else
      if group.generics?
        group.generics |> map (g) ->
          identifier = Generic.name g
          grp = resolve[identifier]
          if typeof! grp == "Array"
            grp |> map -> generate-source-map-for &0, resolve, sources
          else
            generate-source-map-for grp, resolve, sources
        sources[id] = "{{group #id}}"

  generate-dependency-graph = (generic-name, resolve) ->
    # TODO: implement 'if main is output' (single output selected, we are not running a whole program)
    # this case should be dealt with somewhere .. probably here

    console.log resolve
    console.log "best match for #generic-name"
    grp = get-best-match generic-name, resolve
    console.log grp
    grp-graph = Graph.from-group grp
    grp-graph.nodes |> map (n) ->
      console.log "node found #n"

    name: "DEPENDENCYGRAPH"


  # generates source code for the program and resolved objects
  generate-source-for = (entry, resolve) ->
    dependency-graph = generate-dependency-graph entry, resolve

    console.log dependency-graph

    sources = {}
    generate-source-map-for main-entry-group, resolve, sources
    source = ""
    keys sources |> map (id) !->
      source += "// begin source for #id \n"
      source += sources[id]
      source += "\n// end source for #id \n"

    return source

  {
    compose: (ld, done) ->
      Resolve.resolve ld, (resolve) ->
        source = generate-source-for "main" resolve
        done? source
      
  }
