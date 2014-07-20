

var collectDocumentationFiles = function(page) {
  var path = require("path");
  var doc = page.documentation;
  var curPath = doc.path;
  var files = {};
  for(var i=0; i<doc.chapters.length; i++){
    var chap = doc.chapters[i];
    var chapPath = path.join(curPath, chap.path);
    for(var j=0; j<chap.sections.length; j++){
      var sec = chap.sections[j];
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
