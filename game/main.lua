function love.load()
  world = require('libs.bump').newWorld(32)
  local width, height, flags = love.window.getMode()
  love.window.setMode(width, height + 8, flags)
  local image = love.graphics.newImage('assets/boboman.png', nil)
  local Map = require 'src.map'
  local map = Map.make(25, 19)
  for i, row in ipairs(map) do
    for j, col in ipairs(row) do
      if col ~= 0 then
        Map.ctors[col]((j - 1) * 32, (i - 1) * 32, image)
      end
    end
  end
end

function love.update(dt)
  local items = world:getItems()
  for i = 1, #items do
    items[i]:update(dt)
  end
end

function love.draw()
  love.graphics.setBackgroundColor(0.2, 0.2, 0.2)
  local items = world:getItems()
  for i = 1, #items do
    items[i]:draw()
  end
end
