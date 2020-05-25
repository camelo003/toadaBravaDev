dofile("func/mapLoaderFunc.lua")
dofile("func/charLoaderFunc.lua")
dofile("func/eventsFunc.lua")
dofile("func/playerEntityFunc.lua")
dofile("func/inputsFunc.lua")

dofile("lib/collisions.lua") -- https://love2d.org/wiki/PointWithinShape
flux = dofile("lib/flux.lua") -- https://github.com/rxi/flux

-- T E M P   S T U F F --

do
    -- an = charLoader("char/brasilino.lua")
    tempClock = 0
    fpsControl = 1/8
    tempTimer = fpsControl  
end

do
    mode = "map" -- init, map, game menu
    modeLabelX, modeLabelY, modeLabelIncX,modeLabelIncY = 816/2, 624/2, 2, 2
    width, height = love.window.getMode()
end

-- S O M E   G L O B A L S --

debugation = {}

workingCanvas = 0 -- canvas onde o jogo e desenhado

workingMap = {{}}
workingMapMaxLength = 5


-- S E T U P ! --

function love.load()
    print("Olá mundo!")

    do -- FUNCAO init() (em breve)
        local init
        do
            -- I N I T   C O I S A S ! --
            local f = love.filesystem.load("save/init.lua")
            init = f()
        end

        playerEntity.pos.x = init.charPos.x
        playerEntity.pos.y = init.charPos.y

        playerEntity.activeChar = charLoader("char/" .. init.activeChar .. ".lua")

        playerEntity.bouningBox.w = playerEntity.activeChar.collisionRects[1].width
        playerEntity.bouningBox.h = playerEntity.activeChar.collisionRects[1].height

        -- get map a) drawings layers, b) walkeable spaces, c) blocked spaces, d) touchEvents, e) checkEvents (por enquanto)
        local a, b, c, d, e, info = mapLoader("map/" .. init.firstMap .. ".lua")
        workingMap[1].drawings = a
        workingMap[1].walks = b
        workingMap[1].blocks = c
        workingMap[1].touches = d
        workingMap[1].checks = e

        workingFader = dofile("obj/fadeToBlackObj.lua")
        workingCamera = dofile("obj/cameraObj.lua")
        workingCanvas = love.graphics.newCanvas(info.wRes,info.hRes);
    end

    local function deactivateFader()
        workingFader.isActive = false
    end

    flux.to(workingFader, 0.2, {opacity = 0}):delay(0.3):oncomplete(deactivateFader)
end

-- U P D A T E ! --

function love.update(dt)
    flux.update(dt)
    updateInput()

    workingCamera:update(playerEntity.pos)

    updateModeLabel()

    playerEntity.update(dt,workingMap[1])

    local activeEvent = checkTouchEvents(workingMap[1].touches,playerEntity.corners)
    if activeEvent and not isSomeEventHappening then
        enventHandler(activeEvent)
    end

    tempTimer = tempTimer - dt
    if tempTimer < 0 then
        tempTimer = tempTimer + fpsControl
        tempClock = tempClock + 1
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
    love.graphics.print("D E B U G A T I O N S :" .. '\n' .. #debugation)
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

    love.graphics.draw(a[1],0,0,0,1,1,1,1,0,0) -- UL
    love.graphics.draw(a[2],0,0,0,1,1,1,1,0,0) -- BL

    -- COLLISION COISAS
    for i=1, #b do
        if b[i].active then
            love.graphics.setColor(0,255,0,0.25)
            love.graphics.rectangle("fill", b[i][1].x, b[i][1].y, b[i][2].x - b[i][1].x, b[i][2].y - b[i][1].y)
        end
        love.graphics.setColor(0,255,0,1)
        love.graphics.rectangle("line", b[i][1].x, b[i][1].y, b[i][2].x - b[i][1].x, b[i][2].y - b[i][1].y)
    end
    love.graphics.setColor(255,255,255,1)

    for i=1, #c do
        if c[i].active then
            love.graphics.setColor(255,0,0,0.25)
            love.graphics.rectangle("fill", c[i][1].x, c[i][1].y, c[i][2].x - c[i][1].x, c[i][2].y - c[i][1].y)
        end
        love.graphics.setColor(255,0,0,1)
        love.graphics.rectangle("line", c[i][1].x, c[i][1].y, c[i][2].x - c[i][1].x, c[i][2].y - c[i][1].y)
    end
    love.graphics.setColor(255,255,255,1)

    love.graphics.setColor(0,0,255,1)
    drawEvents(d)
    love.graphics.setColor(255,255,255,1)
    -- FIM DO COLLISION COISAS

    playerEntity.draw() -- player char

    love.graphics.draw(a[3],0,0,0,1,1,1,1,0,0) -- FL
    love.graphics.draw(a[4],0,0,0,1,1,1,1,0,0) -- OL

    love.graphics.setCanvas()
    love.graphics.draw(workingCanvas,xOffset,yOffset,0,1,1,1,0,0)

    if workingFader.isActive then
        workingFader:draw()
    end

    drawInput(150,5)
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