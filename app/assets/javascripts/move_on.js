$( document ).ready(function() {
  if ($(".dog-image-show").length > 0) {
    var pathname = window.location.pathname;
    console.log(pathname);
    var url = document.URL.split("/")
    var id = url[url.length - 1]

    $.getJSON("https://paws-api.herokuapp.com/api/v1/dog_image_categories",
      function(result){
        console.log(result["breed"])
        console.log("Sending that post request")
        $.ajax({ url: "/dog_images/"+id,
                 type: 'PUT',
                 data: "breed="+result["breed"]})
        console.log('Load was performed.');
        window.location.replace('/dog_images/'+id+'/analysis');
      });
  }
})
