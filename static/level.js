locations = [[90,90],[20,20],[0,0],[50,70],[40,10]];

conns = []    //the time to switch colors

currentNode = 0

canvas = []
function draw() {
  window.canvas = new fabric.Canvas('main');
  window.canvas.setDimensions({width:window.innerHeight - 150, height:window.innerHeight - 150});
  console.log(canvas.getWidth())
  for (i = 0; i < locations.length; i++){
    var rect = new fabric.Rect({
      left: locations[i][0]/ 100 * canvas.getWidth(),
      top: locations[i][1]/ 100 * canvas.getHeight(),
      fill: 'red',
      width: 40,
      height: 40
    });
    canvas.add(rect);
  }
}

function observation(){
  console.log(canvas.getObjects())
  canvas.getObjects()[1].set('fill', 'green');
  canvas.renderAll();
}
