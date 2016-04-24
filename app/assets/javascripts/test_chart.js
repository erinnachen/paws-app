$( document ).ready(function() {
  var buyerData = {
  	labels : [],
  	datasets : [
  		{
  			fillColor : "rgba(172,194,132,0.4)",
  			strokeColor : "#ACC26D",
  			pointColor : "#fff",
  			pointStrokeColor : "#9DB86D",
  			data : []
  		}
  	]
  }
  var buyers = document.getElementById('buyers').getContext('2d');
  var buyers_chart = new Chart(buyers).Line(buyerData);

  var options = Chart.defaults.global = {
    responsive: true,
    maintainAspectRatio: true
  };

  $( "#chart_updater" ).click(function() {
    // buyers_chart.datasets[0].points[2].value = 60;
    // buyers_chart.datasets[0].points[4].value = 20;
    buyers_chart.addData( [55], "January" );
    buyers_chart.addData( [15], "February" );
    buyers_chart.addData( [33], "March" );
    buyers_chart.addData( [22], "April" );
    buyers_chart.addData( [0], "May" );
    buyers_chart.update();
  });
});
