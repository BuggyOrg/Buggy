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

define ->

  (field-name, hooks = [], predicates = []) ->
    #%%#[Semantic Field]
    SemanticField = {
      add: (semantics, fieldValue) -->
        fieldValue = hooks |> fold ((val,hook) -> hook.process val), fieldValue

        if !(semantics[field-name]?)
          semantics[field-name] = [fieldValue]
        else
          semantics[field-name].push fieldValue
        return fieldValue

      add-from-json: (semantics, json) ->
        if json[field-name]?
          json[field-name] |> map SemanticField.add semantics
        else
          []

      query: (semantics, what, options) ->
        semantics[field-name] |> filter ((elem)->
          (predicates |> fold ((val, pred) ->
            val && pred.process elem, what, options), true))
    }
