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

function generateBuildPath(path, grunt,level){
  return grunt.config.get("buildDir") + path.substring(0, path.lastIndexOf("/") + 1);
}

function generateBuildFilepath(path, grunt,level){
  return grunt.config.get("buildDir") + path.replace(/\.[^/.]+$/, "_"+level+".depgraph.js");
}

function getFileName(path, grunt,level){
  return path.replace(/^.*[\\\/]/, '').replace(/\.[^/.]+$/, "");
}

module.exports = function(grunt){
  grunt.registerTask('dep-graph',
      "translates a buggy program and saves the dependency-graph",
      function(spec,level){

      var file = spec;
      var file_out = generateBuildFilepath(spec, grunt,level);
      var file_out_path = generateBuildPath(spec, grunt,level);
      var file_name = getFileName(file_out, grunt,level);

      grunt.task.run("shell:compose:"+file+":"+file_out+":semantics/javascript/modules/jshtml.json:"+level);
  });
}
