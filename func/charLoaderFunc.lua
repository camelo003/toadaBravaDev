--[[##############################################

Duas funcoes:

charLoader() Varre um mapa tiled contendo animacoes
de um personagem retorna uma tabela com os campos:

- spriteSheet
- frameW
- frameH
- anims
    - [label]
        - row
        - order
- collisionRect ! ATENCAO ! tabela com os retangulos para colisão do personagem!

-  lista de 'labels' possíveis (a ser incrementado):

    - walkRight
    - walkDown
    - walkLeft
    - walkUp
    - runRight
    - runDown
    - runLeft
    - runUp
    - dash
    - backDash
    - battleIdle
    - weakIdle
    - defendIdle
    - victoryIdle
    - lostIdle
    - attack
    - getHit

a funcao charPlayer() desenha o personagem animado a partir
das seguintes entradas:

- dummy
    - pos = {x = 0, y = 0} -> onde desenhar
    - animToPlay = "label" -> qual animação tocar

- clock
    - actualFrame

- anim Table -> toda a informacao sobre a animacao

##############################################]]--

charLoader = function(tiledChar)
    local tiledAnim = dofile(tiledChar)
    local anim = {}

    anim.spriteSheet = love.graphics.newImage(tiledAnim.tilesets[1].image)
    anim.frameW = tiledAnim.tilesets[1].tilewidth
    anim.frameH = tiledAnim.tilesets[1].tileheight

    anim.anims = {}

    for i = 1, #tiledAnim.layers do
        if tiledAnim.layers[i].name == "ANIM" then
            local f = load(tiledAnim.layers[i].properties.ANIM)
            anim.anims = f()
            break
        end
    end

    local collisionRects = {}

    for i = 1, #tiledAnim.layers do
        if tiledAnim.layers[i].name == "COLLISION" then
            for j = 1, #tiledAnim.layers[i].objects do
                local tempRect = { x = tiledAnim.layers[i].objects[j].x,
                                   y = tiledAnim.layers[i].objects[j].y,
                                   width = tiledAnim.layers[i].objects[j].width,
                                   height = tiledAnim.layers[i].objects[j].height
                                }
                local f = load("return " .. tiledAnim.layers[i].objects[j].properties.collisionRows)
                local rows = f()
                for k = 1, #rows do
                    collisionRects[rows[k]] = tempRect
                end
            end
            break
        end
    end

    anim.collisionRects = collisionRects

    return anim
end

charPlayer = function(dummy,animTable,clock)
    local i = (math.floor(clock.actualFrame) % #animTable.anims[dummy.animToPlay].order) + 1
    local x = (animTable.anims[dummy.animToPlay].order[i] - 1) * animTable.frameW
    local y = (animTable.anims[dummy.animToPlay].row - 1) * animTable.frameH
    local quad = love.graphics.newQuad(x,y,animTable.frameW,animTable.frameH,animTable.spriteSheet:getDimensions())
    
    local rect = animTable.collisionRects[animTable.anims[dummy.animToPlay].row] -- get collision rect for this particular anim.
    while rect.y > animTable.frameH do -- "normalize" height of the collision until the very first row (to use relactive values)
        rect.y = rect.y - animTable.frameH
    end
    local collisionOffsetX = dummy.pos.x - rect.x - (rect.width / 2)
    local collisionOffsetY = dummy.pos.y - rect.y - (rect.height / 2)

    -- [to-do] inserir tratamento que, caso a anim. nao exista, printar o rotulo no lugar
    
    love.graphics.draw(animTable.spriteSheet, quad, collisionOffsetX, collisionOffsetY)
end