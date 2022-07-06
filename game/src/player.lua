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
  self.type = 'player'
  self.bombTimer = 0
  self.bombStrength = 2
  self.bombExplodesThroughBoxes = false
end

local function playerFilter(self, other)
  if other.type == 'bomb' and other.pid == self.pid and other.newBomb then
    -- don't slide on newly-placed bombs
    return 'cross'
  elseif other.type == 'explosion' or other.type == 'enemy' then
    -- things that hurt the player shouldn't block
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

local function placeBomb(self)
  local xTile, yTile = self:getTile()
  self.bombTimer = 2
  self.canBomb = false
  Bomb((xTile * 32) + 2, (yTile * 32) + 2, self.image, self.pid, self.bombStrength, self.bombExplodesThroughBoxes)
end

function Player:update(dt)
  Player.super.update(self, dt)
  self.bombTimer = self.bombTimer - dt
  if not self.canBomb and self.bombTimer < 0 then
    self.canBomb = true
    self.bombTimer = 0
  end
  if down 'space' and self.canBomb then
    placeBomb(self)
  end
  handlePlayerMovement(self, dt)
end

return Player
