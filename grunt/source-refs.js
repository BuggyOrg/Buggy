
var sourceRefs = function(grunt, where, url){

  var parseRef = function(ref){
    return ref.split("[")[1].split("]")[0];
  }

  var urlExchange = function(file){
    return file.replace(where,url);
  }

  return function(){
    var grep = require("grep1");
    var done = this.async();
    grep(["-n", "-H", "-r", "#%%#",where], function(err, stdout, stderr){
      var resultString = String(stdout);
      var resultLines = resultString.split("\n");
      var results = {};
      for(var i=0; i<resultLines.length-1; i++){
        var line = resultLines[i];
        var parts = line.split(":");
        var ref = parseRef(parts.slice(2).join(":"))
        results[ref] = {
          link: urlExchange(parts[0]),
          line: parts[1],
          ref: ref
        };
      }
      grunt.file.write("source-refs.js", "sourceRefs = " + JSON.stringify(results, null, 2));
      done();
    });
  };
}

module.exports = function(grunt) {
  'use strict';


  grunt.config.merge({
    clean: {
      developGit: ['.buggy_files/develop']
    },
    gitclone: {
      develop: {
        options: {
          repository: 'git@github.com:BuggyOrg/Buggy.git',
          branch: 'develop',
          directory: '.buggy_files/develop',
          depth: 1
        }
      }
    }
  });

  grunt.loadNpmTasks('grunt-git');
  grunt.loadNpmTasks('grunt-contrib-clean');

  grunt.registerTask("git-update", ["clean:developGit", "gitclone:develop"]);

  grunt.file.defaultEncoding = "utf8"
  var sourceRefPath = "./.buggy_files/develop/src/";
  if(grunt.file.exists("./.buggy-source-path")){
    sourceRefPath = grunt.file.read("./.buggy-source-path").split("\n")[0];
    grunt.registerTask("grepSourceRefs",
      "Searches the repository for source references", sourceRefs(grunt, sourceRefPath, "https://github.com/BuggyOrg/Buggy/blob/develop/src"));
    grunt.registerTask("sourceRefs", ["grepSourceRefs"]);
  }
  else {
    grunt.registerTask("grepSourceRefs",
      "Searches the repository for source references", sourceRefs(grunt, sourceRefPath, "https://github.com/BuggyOrg/Buggy/blob/develop/src"));
    grunt.registerTask("sourceRefs", ["git-update", "grepSourceRefs"]);
  }

}
