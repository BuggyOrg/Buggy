
/**
 * Adapted from Rafael Rinaldi (rafaelrinaldi.com) (date Oct 17, 2013)
 */

var _fs = require("fs");

var _args = process.argv.slice(2);

var path = _args[0].split("/").slice(0,-1).join("/");
if(path.length == 0)
	path = ".";
path += "/";

var files = { "group": "group.handlebars.js", "node" : "node.handlebars.js", "atomic" : "atomic.handlebars.js" };
var templates = {};


function stringify(buffer) {
	var parsed = '',
			isFirstEntry = true,
			hasReachedLastLine = false,
			lines = buffer.split('\n'),
			totalLines = lines.length,
			lineNumber = 1;

	lines.forEach(function( line ) {
		hasReachedLastLine = lineNumber === totalLines;

		if(!isFirstEntry) {
			//parsed += '\n';
		}

		if(!hasReachedLastLine && line[line.length-1] != "\\") {
			parsed += line.replace(/\"/g, "\\\"") + ' \\n';
		} else if (line[line.length-1] == "\\") {
			parsed += line.slice(0,-1).replace(/\"/g, "\\\"");
		} else {
			parsed += line.replace(/\"/g, "\\\"");
		}

		isFirstEntry = false;

		lineNumber++;
	});
	return parsed;
}

for( key in files ){
	templates[key] = stringify(_fs.readFileSync(path+"construction/" + files[key]).toString());
}

var languageFile = _fs.readFileSync(_args[0]).toString();

for( key in templates ){
	languageFile = languageFile.replace("!!"+key+"!!", templates[key]);
}

console.log(languageFile);


