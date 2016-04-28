$( document ).ready(function() {
  if ($(".dog-image-report").length > 0) {
    var url = document.URL.split("/")
    var id = url[url.length - 2]
    var ctx = document.getElementById("dogist-accuracy").getContext("2d");

    var dogistAccuracyChart = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: ["", "", "", "", "", "", "", ""],
            datasets: [{
                label: 'PAWs Accuracy for breed',
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

    $.getJSON("/charts/top_breeds_by_accuracy/"+id+"?dogist=true", function(breeds) {
      for (i = 0; i < breeds.breeds.length; i++) {
        dogistAccuracyChart.data.datasets[0].data[i] = breeds.accuracy[i];
        dogistAccuracyChart.data.labels[i] = breeds.breeds[i];
      }
      dogistAccuracyChart.update();
    });
  }
});
