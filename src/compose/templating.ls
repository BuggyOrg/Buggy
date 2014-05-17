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

define ["handlebars", "src/util/deep-find"] (Handlebars, DeepFind) ->

  install-helper = (...) ->
    Handlebars.registerHelper 'if_eq', (a, b, opts) ->
      if a == b
        opts.fn this
      else
        opts.inverse this

    Handlebars.registerHelper 'input', (a) ->
      "input[\"#a\"]"

    Handlebars.registerHelper 'output', (a) ->
      "output[\"#a\"]"

  install-helper!

  install-node-helper = (node) ->
    Handlebars.registerHelper 'meta-query', (a) ->
      "meta."+a

  uninstall-node-helper = (...) ->
    Handlebars.unregisterHelper 'meta-query'
      

  { 
    process: (text, generic, node, connections, connectors, inner-nodes) ->
      context = {
        generic: generic
        node: node
        connections: connections
        connectors: connectors
        meta: "{}"
      }
      if generic.meta?
        context.meta = JSON.stringify generic.meta

      install-node-helper generic

      # apply implementation templates
      if context.node.implementation?
        implTempl = Handlebars.compile context.node.implementation, noEscape: true
        context.node.implementation = implTempl context
      template = Handlebars.compile text, noEscape: true
      result = template context

      uninstall-node-helper!

      result
  }