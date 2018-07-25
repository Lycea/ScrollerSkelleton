local helper = {}

function helper.lerp_(x,y,t) local num = x+t*(y-x)return num end

-- Returns the distance between two points.
function helper.dist(x1,y1, x2,y2) return ((x2-x1)^2+(y2-y1)^2)^0.5 end

function helper.dist_m(x1,y1,x2,y2) return math.abs(x1-x2)+math.abs(y1-y2) end
--return angle between points
function helper.angle(x1,y1, x2,y2) return math.atan2(y2-y1, x2-x1) end


function helper.lerp_point(x1,y1,x2,y2,t)
  local x = helper.lerp_(x1,x2,t)
  local y = helper.lerp_(y1,y2,t)
  --print(x.." "..y)
  return x,y
end

function helper.sign(n)
  return n>0 and 1 or n<0 and -1 or 0 
end


function helper.checkIntersect(l1p1, l1p2, l2p1, l2p2)
	local function checkDir(pt1, pt2, pt3) return helper.sign(((pt2.x-pt1.x)*(pt3.y-pt1.y)) - ((pt3.x-pt1.x)*(pt2.y-pt1.y))) end
	return (checkDir(l1p1,l1p2,l2p1) ~= checkDir(l1p1,l1p2,l2p2)) and (checkDir(l2p1,l2p2,l1p1) ~= checkDir(l2p1,l2p2,l1p2))
end


function helper.CheckCollision(object,line)
  local sum = false
  local b = 0
  local a = 0
  local c = 0
  local d = 0
  --love.graphics.clear()

  a = helper.checkIntersect({x=object.x,y=object.y}, {x=object.x+object.w,y=object.y},                             {x=line.p1.x,y=line.p1.y},{x=line.p2.x,y=line.p2.y})
  b = helper.checkIntersect({x=object.x,y=object.y}, {x=object.x,y=object.y+object.h},                            {x=line.p1.x,y=line.p1.y},{x=line.p2.x,y=line.p2.y})
  c = helper.checkIntersect({x=object.x+object.w,y=object.y}, {x=object.x+object.w,y=object.y+ object.h}, {x=line.p1.x,y=line.p1.y},{x=line.p2.x,y=line.p2.y})
  d = helper.checkIntersect({x=object.x+object.w,y=object.y+object.h}, {x=object.x,y=object.y +object.h},{x=line.p1.x,y=line.p1.y},{x=line.p2.x,y=line.p2.y})
  
  
  
  if not a and not b and not c and not d then
    return false
  else
    return true
  end
  
end



return helper