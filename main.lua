local sprites = {}
local player = {}
local zombies = {}

love.load = function ()
  sprites.background = love.graphics.newImage("sprites/background.png")
  sprites.bullet = love.graphics.newImage("sprites/bullet.png")
  sprites.zombie = love.graphics.newImage("sprites/zombie.png")
  sprites.player = love.graphics.newImage("sprites/player.png")

  player.x = love.graphics.getWidth()/2
  player.y = love.graphics.getHeight()/2
  player.speed = 180 -- <=> moving 3px by frame
end

love.update = function (dt)
  -- games in lua run in 60 fps <=> * 1/60  to help in case the frames drop
  if love.keyboard.isDown("w") then
    player.y = player.y - player.speed * dt
  end
  if love.keyboard.isDown("s") then
    player.y = player.y + player.speed * dt
  end
  if love.keyboard.isDown("a") then
    player.x = player.x - player.speed * dt
  end
  if love.keyboard.isDown("d") then
    player.x = player.x + player.speed * dt
  end

  -- we want the enemy to follow the player at a certain angle - Unit Circle -
  -- turning the angle between the player and the enemy into an (x,y) position
  for i, z in ipairs(zombies) do
    z.x = z.x + math.cos(playerZombieAngle(z)) * z.speed * dt
    z.y = z.y + math.sin(playerZombieAngle(z)) * z.speed * dt
    if distanceBetween(z.x,z.y,player.x,player.y) < 100 then
      player = nil
    end
  end
end

-- only activate once when the key is pressed down - can't hold the key - contrary to isDown in update
love.keypressed = function (key)
  if key == "space" then
    spawnZombie()
  end
end

love.draw = function ()
  love.graphics.draw(sprites.background,0,0)

  -- drawing start from the upper left corner of the sprite which means we need to change the offset to the center of the sprite
  -- for rotation change the degree to radian <=> r * pi/180
  love.graphics.draw(sprites.player,player.x,player.y, playerMouseAngle(),nil,nil,sprites.player:getWidth()/2,sprites.player:getHeight()/2)

  for i, z in ipairs(zombies) do
    love.graphics.draw(sprites.zombie,z.x,z.y,playerZombieAngle(z),nil,nil,sprites.zombie:getWidth()/2,sprites.zombie:getHeight()/2)
  end
end

playerMouseAngle = function ()
  return math.atan2(player.y - love.mouse.getY(),player.x - love.mouse.getX()) + math.pi -- we start with the wrong value player so wee need the oppsite that why the math.pi (180° in radian )
end

playerZombieAngle = function (z)
  return math.atan2(player.y - z.y,player.x - z.x)
end

spawnZombie = function ()
  local zombie = {}
  zombie.x = math.random(0,love.graphics.getWidth())
  zombie.y = math.random(0,love.graphics.getHeight())
  zombie.speed = 150
  table.insert(zombies,zombie)
end

-- calculate the distance between to points
distanceBetween = function (x1,y1,x2,y2)
  d = (x2-x1)^2 + (y2-y1)^2
  return math.sqrt(d)
end

