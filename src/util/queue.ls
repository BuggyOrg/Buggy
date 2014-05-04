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

define (...) ->
  # crappy queue implementation
  # TODO: improve!!
  (...) ->
    items = []

    # first version uses callbacks.. probably not such a good idea.. but sufficient..
    enqueue-callbacks = []
    call-enqueue-callbacks = (item) !->
      enqueue-callbacks |> map !-> it item
    
    Queue = {      
      enqueue: (item) !->
        items.push item
        call-enqueue-callbacks item

      is-empty: (...) ->
        items.length == 0

      dequeue: (...) ->
        if Queue.is-empty!
          null
        else
          item = items[0]
          items := items.splice(1)
          return item

      add-enqueue-callback: (callback) ->
        enqueue-callbacks.push callback
    }
