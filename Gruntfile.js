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

console.log(__dirname);

module.exports = function(grunt) {
  'use strict';

  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    clean: {
      web:  ['build'],
      app:  ['build'],
      test: ['test/*-test.js']
    },

    livescript: {
      test: {
        expand: true,
        cwd: 'test/',
        src: ['**/*.ls'],
        dest: 'test/',
        ext: '.js'
      },
      app: {
        expand: true,
        cwd: 'src/',
        src: ['**/*.ls'],
        dest: 'build/',
        ext: '.js'
      },
    },

    watch : {
      ls: {
        files: ['src/**/*.ls'],
        tasks: ['app'],
      },
      livereload: {
        options: {livereload: true},
        files: ['build/**/*']
      }

    },

    mochacli: {
        options: {
          require: ["test/require"],
          reporter: 'mocha-unfunk-reporter'
        },
        any: {
          src: ['test/**/*-test.js']
        }
    },

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
        command: function(file, file_output){
          return "examples/buggy-to-anything/buggy2anything.ls -l ../../languages/javascript/javascript.ld -m ../modules/jsshell.json -m ../../" + file + " > " + file_output;
        }
      }
    },

    mkdir: {
      buildFile: {
        options: {
          create: ['build']
        }
      }
    }
  });

  grunt.loadNpmTasks('grunt-contrib-clean');
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-livescript');
  grunt.loadNpmTasks('grunt-mocha-cli');
  grunt.loadNpmTasks('grunt-shell');
  grunt.loadNpmTasks('grunt-mkdir');

  require('mocha-unfunk-reporter').option('reportPending', true);

  grunt.registerTask('app', ['livescript:app']);
  grunt.registerTask('test', ['livescript:test', 'mochacli', 'clean:test']);

  grunt.registerTask('lang', ['shell:buildLanguage', 'shell:checkLanguageFile']);


  grunt.registerTask('compose', "translates a buggy program into a executable. The output language defaults to Javascript", function(spec){
    if(!spec){
      grunt.fail.fatal("You have to specify a target file via 'grunt compose:path/to/file'");
    }
    var file = spec;
    grunt.log.write("Building File " + file + " for target language 'Javascript'");

    // at first update and check the language / program files
    grunt.task.run("lang");
    grunt.task.run("shell:jsonLintFile:"+file);

    var file_out_path = "build" + file.substring(0, file.lastIndexOf("/") + 1);
    // some ugly regex to replace (hopefully) the ending!
    // taken from http://stackoverflow.com/questions/4250364/how-to-trim-a-file-extension-from-a-string-in-javascript thanks to John Harstock
    var file_out = "build/" + file.replace(/\.[^/.]+$/, ".js");;
    grunt.config("mkdir.buildFile.options.create", [file_out_path]);
    grunt.task.run("mkdir:buildFile");
    grunt.task.run("shell:compose:"+file+":"+file_out);

  });

  // By default, lint and run all tests.
  grunt.registerTask('default', ['app', 'test-app']);
  grunt.registerTask('continuous', ['app', 'watch']);
};
