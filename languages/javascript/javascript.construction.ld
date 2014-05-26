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
						"data-type" : "{{meta-query 'Constant.data-type'}}"
					}
				],
				"description" : "Represents a constant value. Set the value of the constant in the meta information",
				"implementation" : "{{output 'Value'}} = {{meta-query 'Constant.value'}};"
			}
		],
		"Each" : [
			{
				"name" : "Each",
				"atomic" : true,
				"connectors" : [
					{
						"name" : "Array",
						"connector-type" : "Input"
					},
					{
						"name" : "Element",
						"connector-type" : "Output"
					}
				],
				"description" : "Iterates over an array",
				"explicit-callback" : true,
				"implementation" : "for (var i = 0; i < {{input 'Array'}}.length; i++) {\n    {{output 'Element'}} = {{input 'Array'}}[i];\n    {{metadata 'id'}} = i;\n    callback(output);\n  }"
			}
		],
		"Select" : [
			{
				"name" : "Select",
				"connectors" : [
					{
						"name" : "Array",
						"connector-type" : "Input",
						"data-type" : "array"
					},
					{
						"name" : "Data",
						"connector-type" : "Output",
						"data-type" : "array"
					}
				],
				"generics" : [
					{
						"name" : "Each",
						"inputs" :  { "Array" : ">Select:Array" }
					},
					{
						"name" : "Switch",
						"inputs" : { "A" : ">Each:Element", "Switch" : ">Less:Result" }
					},
					{
						"name" : "Constant",
						"meta" : {
              "Constant" : {
                "data-type" : "number",
                "value" : 10
              }
            }
					},
					{
						"name" : "Less",
						"inputs" : { "what" : ">Each:Element", "lessThan" : ">Constant:Value" }
					}
				],
				"connections" : [
					{ 
						"id": "Switch:Result -> Select:Data",
			     	"input": { "generic": "Select", "connector": "Data" },
				    "output": { "generic": "Switch", "connector": "Result" }
					}
				]
			}
		],
		"Less" : [
			{
				"name" : "Less",
				"atomic" : true,
				"connectors" : [
					{
						"name" : "what",
						"connector-type" : "Input",
						"comment" : "Less could work on other data too, but for some an explicit method is needed..",
						"data-type" : "number"
					},
					{
						"name" : "lessThan",
						"connector-type" : "Input",
						"comment" : "Less could work on other data too, but for some an explicit method is needed..",
						"data-type" : "number"
					},
					{
						"name" : "Result",
						"connector-type" : "Output",
						"data-type" : "bool"
					}
				],
				"implementation" : "{{output 'Result'}} = {{input 'what'}} < {{input 'lessThan'}};"
			}
		],
		"car" : [
			{
				"name" : "car",
				"atomic" : true,
				"connectors" : [
					{
						"name" : "Array",
						"connector-type" : "Input",
						"data-type" : "array"
					},
					{
						"name" : "Value",
						"connector-type" : "Output"
					}
				],
				"explicit-callback" : true,
				"description" : "Gives the first element in a list. If the list is empty no callback will be invoked",
				"implementation" : "if({{input 'Array'}}.length > 0){\n    {{output 'Value'}} = {{input 'Array'}}[0];\n    callback(output);\n  }"
			}
		],
		"cdr" : [
			{
				"name" : "car",
				"atomic" : true,
				"connectors" : [
					{
						"name" : "Array",
						"connector-type" : "Input",
						"data-type" : "array"
					},
					{
						"name" : "Rest",
						"connector-type" : "Output"
					}
				],
				"explicit-callback" : true,
				"description" : "Gives the first element in a list. If the list is empty no callback will be invoked",
				"implementation" : "if({{input 'Array'}}.length > 0){\n    {{output 'Rest'}} = {{input 'Array'}}.slice(1);\n    callback(output);\n  }"
			}
		],
		"Empty" : [
			{
				"comment" : "this node is not in its final stage. The empty function should ask the type with a query if it is empty and not simply implement the functionality.",
				"name" : "Empty",
				"atomic" : true,
				"connectors" : [
					{
						"name" : "Array",
						"connector-type" : "Input",
						"data-type" : "array"
					},
					{
						"name" : "IsEmpty",
						"connector-type" : "Output",
						"data-type" : "bool"
					}
				],
				"implementation" : "{{output 'IsEmpty'}} = ({{input 'Array'}}.length == 0);"
			}
		],
		"Switch" : [
			{
				"name" : "Switch",
				"atomic" : true,
				"connectors" : [
					{
						"name" : "Switch",
						"connector-type" : "Input",
						"data-type" : "bool"
					},
					{
						"name" : "A",
						"connector-type" : "Input"
					},
					{
						"name" : "Result",
						"connector-type" : "Output"
					}
				],
				"explicit-callback" : true,
				"implementation" : "if({{input 'Switch'}}){\n   {{output 'Result'}} = {{input 'A'}};\n    callback(output);\n  }"
			}
		],
		"Mux" : [
			{
				"name" : "Mux",
				"atomic" : true,
				"connectors" : [
					{
						"name" : "Switch",
						"connector-type" : "Input",
						"data-type" : "bool"
					},
					{
						"name" : "A",
						"connector-type" : "Input"
					},
					{
						"name" : "B",
						"connector-type" : "Input"
					},
					{
						"name" : "Result",
						"connector-type" : "Output"
					}
				],
				"implementation" : "if({{input 'Switch'}}){\n   {{output 'Result'}} = {{input 'A'}};\n  } else {\n    {{output 'Result'}} = {{input 'B'}};\n  }"
			}
		],
		"Fold"		: [
			{
				"name" : "Fold",
				"generics" : [
					{
						"name" : "Empty",
						"id" : "EmptyInput",
						"inputs" : { "Array" : ">Fold:Array" }
					},
					{
						"name" : "car",
						"inputs" : { "Array" : ">Fold:Array" }
					},
					{
						"name" : "cdr",
						"inputs" : { "Array" : ">Fold:Array" }
					},
					{
						"name" : "Empty",
						"id" : "EmptyCurrent",
						"inputs" : { "Array" : ">cdr:Rest" }
					},
					{
						"name" : "Switch",
						"id" : "SwitchInput",
						"inputs" : { "Switch" : ">EmptyInput:IsEmpty", "A" : ">Fold:Initial" }
					},
					{
						"name" : "Switch",
						"id" : "SwitchCurrent",
						"inputs" : { "Switch" : ">EmptyCurrent:IsEmpty", "A" : ">Fold:FunctionResult" }
					}
				],
				"connections" : [
					{ 
						"id": "Fold:Initial -> Fold:Value1",
				     	"input": { "generic": "Fold", "connector": "Value1" },
					    "output": { "generic": "Fold", "connector": "Initial" }
					},
					{ 
						"id": "Fold:FunctionResult -> Fold:Value1",
				     	"input": { "generic": "Fold", "connector": "Value1" },
					    "output": { "generic": "Fold", "connector": "FunctionResult" }
					},
					{ 
						"id": "car:Value -> Fold:Value2",
				     	"input": { "generic": "Fold", "connector": "Value2" },
					    "output": { "generic": "car", "connector": "Value" }
					},
					{ 
						"id": "cdr:Rest -> car:Array",
				     	"input": { "generic": "car", "connector": "Array" },
					    "output": { "generic": "cdr", "connector": "Rest" }
					},
					{ 
						"id": "cdr:Rest -> cdr:Array",
				     	"input": { "generic": "cdr", "connector": "Array" },
					    "output": { "generic": "cdr", "connector": "Rest" }
					},
					{
						"id": "SwitchInput:Result -> Fold:Result",
				     	"input": { "generic": "Fold", "connector": "Result" },
					    "output": { "generic": "SwitchInput", "connector": "Result" }	
					},
					{
						"id": "SwitchCurrent:Result -> Fold:Result",
				     	"input": { "generic": "Fold", "connector": "Result" },
					    "output": { "generic": "SwitchCurrent", "connector": "Result" }	
					}
				],
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
				"explicit-callback" : true,
				"implementation" : "var num = Number({{input 'String'}});\n  if(!isNaN(num)){\n    {{output 'Number'}} = num;\n    callback(output);\n  }"
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
				],
				"implementation" : "if({{input 'String'}}.length == 0){\n  {{output 'Array'}} = []\n  } else {\n    {{output 'Array'}} = String({{input 'String'}}).split(',');\n  }"
			}
		]
	},
	"transformations" : {
		"string -> number" : [ "StringToNumber"	],
		"string -> array" : [ "StringToArray"	]
	},
	"construction" : {
		"atomic" : "!!atomic!!",
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