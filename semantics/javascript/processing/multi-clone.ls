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

#######  CSP Multi Clone
###  To emulate arbitrary output connections streams are cloned
###  An arbitrary number of outgoing connectors is required but not
###  possible so we have to emulate this behaviour by manipulating the graph.

return (graph) ->
  graph.nodes = graph.nodes |> map (n) ->
    if (take 5, n.name) == "Clone"
      if (drop 5, n.name) == "2"
        {
          name: "Clone",
          id: n.id
          mangle: n.mangle,
          parent-group: n.parent-group
        }
      else
        throw new Error "Clone with more than 2 outputs not supported yet"
    else
      n

  graph
