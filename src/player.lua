local Entity = require('src.entity')
local Player = Entity:extend()
local Bomb = require('src.bomb')

local pCount = 0

function PlaceBomb(xTile, yTile, image, pid)
  local bomb = Bomb((xTile * 32) + 2, (yTile * 32) + 2, image, pid)
  world:add(bomb, bomb.x, bomb.y, bomb.width, bomb.height)
end

local down = love.keyboard.isDown
local floor = math.floor

function Player:new(x, y, image)
  Player.super.new(self, x, y, image, 32, 33, 30, 28)
  pCount = pCount + 1
  self.pid = pCount
  self.canBomb = true
  self.isPlayer = true
  self.bombTimer = 0
end

local function playerFilter(self, other)
  if other.isBomb and other.pid == self.pid and other.newBomb then return 'cross'
  else return 'slide'
  end
end

local function movePlayer(self, x, y)
  local actualX, actualY = world:move(self, x, y, playerFilter)
  self.x = actualX
  self.y = actualY
end

local function getPlayerTile(self)
  local xTile = floor((self.x + self.width/2) / 32)
  local yTile = floor((self.y + self.height/2) / 32)
  return xTile, yTile
end

function Player:update(dt)
  self.bombTimer  = self.bombTimer - dt
  if not self.canBomb and self.bombTimer < 0 then
    self.canBomb = true
    self.bombTimer = 0
  end
  if down('space') and self.canBomb then
    self.bombTimer = 3
    self.canBomb = false
    local xTile, yTile = getPlayerTile(self)
    PlaceBomb(xTile, yTile, self.image, self.pid)
  end
  if down('up') then
    movePlayer(self, self.x, self.y - 200 * dt)
  elseif down('down') then
    movePlayer(self, self.x, self.y + 200 * dt)
  end
  if down('left') then
    movePlayer(self, self.x - 200 * dt, self.y)
  elseif down('right') then
    movePlayer(self, self.x + 200 * dt, self.y)
  end
end

function Player:draw()
  Player.super.draw(self)
  love.graphics.print(getPlayerTile(self), 10, 10)
end

return Player
