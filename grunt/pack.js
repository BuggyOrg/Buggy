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
          baseUrl: ".",
//          baseUrl: "path/to/base",
          name: "node_modules/almond/almond.js",
          include: ["ls!src/buggy"],
          out: "build/buggy.js",
          paths: {
            'text': "lib/text",
            'json': "lib/json",
            'src': "src",
            'semantics': "semantics",
            'examples': "examples",
            'LiveScript': "lib/livescript",
            'handlebars': "lib/handlebars",
            'ls': "lib/ls",
            'prelude': "lib/prelude-browser",
          },
          wrap: {
              startFile: 'grunt/start.frag',
              endFile: 'grunt/end.frag'
          },
          shim: {
            'handlebars':{
              exports: "Handlebars"
            }
          },
          stubModules: ["ls","json","text"],
          onBuildWrite: function (moduleName, path, contents) {
            if(moduleName == "ls") {
              return "define('"+ moduleName +"', {load:function(){}});";
            }
            return contents;
          },
          optimize:"uglify2",
          preserveLicenseComments:false,
          generateSourceMaps: true
        }
      }
    },
    shell: {
      semantics: {
        command: function(){
          var sources = ["semantics/base.json",
                         "semantics/javascript/js.json"];
          var src = "-s " + sources.join(" -s ");
          console.log("src/buggy/buggy2anything.ls -l javascript -n " + src + " > build/semantics.js");
          return "src/buggy/buggy2anything.ls -l javascript -n " + src + " > build/semantics.js";
        }
      }
    }
  });

  grunt.loadNpmTasks('grunt-contrib-requirejs');

  grunt.registerTask("pack", ["requirejs", "shell:semantics"]);

}
