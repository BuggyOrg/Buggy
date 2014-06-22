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
				"implementation" : "{{merge-meta 'Sum' 'Term 1'}};{{merge-meta 'Sum' 'Term 2'}};\n  {{output 'Sum'}} = Number({{input 'Term 1'}}) + Number({{input 'Term 2'}});"
			}
		],
		"Serialize" : [
			{
				"name" : "Serialize",
				"atomic" : true,
				"connectors" : [
					{
						"name" : "Data",
						"connector-type" : "Input"
					},
					{
						"name" : "Result",
						"connector-type" : "Output"
					}
				],
				"explicit-callback" : true,
				"implementation" : "for(var i=0; i<{{input 'Data'}}.length; i++){\n  {{output 'Result'}} = {{input 'Data'}}[i];\n  if(i == {{input 'Data'}}.length -1){ {{set-meta 'Result' 'last' true}};}  {{set-meta 'Result' 'StreamComponent' 'i'}}; {{output-data 'Result'}};\n  }\n"
			}
		],
		"Deserialize" : [
			{
				"name" : "Deserialize",
				"atomic" : true,
				"connectors" : [
					{
						"name" : "Data",
						"connector-type" : "Input"
					},
					{
						"name" : "Result",
						"connector-type" : "Output"
					}
				],
				"explicit-callback" : true,
				"implementation" : " if(!('Value' in storage)){storage.Value = []; }\n  storage.Value.push({{input 'Data'}});\n if({{has-meta 'Data' 'last'}} && {{meta-query 'Data' 'last'}} == true){ {{output 'Result'}} = storage.Value; {{output-data 'Result'}};\n  delete storage.Value;\n}\n"
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
				"implementation" : "{{output 'Value'}} = {{node-meta 'Constant.value'}};"
			}
		],
		"Map" : [
			{
				"name" : "Map",
				"connectors" : [
					{
						"name" : "Array",
						"connector-type" : "Input"
					},
					{
						"name" : "Result",
						"connector-type" : "Output"
					},
					{
						"name" : "ValueOut",
						"connector-type" : "Output"
					},
					{
						"name" : "ValueIn",
						"connector-type" : "Input"
					}
				],
				"generics" : [
					{
						"name" : "Serialize",
						"inputs" : { "Data" : ">Map:Array" }
					},
					{
						"name" : "Deserialize",
						"inputs" : { "Data" : ">Map:ValueIn" }
					}
				],
				"connections" : [
					{
						"id" : "Serialize:Result -> Map:ValueOut",
						"input" : { "generic" : "Map", "connector" : "ValueOut" },
						"output" : { "generic" : "Serialize", "connector" : "Result" }
					},
					{
						"id" : "Deserialize:Result -> Map:Result",
						"input" : { "generic" : "Map", "connector" : "Result" },
						"output" : { "generic" : "Deserialize", "connector" : "Result" }
					}
				]
			}
		],
		"Select" : [
			{
				"name" : "Select",
				"atomic" : true,
				"connectors" : [
					{
						"name" : "Stream",
						"connector-type" : "Input"
					},
					{
						"name" : "OutStream",
						"connector-type" : "Output"
					},
					{
						"name" : "Selection",
						"connector-type" : "Output"
					}
				],
				"explicit-callback" : true,
				"implementation" : "if({{meta-query 'Stream' 'StreamComponent'}} == {{node-meta 'Select.Selection'}}){ {{output 'Selection'}} = {{input 'Stream'}}; {{output-data 'Selection'}} }\n {{merge-meta 'OutStream' 'Stream'}}; {{output 'OutStream'}} = {{input 'Stream'}}; {{output-data 'OutStream'}};"
			}
		],
		"Set" : [
			{
				"name" : "Set",
				"atomic" : true,
				"connectors" : [
					{
						"name" : "Stream",
						"connector-type" : "Input"
					},
					{
						"name" : "OutStream",
						"connector-type" : "Output"
					},
					{
						"name" : "Selection",
						"connector-type" : "Input"
					}
				],
				"explicit-input" : true,
				"implementation" : "{{input-data 'Stream'}}; if({{meta-query 'Stream' 'StreamComponent'}} == {{node-meta 'Set.Selection'}}){ {{input-data 'Selection'}}; {{output 'OutStream'}} = {{input 'Selection'}}; }\nelse{ {{output 'OutStream'}} = {{input 'Stream'}};}\n {{merge-meta 'OutStream' 'Stream'}};"
			}
		],
		"Take" : [
			{
				"name" : "Take",
				"atomic" : true,
				"connectors" : [
					{
						"name" : "N",
						"connector-type" : "Input",
						"data-type" : "number"
					},
					{
						"name" : "Sequence",
						"connector-type" : "Input",
						"data-type" : "sequence"
					},
					{
						"name" : "Data",
						"connector-type" : "Output"
					}
				],
				"implementation" : "var arr = [];\n  var cur = {{input 'Sequence'}}.start;\n  for(var i=0; i<{{input 'N'}}; i++){\n    cur = arr.push({{input 'Sequence'}}.next(cur));\n  }\n  {{output 'Data'}} = arr;"
			}
		],
		"NaturalNumbers" : [
			{
				"name" : "Natural Numbers",
				"atomic" : true,
				"connectors" : [
					{
						"name" : "Value",
						"connector-type" : "Output",
						"data-type" : "sequence"
					}
				],
				"implementation" : "{{output 'Value'}} = { start: 0, next: function(value){ return value + 1; } };"
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
				"implementation" : "var num = Number({{input 'String'}});\n  if(!isNaN(num)){\n    {{output 'Number'}} = num;\n    do_callback(callback, output);\n  }"
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
