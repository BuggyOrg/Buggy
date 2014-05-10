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


requirejs.config({
  paths: {
  	'text': "lib/text",
  	'json': "lib/json",
    'src': "src",
    'driver': "src/browser/driver",
    'livescript': "lib/livescript",
    'ls': "lib/ls",
    'prelude': "lib/prelude-browser",
    'snap': 'lib/snap.svg-min',
    'jquery': 'lib/jquery.2.1.1.min'
  }
});

require(["ls!src/buggy", "ls!src/group", "ls!src/generic", "ls!src/browser/buggy-ui", "snap", "jquery"], function(Buggy, Group, Generic, BuggyUI, Snap, $){
  exports.installPrelude(window);

  var scene = Buggy.create();
  var groupName = $("#semanticGroup").val();
  var newGroup = Group.create({name: groupName});
  Buggy.addGroup(scene, newGroup);

  var UI = BuggyUI.create({
    displayElement: "#svg",
    resources: {
      group: "resources/button.svg",
    },
    viewstate : {
      activeGroup: groupName,
      activeImplementation: 0,
    }
  }, function(UI){
    var addGroup = function(){
      // add a generic with the name we don't need to resolve it at first
      var groupName = $("#name").val();
      var newGeneric = Generic.create(groupName);
      var implementation = scene.symbols[UI.viewstate.activeGroup][UI.viewstate.activeImplementation];
      Group.addGeneric(implementation, newGeneric);
      console.log(scene);
      BuggyUI.refresh(UI, scene);
    }

    $("#addGroup").click(addGroup);
  });

  var add__Group = function () {
    var name = $("#name").val();
    var s = Snap("#svg");
    Snap.load("resources/button.svg", function(f){
      var tC = f.select("#textContainer");
      tC.attr({text: name});
      tC.hover(function(){
        tC.animate({transform:"t0,0 s1.35"}, 500);
      }, function(){
        tC.animate({transform:"t0,0 s1"}, 500);
      });
      var dragArea = f.select("#drag");
      var g = f.select("g");
      s.append(g);
      var move = function(dx,dy) {
        g.attr({
            transform: g.data('origTransform') + (g.data('origTransform') ? "T" : "t") + [dx, dy]
        });
      }
      var start = function() {
        g.data('origTransform', g.transform().local );
      }
      var stop = function() {
        g.data('origTransform', g.transform().local );
      }
      dragArea.drag(move,start,stop);
    });
  };
});
