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

define ["snap"] (Snap) ->

  { 
    create: (config) ->
      Snap config.display-element


    clear: (UI) ->
      UI.clear!

    add-node: (UI, name) ->
      Snap.load "resources/button.svg", (f) !->
        tC = f.select "\#textContainer"
        tC.attr text: name
        
        dragArea = f.select "\#drag"
        g = f.select "g"
        UI.display.canvas.append g
        move = (dx,dy) !->
          g.attr {
            transform: (g.data 'origTransform') + "t" + [dx, dy]
          }

        start = !->
          g.data 'origTransform', g.transform!.local
        stop = !->
          g.data 'origTransform', g.transform!.local

        dragArea.drag move,start,stop

  }