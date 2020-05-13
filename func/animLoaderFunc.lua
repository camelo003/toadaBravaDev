--[[##############################################

Duas funcoes:

animLoader() Varre um mapa tiled contendo animacoes
de um personagem retorna uma tabela com os campos:

- spriteSheet
- frameW
- frameH
- anims
    - [label]
        - row
        - order

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

a funcao animPlayer() desenha o personagem animado a partir
das seguintes entradas:

- dummy
    - pos = {x = 0, y = 0} -> onde desenhar
    - animToPlay = "label" -> qual animação tocar

- clock
    - actualFrame

- anim Table -> toda a informacao sobre a animacao

##############################################]]--

animLoader = function(tiledChar)
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

    return anim
end

animPlayer = function(dummy,animTable,clock)
    local i = (math.floor(clock.actualFrame) % #animTable.anims[dummy.animToPlay].order) + 1
    local x = (animTable.anims[dummy.animToPlay].order[i] - 1) * animTable.frameW
    local y = (animTable.anims[dummy.animToPlay].row - 1) * animTable.frameH
    local quad = love.graphics.newQuad(x,y,animTable.frameW,animTable.frameH,animTable.spriteSheet:getDimensions())
    love.graphics.draw(animTable.spriteSheet, quad, dummy.pos.x, dummy.pos.y)
end