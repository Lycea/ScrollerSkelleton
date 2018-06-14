local console = {}

local buffer = {}
local buffer_max = 30


function console.print(text)
 -- if #buffer>=buffer_max then
 --   table.remove(buffer,buffer_max)
 -- end
  
  while #buffer >= buffer_max do
    table.remove(buffer,buffer_max)
  end
  
  table.insert(buffer,1,text)

end



function console.draw()
  love.graphics.rectangle("line",590,145,200,400)
  love.graphics.print(table.concat(buffer,"\n"),600,150)
end





return console