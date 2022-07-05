local Entity = require 'src.entity'
local Player = Entity:extend()
local Bomb = require 'src.bomb'

local playerCount = 0

local down = love.keyboard.isDown

function Player:new(x, y, image)
  Player.super.new(self, x, y, image, 32, 33, 30, 28)
  playerCount = playerCount + 1
  self.speed = 150
  self.pid = playerCount
  self.canBomb = true
  self.isPlayer = true
  self.bombTimer = 0
  self.bombStrength = 1
end

local function playerFilter(self, other)
  -- don't slide on newly-placed bombs
  if other.isBomb and other.pid == self.pid and other.newBomb then
    return 'cross'
  elseif other.isExplosion then
    return 'cross'
  else
    return 'slide'
  end
end

local function movePlayer(self, dx, dy, dt)
  local width = love.graphics.getWidth()
  local height = love.graphics.getHeight()

  local actualX, actualY = world:check(self, self.x + dx * self.speed * dt, self.y + dy * self.speed * dt, playerFilter)
  if actualX >= 32 and actualX <= width - 32 and actualY >= 32 and actualY <= height - 32 then
    self.x = actualX
    self.y = actualY
    world:update(self, self.x, self.y)
  end
end

local function handlePlayerMovement(self, dt)
  if down 'up' then
    movePlayer(self, 0, -1, dt)
  elseif down 'down' then
    movePlayer(self, 0, 1, dt)
  end
  if down 'left' then
    movePlayer(self, -1, 0, dt)
  elseif down 'right' then
    movePlayer(self, 1, 0, dt)
  end
end

local function placeBomb(xTile, yTile, image, pid, strength)
  Bomb((xTile * 32) + 2, (yTile * 32) + 2, image, pid, strength)
end

function Player:update(dt)
  Player.super.update(self, dt)
  self.bombTimer = self.bombTimer - dt
  if not self.canBomb and self.bombTimer < 0 then
    self.canBomb = true
    self.bombTimer = 0
  end
  if down 'space' and self.canBomb then
    -- add extra second to prevent some explosion overlap
    self.bombTimer = 2 + 1
    self.canBomb = false
    local xTile, yTile = self:getTile()
    placeBomb(xTile, yTile, self.image, self.pid, self.bombStrength)
  end
  handlePlayerMovement(self, dt)
end

return Player
