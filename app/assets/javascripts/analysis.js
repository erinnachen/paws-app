$( document ).ready(function() {
  if ($(".dog-image-analysis").length > 0) {
    $(".edit_dog_image").hide()

    $( "#wrong-btn" ).click(function() {
      $("#wrong-btn").hide();
      $("#correct-btn").hide();
      $(".edit_dog_image").show();
    });
  }
});
