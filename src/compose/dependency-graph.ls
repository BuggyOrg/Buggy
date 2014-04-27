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

define ["ls!src/graph"] (Graph) ->

  generate-dependency-graph = (generic-name, resolve, match-function) ->
    # TODO: implement 'if main is output' (single output selected, we are not running a whole program)
      # this case should be dealt with somewhere .. probably here

      grp = match-function generic-name, resolve
      grp-graph = Graph.from-group grp
      sub-graphs = grp-graph.nodes |> map (n) ->
        generate-dependency-graph n.name, resolve, match-function

      fold Graph.union, grp-graph, sub-graphs

  {
    generate-for: (entry, resolve, match-function) ->
      # create the graph starting with the entry
      dependency-graph = generate-dependency-graph entry, resolve, match-function
      # add the entry group to the graph
      Graph.add-node dependency-graph, entry
  }
