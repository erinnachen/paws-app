$( document ).ready(function() {
  if ($(".dog-image-show").length > 0) {
    var pathname = window.location.pathname;
    console.log(pathname);
    var url = document.URL.split("/")
    var id = url[url.length - 1]
    setTimeout("location.href = '/dog_images/"+id+"/analysis';",5000);
  }
})
