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

var toString$ = {}.toString;
var Database = {
  createModel: function(model){
    var databaseModel;
    return databaseModel = {
      create: model.create,
      query: model.query,
      add: function(db, what, content){
        if (databaseModel.contains(db, what)) {
          throw new Error("Value " + what + " already exists. \n Values are immutable, it is impossible to update them. Create a new Datatype and hope for a good automatic optimization... or improve it yourself!");
        } else {
          return model.add(db, what, content);
        }
      },
      contains: function(db, what){
        return toString$.call(databaseModel.query(db, what)).slice(8, -1) !== 'Undefined';
      }
    };
  }
};

MapUtil = {
  find: function (obj, path) {
    var paths = path.split('.')
      , current = obj
      , i;

    for (i = 0; i < paths.length; ++i) {
      if (current[paths[i]] == undefined) {
        return undefined;
      } else {
        current = current[paths[i]];
      }
    }
    return current;
  },

  assign: function(obj, path, value) {
    keyPath = path.split(".");
    lastKeyIndex = keyPath.length-1;
    for (var i = 0; i < lastKeyIndex; ++ i) {
     key = keyPath[i];
     if (!(key in obj))
       obj[key] = {}
     obj = obj[key];
    }
    obj[keyPath[lastKeyIndex]] = value;
  }
};

Mapdatabase = Database.createModel({
  create: function(){
    return {};
  },
  query: function(db, what){
    return MapUtil.find(db, what);
  },
  add: function(db, what, content){
    return MapUtil.assign(db, what, content);
  }
});

