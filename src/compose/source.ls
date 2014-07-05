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

define ["ls!src/compose/templating",
        "ls!src/semantics"] (Templating, Semantics) ->

  {

    generate-source: (semantics, graph, options) ->
      res = graph.nodes |> map (n) ->
        {
          node: n
          implementation: options.best-match n.name, semantics, options, "implementations"
          symbol: options.best-match n.name, semantics, options, "symbols"
        }

      constr = (Semantics.query semantics, "js-csp", options, "construction").0

      sources = constr.templates |> map (t) ->
        if t.process == "once"
          t["template-file"]
        else if t.process == "graph"
          console.log graph.connections
          Templating.process t["template-file"], graph, options
        else if t.process == "implementations" or t.process == "nodes"
          res |> map (r) ->
            Templating.process t["template-file"], r, options

      fold1 (+), (flatten sources)

  }
