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

# This config is used during creation. If any config isn't specified use
# one from the default config
default-config = {
  display-element: undefined,
  resources: {
    group: "resources/button.svg",
  },
  display: {
    type: "snap-display"
  }
};

define ["ls!src/util/clone"] (Clone) ->

  { 
    create: (config, callback) ->
      # first write the default config
      new-ui = Clone default-config
      # and overwrite all elements defined in config
      new-ui <<< Clone config

      # load the display driver
      requirejs ["ls!driver/"+new-ui.display.type], (display) ->
        new-ui.display.driver = display
        new-ui.display.canvas = display.create new-ui
        callback(new-ui)

    refresh: (UI, scene) ->
      console.log "refreshing UI"
      canvas = UI.display.canvas
      # first sync everything
      display = {}
      UI.display.driver.sync canvas, !->
        node-display = {}
        # TODO: this shouldn't be hardcoded
        node-display[it.type] = {
          x: it.x
          y: it.y
        }
        display[it.id] = node-display
      # then clear everything
      UI.display.driver.clear canvas
      # then recreate stuff..
      if "viewstate" of UI and UI.viewstate.activeGroup of scene.symbols
        implementation = scene.symbols[UI.viewstate.activeGroup][UI.viewstate.activeImplementation];
        implementation.generics |> map !-> UI.display.driver.add-node canvas, it, display[it.id]

  }
