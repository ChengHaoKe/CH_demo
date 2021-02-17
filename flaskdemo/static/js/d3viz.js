// white-dark mode
function whitedark() {
  var element = document.body;
  element.classList.toggle("dark-mode");
}


// d3 stuff
var data;

var svg = d3.select("#graph")
    .attr("width", 960)
    .attr("height", 500);

var tooltip = d3.select(".tooltip");

var padding = {
    top: 110,
    right: 20,
    bottom: 40,
    left: 75
};

var width = +svg.attr("width") - padding.left - padding.right;
var height = +svg.attr("height") - padding.top - padding.bottom;

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
    console.log(d)
    return {
        Topic: d.Topic,
        // CharityCountry: d.CharityCountry,
        Volunteers: +d.Volunteers
    }
}

function initializeChart(error, parsedData) {
    if (error) {
        throw error
    }

    groupby = d3.nest()
    .key(function(d){return d.Topic; })
    // .key(function(d) {return d.CharityCountry; })
    .rollup(function(v) { return d3.sum(v, function(d) { return d.Volunteers; }); })
    .entries(parsedData)
    // parsed data is data already processed by the stream function

    data = groupby
    // console.log(data)
    drawChart()
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
    xAxisGroup
        .call(d3.axisBottom(x))
    yAxisGroup
        .call(d3.axisLeft(y).ticks(5, "%"))
}

function drawBars() {
    var dataBoundToSelection = g.selectAll(".bar")
        .data(data)
    var enteringBars = dataBoundToSelection.enter().append("rect")

    console.log(enteringBars)

    // create bars
    enteringBars
        .attr("class", "bar")
        .attr("x", function(d) { return x(d.Topic) })
        .attr("y", function(d) { return y(d.Volunteers) })
        .attr("width", 0)
        .attr("height", function(d) { return height - y(d.Volunteers) })
        .attr("fill", "white")
}

function drawChart() {
    console.log("ready to draw!", data)
    prepScales()
    drawAxes()
    console.log("scales and axis set")
    drawBars()
}

// d3.json("/data", initializeChart)
d3.json("/data", function(error, data) {
    if (error) {
        throw error
    }

    data = JSON.parse(data);
    console.log(data)

    // var newd = data.forEach(function(d) {
    //     d = streamParse(d)
    //     return d
    // })
    // var pdata = d3.map(data, function (d) {
    //     d = streamParse(d)
    //     return d
    // })
    // console.log(pdata)

    data.forEach(function(d) {
        d = streamParse(d)
        return d
    })

    initializeChart(error, data)
})
