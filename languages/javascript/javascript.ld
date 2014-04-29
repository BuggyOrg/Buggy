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
				"implementation" : "{{var 'Sum'}} = {{var 'Term 1'}} + {{var 'Term 2'}};"
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
				"implementation" : "{{var 'Number'}} = Number({{var 'String'}});"
			}
		]
	},
	"transformations" : {
		"string -> number" : [ "StringToNumber"	]
	},
	"construction" : {
		"atomic" : "function {{generic.name}} ({{#each node.connectors}}{{#if_eq connector-type \"Input\"}}{{name}}, {{/if_eq}}{{/each}}callback){\n {{node.implementation}}\n callback({{commaSeperated_outputNames}});\n}\n",
		"node" : "function Node_{{generic.id}} (InQueues, OutQueues){\n var InValues = {};\n    for(var key in InQueues){\n     InValues[key] = InQueues[key].dequeue();\n    }\n  {{generic.name}}(InValues, function(returnVals){ \n      for(var key in OutQueues){\n           OutQueues[key].enqueue(returnVals[key]);\n        }\n    });\n}\n",
		"group" : "function Group_{{generic.id}} (InQueues, OutQueues){\n    qInput = {\n{{#each connectors}}{{#if_eq connector-type \"Input\"}}        \"{{generic}}:{{name}}\" : new Queue(),\n{{/if_eq}}{{/each}}    };\n    qOutput = {\n{{#each connectors}}        \"{{generic}}:{{name}}\" : new Queue(),\n{{/each}}    };\n {{implement_connections}}\n {{activate_inputs}} \n}\n"
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