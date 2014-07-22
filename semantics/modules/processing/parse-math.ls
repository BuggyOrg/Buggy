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

math = require "mathjs"

rename = {
  "add" : "Add",
  "constant" : "Constant"
}

results = {
  "add" : "Sum",
  "constant" : "Value"
}

inputs = {
  "add" : ["Term 1", "Term 2"],
}

math-id-counter = 0

term-to-term-name = (term) ->
  if "fn" of term
    term.fn
  else if "value" of term
    "constant"
  else if "name" of term
    "input"

term-to-meta = (term, generic) ->
  switch term-to-term-name term
  | "constant" => { Constant : { value: term.value } }
  | "input"    => { is-input: true, input-of: generic.id }

get-connector = (term, conn) ->
  if conn == "Result"
    results[term-to-term-name term]
  else
    inputs[term-to-term-name term][conn]


term-to-generic = (term) ->
  if !(term.meta?) or !term.meta.isInput
    {
      name: rename[term.term-name]
      id: "math_" + term.id
      meta: term.meta
    }

create-connection = (t1, t2) ->
  if t1.meta? && t1.meta.is-input
    {
      from: { generic: t1.meta.input-of, connector: t1.name  }
      to: { generic: "math_" + t2.id, connector: get-connector t2, t1.connector-id}
    }
  else
    {
      from: { generic: "math_" + t1.id, connector: get-connector t1, "Result"  }
      to: { generic: "math_" + t2.id, connector: get-connector t2, t1.connector-id}
    }

create-input = (term) ->
  if term.meta && term.meta.is-input
    { name: term.name, type: "Input" }

term-to-generic-list = (term) ->
  if term.params?
    subnodes = (term.params |> map -> term-to-generic-list it)
    compact flatten (union [term-to-generic term], subnodes)
  else
    [term-to-generic term]

term-to-connection-list = (term) ->
  if term.params?
    flatten (term.params |> map ->
      union (term-to-connection-list it), [create-connection it, term])
  else
    []

term-to-input-list = (term) ->
  if term.params?
    inputs = flatten (term.params |> map ->
      term-to-input-list it)
    compact union [create-input term], inputs
  else
    [create-input term]

preprocess = (term, generic) ->
  term.term-name = term-to-term-name term
  term.id = math-id-counter
  term.meta = term-to-meta term, generic
  math-id-counter += 1
  if term.params?
    connector-id = 0
    term.params |> each ->
      it.connector-id = connector-id
      preprocess it, generic
      connector-id += 1
  return term

return (generic) ->
  term = math.parse generic.module.term
  term = preprocess term, generic

  inputs = term-to-input-list term
  inputs = union inputs, [{ name : "Result", type : "Output" }]
  generics = term-to-generic-list term
  connections = term-to-connection-list term
  connections.push {
    from: { generic: "math_" + term.id, connector: results[term.term-name] },
    to: { generic: generic.id, connector: "Result" }
  }

  {
    symbol: {
      name : "Math",
      id: generic.id
      connectors : inputs
    },
    implementation: {
      generics: generics
      connections: connections
    }
  }
