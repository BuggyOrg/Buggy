function Input(callback){
	var sys = require("sys");

	var stdin = process.openStdin();

	listener = function(Value) {
		# perhaps substring of d without newline?
	    callback({Value: Value});
	};

	stdin.addListener("data", listener);
}

function Add(Input, callback){
	var Sum;
	Sum = Input.Term1 + Input.Term2;
	callback({Sum: Sum});
}
function Output(Input){
	console.log(Input.String);
	// no output connector -> no callback!
}

function Node__Input(OutQueues){
	Input(function(returnVals){
		for(var key in OutQueues){
			// enqueue in the right queue
			OutQueues[key].enqueue(returnVals[key]);
		}
	});
}

function Node__Add(InQueues, OutQueues){
	var InValues = {}
	for(var key in InQueues){
		InValues[key] = InQueues[key].dequeue();
	}
	Add(InValues, function(returnVals){
		for(var key in OutQueues){
			// enqueue in the right queue
			OutQueues[key].enqueue(returnVals[key]);
		}
	});
}

function Node_Output(InQueues){
	var InValues = {}
	for(var key in InQueues){
		InValues[key] = InQueues[key].dequeue();
	}
	Output(InValues);
}

function Node_Add2()
     Output: 
      { id: 'Output',
        tag: undefined,
        source: 'function {{id}} ({{commaSeparated inputNames}}){\n {{implement generics}} {{implement connections}} \n}' },
     Add2: 
      { id: 'Add2',
        tag: undefined,
        source: 'function {{id}} ({{commaSeparated inputNames}}){\n {{implement generics}} {{implement connections}} \n}' },
     Add3: 
      { id: 'Add3',
        tag: undefined,
        source: 'function {{id}} ({{commaSeparated inputNames}}){\n {{implement generics}} {{implement connections}} \n}' } },
