local sprites = {}
local player = {}

love.load = function ()
  sprites.background = love.graphics.newImage("sprites/background.png")
  sprites.bullet = love.graphics.newImage("sprites/bullet.png")
  sprites.zombie = love.graphics.newImage("sprites/zombie.png")
  sprites.player = love.graphics.newImage("sprites/player.png")

  player.x = love.graphics.getWidth()/2
  player.y = love.graphics.getHeight()/2
  player.speed = 180 -- <=> moving 3px by frame
end

love.draw = function ()
  love.graphics.draw(sprites.background,0,0)

  -- drawing start from the upper left corner of the sprite which means we need to chnage the offset to the center of the sprite
  -- for rotation change the degree to radian <=> r * pi/180
  love.graphics.draw(sprites.player,player.x,player.y, playerMouseAngle(),nil,nil,sprites.player:getWidth()/2,sprites.player:getHeight()/2)
end

love.update = function (dt)
  -- games in lua run in 60 fps <=> * 1/60  to help in case the frames drop
  if love.keyboard.isDown("d") then
    player.x = player.x + player.speed * dt
  end
end

playerMouseAngle = function ()
  return math.atan2(player.y - love.mouse.getY(),player.x - love.mouse.getX()) + math.pi
end
