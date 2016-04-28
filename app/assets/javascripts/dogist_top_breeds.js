$( document ).ready(function() {
  if ($(".dog-image-report").length > 0 || $(".dog-image-show").length > 0) {
    var url = document.URL.split("/")
    var id = url[url.length - 2]
    if ($(".dog-image-show").length > 0) {
      id = url[url.length - 1]
    }
    var ctx = document.getElementById("dogist-breeds").getContext("2d");

    var dogistBreedsChart = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: ["", "", "", "", "", "", "", ""],
            datasets: [{
                label: 'Number of images',
                data: [0, 0, 0, 0, 0, 0, 0, 0]
            }]
        },
        options: {
            scales: {
                yAxes: [{
                    ticks: {
                        beginAtZero:true
                    }
                }]
            }
        }
    });

    $.getJSON("/charts/top_breeds/"+id+"?dogist=true", function(breeds) {
      for (i = 0; i < breeds.breeds.length; i++) {
        dogistBreedsChart.data.datasets[0].data[i] = breeds.count[i];
        dogistBreedsChart.data.labels[i] = breeds.breeds[i];
      }
      dogistBreedsChart.update();
    });
  }
});
