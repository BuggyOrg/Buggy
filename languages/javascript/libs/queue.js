
Queue = function(){
      var items, enqueueCallbacks, callEnqueueCallbacks, Queue;
      items = [];
      enqueueCallbacks = [];
      callEnqueueCallbacks = function(item){
        map(function(it){
          it(item);
        })(
        enqueueCallbacks);
      };
      return Queue = {
        enqueue: function(item){
          items.push(item);
          callEnqueueCallbacks(item);
        },
        isEmpty: function(){
          return items.length === 0;
        },
        dequeue: function(){
          var item;
          if (Queue.isEmpty()) {
            return null;
          } else {
            item = items[0];
            items = items.splice(1);
            return item;
          }
        },
        addEnqueueCallback: function(callback){
          return enqueueCallbacks.push(callback);
        }
      };
    }

