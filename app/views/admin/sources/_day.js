var data = <%= raw @data_article %>;

var color = d3.scale.ordinal()
    .range(["#304345","#789aa1","#c7c0b5"]);

var w = 200,
    h = 200,                          
    radius = Math.min(w, h) / 2;
    
var chart = d3.select("div#chart_day").append("svg")          
    .data([data]) 
    .attr("width", w) 
    .attr("height", h)
    .attr("class", "chart")
    .append("svg:g") 
    .attr("transform", "translate(100,100)")
 
var arc = d3.svg.arc() 
    .outerRadius(radius - 10)
    .innerRadius(radius - 40);
 
var pie = d3.layout.pie()  
    .value(function(d) { return d.day; });
 
var arcs = chart.selectAll("g.slice") 
    .data(pie)        
    .enter()                
    .append("svg:g") 
    .attr("class", "slice"); 
 
arcs.append("svg:path")
    .attr("fill", function(d, i) { return color(i); } )
    .attr("d", arc);
    
arcs.append("svg:title")
    .text(function(d) { return d.data.day.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",") + " articles " + d.data.name });
    
chart.append("text")
    .attr("dy", 0)
    .attr("text-anchor", "middle") 
    .attr("class", "title")
    .text("Events");
    
chart.append("text")
    .attr("dy", 21)
    .attr("text-anchor", "middle") 
    .attr("class", "subtitle")
    .text("last 24 hours");