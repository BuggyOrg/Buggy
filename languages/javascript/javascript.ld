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
				"name":  "Add",
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
				"description" : "Adds two numbers",
				"implementation" : "{{output 'Sum'}} = Number({{input 'Term 1'}}) + Number({{input 'Term 2'}});"
			}
		],
		"Constant" : [
			{
				"name" : "Constant",
				"atomic" : true,
				"connectors" : [
					{
						"name" : "Value",
						"connector-type" : "Output",
						"data-type" : "{{meta 'Constant.data-type'}}"
					}
				],
				"description" : "Represents a constant value. Set the value of the constant in the meta information",
				"implementation" : "{{output 'Value'}} = {{meta 'Constant.value'}};"
			}
		],
		"Fold"		: [
			{
				"name" : "Fold",
				"atomic" : true,
				"connectors" : [
					{
						"name" : "Initial",
						"connector-type" : "Input"
					},
					{
						"name" : "Array",
						"connector-type" : "Input",
						"data-type" : "array"
					},
					{
						"name" : "FunctionResult",
						"connector-type" : "Input"
					},
					{
						"name" : "Value1",
						"connector-type" : "Output"
					},
					{
						"name" : "Value2",
						"connector-type" : "Output"
					},
					{
						"name" : "Result",
						"connector-type" : "Output"
					}
				]
			}
		],
		"StringToNumber" : [
			{
				"name" : "StringToNumber",
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
				"description" : "Converts a String into a number",
				"implementation" : "{{output 'Number'}} = Number({{input 'String'}});"
			}
		],
		"StringToArray" : [
			{
				"name" : "StringToArray",
				"atomic" : true,
				"connectors" : [
					{
						"name" : "String",
						"connector-type" : "Input",
						"data-type" : "string"
					},
					{
						"name" : "Array",
						"connector-type" : "Output",
						"data-type" : "array"
					}
				]
			}
		]
	},
	"transformations" : {
		"string -> number" : [ "StringToNumber"	],
		"string -> array" : [ "StringToArray"	]
	},
	"construction" : {
		"atomic" : "function {{generic.name}} (input, callback){\n  var output = {};\n  {{node.implementation}}\n{{#unless node.explicit-callback}}  callback(output);\n{{/unless}} }\n",
		"node" : "function Node_{{generic.id}} (InQueues, OutQueues){ \n  if({{#each node.connectors}}{{#if_eq connector-type \"Input\"}} InQueues[\"{{../../generic.id}}:{{name}}\"].isEmpty() || {{/if_eq}}{{/each}} false){ \n    return; \n  } \n  var InValues = { \n{{#each node.connectors}}{{#if_eq connector-type \"Input\"}}    \"{{name}}\" : InQueues[\"{{../../generic.id}}:{{name}}\"].dequeue(), \n{{/if_eq}}{{/each}}  } \n  {{generic.name}}(InValues, function(returnVals){ \n    for(var key in returnVals){ \n      OutQueues[\"{{generic.id}}:\" + key].enqueue(returnVals[key]); \n    } \n  }); \n} \n \n",
		"group" : "function Group_{{generic.id}} (InQueues, OutQueues){ \n  qInput = { \n{{#each connectors}}{{#if_eq connector-type \"Input\"}}    \"{{generic}}:{{name}}\" : Queue(), \n{{/if_eq}}{{/each}}  }; \n  qOutput = { \n{{#each connectors}}{{#if_eq connector-type \"Output\"}}    \"{{generic}}:{{name}}\" : Queue(), \n{{/if_eq}}{{/each}}  }; \n{{#each connections}}  qOutput[\"{{from.generic}}:{{from.connector}}\"].addEnqueueCallback(function(item){ qInput[\"{{to.generic}}:{{to.connector}}\"].enqueue(item);}); \n{{/each}} \n{{#each connectors}}{{#if_eq connector-type \"Output\"}}  qOutput[\"{{generic}}:{{name}}\"].addEnqueueCallback(function(){ qOutput[\"{{generic}}:{{name}}\"].dequeue(); }); \n{{/if_eq}}{{/each}} \n{{#each connectors}}{{#if_eq connector-type \"Input\"}}  qInput[\"{{generic}}:{{name}}\"].addEnqueueCallback(function(){ Node_{{generic}}(qInput,qOutput); }); \n{{/if_eq}}{{/each}} \n  return {input:qInput, output:qOutput}; \n} \n \n"
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
