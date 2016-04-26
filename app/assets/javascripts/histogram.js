$( document ).ready(function() {
  if ($(".dog-image-report").length > 0) {
  $( "#chart_updater" ).hide()
  var url = document.URL.split("/")
  var id = url[url.length - 2]
  var ctx = document.getElementById("fun").getContext("2d");
  var myChart = new Chart(ctx, {
      type: 'bar',
      data: {
          labels: ["", "", "", "", "", ""],
          datasets: [{
              label: 'Number of images',
              data: [1, 1, 1, 1, 1, 1]
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

  $.getJSON("/charts/top_breeds/"+id, function(breeds) {
    for (i = 0; i < breeds.breeds.length; i++) {
      myChart.data.datasets[0].data[i] = breeds.count[i];
      myChart.data.labels[i] = breeds.breeds[i];
    }
    myChart.update();
  });
}
});
