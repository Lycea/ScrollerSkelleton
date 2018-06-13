local canv_1 = 0
local canv_1y = 0

local canv_height = 800
local canv_width  = 600

rnd = love.math.random


local p={}
p.p = {x=0,y=0}

function gen_bg1()
  local canv =love.graphics.newCanvas(canv_width,canv_height-20)
  love.graphics.setCanvas(canv)
    for i=0, 500 do
      local x,y = rnd(20,canv_width-30),rnd(20,canv_height - 30)
      local c = rnd(0,255)/255
      local r = rnd(5,20)
      love.graphics.setColor(c,c,c,1)
      love.graphics.circle("fill",x,y,r)
    end
    
  love.graphics.setCanvas()
  return canv
end




local h = 0
local col_count = 0

function love.load()
  require("mobdebug").start()
  
  h =require("helper")
  for i=1,15 do
    array[i] = (i-1)*32
  end
  canv_1 = gen_bg1()
  canv_2 = gen_bg1()
  
  love.graphics.setColor(1,1,1,1)
  love.mouse.setVisible(false)
end

array = 
{

  }

local bull = {}
local mobs = {}


function spawn_bull()
  bull[#bull+1] = {}
  
  bull[#bull].x = p.p.x -5
  bull[#bull].y = p.p.y -10
  
  bull[#bull].w = 10
  bull[#bull].h = 20
  
  bull[#bull].sx = p.p.x -5
  bull[#bull].sy = p.p.y -10
  
  bull[#bull].time = 0
  bull[#bull].speed = 0.03
  
end

function spawn_mob(x_,y_)
  mobs[#mobs+1] = {}
  
  mobs[#mobs].w = 32
  mobs[#mobs].h = 32
  
  mobs[#mobs].x = x_
  mobs[#mobs].y = y_
  
end

function update_mob()
  for i=#mobs,1,-1 do
      local k = mobs[i]
      k.y = k.y + 3
      
      --check player coll and end
     local boo = h.CheckCollision(k,{p1={x=p.p.x-16,y = p.p.y-16 },p2={x=p.p.x+16,y = p.p.y-16 }})
     
     if boo == true then
       col_count = col_count +1
     end
     
     if k.y> 400 then
       table.remove(mobs,i)
     end
  end
  
end


function draw_mob()
   for i,j in ipairs(mobs) do
     love.graphics.rectangle("fill",j.x,j.y,32,32)
   end
   
end


function draw_bull()
  for i,j in ipairs(bull) do
    love.graphics.rectangle("fill",j.x,j.y,10,20)
  end
end

function update_bull()
  for i= #bull,1,-1 do
    local j=bull[i]
    j.x,j.y =h.lerp_point(j.sx,j.sy,j.sx,-20,j.time +j.speed)
    j.time = j.time+j.speed
    if j.y < -10 then
      table.remove(bull,i)
    end
    
    for k = #mobs,1,-1 do
        local mob = mobs[k]
        if h.CheckCollision(j,{p1={x =mob.x,y= mob.y+mob.h},p2={x=mob.x+mob.w,y=mob.y+mob.h}}) == true then
          table.remove(mobs,k)
          table.remove(bull,i)
        end
    end
    
  end
  
end



function update_pos(pos,num)
    if pos > num*#array-2 then
      pos = 0-32
    else
      pos = pos + 3
    end
    return pos
end


function bg_draw()
  for i,j in ipairs(array) do
    love.graphics.setColor((255 - i*10)/255,(255-i*10)/255,(255-i*10)/255,255)
    for k=0,15 do
      love.graphics.setColor((255 - i*10)/255,(255-i*10)/255,(255-i*10)/255,255)
    love.graphics.rectangle("fill",0+k*32,j+k*32,32,32)
    
    love.graphics.setColor(1,1,1,1)
    love.graphics.rectangle("line",0+k*32,j+k*32,32,32)
    end
  
  end
end


function bg_update()
  for i,j in ipairs(array) do
    array[i] = update_pos(j,32)
  end
end

function bg_draw2()
  love.graphics.rectangle("line",0,canv_1y,600,800)
  love.graphics.draw(canv_1,0,canv_1y)
  
  love.graphics.rectangle("line",0,0 - canv_height +canv_1y,canv_width,canv_height)
  love.graphics.draw(canv_1,0,0 - canv_height +canv_1y)
end

function bg_update2()
  if canv_1y < canv_height then
    canv_1y = canv_1y +1
  else
    canv_1y = 0
  end
end




function love.draw()
  --bg_draw()
  love.graphics.setColor(1,1,1,1)
  bg_draw2()
  
  love.graphics.setColor(125/255,1,1,1)
  love.graphics.circle("fill",p.p.x,p.p.y,5)
  
  
  draw_mob()
  
  draw_bull()
  
  
  love.graphics.print(col_count,0,0)
end

timer = 0
function love.update(dt)
  local mx,my= love.mouse.getPosition()
  p.p.x = h.lerp_(mx,p.p.x,0.05)
  p.p.y = h.lerp_(my,p.p.y,0.05)
  --bg_update()
  timer = timer +dt
  
  
  if love.mouse.isDown(1) and timer > 0.2 then
    spawn_bull()
    timer = 0
  end
  
  
  
  bg_update2()
  
  update_mob()
  
  update_bull()
end


function love.mousepressed(x,y)
  spawn_mob(rnd(10,canv_width-32),0)
end

