{ fabric } = require 'fabric'
threads = (require './test.json')
require! 'numeral'

window.numeral = numeral

window.the-f-canvas = new fabric.Canvas(document.getElementById('the-canvas'), {
  width: 900,
  height: 500
})

canvas = window.the-f-canvas

c = canvas.getElement!
w = c.width 
h = c.height

if window.devicePixelRatio
  c.setAttribute('width', w*window.devicePixelRatio)
  c.setAttribute('height', h*window.devicePixelRatio)
  
  c.getContext('2d').scale(window.devicePixelRatio, window.devicePixelRatio)

random-int = (min, max) ->
  Math.floor(Math.random() * (max - min + 1) + min)

get-random-pos = ->
  boundaries = {min-x: -450, min-y: -250, max-x: 375, max-y: 200}
  {x: random-int(boundaries.min-x, boundaries.max-x), y: random-int(boundaries.min-y, boundaries.max-y)}

make-thread = (thread) ->
  pos = get-random-pos!
  console.log thread.target.name, pos
  group = new fabric.Group([], {
    left: pos.x,
    top: pos.y,
    width: 150,
    height: 100,
    originX: 'center',
    originY: 'center'
  })

  text = new fabric.Text(thread.target.name, {
    left: 0,
    top: 20,
    fontSize: 14,
    fontFamily: 'Roboto',
    textAlign: 'center',
    originX: 'center',
    originY: 'center'
  })

  text-counter = numeral(thread.message_count)
    .format("0a")
    .concat(" ")
    .concat(if thread.message_count < 2 then "mensagem" else "mensagens")

  counter = new fabric.Text(text-counter, {
    left: 0,
    top: 40,
    fontSize: 14,
    fontFamily: 'Roboto',
    textAlign: 'center',
    originX: 'center',
    fontStyle: 'italic',
    originY: 'center'
  })

  text.hasControls = false
  text-counter.hasControls = false
  group.hasControls = false

  fabric.Image.fromURL(thread.target.image_src, (oImg) ->
    oImg.left = 0
    oImg.top = -18
    oImg.originY = 'center'
    oImg.originX = 'center'
    oImg.clip-to = (ctx) ->
      ctx.arc(0,0,32,0,2*Math.PI)

    oImg.scale(0.8)
    group.add(oImg)
    canvas.renderAll()
  )

  group.add(text)
  group.add(counter)
  

for thread in threads
  obj = make-thread(thread)
  canvas.add(obj)