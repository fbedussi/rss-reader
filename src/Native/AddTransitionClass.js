var _user$project$Native_AddTransitionClass = function(){
    function addTransitionClass(className){
        function cb() {
          return className
      }
       
      setTimeout(function(){
        cb();
      }, 0)

      return cb;
    }
  
    return {
        addTransitionClass: addTransitionClass
    };
  }();