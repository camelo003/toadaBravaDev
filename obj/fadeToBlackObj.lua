--[[##############################################
    
Pequeno objeto [estatico] para desenhar as transicoes.

##############################################]]--

local fader = {}


fader.isActive = true
fader.opacity = 1
fader.draw = function(self)
    love.graphics.setColor(0,0,0,self.opacity)
    love.graphics.rectangle("fill", -1, -1, width + 1, height + 1)
    love.graphics.setColor(255,255,255,255)  -- RESTAURAR A NORMALIDADE!!!
end

return fader