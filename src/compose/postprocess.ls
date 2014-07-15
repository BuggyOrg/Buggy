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
 along with Buggy. If not, see <http://www.gnu.org/licenses/>.
 */

define ["LiveScript",
        "ls!src/semantics"], (ls, Semantics) ->

  create-ruleset = (semantics, options) ->
    constr = (Semantics.query semantics, "js-csp", options, "construction").0
    constr.postprocessing |> map ->
      # eval only works for javascript so compile livescript to javascript
      eval ls.compile it["procedure"]


  apply-ruleset = (graph, rs) ->
    gr, rule <- fold _, graph, rs
    rule gr

  {
    process: (graph, semantics, options) ->
      rs = create-ruleset semantics, options
      console.warn rs
      apply-ruleset graph, rs

  }
