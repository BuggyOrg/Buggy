/**
 * Reads a file content and converts it into a string.
 * @author Rafael Rinaldi (rafaelrinaldi.com)
 * @date Oct 17, 2013
 */
var 	_fs = require('fs'),
		_args = process.argv.slice(2),
		_file = _args[0],
		_isValidFile = _file && _fs.existsSync(_file);

function init() {
	if(_isValidFile) {
		loadFile(_args[0]);
	} else {
		console.log('Either none or invalid file URL.');
		process.kill();
	}
}

function loadFile(url, callback) {
	//console.log('Loading "%s"...', url);
	var file = _fs.readFileSync(url).toString();
	loadHandler(file);
}

function loadHandler(buffer) {
	var parsed = '',
			isFirstEntry = true,
			hasReachedLastLine = false,
			lines = buffer.split('\n'),
			totalLines = lines.length,
			lineNumber = 1;

	lines.forEach(function( line ) {
		hasReachedLastLine = lineNumber === totalLines;

		if(!isFirstEntry) {
			parsed += '\n';
		}

		if(!hasReachedLastLine) {
			parsed += line.replace() + ' \\n\\';
		} else {
			parsed += line;
		}

		isFirstEntry = false;

		lineNumber++;
	});
	console.log("var workerString = \""+parsed+"\"");
}

init();