[![Build Status](https://travis-ci.org/BuggyOrg/Buggy.svg?branch=master)](https://travis-ci.org/BuggyOrg/Buggy)

Buggy
=====

A *special* Development-Framework (there is more to come soon.. we hope)

General Idea
=============

With **Buggy** we want to adress several problems of modern programming languages like avoiding manual parallelization effort and simpe exchangeability of code parts without redesigning. But the major philosophy behind Buggy is to develop a tool that lets programmer write programs /program parts that are highly reusable and shareable.

Basis
=====

The basis of Buggy is a dataflow approach for the description of semantics.

Installation
============

Clone the repository install nodejs and npm. You also need grunt-cli globally

```
npm install -g grunt-cli
```

Install dev-dependencies via

```
npm install
```

Run Examples
============

You can run examples with grunt. Currently you can build into node with harmony (at least v.11)
via

```
grunt compose:<file-path>
```

you will find the resulting file in the build directory (build/<file_path>). To run simply start it with node. You can also build a webpage via

```
grunt browser:<file-path>
```

This will generate a html file in at build/<file-path>. You need Harmony support in your browser. You can enable it in newer Chrome versions under chrome://flags.

Version
=======

Buggy is already in it's third iteration. We startet with a humble goal and had a lot of ideas that could be possible with a cleaner design. We hope version 3 will fulfil at least some of our expectations.

License
=======

Buggy is released under GPL v3, see the License file (https://raw.githubusercontent.com/BuggyOrg/Buggy/develop/LICENSE).
