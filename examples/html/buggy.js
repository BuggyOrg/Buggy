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

function import$(obj, src){var own = {}.hasOwnProperty;for (var key in src) if (own.call(src, key)) obj[key] = src[key];return obj;}
import$(window, require('prelude-ls'));

requirejs.config({
  paths: {
  	'text': "lib/text",
  	'json': "lib/json",
    'src': "src",
    'driver': "src/browser/driver",
    'livescript': "lib/livescript",
    'ls': "lib/ls",
    'prelude': "lib/prelude-browser",
    'snap': 'lib/snap.svg-min'
  }
});

requirejs([
  "ls!src/buggy", "ls!src/group", "ls!src/generic", "ls!src/language-definition",
   "ls!src/browser/buggy-ui", 
  "json!languages/javascript/javascript.ld"],
  function(Buggy, Group, Generic, LD, BuggyUI, jsDef){

  var jsLD = LD.loadFromJson(jsDef);

  var uglyGlobalCounter = 1;
  var setupView = function(scene){
    $("#version").html(scene.meta.version);
    $(".logo").addClass("visible");
  }

  var setupScene = function (scene, groupName){
    var newGroup = Group.create({name: groupName});
    Buggy.addGroup(scene, newGroup);
  }

  var setupUI = function(UI){
    var addGroup = function(){
      // add a generic with the name we don't need to resolve it at first
      var groupName = $("#groupName").val();
      var newGeneric = Generic.create(groupName);
      newGeneric.id = groupName + "." + uglyGlobalCounter;
      uglyGlobalCounter++;
      var groupImplementation = scene.symbols[UI.viewstate.activeGroup][UI.viewstate.activeImplementation];
      Group.addGeneric(groupImplementation, newGeneric);
      console.log(scene);
      BuggyUI.refresh(UI, scene);
    }

    $("#addGroup").click(addGroup);

    $("#groupName").autocomplete({
      source: function(request, callback){
        Buggy.search(jsLD, request.term, function(result){
          callback(result);
        });
      },
      focus: function( event, ui ) {
        $( "#groupName" ).val( ui.item.name );
        return false;
      },
      select: function(event, ui){
        $( "#groupName" ).val( ui.item.name );
        return false;
      }
    })
    .data("ui-autocomplete")._renderItem = function( ul, item ) {
      return $( "<li>" )
        .append( "<a>" + item.name + '<div class="description">' + item.description + "</div></a>" )
        .appendTo( ul );
    };

    $("#semanticGroup").autocomplete({
      source: function(request, callback){
        Buggy.search(jsLD, request.term, function(result){
          callback(result);
        });
      },
      focus: function( event, ui ) {
        $( "#semanticGroup" ).val( ui.item.name );
        console.log("focus!!");
        UI.viewstate.activeGroup = ui.item.name;
        BuggyUI.refresh(UI, scene);
        return false;
      },
      select: function(event, ui){
        $( "#semanticGroup" ).val( ui.item.name );
        console.log("select!!");
        UI.viewstate.activeGroup = ui.item.name;
        BuggyUI.refresh(UI, scene);
        return false;
      }
    })
    .data("ui-autocomplete")._renderItem = function( ul, item ) {
      return $( "<li>" )
        .append( "<a>" + item.name + '<div class="description">' + item.description + "</div></a>" )
        .appendTo( ul );
    };
    $("#semanticGroup").keyup(function(){
      console.log("change!!");
      UI.viewstate.activeGroup = $("#semanticGroup").val();
      BuggyUI.refresh(UI, scene);
      return false;
    })
  };

  var scene = Buggy.create();
  setupView(scene);
  var groupName = $("#semanticGroup").val();
  setupScene(scene, groupName)

  var UI = BuggyUI.create({
    displayElement: "#svg",
    resources: {
      group: "resources/button.svg",
    },
    viewstate : {
      activeGroup: groupName,
      activeImplementation: 0,
    }
  }, setupUI);


});
