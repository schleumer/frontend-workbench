{ fabric } = require 'fabric'
threads = (require './test.json').data

canvas = new fabric.Canvas(document.getElementById('the-canvas'), {
  width: 500,
  height: 500
})

