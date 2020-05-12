--[[##############################################
    
Pequeno objeto [estatico] para resolver questoes de camera.

##############################################]]--

local cam = {}

cam.pos = {x = 0, y = 0}

local x, y = love.window.getMode()
cam.width = x
cam.height = y

cam.visibleFrame = true

cam.update = function(self,followPoint)
    self.pos.x = followPoint.x - (self.width/2)
    self.pos.y = followPoint.y - (self.height/2)
end

cam.solveCamera = function(self)
    return -self.pos.x, -self.pos.y
end

return cam