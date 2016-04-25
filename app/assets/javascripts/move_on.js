$( document ).ready(function() {
  if ($(".dog-image-show").length > 0) {
    var pathname = window.location.pathname;
    var url = document.URL.split("/")
    var id = url[url.length - 1]
    var image_url = $("#dog-image").attr("src")

    //getJSON("http://162.243.13.94:8080/api/v1/dog_image_categories",
    console.log(image_url)
    $.getJSON("http://localhost:5000/api/v1/dog_image_categories",
      {image: image_url},
      function(result){
        $.ajax({ url: "/dog_images/"+id,
                 type: 'PUT',
                 data: "breed_id="+result["breed_id"],
                 complete: function(data){
                   window.location.replace('/dog_images/'+id+'/analysis');
                 }
               })
      });
  }
})
