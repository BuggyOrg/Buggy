

var collectDocumentationFiles = function(page) {
  var path = require("path");
  var doc = page.documentation;
  var curPath = doc.path;
  var files = {};
  for(var chapter in doc.chapters){
    var chap = doc.chapters[chapter];
    var chapPath = path.join(curPath, chap.path);
    for(var section in chap.sections){
      var sec = chap.sections[section];
      var secFileName = path.join(chapPath, sec.file);
      files[secFileName + ".html"] = secFileName + ".jade";
    }
  }
  return files;
}

module.exports = function(grunt) {
  'use strict';


  var page = require("../page.json");
  var files = collectDocumentationFiles(page);

  grunt.config.merge({
    jade: {
      documentation: {
        options: {
          data: page
        },
        files: files
      }
    }
  });

  grunt.loadNpmTasks('grunt-contrib-jade');

}
