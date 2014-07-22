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

define ["LiveScript"], (ls) ->

  resolve-module = (mod-impl, generic) ->
    if !"module" of generic
      throw new Error "Module Attribute 'module' not set in #{generic.name}"
    (eval ls.compile mod-impl.process) generic

  {
    resolve: (generic, semantics, options) ->
      match-function = options.best-match
      grp-impl = match-function generic.name, semantics, options, "implementations"
      grp-sym = match-function generic.name, semantics, options, "symbols"
      mod-impl = match-function generic.name, semantics, options, "modules"

      if mod-impl
        mod = resolve-module mod-impl, generic
        grp-sym = mod.symbol
        grp-impl = mod.implementation

      if grp-impl
        {
          symbol: grp-sym
          implementation: grp-impl
        }
  }
