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

define ["ls!src/generic", "snap"] (Generic, Snap) ->

  { 
    create: (config) ->
      Snap config.display-element


    clear: (canvas) ->
      canvas.clear!

    # sync is called to request a metadata synchronization like positional data
    # this is usually done before saving a document or context-switches
    sync: (canvas, callback) ->
      allGroups = canvas.selectAll "g\#all"
      allGroups.items |> map !->
        transform = it.attr "transform"

        callback { 
          type: "position"
          id: it.attr "buggyNode"
          x: transform.localMatrix.e
          y : transform.localMatrix.f
        }

    add-node: (canvas, node, config) ->
      Snap.load "resources/button.svg", (f) !->
        tC = f.select "\#textContainer"
        tC.attr text: Generic.name node
        
        dragArea = f.select "\#drag"
        g = f.select "g"
        g.attr buggy-node: Generic.identifier node
        canvas.append g
        move = (dx,dy) !->
          g.attr {
            transform: (g.data 'origTransform') + "t" + [dx, dy]
          }

        start = !->
          g.data 'origTransform', g.transform!.local
        stop = !->
          g.data 'origTransform', g.transform!.local


        g.data 'origTransform', g.transform!.local

        if config? && "position" of config
          g.attr {
            transform: (g.data 'origTransform') + "t" + [config.position.x, config.position.y]
          }

        dragArea.drag move,start,stop

  }