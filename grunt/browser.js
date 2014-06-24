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
    grunt.file.write(file_out_path+file_name + ".html", "<script src='https://code.jquery.com/jquery-2.1.1.min.js'></script><script src='"+file_name+".min.js'></script><body><h1>"+file_name+"</h1></body>");
  });

  grunt.registerTask('browser',
      "translates a buggy program into a html file with javascript",
      function(spec){
    grunt.task.run("compose:"+spec+":jshtml.json");
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
    grunt.task.run("generateHTMLFile:"+file_out_path+":"+file_name);
  });

  grunt.loadNpmTasks('grunt-browserify');

  grunt.config.merge({

  });
}
