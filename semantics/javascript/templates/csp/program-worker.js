(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);throw new Error("Cannot find module '"+o+"'")}var f=n[o]={exports:{}};t[o][0].call(f.exports,function(e){var n=t[o][1][e];return s(n?n:e)},f,f.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){

//##content#begin
\{{header}}

var registerInput;
var sendOutput;
\{{atomics}}
\{{nodes}}
\{{graph}}

var __input__;
// make scope bound to avoid possible side effects
(function(){
  // map id -> callback
  var inputs = {};
  __input__ = function(id, content){
    if(!(id in inputs)){
      postMessage({type:"error", content:"input \""+ id +"\" not registered"});
      return;
    }
    inputs[id](content);
  }
  registerInput = function(id, callback){
    // register callback
    if(id in inputs){
      postMessage({type:"error", content:"input \""+ id +"\" registered twice"});
      return;
    }
    postMessage({type:"register",what:"input",node:id});
    inputs[id] = callback;
  }
  sendOutput = function(id, content){
    postMessage({type:"output", id:id, content:content});
  }
}());

self.onmessage=function(event){
  var msg = event.data;
  if(msg == "start"){
    \{{starter}};
    postMessage("ready");
    return;
  }
  else if("type" in msg && msg.type == "query"){
    {{~#if debug}}
    if(msg.query == "non-empty-channels"){
      postMessage({type:"query-result", query:"non-empty-channels", data: notTaken});
    }
    {{/if}}
    {{~#unless debug}}
    console.log("All query features are only enabled in debug mode");
    {{/unless}}
  }
  else {
    __input__(msg.id, msg.content);
  }
}
//##content#end
\{{requires}}
