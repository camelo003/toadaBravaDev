--[[##############################################
    
Varre um mapa tiled exportado e retorna: 

- [x] a) Um array (canvas Canvas) preenchido com os seguintes Canvas:

    1. under layer
    2. back layer
    3. front layer
    4. above layer

- [x] b) Um array (walkShapes) com as shapes "caminháveis"
- [ ] c) Um array com os shapes de caminhos bloqueados
- [ ] d) Um array de "eventos"

##############################################]]--

-- Start declaring some locals helper functions!

local extractShapes -- (helper function bellow)

function mapLoader(tiledMap)

    -- M A P !
    local map = dofile(tiledMap)
    local mapW = map.width -- in tiles!
    local mapH = map.height -- in tiles!

    -- T I L E !
    local tileset = love.graphics.newImage(map.tilesets[1].image)
    local tileW = map.tilesets[1].tilewidth
    local tileH = map.tilesets[1].tileheight
    local tileImgW = map.tilesets[1].imagewidth
    local tileImgH =map.tilesets[1].imageheight
    local tileImgColumns =  map.tilesets[1].columns

    -- W O R K I N G   Q U A D !
    local workQuad = love.graphics.newQuad(0,0,tileW,tileH,tileset:getDimensions())

    -- C A N V A S ! (2 output)
    local canvas = {}
    for i=1, 4 do
        canvas[i] = love.graphics.newCanvas(mapW*tileW,mapH*tileH)
    end

    -- canvas[1] -> under layer, UL
    -- canvas[2] -> back layer, BL
    -- canvas[3] -> front layer, FL
    -- canvas[4] -> above layer, AL

    -- F I L L   C A N V A S (vários loops para separar layers. Optimizar!)
    for i=1, #map.layers do
        local s = map.layers[i].name
        local canvasToDraw = 0
        
        if string.find(s,"UL_") == 1 then
            canvasToDraw = 1
        elseif string.find(s,"BL_") == 1 then
            canvasToDraw = 2
        elseif string.find(s,"FL_") == 1 then
            canvasToDraw = 3
        elseif string.find(s,"AL_") == 1 then
            canvasToDraw = 4
        end

        if canvasToDraw ~= 0 then
            love.graphics.setCanvas(canvas[canvasToDraw])

            for j=1, #map.layers[i].data do
                if map.layers[i].data[j] ~= 0 then
                    local linear = map.layers[i].data[j]
                    local readFromX = ((linear % tileImgColumns) * tileW) - tileW
                    local readFromY = math.floor(linear/tileImgColumns) * tileH
                    workQuad:setViewport(readFromX,readFromY,tileW,tileH)
        
                    local drawAtX = (((j-1) % mapW) * tileW)
                    local drawAtY = math.floor((j-1) / mapW) * tileH

                    love.graphics.draw(tileset, workQuad,drawAtX,drawAtY)
                end
            end

            love.graphics.setCanvas()
        end

    end

    -- G E T   S H A P E S

    local walkShapes = extractShapes(map.layers,"WALK_")

    local blockShapes = extractShapes(map.layers,"BLOCK_")

    -- G E T   E V E N T S (touch and check)

    local touchEvents, checkEvents = eventsLoader(map)

    return canvas, walkShapes, blockShapes, touchEvents, checkEvents

end

-- H E L P E R  F U N C I T I O N S !

extractShapes = function(layers,catcher)
    local tableToReturn = {}

    for i=1, #layers do
        local s = layers[i].name
        if string.find(s,catcher) == 1 then
            for j=1, #layers[i].objects do
                local tempBox = {}
                
                local tempX = layers[i].objects[j].x
                local tempY = layers[i].objects[j].y
                local tempW = layers[i].objects[j].width
                local tempH = layers[i].objects[j].height
                
                table.insert(tempBox,{x = tempX, y = tempY})
                table.insert(tempBox,{x = tempX + tempW, y = tempY + tempH})
                

                table.insert(tableToReturn,tempBox)
            end
        end
    end

    return tableToReturn
end