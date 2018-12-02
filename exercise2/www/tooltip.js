$(document).ready(function(){
       // id of the plot
       $("#plot1").mousemove(function(e){
              // ID of uiOutput
              $("#my_tooltip").show();
              $("#my_tooltip").css({
                     top: (e.pageY + 5) + "px",
                     left: (e.pageX + 5) + "px"
              });
       });
});