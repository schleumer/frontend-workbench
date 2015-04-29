{ fabric } = require \fabric
{ each } = require \prelude-ls

threads = require "./test.json"
require! \numeral

export numeral = numeral



canvas-el = document.get-element-by-id \the-canvas

export the-f-canvas = new fabric.Canvas canvas-el, {
  width: 900
  height: 500  
}

canvas = the-f-canvas

c = canvas.get-element!
w = c.width
h = c.height

if window.device-pixel-ratio
  c.set-attribute \width w * window.device-pixel-ratio
  c.set-attribute \height h * window.device-pixel-ratio

  c.get-context \2d .scale window.device-pixel-ratio, window.device-pixel-ratio

random-int = (min, max) --> Math.floor Math.random! * (max - min + 1) + min

get-random-pos = ->
  boundaries =
    min-x: 75
    min-y: 50
    max-x: 825
    max-y: 450
    #min-x: -450
    #min-y: -250
    #max-x: 375
    #max-y: 200

  x: random-int boundaries.min-x, boundaries.max-x
  y: random-int boundaries.min-y, boundaries.max-y

make-thread = (thread) ->
  pos = get-random-pos!
  console.log thread.target.name, pos

  group = new fabric.Group [] {
    left: pos.x
    top: pos.y
    width: 150
    height: 100
    origin-x: \center
    origin-y: \center
  }

  text = new fabric.Text thread.target.name, {
    left: 0
    top: 20
    font-size: 14
    font-family: \Roboto
    text-align: \center
    origin-x: \center
    origin-y: \center
  }

  text-counter = numeral thread.message_count
    .format(\0a) ++ " " ++ do ->
      | thread.message_count < 2 => \mensagem
      | otherwise                => \mensagens

  counter = new fabric.Text text-counter, {
    left: 0
    top: 40
    font-size: 14
    font-family: \Roboto
    text-align: \center
    font-style: \italic
    origin-y: \center
    origin-x: \center
  }

  text.has-controls = no
  text-counter.has-controls = no
  group.has-controls = no

  fabric.Image.fromURL thread.target.big_image_src, (o-img) !->
    anti-crisp-circle = new fabric.Circle {
      stroke-width: 2,
      stroke: 'white'
      left: -26
      top: -44
      radius: 25
      fill: \transparent
    }

    o-img
      ..left     = 0
      ..top      = -18
      ..origin-x = \center
      ..origin-y = \center
      ..clip-to  = (ctx) -> 
        ctx.arc 0 0 25 0 2 * Math.PI
      ..scale 1

    group.add o-img, anti-crisp-circle
    canvas.render-all!

  

  group.add text, counter


test = (x) ->
  console.log(x)

threads-group = [ make-thread thread for thread in threads ]

[ canvas.add obj for obj in threads-group ]

collision-check = ->
  threads-group |> each (obj) ->
    canvas.for-each-object (target) ->
      if target.intersects-with-object obj
        t-left    = target.left
        t-top     = target.top
        t-width   = target.width
        t-height  = target.height
        top       = obj.top
        left      = obj.left
        width     = obj.width
        height    = obj.height
        # working