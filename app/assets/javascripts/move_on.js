$( document ).ready(function() {
  if ($(".dog-image-show").length > 0) {
    var pathname = window.location.pathname;
    var url = document.URL.split("/")
    var id = url[url.length - 1]
    var image_url = $("#dog-image").attr("src")

    $.getJSON("http://6eb4715c.ngrok.io/api/v1/dog_image_categories",
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
