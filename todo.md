# TODO:

## Language Files

* Loading other sources as started in languages/javascript/construction/javascript.construction
* Create more than one file for all the core nodes (we probably need some structuring)
* The name in the group description is uneccessary (eg. "Each" : [ {  **"name" : "Each"**, ... } ...]). It can be removed if it is added during composition as it is (currently??) required there.

## Composition

* Choose implementation based on some criteria. Currently the composition always takes the first found implementation (src/compose/source.ls -> get-best-match). A few necessary criteria are
    - Is it possible to implement all of the sub-nodes?
    - Is there a fitting type or is a type conversion possible?
* Constants are still a problem. They should fire always but how ?? They shouldn't flood the queue.. probably it is best to create a "no delete" rule for these. This could solve the Constant -> Output problem as a constant's queue doesn't enqueue anything and thus there will be no firing of events...
* Pre composition DSL? should be applied. Those should transform the given nodes into processable standardized nodes like converting connections in form of inputs (">NODE:CONNECTOR") into the correct data representation

## Types

* Types aren't implemented yet (at all)!