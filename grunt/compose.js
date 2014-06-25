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

  grunt.registerTask('compose', "translates a buggy program into an executable. The output language defaults to Javascript", function(spec,inout_module){
    if(!spec){
      grunt.fail.fatal("You have to specify a target file via 'grunt compose:path/to/file'");
    }
    if(!inout_module)
    {
      inout_module = "jsshell.json";
    }
    var file = spec;
    grunt.log.write("Building File " + file + " for target language 'Javascript'");

    // at first update and check the language / program files
    grunt.task.run("lang");
    grunt.task.run("shell:jsonLintFile:"+file);

    var file_out_path = generateBuildPath(file, grunt);
    // some ugly regex to replace (hopefully) the ending!
    // taken from http://stackoverflow.com/questions/4250364/how-to-trim-a-file-extension-from-a-string-in-javascript thanks to John Harstock
    var file_out = generateBuildFilepath(file, grunt);
    grunt.config("mkdir.buildFile.options.create", [file_out_path]);
    grunt.task.run("mkdir:buildFile");
    grunt.task.run("shell:compose:"+file+":"+file_out+":"+inout_module);
  });

  grunt.registerTask('lang', ['shell:buildLanguage', 'shell:checkLanguageFile']);

  grunt.loadNpmTasks('grunt-shell');
  grunt.loadNpmTasks('grunt-mkdir');

  grunt.config.merge({
    shell: {
      buildLanguage: {
        command: "node tools/build_language_file.js languages/javascript/javascript.construction.ld > languages/javascript/javascript.ld"
      },
      jsonLintFile: {
        command: function(file){
          return "jsonlint " + file;
        },
        options : {
          stdout: false
        }
      },
      checkLanguageFile: {
        command: "jsonlint languages/javascript/javascript.ld",
        options: {
          stdout: false
        }
      },
      compose: {
        command: function(file, file_output, inout_module){
          return "examples/buggy-to-anything/buggy2anything.ls -l ../../languages/javascript/javascript.ld -m ../modules/"+inout_module+" -m ../../" + file + " > " + file_output;
        }
      }
    },

    mkdir: {
      buildFile: {
        options: {
          create: ['build']
        }
      }
    },
  });
}