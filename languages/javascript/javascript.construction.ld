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
				"connectors" : [
					{
						"name" : "Value",
						"connector-type" : "Output",
						"data-type" : "{{meta 'Constant.data-type'}}"
					}
				]
			}
		],
		"Fold1"		: [
			{
				"name" : "Fold1",
				"atomic" : true,
				"connectors" : [
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
		"node" : "!!node!!",
		"group" : "!!group!!"
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