// ########### Pure function implementations of atomics
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

// ########### Node specific callback that handles in/output

function Node__Input(_, OutQueues){
	Input(function(returnVals){
		for(var key in OutQueues){
			// enqueue in the right queue
			OutQueues[key].enqueue(returnVals[key]);
		}
	});
}

function Node__Add(InQueues, OutQueues){
	var InValues = {};
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
	var InValues = {};
	for(var key in InQueues){
		InValues[key] = InQueues[key].dequeue();
	}
	Output(InValues);
}

function Node_Add2(InQueues, OutQueues){
	var InValues = {};
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

function Node_Add2(InQueues, OutQueues){
	var InValues = {};
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

// ########### Group definition

// The main group has NO input / output connectors
function Group_Main(_, _){
	qInput_In = { 
		"Add:Term1" : new Queue(), "Add:Term2" : new Queue(),
		"Add2:Term1" : new Queue(), "Add2:Term2" : new Queue(),
		"Add3:Term1" : new Queue(), "Add3:Term2" : new Queue(),
		"Output:Output" : new Queue()
	};
	qInput_Out = {
		"Input:Input" : new Queue(),
		"Add:Sum" : new Queue(),
		"Add2:Sum" : new Queue(),
		"Add3:Sum" : new Queue(),
	}
	
}
