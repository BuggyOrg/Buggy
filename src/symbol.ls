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

define ["ls!src/util/clone"], (Clone) ->
  empty-symbol = {
    name : "Unnamed",
    connectors : [
#      { "name" : "StreamIn" , "type" : "Input" },
    ]
    meta: {}
  }

  Symbol = {
    
    create: (from) ->
      new-symbol = Clone empty-symbol
      if typeof! from == "String"
        new-symbol.name = from
        return new-symbol
      else 
        new-symbol <<< Clone from
      
    name: (symbol) ->
      symbol.name
    
    inputs: (symbol) ->
      symbol.connectors |> filter (.type == "Input")
      
    outputs: (symbol) ->
      symbol.connectors |> filter (.type == "Output")
      
    get-input: (symbol, name) ->
      first ((Symbol.inputs symbol) |> filter (.name == name))
    
    get-output: (symbol, name) ->
      first ((Symbol.outputs symbol) |> filter (.name == name))
    
    add-input: (symbol, name) ->
      if (Symbol.get-input symbol, name)
        throw new Error "[Symbol.addInput]: Input #name already 
                          exists in Symbol #{symbol.name}"
      symbol.connectors.push name: name, type: "Input"
    
    add-output: (symbol, name) ->
      if (Symbol.get-output symbol, name)
        throw new Error "[Symbol.addOutput]: Output #name already 
                          exists in Symbol #{symbol.name}"
      symbol.connectors.push name: name, type: "Output"
      
    remove-input: (symbol, name) ->
      symbol.connectors = 
        symbol.connectors |> reject -> (it.type == "Input" && it.name == name)
    
    remove-output: (symbol, name) ->
      symbol.connectors =
        symbol.connectors |> reject -> (it.type == "Output" && it.name == name)
      
  }
