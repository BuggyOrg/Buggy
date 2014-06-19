# Buggy Specification Draft 0.1

Buggy is a system that translates an abstract description of an problem description
into a program via a Database containing implementations information that is
dependent or independent of the output programming language. Buggy is not
restricted to a specific output language and it is possible to translate
a problem description into a program in any supported language.

Even though it is **discouraged**, the Buggy system also defines specific data
interfaces which can be used to use external software

## Data flow centric and functional

To create a system that has as little state as possible and that allows for
elaborate optimization techniques Buggy is based on functional units that can
communicate only via data! The functional units are called Semantic Groups and
the data connections are simply called connections.

## Syntactical description

The common way of defining all of Buggys parts is in JSON. Buggy is data centric
and it is thus possible to simply define different ways of defining Buggy
elements. This is **encouraged** as long as any format translates into Buggys
standardized JSON format.

## Semantic Groups

The key element of Buggy are the Semantic Groups. A Semantic Group must have
a name that usually isn't unique. A name can refer to different Semantic Groups.
Furthermore a Semantic Groups can contain multiple Connectors. These connectors
 must have a unique name with regard to the Semantic Group. Meaning that one
 Semantic Group cannot have two Inputs with the same name or two Outputs with
 the same name. (It is currently no problem to have an Input that has the same
 name as an Output. It is also questionable if a Semantic Node needs to have
 more than one Input / Output at all or if it simply takes data and sends data).

 A Semantic Group must have at least on Input or one Output. It is not possible
 to define a Semantic Group without any connector.

Syntactically a Semantic Group is a JSON Object like this

```
{
  "name" : "<NAME OF SEMANTIC GROUP>",
  "connectors" : [
    <LIST OF CONNECTORS>
  ],
  "semantics" : {                         (optional)
    <SEMANTICS>
  },
  <ATOMIC SPECIFIC>
  ...
}
```

A Semantic Group defines a unit that fulfills a specific semantic purpose. That
means that in order to use a group the information on what semantics it should
have, must be defined.

### Defining the semantics

In order to define the semantics of a group one needs to use an appropriate name.
Even if this is not always sufficient enough it is highly recommended to name
a group accordingly. The second criteria will be keywords that narrow down
the area in which this semantics is known. E.g.
*"graph algorithm, optimization, shortest path"* for a Dijkstra routine.

As it can be problematic to find only one name for the Semantic Group it is
possible to define Synonyms for the group.

All the semantic information, except for the name, are located in the
**&lt;SEMANTICS&gt;** part of the Semantic Group, more specifically.

| **What** | **Where**                | **Example**                   |
|----------|--------------------------|-------------------------------|
| Name     | name                     | Dijkstra                      |
| Keywords | semantics/keywords       | graph algorithm, optimization |
| Synonyms | semantics/synonyms       | Single Source Shortest Path   |

### Connectors

Each Semantic Group must contain at least one input or output connector. A
connector is simply a JSON object that has a name, type and an
data-type that can be optional for non atomics. A connector might look like this

```
{
  "name" : "<NAME OF CONNECTOR>",
  "connector-type" : "<Input or Output>",
  "data-type" : "<DATATYPE>"
}
```

The name can be any name that is unique for the specified *connector-type*. The
*connector-type* itself must be either "Input" or "Output". No other value is
accepted. The *data-type* can be any name for an type. (It is possible that the
data-type will be an object with further information about the specific type.
E.g. "number" could be very unspecific and sometimes it would be preferable to
specify the precision type &ndash; integer, float, double or fixed point etc.)


## Atomics

A special Semantic Group is an atomic. An atomic is a Semantic Group that
has an implementation in the output language. Usually it is **discouraged** to
implement the node directly. Automated tools that optimize, test, validate etc.
Buggy programs can only work if the number of atomics is small. But in some cases
it might be necessary to use native calls in the programming language directly
and thus it is currently possible to make all Semantic Groups atomic.

Syntactically atomics are defined directly in the Semantic Group with the
following properties:

| **What**       | **Where**                | **Example**                   |
|----------------|--------------------------|-------------------------------|
| Atomicness     | atomic                   | "true" or "false"             |
| Implementation | implementation           | "var val = 1;"                |
| Explicit Callback | explicit-callback     | "true" or "false"             |

The implementations are explained in more detail in section ???. The
*explicit-callback* property deciedes if
 * **explicit-callback = false** Buggy should send the data after the of the
 implementation automatically
 * **explicit-callback = true** Buggy should not send the data after running the
 implementation. The User is responsible for calling the callback via the ouput language
 dependent method
