
/** Thanks to qiao
(http://stackoverflow.com/questions/8817394/javascript-get-deep-value-from-object-by-passing-path-to-it-as-string)
**/

define(function() {
  return {
    find: function (obj, path) {
      var paths = path.split('.')
        , current = obj
        , i;

      for (i = 0; i < paths.length; ++i) {
        if (current[paths[i]] == undefined) {
          return undefined;
        } else {
          current = current[paths[i]];
        }
      }
      return current;
    },

    assign: function(obj, path, value) {
      keyPath = path.split(".");
      lastKeyIndex = keyPath.length-1;
      for (var i = 0; i < lastKeyIndex; ++ i) {
       key = keyPath[i];
       if (!(key in obj))
         obj[key] = {}
       obj = obj[key];
      }
      obj[keyPath[lastKeyIndex]] = value;
    }
  };
});
