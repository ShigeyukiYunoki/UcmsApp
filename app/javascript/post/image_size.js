document.addEventListener("turbolinks:load", () => {
  $("#post_image").on("change", function () {
    var size_in_megabytes = this.files[0].size / 1024 / 1024;
    if (size_in_megabytes > 5) {
      alert(
        "アップロード可能なファイルサイズは5MBまでです。より小さいサイズのファイルを選んでください。"
      );
      $("#post_image").val("");
    }
  });
});

// document.addEventListener("turbolinks:load",function(){
//   $("#post_image").bind("change",function(){
//     var size_in_megabytes = this.files[0].size/1024/1024;
//     if (size_in_megabytes > 5){
//       alert("アップロード可能なファイルサイズは5MBまでです。より小さいサイズのファイルを選んでください。");
//       $("#post_image").val("");
//     }
//   });
// });
