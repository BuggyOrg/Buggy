
var sourceRefs = function(grunt, identify, where_path, sub_where, url){

  var path = require("path");
  var where = path.join(where_path, sub_where);

  var parseRef = function(ref){
    return ref.split("[")[1].split("]")[0];
  }

  var urlExchange = function(file){
    return file.replace(where,url);
  }

  return function(res){
    var grep = require("grep1");
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
      res(results);
    });
  };
}

// Code from: https://github.com/rxaviers/cldr
//
var merge = function() {
    var destination = {},
        sources = [].slice.call( arguments, 0 );
    sources.forEach(function( source ) {
        var prop;
        for ( prop in source ) {
            if ( prop in destination && Array.isArray( destination[ prop ] ) ) {

                // Concat Arrays
                destination[ prop ] = destination[ prop ].concat( source[ prop ] );

            } else if ( prop in destination && typeof destination[ prop ] === "object" ) {

                // Merge Objects
                destination[ prop ] = merge( destination[ prop ], source[ prop ] );

            } else {

                // Set new values
                destination[ prop ] = source[ prop ];

            }
        }
    });
    return destination;
};

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
  var sourceRefPath = "./.buggy_files/develop/";
  if(grunt.file.exists("./.buggy-source-path")){
    sourceRefPath = grunt.file.read("./.buggy-source-path").split("\n")[0];
    grunt.registerTask("sourceRefs", ["grepSourceRefs"]);
  }
  else {
    grunt.registerTask("sourceRefs", ["git-update", "grepSourceRefs"]);
  }

  var srcRefs = sourceRefs(grunt, "#%%#", sourceRefPath, "src", "https://github.com/BuggyOrg/Buggy/blob/develop/src");
  var semRefs = sourceRefs(grunt, "#%%#", sourceRefPath, "semantics", "https://github.com/BuggyOrg/Buggy/blob/develop/semantics");

  grunt.registerTask("grepSourceRefs",
    "Searches the repository for source references", function(){
      var done = this.async();
      var rets = 0;
      var sourceRefs = {};
      var res = function(json){
        rets += 1;
        sourceRefs = merge(sourceRefs, json);
        if(rets == 2){
          grunt.file.write("source-refs.js", "sourceRefs = " + JSON.stringify(sourceRefs, null, 2));
          done();
        }
      }
      srcRefs(res);
      semRefs(res);
    });


}
