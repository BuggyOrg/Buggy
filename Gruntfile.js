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

module.exports = function(grunt) {
  'use strict';

  // Project configuration.
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    // Before generating any new files, remove any previously-created files.
    clean: {
      web:  ['build'],
      app:  ['build'],
      test: ['test/*.js']
    },

    // Configuration to be run (and then tested).
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

    mochaTest: {
        options: {
            reporter: 'mocha-unfunk-reporter'
        },
        any: {
            src: ['test/**/*-test.js']
        }
    },
  });

  grunt.loadTasks('tasks');

  grunt.loadNpmTasks('grunt-contrib-clean');
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-livescript');
  grunt.loadNpmTasks('grunt-mocha-test');

  require('mocha-unfunk-reporter').option('reportPending', true);

  grunt.registerTask('app', ['livescript:app']);
  grunt.registerTask('test', ['livescript:test', 'exec:mocha_test', 'clean:test']);
  
  // By default, lint and run all tests.
  grunt.registerTask('default', ['app', 'test-app']);
  grunt.registerTask('continuous', ['app', 'watch']);
};