import { format, eachDayOfInterval } from "date-fns";

var date = new Date();
var today = format(date, "yyyy-MM-dd");

document.addEventListener("turbolinks:load", () => {
  document.getElementById("today").value = today;

  var setmin = document.getElementById("today");
  setmin.setAttribute("min", `${today}`);
});

// document.addEventListener("turbolinks:load",function () {
//   var today = new Date();
//   today.setDate(today.getDate());
//   var yyyy = today.getFullYear();
//   var mm = ("0"+(today.getMonth()+1)).slice(-2);
//   var dd = ("0"+today.getDate()).slice(-2);
//   document.getElementById("today").value=yyyy+'-'+mm+'-'+dd;
// });
//
// document.addEventListener("turbolinks:load",function(){
//     $('[type="date"]').prop('min', function(){
//         return new Date().toJSON().split('T')[0];
//     });
// });
