// white-dark mode
function whitedark() {
  var element = document.body;
  element.classList.toggle("dark-mode");
  var d3col = d3.selectAll("text").attr("fill");
  if (d3col === "white") {
      d3.selectAll("text").attr("fill", "black");
      d3.selectAll(".tooltip").style("background-color", "#ffffff");
  } else {
      d3.selectAll("text").attr("fill", "white");
      d3.selectAll(".tooltip").style("background-color", "black");
  }
}


// d3 stuff
var data

var svg = d3.select("#graph")
    .attr("width", 960)
    .attr("height", 500)

var tooltip = d3.select(".tooltip")

var padding = {
    top: 50,
    right: 20,
    bottom: 80,
    left: 75
}

var width = +svg.attr("width") - padding.left - padding.right
var height = +svg.attr("height") - padding.top - padding.bottom

// hold charts
var g = svg.append("g")
    .attr("transform", "translate(" + padding.left + "," + padding.top + ")")

var xAxisGroup = g.append("g")
    .attr("class", "axis x-axis")
    // move down
    .attr("transform", "translate(0, " + height + ")")

var yAxisGroup = g.append("g")
    .attr("class", "axis y-axis")

var x = d3.scaleBand()
    // min, max
    .rangeRound([0, width])
    .padding(0.1)

var y = d3.scaleLinear()
    // inverted
    .rangeRound([height, 0])

function streamParse(d) {
    // console.log(d)
    return {
        Topic: d.Topic,
        // CharityCountry: d.CharityCountry,
        Volunteers: +d.Volunteers
    }
}

function prepScales() {
    function findLetters(d) {
        return d.Topic
    }
    function findFrequency(d) {
        return d.Volunteers
    }

    // array of object into strings
    var letters = data.map(findLetters)
    x.domain(letters)
    var min = 0
    var max = d3.max(data, findFrequency)
    var extents = [min, max]
    y.domain(extents)
}

function drawAxes() {
    // x axis and rotate labels
    xAxisGroup
        .call(d3.axisBottom(x))
        .selectAll("text")
        .style("text-anchor", "end")
        .attr("transform", "rotate(-45)")
    yAxisGroup
        .call(d3.axisLeft(y).ticks(5))
    // , "%"
}

function drawBars() {
    var dataBoundToSelection = g.selectAll(".bar")
        .data(data)
    console.log(data)
    var enteringBars = dataBoundToSelection.enter().append("rect")

    console.log(enteringBars)

    // create bars
    enteringBars
        .attr("class", "bar")
        .attr("x", function(d) { return x(d.Topic) })
        .attr("y", function(d) { return y(d.Volunteers) })
        .attr("width", x.bandwidth())
        .attr("height", function(d) { return height - y(d.Volunteers) })
        .attr("fill", "steelblue")
        .on("mousemove", mousemove)
        .on("mouseout", mouseout)

    // show values
    g.selectAll("text.bar")
        .data(data)
        .enter()
        .append("text")
        .attr("class", "bar")
        .attr("text-anchor", "middle")
        .attr("x", function(d) { return x(d.Topic) + x.bandwidth() / 2; })
        .attr("y", function(d) { return y(d.Volunteers) - 5; })
        .text(function(d) { return d.Volunteers; })
}

function drawChart() {
    console.log("ready to draw!", data)
    prepScales()
    drawAxes()
    console.log("scales and axis set")
    drawBars()
}

// tooltip related
function mouseout(d,i) {
    tooltip
        .style("display", "none");
}


function mousemove(d,i) {
    tooltip
        .html("Topic:  <b> " + d.Topic + "</b><br>Volunteers: " + d.Volunteers + "</b>")
        .style("display", "inline-block")

    var w = tooltip.node().offsetWidth/2,
        h = tooltip.node().offsetHeight*1.1;

    tooltip
        .style("left", d3.event.pageX - w + "px")
        .style("top", d3.event.pageY - h + "px");
}

// title
g.append("text")
        .attr("x", (width / 2))
        .attr("y", 0 - (padding.top / 2))
        .attr("text-anchor", "middle")
        .style("font-size", "26px")
        // .style("text-decoration", "underline")  // underlines the title
        .text("Volunteers by Topic")


// final function that calls everything
function initializeChart(error, parsedData) {
    if (error) {
        throw error
    }
    console.log(parsedData)

    groupby = d3.nest()
    .key(function(d){return d.Topic; })
    // .key(function(d) {return d.CharityCountry; })
    .rollup(function(v) { return d3.sum(v, function(d) { return d.Volunteers; }); })
    .entries(parsedData)
    .map(function(group) {
        return {
          Topic: group.key,
          Volunteers: group.value
        }
    })
    // parsed data is data already processed by the stream function

    data = groupby
    console.log(data)
    drawChart()
}

// d3.json("/data", initializeChart)
d3.json("/data", function(error, data) {
    if (error) {
        throw error
    }

    data = JSON.parse(data);
    // console.log(data)

    data.forEach(function(d) {
        d = streamParse(d)
        return d
    })

    initializeChart(error, data)
})
