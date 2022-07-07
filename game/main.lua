local MapEntity

local function makeArr(size, val)
  local arr = {}
  for _ = 1, size do
    table.insert(arr, val)
  end
  return arr
end

local function makeMap(x, y)
  assert(x % 2 ~= 0, 'x should be odd')
  assert(y % 2 ~= 0, 'y should be odd')
  local map = {}
  for row = 1, y do
    if row == 1 or row == y then
      table.insert(map, makeArr(x, MapEntity.WALL))
    elseif row % 2 == 0 then
      local arr = {}
      table.insert(arr, MapEntity.WALL)
      for _, v in ipairs(makeArr(x - 2, MapEntity.NOTHING)) do
        table.insert(arr, v)
      end
      table.insert(arr, MapEntity.WALL)
      table.insert(map, arr)
    else
      local arr = {}
      for col = 1, x do
        table.insert(arr, col % 2 ~= 0 and MapEntity.WALL or MapEntity.NOTHING)
      end
      table.insert(map, arr)
    end
  end
  return map
end

local function fillMap(map)
  map[2][2] = MapEntity.PLAYER
  return map
end

function love.load()
  world = require('libs.bump').newWorld(32)
  local width, height, flags = love.window.getMode()
  love.window.setMode(width, height + 8, flags)
  local image = love.graphics.newImage('assets/boboman.png', nil)
  local Player = require 'src.player'
  local Box = require 'src.box'
  local Wall = require 'src.wall'
  local Enemy = require 'src.enemy'

  MapEntity = { NOTHING = 0, WALL = 1, BOX = 2, PLAYER = 3, ENEMY = 4 }
  local ctors = { Wall, Box, Player, Enemy }

  local map = fillMap(makeMap(25, 19))

  for i, row in ipairs(map) do
    for j, col in ipairs(row) do
      if col ~= 0 then
        ctors[col]((j - 1) * 32, (i - 1) * 32, image)
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
