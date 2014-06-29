/*
 This file is part of Buggy.

 Buggy is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.

 Buggy is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with Buggy.  If not, see <http://www.gnu.org/licenses/>.
*/

console.log "starting semantics server"
url = require "url"
global <<< require \prelude-ls
requirejs = require "../require.js"


Semantics = requirejs "ls!src/semantics"

Semantics.load-semantic-files ["semantics/base.json", "semantics/javascript/js.json"], (semantics) ->
  console.log "Semantics"
  console.log semantics

  options = language: "javascript"

  http = require("http");

  (http.createServer (request, response) ->
    uri = url.parse(request.url, true)
    if uri.query.query == "sources"
      response.writeHead 200, "Content-Type": "text/plain"
      response.write JSON.stringify semantics.sources
      response.end!
    else if uri.query.query?
      if uri.query.what?
        console.log "querying for " + uri.query.what + " in : " + uri.query.query
        response.writeHead 200, "Content-Type": "text/plain"
        response.write JSON.stringify Semantics.query semantics, uri.query.what, options, uri.query.query
        response.end!
      else
        response.writeHead 200, "Content-Type": "text/plain"
        response.write JSON.stringify semantics.symbols
        response.end!
    else
      response.writeHead 200, "Content-Type": "text/plain"
      response.write "Server is running!"
      response.end!
    ).listen 8001
