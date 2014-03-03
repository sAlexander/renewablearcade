var  w = 400,
     h = 400,
     aw = 10,
     ah = 30;

var d = [
    {x: 100, y: 100}
    ]

window.onload=function(){
var chart = d3.select("#placeholder").append("svg")
    .attr("class","chart")
    .attr("width",w)
    .attr("height",h)
    .on("mousedown",add);

function render() {
    chart.selectAll("rect")
        .data(d)
        .enter().append("rect")
        .attr("x", function(d) { return d.x-aw/2})
        .attr("y", function(d) { return d.y-ah/2})
        .attr("width",aw)
        .attr("height",ah)
        .call(d3.behavior.drag().on("drag", move));
};

render()
function move(d){
    this.parentNode.appendChild(this);
    var dragTarget = d3.select(this);
    d.x = d3.event.dx + d.x
    d.y = d3.event.dy + d.y
    d = bound(d);

    dragTarget
        .attr("x", function(){return d.x-aw/2})
        .attr("y", function(){return d.y-ah/2});
};

function add(){
    xp = d3.mouse(this);
    cur = {x:xp[0], y:xp[1]};
    cur = bound(cur);
    d = chart.selectAll("rect").data()
    r = d.map(function(id){return Math.sqrt(Math.pow((cur.x-id.x),2)+Math.pow((cur.y-id.y),2));})
    if (d3.min(r) > ah*2/3){
        if (20-d.length > 0){
            d.push(cur);
            d3.select("#number").text(20-d.length);
            render();
        }
        if (20-d.length == 0) {
            d3.select("#submit-layout").style("display","block");
        }
    }
}

function bound(d){
    if (d.x < aw/2){d.x=aw/2;};
    if (d.x > w - aw/2){d.x = w - aw/2;};
    if (d.y < ah/2){d.y=ah/2;};
    if (d.y > h-ah/2){d.y = h-ah/2;};
    return d;
}
}
