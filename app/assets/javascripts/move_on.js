$( document ).ready(function() {
  if ($(".dog-image-show").length > 0) {
    var pathname = window.location.pathname;
    var url = document.URL.split("/")
    var id = url[url.length - 1]
    var image_url = $("#dog-image-analyze").attr("src")

    var count = 1
    var messages = ["Fetching those doggie details ... ", "Analyzing your sweet puppy", "Any second now.....", "ooooooooo I can't wait!!!", "Almost there ...", "It's going to be amazing!"]
    var heading = document.getElementById("changeText");

    $.getJSON("http://6eb4715c.ngrok.io/api/v1/dog_image_categories",
      {image: image_url},
      function(result){
        $.ajax({ url: "/api/v1/dog_images/"+id,
                 type: 'PUT',
                 data: "breed_id="+result["breed_id"],
                 complete: function(data){
                   window.location.replace('/dog_images/'+id+'/analysis');
                 }
               })
      });

      setInterval(change, 2700);
      function change() {
       heading.innerHTML = messages[count];
          count++;
          if(count >= messages.length) { count = 0; }
      }
  }
})
