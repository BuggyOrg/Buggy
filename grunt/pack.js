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

module.exports = function(grunt){


  grunt.config.merge({
    requirejs: {
      compile: {
        options: {
//          baseUrl: "path/to/base",
          name: "ls!src/buggy", // assumes a production build using almond
//          optimize: "uglify",
          out: "build/buggy.js",
          paths: {
            'text': "lib/text",
            'json': "lib/json",
            'src': "src",
            'semantics': "semantics",
            'examples': "examples",
            'livescript': "lib/livescript",
            'ls': "lib/ls",
            'prelude': "lib/prelude-browser",
          },
          stubModules: ["ls","json","text"],
          onBuildWrite: function (moduleName, path, contents) {
            if(moduleName == "ls") {
              return "define('"+ moduleName +"', {load:function(){}});";
            }
            return contents;
          }
        }
      }
    }
  });

  grunt.loadNpmTasks('grunt-contrib-requirejs');

}
