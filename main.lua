-- =]

dofile("func/mapLoaderFunc.lua")
dofile("func/eventsFunc.lua")
dofile("func/tempChar.lua")

dofile("lib/collisions.lua") -- https://love2d.org/wiki/PointWithinShape
flux = dofile("lib/flux.lua") -- https://github.com/rxi/flux


-- T E M P   S T U F F --

do
    mode = "map" -- init, map, game menu
    modeLabelX, modeLabelY, modeLabelIncX,modeLabelIncY = 816/2, 624/2, 2, 2
    width, height = love.window.getMode()
end

-- S O M E   G L O B A L S --

workingCanvas = 0 -- canvas onde o jogo e desenhado

workingMap = {{}}
workingMapMaxLength = 5


-- S E T U P ! --

function love.load()
    print("Olá mundo!")

    local init
    do
        -- I N I T   C O I S A S ! --
        local f = love.filesystem.load("save/init.lua")
        init = f()
    end

    tempChar.x = init.charPos.x
    tempChar.y = init.charPos.y

    -- get map a) drawings layers, b) walkeable spaces, c) blocked spaces, d) touchEvents, e) checkEvents (por enquanto)
    local a, b, c, d, e = mapLoader("map/" .. init.firstMap .. ".lua")
    workingMap[1].drawings = a
    workingMap[1].walks = b
    workingMap[1].blocks = c
    workingMap[1].touches = d
    workingMap[1].checks = e

    workingFader = dofile("obj/fadeToBlackObj.lua")
    workingCamera = dofile("obj/cameraObj.lua")
    workingCanvas = love.graphics.newCanvas();

    local function deactivateFader()
        workingFader.isActive = false
    end

    flux.to(workingFader, 0.2, {opacity = 0}):delay(0.3):oncomplete(deactivateFader)
end

-- U P D A T E ! --

function love.update(dt)
    flux.update(dt)

    workingCamera:update({x = tempChar.x, y = tempChar.y})

    updateModeLabel()

    tempChar.update(dt, b, c)
    local tempCharPlace = { {x = tempChar.x, y = tempChar.y},
                            {x = tempChar.x + tempChar.w, y = tempChar.y},
                            {x = tempChar.x + tempChar.w, y = tempChar.y + tempChar.h},
                            {x = tempChar.x, y = tempChar.y + tempChar.h}
                          }

       
    local activeEvent = checkTouchEvents(workingMap[1].touches,tempCharPlace)
    if activeEvent and not isSomeEventHappening then
        enventHandler(activeEvent)
    end
end

-- D R A W ! --

function love.draw()
    if mode == "init" then
        initModeDraw()
    elseif mode == "map" then
        mapModeDraw(workingMap[1])
    elseif mode == "game menu" then
        gameMenuModeDraw()
    end
end

-- D E B U G ? --

function love.keypressed(key, u)   
    -- print("Debug's on the table!")
    -- debug.debug()
end

-- Q U I T ! --

function love.quit()
    print("Fechou!")
end

-- Alguma tecla é soltada
function love.keyreleased(key)
    if key == "1" then
        mode = "init"
        print(mode)
    elseif key == "2" then
        mode = "map"
    elseif key == "3" then
        mode = "game menu"
    elseif key == "4" then
        flux.to(workingFader, 0.2, {opacity = 1})
    elseif key == "5" then
        flux.to(workingFader, 0.2, {opacity = 0})
    end
end

--/////////////////////// separar em arquivos ///////////////////////--

function initModeDraw()
    love.graphics.setBackgroundColor(255,0,0,1)
    love.graphics.print("Modo init!", modeLabelX,modeLabelY)
end

function mapModeDraw(workingMapTable)
    a = workingMapTable.drawings
    b = workingMapTable.walks
    c = workingMapTable.blocks
    d = workingMapTable.touches
    e = workingMapTable.checks

    love.graphics.setCanvas(workingCanvas)
    love.graphics.setBackgroundColor(0,0,0,255)
    love.graphics.clear()

    local xOffset, yOffset = workingCamera:solveCamera()

    love.graphics.print("Modo map!", modeLabelX,modeLabelY)

    love.graphics.draw(a[1],xOffset,yOffset,0,1,1,1,1,0,0)
    love.graphics.draw(a[2],xOffset,yOffset,0,1,1,1,1,0,0)
    tempChar.draw(xOffset, yOffset)
    love.graphics.draw(a[3],xOffset,yOffset,0,1,1,1,1,0,0)
    love.graphics.draw(a[4],xOffset,yOffset,0,1,1,1,1,0,0)

    for i=1, #b do
        love.graphics.rectangle("line", b[i][1].x + xOffset, b[i][1].y + yOffset, b[i][2].x - b[i][1].x, b[i][2].y - b[i][1].y)
    end

    for i=1, #c do
        love.graphics.rectangle("line", c[i][1].x + xOffset, c[i][1].y + yOffset, c[i][2].x - c[i][1].x, c[i][2].y - c[i][1].y)
    end

    drawEvents(d, xOffset, yOffset)

    if workingFader.isActive then
        workingFader:draw()
    end

    love.graphics.setCanvas()
    love.graphics.draw(workingCanvas,0,0,0,1,1,1,0,0)

end

function gameMenuModeDraw()
    love.graphics.setBackgroundColor(0,0,255,255)
    love.graphics.print("Modo Game Menu!", modeLabelX,modeLabelY)
end

function updateModeLabel()
    modeLabelX = modeLabelX + modeLabelIncX
    modeLabelY = modeLabelY + modeLabelIncY
    
    if modeLabelX > width or modeLabelX<0 then
        modeLabelIncX = modeLabelIncX * -1
    end

    if
        modeLabelY > height or modeLabelY < 0
    then
        modeLabelIncY = modeLabelIncY * -1
    end
end