local Player = require 'src.player'
local Box = require 'src.box'
local Wall = require 'src.wall'
local Enemy = require 'src.enemy'

local Map = { ctors = nil, make = nil }

Map.ctors = { Wall, Box, Player, Enemy }
local Entities = { NOTHING = 0, WALL = 1, BOX = 2, PLAYER = 3, ENEMY = 4 }

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
      table.insert(map, makeArr(x, Entities.WALL))
    elseif row % 2 == 0 then
      local arr = {}
      table.insert(arr, Entities.WALL)
      for _, v in ipairs(makeArr(x - 2, Entities.NOTHING)) do
        table.insert(arr, v)
      end
      table.insert(arr, Entities.WALL)
      table.insert(map, arr)
    else
      local arr = {}
      for col = 1, x do
        table.insert(arr, col % 2 ~= 0 and Entities.WALL or Entities.NOTHING)
      end
      table.insert(map, arr)
    end
  end
  return map
end

local abs = math.abs

local function fillMap(map, numPlayers)
  local rows = #map
  local cols = #map[1]
  local players = {
    { 2, 2 },
    { 2, cols - 1 },
    { rows - 1, cols - 1 },
    { rows - 1, 2 },
  }

  for n = 1, numPlayers do
    local v = players[n]
    map[v[1]][v[2]] = Entities.PLAYER
  end

  -- use manhattan distance to make sure players aren't trapped
  local function nearPlayer(i, j)
    for n = 1, numPlayers do
      local v = players[n]
      if abs(i - v[1]) + abs(j - v[2]) < 4 then
        return true
      end
    end
    return false
  end

  -- random map?
  for i = 1, #map - 1 do
    for j = 1, #map[i] - 1 do
      local empty = map[i][j] == Entities.NOTHING
      if not nearPlayer(i, j) and empty then
        map[i][j] = love.math.random(0, 3) > 0 and Entities.BOX or Entities.NOTHING
      end
    end
  end
  return map
end

Map.make = function(x, y, numPlayers)
  return fillMap(makeMap(x, y), numPlayers)
end

return Map
