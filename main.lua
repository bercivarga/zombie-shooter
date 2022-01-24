function love.load()
  SPRITES = {}

  SPRITES.background = love.graphics.newImage('sprites/background.png')
  SPRITES.bullet = love.graphics.newImage('sprites/bullet.png')
  SPRITES.player = love.graphics.newImage('sprites/player.png')
  SPRITES.zombie = love.graphics.newImage('sprites/zombie.png')

  PLAYER = {}
  PLAYER.x = love.graphics.getWidth() / 2
  PLAYER.y = love.graphics.getHeight() / 2
  PLAYER.speed = 180

  ZOMBIES = {}
end

function love.update(dt)

  -- Controls
  if love.keyboard.isDown("d") then
    PLAYER.x = PLAYER.x + PLAYER.speed * dt
  end

  if love.keyboard.isDown("a") then
    PLAYER.x = PLAYER.x - PLAYER.speed * dt
  end

  if love.keyboard.isDown("w") then
    PLAYER.y = PLAYER.y - PLAYER.speed * dt
  end

  if love.keyboard.isDown("s") then
    PLAYER.y = PLAYER.y + PLAYER.speed * dt
  end

  -- Zombie movement
  for i,z in ipairs(ZOMBIES) do
    z.x = z.x + (math.cos( GETMOUSEANGLE( z.x, z.y, PLAYER.x, PLAYER.y ) ) * z.speed * dt)
    z.y = z.y + (math.sin( GETMOUSEANGLE( z.x, z.y, PLAYER.x, PLAYER.y ) ) * z.speed * dt)
  end
end

function love.draw()
  love.graphics.draw(SPRITES.background, 0, 0)

  love.graphics.draw(
    SPRITES.player,
    PLAYER.x,
    PLAYER.y,
    GETMOUSEANGLE( PLAYER.x, PLAYER.y, love.mouse.getX(), love.mouse.getY() ),
    nil,
    nil,
    SPRITES.player:getWidth() / 2,
    SPRITES.player:getHeight() / 2
  )

  for i,z in ipairs(ZOMBIES) do
    love.graphics.draw(
      SPRITES.zombie,
      z.x,
      z.y,
      GETMOUSEANGLE( z.x, z.y, PLAYER.x, PLAYER.y ),
      nil,
      nil,
      SPRITES.zombie:getWidth() / 2,
      SPRITES.zombie:getHeight() / 2
    )
  end
end

-- Helpers

function GETMOUSEANGLE(x1, y1, x2, y2)
  return math.atan2( ( y1 - y2 ), ( x1 - x2 ) ) + math.pi
end

function SPAWNZOMBIE()
  local zombie = {}
  zombie.x = math.random(0, love.graphics.getWidth())
  zombie.y = math.random(0, love.graphics.getHeight())
  zombie.speed = 180

  table.insert(ZOMBIES, zombie)
end

function love.keypressed(key)
  if key == "space" then
    SPAWNZOMBIE()
  end
end