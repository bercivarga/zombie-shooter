function love.load()
  math.randomseed(os.time())

  GAMESTATE = 1 -- 1 for menu, 2 for game, 3 for score

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
  BULLETS = {}

  MAXTIME = 3
  TIMER = MAXTIME

  GAMEFONT = love.graphics.newFont(40)
end

function love.update(dt)
  if GAMESTATE == 2 then
    -- Controls
    if love.keyboard.isDown("d") and PLAYER.x <= love.graphics.getWidth() then
      PLAYER.x = PLAYER.x + PLAYER.speed * dt
    end

    if love.keyboard.isDown("a") and PLAYER.x >= 0 then
      PLAYER.x = PLAYER.x - PLAYER.speed * dt
    end

    if love.keyboard.isDown("w") and PLAYER.y >= 0 then
      PLAYER.y = PLAYER.y - PLAYER.speed * dt
    end

    if love.keyboard.isDown("s") and PLAYER.y <= love.graphics.getHeight() then
      PLAYER.y = PLAYER.y + PLAYER.speed * dt
    end
  end

  -- Zombie movement
  for i,z in ipairs(ZOMBIES) do
    z.x = z.x + (math.cos( GETMOUSEANGLE( z.x, z.y, PLAYER.x, PLAYER.y ) ) * z.speed * dt)
    z.y = z.y + (math.sin( GETMOUSEANGLE( z.x, z.y, PLAYER.x, PLAYER.y ) ) * z.speed * dt)
  end

  -- Bullet movement
  for i,b in ipairs(BULLETS) do
    b.x = b.x + (math.cos( b.direction ) * b.speed * dt)
    b.y = b.y + (math.sin( b.direction ) * b.speed * dt)
  end

  -- # returns array length
  for i=#BULLETS, 1, -1 do
    local b = BULLETS[i]
    if b.x < 0 or b.y < 0 or b.x > love.graphics.getWidth() or b.y > love.graphics.getHeight() then
      table.remove(BULLETS, i)
    end
  end

  for i,z in ipairs(ZOMBIES) do
    for j,b in ipairs(BULLETS) do
      if DISTANCEBETWEEN(z.x, z.y, b.x, b.y) < 20 then
        z.dead = true
        b.dead = true
      end
    end
  end

  for i=#ZOMBIES, 1, -1 do
    local z = ZOMBIES[i]
    if z.dead then
      table.remove(ZOMBIES, i)
    end
  end

  for i=#BULLETS, 1, -1 do
    local b = BULLETS[i]
    if b.dead then
      table.remove(BULLETS, i)
    end
  end

  if GAMESTATE == 2 then
    TIMER = TIMER - dt
    if TIMER <= 0 then
      SPAWNZOMBIE()
      TIMER = MAXTIME
      if MAXTIME >= 0.5 then
        MAXTIME = MAXTIME - 0.1
      end
    end
  end
end

function love.draw()
  love.graphics.draw(SPRITES.background, 0, 0)

  if GAMESTATE == 1 then
    love.graphics.setFont(GAMEFONT)
    love.graphics.printf("Click to begin", 0, 50, love.graphics.getWidth(), "center")
  end

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

  for _,z in ipairs(ZOMBIES) do
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

    -- Remove all zombies
    if DISTANCEBETWEEN(z.x, z.y, PLAYER.x, PLAYER.y) < 30 then
      for index in ipairs(ZOMBIES) do
        ZOMBIES[index] = nil
      end
      GAMESTATE = 1
      PLAYER.x = love.graphics.getWidth() / 2
      PLAYER.y = love.graphics.getHeight() / 2
      TIMER = MAXTIME
    end
  end

  for _,b in ipairs(BULLETS) do
    love.graphics.draw(
      SPRITES.bullet,
      b.x,
      b.y,
      nil,
      .5,
      nil,
      SPRITES.bullet:getWidth() / 2,
      SPRITES.bullet:getHeight() / 2
    )
  end
end

-- Helpers

function GETMOUSEANGLE(x1, y1, x2, y2)
  return math.atan2( ( y1 - y2 ), ( x1 - x2 ) ) + math.pi
end

function DISTANCEBETWEEN(x1, y1, x2, y2)
  return math.sqrt( ( x2 - x1 )^2 + ( y2 - y1 )^2 )
end

function SPAWNZOMBIE()
  local zombie = {}
  zombie.x = 0
  zombie.y = 0
  zombie.speed = 90
  zombie.dead = false

  local side = math.random(1, 4)
  if side == 1 then
    zombie.x = -30
    zombie.y = math.random(0, love.graphics.getHeight())
  elseif side == 2 then
    zombie.x = love.graphics.getWidth() + 30
    zombie.y = math.random(0, love.graphics.getHeight())
  elseif side == 3 then
    zombie.x = math.random(0, love.graphics.getWidth())
    zombie.y = -30
  elseif side == 4 then
    zombie.x = math.random(0, love.graphics.getWidth())
    zombie.y = love.graphics.getHeight() + 30
  end

  table.insert(ZOMBIES, zombie)
end

function SPAWNBULLET()
  local bullet = {}
  bullet.x = PLAYER.x
  bullet.y = PLAYER.y
  bullet.speed = 500
  bullet.direction = GETMOUSEANGLE(PLAYER.x, PLAYER.y, love.mouse.getX(), love.mouse.getY())
  bullet.dead = false

  table.insert(BULLETS, bullet)
end

function love.keypressed(key)
  if key == "space" then
    SPAWNZOMBIE()
  end
end

function love.mousepressed(x, y, button)
  if button == 1 and GAMESTATE == 2 then
    SPAWNBULLET()
  elseif button == 1 and GAMESTATE == 1 then
    GAMESTATE = 2
  end
end