{
	"meta" : {
		"LanguageName" : "JavaScript",
		"Buggy-Version" : "3.0.0",
		"Source-Extension" : "js",
		"Interpreted" : true
	},
	"symbols" : {
		"Add"	: [
			{
				"atomic": true,
				"connectors": [
					{ 
						"name" : "Term 1",
						"connector-type" : "Input",
						"data-type"	: "number"
					},
					{
						"name" : "Term 2",
						"connector-type" : "Input",
						"data-type"	: "number"
					},
					{
						"name" : "Sum",
						"connector-type" : "Output",
						"data-type" : "number"
					}
				],
				"implementation" : "{{Sum}} = {{Term 1}} + {{Term 2}};"
			}
		],
		"StringToNumber" : [
			{
				"atomic" : true,
				"connectors" : [
					{
						"name" : "String",
						"connector-type" : "Input",
						"data-type" : "string"
					},
					{
						"name" : "Number",
						"connector-type" : "Output",
						"data-type" : "number"
					}
				],
				"implementation" : "{{Number}} = Number({{String}});"
			}
		]
	},
	"transformations" : {
		"string -> number" : [ "StringToNumber"	]
	},
	"construction" : {
		"atomic" : "function {{id}} ({{commaSeparated inputNames}}, callback){\n {{implementation}}\n callback{{commaSeperated outputNames}}\n}",
		"node" : "function Node_{{id}} (InQueues, OutQueues){\n var InValues = {};\n    for(var key in InQueues){\n     InValues[key] = InQueues[key].dequeue();\n    }\n  {{id}}(InValues, function(returnVals){ \n      for(var key in OutQueues){\n           OutQueues[key].enqueue(returnVals[key]);\n        }\n    });\n}",
		"group" : "function Group_{{id}} (InQueues, OutQueues){\n {{create_queues}}\n {{implement_connections}}\n {{activate_inputs}} \n}"
	},
	"sources" : [
		{
			"comment" : "Additional (Distributed) Source for symbols",
			"name" : "GitHub Project Source",
			"type" : "json",
			"url"  : "https://github.com/LittleHelicase/Buggy/..."
		}
	]
}