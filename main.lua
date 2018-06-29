local ui 


local canv_1 = 0
local canv_1y = 0

local canv_height = 800
local canv_width  = 600

local rnd = love.math.random
local gr  = love.graphics


local p={}
p.p = {x=0,y=0}



local draw   ={}

local update ={}
local last_state = "menue"





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
      local c = rnd(0,255)
      local r = rnd(5,20)
      love.graphics.setColor(c,c,c,255)
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

local img = 0
local mob_quad={}



local bull = {}
local mobs = {}

local states= {"game","menue","options","pause"}
local state = "game"

local timer = 0
local timer_mobs = 0

-------------------------
-- Game functions...   -- 
-------------------------
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
  
  mobs[#mobs].w = 64
  mobs[#mobs].h = 64
  
  mobs[#mobs].x = x_
  mobs[#mobs].y = y_
  
end

local function spawn_mob_row()
  for i = 0, 7 do
     --cons.print(i*32+20)
    spawn_mob(i* 75 ,0)
  end
end



local function update_mob()
  for i=#mobs,1,-1 do
      local k = mobs[i]
      k.y = k.y + 0.75
      local boo 
      --check player coll and end
      --cons.print(h.dist(p.p.x,p.p.y,k.x,k.y))
      if h.dist(p.p.x,p.p.y,k.x,k.y) < 15 then
         boo = h.CheckCollision(k,{p1={x=p.p.x-16,y = p.p.y-16 },p2={x=p.p.x+16,y = p.p.y-16 }})
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
    love.graphics.setColor(255,255,255,255)
   for i,j in ipairs(mobs) do
       
     --love.graphics.rectangle("fill",j.x,j.y,32,32)
     love.graphics.draw(img,mob_quad[1],j.x,j.y,0,1,1)
    
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
        
        if h.dist(mob.x,mob.y,j.x,j.y) < 70 then
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

-------------------------------------------
--main drawing and update functions start--
-------------------------------------------
function draw.game()
    --bg_draw()
  love.graphics.setColor(255,255,255,255)
  bg_draw2()
  
  love.graphics.setColor(125,255,255,255)
  love.graphics.circle("fill",p.p.x,p.p.y,5)
  
  
  draw_mob()
  
  draw_bull()
  
  
  love.graphics.print(col_count,0,0)
  love.graphics.line(canv_width,0,canv_width,canv_height)
  
  print_stats()
  love.graphics.print(love.timer.getFPS(),canv_width + 10,120)
  
  cons.draw()
  
  
  love.graphics.draw(psystem, p.p.x,p.p.y )
end

function draw.menue()
    
end

function draw.options()
    
end

function draw.pause()
    draw.game()
    
    love.graphics.setColor(0,0,0,100)
    love.graphics.rectangle("fill",0,0,canv_width,canv_height)
end


function update.game(dt)
  local mx,my= love.mouse.getPosition()
  p.p.x = math.min(h.lerp_(mx,p.p.x,0.05),canv_width-20)
  p.p.y = h.lerp_(my,p.p.y,0.05)
  --bg_update()
  timer = timer +dt
  timer_mobs = timer_mobs +dt
  
  if timer_mobs > 1.5 then
    timer_mobs = 0

    spawn_mob_row()
  end
  
  
  if love.mouse.isDown(1) and timer > 0.1 then
    spawn_bull()
    timer = 0
  end
  
  
  
  bg_update2()
  
  update_mob()
  
  update_bull()
  
  
  update_stats(dt) 
end

function update.menue(dt)
    
end

function update.options(dt)
    
end

function update.pause(dt)
    
end



local cb={
    game = function (id) 
       
    end,
    options = function (id) 
        
        
        end,
    menue  = function (id) 
         if id == gui["menue"][1] then
            state="game"
            ui.SetGroupVisible("menue",false)
            ui.SetGroupVisible("game",true)
            love.mouse.setVisible(false)
        elseif id == gui["menue"][2] then
          
        elseif id == gui["menue"][3] then
        elseif id == gui["menue"][4] then
        elseif id == gui["menue"][5] then
            love.event.quit()
        end
        
        end,
    pause  = function (id) 
        if id == gui["pause"][1] then
            state="game"
            ui.SetGroupVisible("pause",false)
            ui.SetGroupVisible("game",true)
        elseif id == gui["pause"][2] then
            state="options"
            ui.SetGroupVisible("pause",false)
            ui.SetGroupVisible("options",true)
        elseif id == gui["pause"][3] then
        elseif id == gui["pause"][4] then
            state ="menue"
            ui.SetGroupVisible("pause",false)
            ui.SetGroupVisible("menue",true)
            --reset the game/stats
        end
    end
    }





local function button_cb(id,name)
    cons.print("clicked:"..id)
    for idx,obj in pairs(gui) do
        for idx2,id_ in ipairs(obj) do
           if id == id_ then
               print(idx)
               cb[idx](id)
           end
           
        end
    end
    
end

------------------
--particle functions
------------------
local function load_parts()
  local img = gr.newImage("snow.png")
  
  psystem = love.graphics.newParticleSystem(img, 32)
	psystem:setParticleLifetime(2, 5) -- Particles live at least 2s and at most 5s.
  psystem:setEmissionRate(5)
	psystem:setSizeVariation(1)
	psystem:setLinearAcceleration(-10, 20, 10, 20) -- Random movement in all directions.
	psystem:setColors(255, 255, 255, 255, 255, 255, 255, 0) -- Fade to transparency.
	psystem:setSizes(0.5)
end



-----------------------------
--base framework callbacks --
-----------------------------
local scr_w,scr_h
function love.load()
  
 -- require("mobdebug").start()
  
  h    = require("helper")
  cons = require("console")
  ui   = require("SimpleUI.SimpleUI")
  scr_w,scr_h = love.graphics.getWidth(),love.graphics.getHeight()
  
  canv_1 = gen_bg1()
  
  
  love.graphics.setColor(255,255,255,255)
  love.mouse.setVisible(false)
  
  
  
  --load the images
  img = love.graphics.newImage("mobsi_1.png")
  
  local img_h = img:getHeight()
  local img_w = img:getWidth()
  
  mob_quad[1] =love.graphics.newQuad(0,0,64,64,img_w,img_h)
  mob_quad[2] =love.graphics.newQuad(64,0,64,64,img_w,img_h)
  mob_quad[3] =love.graphics.newQuad(128,0,64,64,img_w,img_h)
  
  
  --setup the ui
  ui.init()
  ui.AddClickHandle(button_cb)
  
  gui=
  {
      menue={
          
      ui.AddButton(" start run ",scr_w/2 - 30,40,0,0),
      ui.AddButton(" options ",scr_w/2 - 30,90,0,0),
      ui.AddButton(" shop ",scr_w/2 - 30,140,0,0),
      ui.AddButton(" score ",scr_w/2 - 30,190,0,0),
      ui.AddButton(" exit ",scr_w/2 - 30,240,0,0)
     },
     
     options={
         ui.AddButton(" confirm ",scr_w/2 - 30,40,0,0),
         ui.AddButton(" cancel ",scr_w/2 +50,40,0,0),
     },
     
     pause={
         ui.AddButton(" continue ",scr_w/2 - 30,40,0,0),
         ui.AddButton(" restart ",scr_w/2 - 30,90,0,0),
         ui.AddButton(" options ",scr_w/2 - 30,140,0,0),
         ui.AddButton(" back to menue ",scr_w/2 - 30,190,0,0),
     },
     game={}
  }
  
  for idx,obj in pairs(gui)do
    ui.AddGroup(obj,idx)
  end

 ui.SetGroupVisible("menue",false)  
 ui.SetGroupVisible("options",false)  
 ui.SetGroupVisible("pause",false)  
 
 
 load_parts()
end


function love.draw()
  draw[state]()
  ui.draw()
end




function love.update(dt)
 update[state](dt)
 
 ui.update()
 psystem:update(dt)
end


function love.mousepressed(x,y)
 -- spawn_mob(rnd(10,canv_width-32),0)
end

function love.keypressed(key,code,repe)
    --start game
    if key == "1"then
        ui.SetGroupVisible(state,false)
        print(state)
        state = states[1]
        ui.SetGroupVisible(state,true)
        love.mouse.setVisible(false)
    --menue
elseif key == "2" then
        ui.SetGroupVisible(state,false)
        state = states[2]
        ui.SetGroupVisible(state,true)
         love.mouse.setVisible(true)
     --options
 elseif key == "3" then
        ui.SetGroupVisible(state,false)
        state = states[3]
        ui.SetGroupVisible(state,true)
        love.mouse.setVisible(true)
    elseif key == "escape" and state == "game" then
        --pause the game
        ui.SetGroupVisible(state,false)
        state ="pause"
        ui.SetGroupVisible(state,true)
        --unhide the mouse
        love.mouse.setVisible(true)
    end
    
    
end

function love.focus(f)
    if state == "game" then
        if f == false then
            ui.SetGroupVisible(state,false)
            state ="pause"
            ui.SetGroupVisible(state,true)
            love.mouse.setVisible(true)
        else
            ui.SetGroupVisible(state,false)
            state ="game"
            ui.SetGroupVisible(state,true)
            love.mouse.setVisible(false)
        end
    end
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
