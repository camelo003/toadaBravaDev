--[[############################################
##                                            ##
##  Lida com os inputs de controle do jogador ##
##                                            ##
############################################]]--

inputs = {
    -- cada botao um array -> {just pressed, hold, just released}
    upBtn = {false, false, false},
    rightBtn = {false, false, false},
    downBtn = {false, false, false},
    leftBtn = {false, false, false},
    aBtn = {false, false, false},
    bBtn = {false, false, false},
    xBtn = {false, false, false},
    ybtn = {false, false, false},
    startBtn = {false, false, false},
    selectBtn = {false, false, false},
    lBtn = {false, false, false},
    rBtn = {false, false, false}
}

local lastFrameInputs = {
    upBtn = false,
    rightBtn = false,
    downBtn = false,
    leftBtn = false,
    aBtn = false,
    bBtn = false,
    xBtn = false,
    ybtn = false,
    startBtn = false,
    selectBtn = false,
    lBtn = false,
    rBtn = false
}

-- MAPEAR OS COMANDOS AQUI! (eventualmente c/ joystick =] !)
local inputMap = {
    upBtn = "w",
    rightBtn = "d",
    downBtn = "s",
    leftBtn = "a",
    aBtn = "h",
    bBtn = "g",
    xBtn = "y",
    ybtn = "t",
    startBtn = "space",
    selectBtn = "v",
    lBtn = "q",
    rBtn = "e"
}

updateInput = function()
    for k, v in pairs(inputMap) do
        inputs[k][2] = love.keyboard.isDown(v) -- seta 'hold'

        if not (inputs[k][2] == lastFrameInputs[k]) then
            if inputs[k][2] and (not lastFrameInputs[k]) then
                inputs[k][1] = true -- seta 'just pressed'
            elseif (not inputs[k][2]) and lastFrameInputs[k] then
                inputs[k][3] = true -- seta 'just released'
            end
        else
            inputs[k][1] = false
            inputs[k][3] = false
        end

        lastFrameInputs[k] = inputs[k][2]
    end
end

local inputDesigners = {
    upBtn = function(mode, x, y)
        love.graphics.circle(mode,x+25,y+25,10)
    end,
    rightBtn = function(mode, x, y)
        love.graphics.circle(mode,x+40,y+35,10)
    end,
    downBtn = function(mode, x, y)
        love.graphics.circle(mode,x+25,y+45,10)
    end,
    leftBtn = function(mode, x, y)
        love.graphics.circle(mode,x+10,y+35,10)
    end,
    aBtn = function(mode, x, y)
        love.graphics.circle(mode,x+140,y+35,10)
    end,
    bBtn = function(mode, x, y)
        love.graphics.circle(mode,x+125,y+45,10)
    end,
    xBtn = function(mode, x, y)
        love.graphics.circle(mode,x+125,y+25,10)
    end,
    ybtn = function(mode, x, y)
        love.graphics.circle(mode,x+110,y+35,10)
    end,
    startBtn = function(mode, x, y)
        love.graphics.rectangle(mode,x+80,y+32,15,6)
    end,
    selectBtn = function(mode, x, y)
        love.graphics.rectangle(mode,x+55,y+32,15,6)
    end,
    lBtn = function(mode, x, y)
        love.graphics.rectangle(mode,x,y,50,10)
    end,
    rBtn = function(mode, x, y)
        love.graphics.rectangle(mode,x+100,y,50,10)
    end
}

drawInput = function(x,y)
    for k, v in pairs(inputDesigners) do
        local m = "line"

        if inputs[k][2] then
            if inputs[k][1] then
                -- JUST PRESSED!
                love.graphics.setColor(255,0,255)
            end
            m = "fill"
        end

        if inputs[k][3] then
            -- JUST RELEASED!
            love.graphics.setColor(0,255,255)
            m = "fill"
        end

        v(m,x,y)

        love.graphics.setColor(255,255,255)
    end
end