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

var handlebars = require("handlebars");

function generateBuildPath(path, grunt){
  return grunt.config.get("buildDir") + path.substring(0, path.lastIndexOf("/") + 1);
}

function generateBuildFilepath(path, grunt){
  return grunt.config.get("buildDir") + path.replace(/\.[^/.]+$/, ".js");
}

function getFileName(path, grunt){
  return path.replace(/^.*[\\\/]/, '').replace(/\.[^/.]+$/, "");
}

module.exports = function(grunt){
  grunt.registerTask('generateHTMLFile', function(file_out_path, file_name){
    var fs = require("fs");
    var tmpl = fs.readFileSync("grunt/html.template", "utf8");
    var context = { file_name: file_name };
    var template = handlebars.compile(tmpl);
    grunt.file.write(file_out_path+file_name + ".html", template(context));
  });

  grunt.registerTask('browser',
      "translates a buggy program into a html file with javascript",
      function(spec, debug){
    if(debug){
      grunt.task.run("compose:"+spec+":jshtml.json:"+debug);
    }
    else{
      grunt.task.run("compose:"+spec+":jshtml.json");
    }
    grunt.log.write("browserifying");
    var file_out = generateBuildFilepath(spec, grunt);
    var file_out_path = generateBuildPath(spec, grunt);
    var file_name = getFileName(file_out, grunt);
    grunt.config.merge({
      browserify: {
        specFile: {
          src: [file_out],
          dest:file_out_path + file_name + ".min.js"
        }
      }
    });
    grunt.task.run("browserify:specFile");
    grunt.task.run("dep-graph:"+spec+":1");
    grunt.task.run("dep-graph:"+spec+":2");
    grunt.task.run("generateHTMLFile:"+file_out_path+":"+file_name);
  });

  grunt.loadNpmTasks('grunt-browserify');

  grunt.config.merge({

  });
}
