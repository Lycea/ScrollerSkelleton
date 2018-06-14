local canv_1 = 0
local canv_1y = 0

local canv_height = 800
local canv_width  = 600

local rnd = love.math.random


local p={}
p.p = {x=0,y=0}

local function gen_bg1()
  local canv =love.graphics.newCanvas(canv_width,canv_height-20)
  love.graphics.setCanvas(canv)
  
  love.graphics.setPointSize(3)
    for i= 0, 50 do
      local x,y =rnd(0, canv_width-10),rnd(0,canv_height-10)
      love.graphics.points(x,y)
    end
  love.graphics.setPointSize(1)
    for i=0, 50 do
      local x,y = rnd(20,canv_width-30),rnd(20,canv_height - 30)
      local c = rnd(0,255)/255
      local r = rnd(5,20)
      love.graphics.setColor(c,c,c,1)
      love.graphics.circle("fill",x,y,r)
    end
    
    
    
  love.graphics.setCanvas()
  return canv
end






local stats =
{
  time_alive  = 0,
  killed_mobs = 0,
  coins       = 0,
  special     = 0,
  mobs_on_screen = 0,
  bullets_on_screen = 0,
  score       = 0
  }


local h = 0
local col_count = 0
local cons = 0
function love.load()
  
  print("test")
  
  --debug slows performance a lot only run if needed...
  --TODO: maybe adjust checking only if objects are "near" ... 10/20 pix away
  --this could increase the performance
  
  --require("mobdebug").start()
  
  h =require("helper")
  cons =require("console")
  
 -- for i=1,15 do
 --   array[i] = (i-1)*32
 -- end
  canv_1 = gen_bg1()
  
  love.graphics.setColor(1,1,1,1)
  love.mouse.setVisible(false)
  
  

end


local bull = {}
local mobs = {}


local function spawn_bull()
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

local function spawn_mob(x_,y_)
  mobs[#mobs+1] = {}
  
  mobs[#mobs].w = 32
  mobs[#mobs].h = 32
  
  mobs[#mobs].x = x_
  mobs[#mobs].y = y_
  
end

local function spawn_mob_row()
  for i = 0, 7 do
     --cons.print(i*32+20)
    spawn_mob(i* 40 ,0)
  end
end



local function update_mob()
  for i=#mobs,1,-1 do
      local k = mobs[i]
      k.y = k.y + 0.75
      
      --check player coll and end
      if h.dist(p.p.x,p.p.y,k.x,k.y) < 15 then
        local boo = h.CheckCollision(k,{p1={x=p.p.x-16,y = p.p.y-16 },p2={x=p.p.x+16,y = p.p.y-16 }})
     end
     
     if boo == true then
       col_count = col_count +1
     end
     
     if k.y> 800 then
       table.remove(mobs,i)
     end
  end
  
end


local function draw_mob()
   for i,j in ipairs(mobs) do
     love.graphics.rectangle("fill",j.x,j.y,32,32)
   end
   
end


local function draw_bull()
  for i,j in ipairs(bull) do
    love.graphics.rectangle("fill",j.x,j.y,10,20)
  end
end

local function update_bull()
  for i= #bull,1,-1 do
    local j=bull[i]
    j.x,j.y =h.lerp_point(j.sx,j.sy,j.sx,-20,j.time +j.speed)
    j.time = j.time+j.speed
    if j.y < -10 then
      table.remove(bull,i)
    end
    
    for k = #mobs,1,-1 do
        local mob = mobs[k]
        
        if h.dist(mob.x,mob.y,j.x,j.y) < 50 then
          if h.CheckCollision(j,{p1={x =mob.x,y= mob.y+mob.h},p2={x=mob.x+mob.w,y=mob.y+mob.h}}) == true then
            table.remove(mobs,k)
            table.remove(bull,i)
            stats.killed_mobs = stats.killed_mobs+1
          end
        end
    end
    
  end
  
end



local function update_pos(pos,num)
    if pos > num*#array-2 then
      pos = 0-32
    else
      pos = pos + 3
    end
    return pos
end


local function update_stats(dt)
  stats.mobs_on_screen = #mobs
  stats.bullets_on_screen =#bull
  
  stats.time_alive = stats.time_alive +  math.floor(dt*1000)/1000
  stats.score       = stats.killed_mobs *10  +math.floor(stats.time_alive*100)
end

local function print_stats()
  local txt = {}
  for i,j in pairs(stats) do
      if i == "time_alive" then
        j = math.floor(j)
      end
      txt[#txt+1] = i.." :"..j
  end
  
  love.graphics.print(table.concat(txt,"\n"),canv_width+10,20)
    
end


local function bg_draw()
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


local function bg_update()
  for i,j in ipairs(array) do
    array[i] = update_pos(j,32)
  end
end

local function bg_draw2()
  --love.graphics.rectangle("line",0,canv_1y,600,800)
  love.graphics.draw(canv_1,0,canv_1y)
  
  --love.graphics.rectangle("line",0,0 - canv_height +canv_1y,canv_width,canv_height)
  love.graphics.draw(canv_1,0,0 - canv_height +canv_1y)
end

local function bg_update2()
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
  love.graphics.line(canv_width,0,canv_width,canv_height)
  
  print_stats()
  love.graphics.print(love.timer.getFPS(),canv_width + 10,120)
  
  cons.draw()
end

local timer = 0
local timer_mobs = 0

function love.update(dt)
  local mx,my= love.mouse.getPosition()
  p.p.x = math.min(h.lerp_(mx,p.p.x,0.05),canv_width-20)
  p.p.y = h.lerp_(my,p.p.y,0.05)
  --bg_update()
  timer = timer +dt
  timer_mobs = timer_mobs +dt
  
  if timer_mobs > 0.01 then
    cons.print("spawn: "..timer_mobs)
      timer_mobs = 0
      --local r = rnd(0,1000) 
      --if r > 750 then
        spawn_mob_row()
      --end
      
  end
  
  
  if love.mouse.isDown(1)  then--and timer > 0.1 then
    spawn_bull()
    timer = 0
  end
  
  
  
  bg_update2()
  
  update_mob()
  
  update_bull()
  
  
  update_stats(dt)
end


function love.mousepressed(x,y)
  spawn_mob(rnd(10,canv_width-32),0)
end


function love.run()
 
	if love.math then
		love.math.setRandomSeed(os.time())
	end
 
	if love.load then love.load(arg) end
 
	-- We don't want the first frame's dt to include time taken by love.load.
	if love.timer then love.timer.step() end
 
	local dt = 0
 
	-- Main loop time.
	while true do
		local start_time = love.timer.getTime()
		-- Process events.
		if love.event then
			love.event.pump()
			for name, a,b,c,d,e,f in love.event.poll() do
				if name == "quit" then
					if not love.quit or not love.quit() then
						return a
					end
				end
				love.handlers[name](a,b,c,d,e,f)
			end
		end
 
		-- Update dt, as we'll be passing it to update
		if love.timer then
			love.timer.step()
			dt = love.timer.getDelta()
		end
		
		-- Call update and draw
		if love.update then love.update(dt) end -- will pass 0 if love.timer is disabled
 
		if love.graphics and love.graphics.isActive() then
			love.graphics.clear(love.graphics.getBackgroundColor())
			love.graphics.origin()
			if love.draw then love.draw() end
			love.graphics.present()
		end
		local end_time = love.timer.getTime()
		local frame_time = end_time - start_time
		
		if love.timer then love.timer.sleep(1/60-frame_time) end
	end
 
end
