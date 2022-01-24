function love.load()
  SPRITES = {}

  SPRITES.background = love.graphics.newImage('sprites/background.png')
  SPRITES.bullet = love.graphics.newImage('sprites/bullet.png')
  SPRITES.player = love.graphics.newImage('sprites/player.png')
  SPRITES.zombie = love.graphics.newImage('sprites/zombie.png')

  PLAYER = {}
  PLAYER.x = love.graphics.getWidth() / 2
  PLAYER.y = love.graphics.getHeight() / 2
end

function love.update(dt)
  if love.keyboard.isDown("d") then
    PLAYER.x = PLAYER.x + 1
  end

  if love.keyboard.isDown("a") then
    PLAYER.x = PLAYER.x - 1
  end

  if love.keyboard.isDown("w") then
    PLAYER.y = PLAYER.y - 1
  end

  if love.keyboard.isDown("s") then
    PLAYER.y = PLAYER.y + 1
  end
end

function love.draw()
  love.graphics.draw(SPRITES.background, 0, 0)

  love.graphics.draw(SPRITES.player, PLAYER.x, PLAYER.y)
end