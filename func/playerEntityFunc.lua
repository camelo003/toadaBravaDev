playerEntity = {
    activeChar = {}, -- anim loaded table with charLoader() function of the char that the player are controlling
    pos = {x = 0, y = 0},
    lastPos = {x = 0, y = 0},
    vel = 150,
    bouningBox = {w = 10, h = 5},
    corners = {{x = 0, y = 0},{x = 0, y = 0},{x = 0, y = 0},{x = 0, y = 0}},
    facing = "left",
    animToPlay = "walkRight",
    drawCollisionBox = true,
    isResponding = true,

    perimeter = 75, -- area que cerca o jogardor para procurar por colisoes (312 e um bom valor!)
    drawPerimeterBox = true,

    update = function(dt, activeMap)
        playerEntity.updateCorners()
        playerEntity.solveFacingDirection()
        playerEntity.solveAnimation()
        playerEntity.solveWalk(dt, activeMap)
    end,

    draw = function() -- draw the player's char!
        charPlayer(playerEntity,{actualFrame = tempClock})
        if playerEntity.drawCollisionBox then
            playerEntity.drawCollision()
        end

        if playerEntity.drawPerimeterBox then
            playerEntity.drawPerimeter()
        end
    end,

    -- P L A Y E R   E N T I T Y   H E L P E R   F U N C T I O N S !

    solveWalk = function(dt, activeMap)
        local intention = {x = 0, y = 0} -- intencao de movimento a ser preenchido

        -- checa inputs
        if inputs.upBtn[2] then
            intention.y = intention.y - playerEntity.vel * dt
        end
        if inputs.rightBtn[2] then
            intention.x = intention.x + playerEntity.vel * dt
        end
        if inputs.downBtn[2] then
            intention.y = intention.y + playerEntity.vel * dt
        end
        if inputs.leftBtn[2] then
            intention.x = intention.x - playerEntity.vel * dt
        end

        -- normaliza!
        local mag = (intention.x ^ 2 + intention.y ^ 2) ^ 0.5
        if mag ~= 0 then
            intention.x = intention.x * math.abs(intention.x / mag)
            intention.y = intention.y * math.abs(intention.y / mag)
        else
            intention.x = 0
            intention.y = 0
        end
        
        -- seta ativo as formas próximas ao personagem
        for i = 1, #activeMap.walks do
            activeMap.walks[i].active = CheckCollision(playerEntity.pos.x - playerEntity.perimeter, -- BOX 1
                                                       playerEntity.pos.y - playerEntity.perimeter,
                                                       playerEntity.perimeter * 2,
                                                       playerEntity.perimeter * 2,
                                                       activeMap.walks[i][1].x, -- BOX 2
                                                       activeMap.walks[i][1].y,
                                                       activeMap.walks[i][2].x - activeMap.walks[i][1].x,
                                                       activeMap.walks[i][2].y - activeMap.walks[i][1].y
                                                    )
            
        end

        for i = 1, #activeMap.blocks do
            activeMap.blocks[i].active = CheckCollision(playerEntity.pos.x - playerEntity.perimeter, -- BOX 1
                                                       playerEntity.pos.y - playerEntity.perimeter,
                                                       playerEntity.perimeter * 2,
                                                       playerEntity.perimeter * 2,
                                                       activeMap.blocks[i][1].x, -- BOX 2
                                                       activeMap.blocks[i][1].y,
                                                       activeMap.blocks[i][2].x - activeMap.blocks[i][1].x,
                                                       activeMap.blocks[i][2].y - activeMap.blocks[i][1].y
                                                    )
            
        end

        -- checa, horizontal, se vai sair das formas "walk"
        if intention.x ~= 0 then
            local totalInside = 0
            if intention.x < 0 then
                for i =1, #activeMap.walks do
                    if activeMap.walks[i].active then
                        local p1X = playerEntity.corners[1].x + intention.x
                        local p1Y = playerEntity.corners[1].y
                        local p4X = playerEntity.corners[4].x + intention.x
                        local p4Y = playerEntity.corners[4].y
                        if BoundingBox(activeMap.walks[i], p1X, p1Y) and BoundingBox(activeMap.walks[i], p4X, p4Y) then
                            -- IS INSIDE!
                            totalInside = totalInside + 1
                        elseif BoundingBox(activeMap.walks[i], p1X, p1Y) or BoundingBox(activeMap.walks[i], p4X, p4Y) then
                            local cornersIn = {false,false,false,false}
                            for j = 1 , #playerEntity.corners do
                                for k = 1, #activeMap.walks do
                                    if activeMap.walks[k].active and BoundingBox(activeMap.walks[k], playerEntity.corners[j].x + intention.x, playerEntity.corners[j].y) then
                                        cornersIn[j] = true
                                        break
                                    end
                                end
                            end
                            if cornersIn[1] and cornersIn[2] and cornersIn[3] and cornersIn[4] then
                                -- IS INSIDE ANOTHER!
                                totalInside = totalInside + 1
                            end
                        end
                    end
                end
            elseif intention.x > 0 then
                for i =1, #activeMap.walks do
                    if activeMap.walks[i].active then
                        local p2X = playerEntity.corners[2].x + intention.x
                        local p2Y = playerEntity.corners[2].y
                        local p3X = playerEntity.corners[3].x + intention.x
                        local p3Y = playerEntity.corners[3].y
                        if BoundingBox(activeMap.walks[i], p2X, p2Y) and BoundingBox(activeMap.walks[i], p3X, p3Y) then
                            -- IS INSIDE!
                            totalInside = totalInside + 1
                        elseif BoundingBox(activeMap.walks[i], p2X, p2Y) or BoundingBox(activeMap.walks[i], p3X, p3Y) then
                            local cornersIn = {false,false,false,false}
                            for j = 1 , #playerEntity.corners do
                                for k = 1, #activeMap.walks do
                                    if activeMap.walks[k].active and BoundingBox(activeMap.walks[k], playerEntity.corners[j].x + intention.x, playerEntity.corners[j].y) then
                                        cornersIn[j] = true
                                        break
                                    end
                                end
                            end
                            if cornersIn[1] and cornersIn[2] and cornersIn[3] and cornersIn[4] then
                                -- IS INSIDE ANOTHER!
                                totalInside = totalInside + 1
                            end
                        end
                    end
                end
            end
            if totalInside == 0 then
                intention.x = 0
            end
        end

        -- checa, vertical, se vai sair das formas "walk"
        if intention.y ~= 0 then
            local totalInside = 0
            if intention.y < 0 then
                for i =1, #activeMap.walks do
                    if activeMap.walks[i].active then
                        local p1X = playerEntity.corners[1].x
                        local p1Y = playerEntity.corners[1].y + intention.y
                        local p2X = playerEntity.corners[2].x
                        local p2Y = playerEntity.corners[2].y + intention.y
                        if BoundingBox(activeMap.walks[i], p1X, p1Y) and BoundingBox(activeMap.walks[i], p2X, p2Y) then
                            -- IS INSIDE!
                            totalInside = totalInside + 1
                        elseif BoundingBox(activeMap.walks[i], p1X, p1Y) or BoundingBox(activeMap.walks[i], p2X, p2Y) then
                            local cornersIn = {false,false,false,false}
                            for j = 1 , #playerEntity.corners do
                                for k = 1, #activeMap.walks do
                                    if activeMap.walks[k].active and BoundingBox(activeMap.walks[k], playerEntity.corners[j].x, playerEntity.corners[j].y + intention.y) then
                                        cornersIn[j] = true
                                        break
                                    end
                                end
                            end
                            if cornersIn[1] and cornersIn[2] and cornersIn[3] and cornersIn[4] then
                                -- IS INSIDE ANOTHER!
                                totalInside = totalInside + 1
                            end
                        end
                    end
                end
            elseif intention.y > 0 then
                for i =1, #activeMap.walks do
                    if activeMap.walks[i].active then
                        local p3X = playerEntity.corners[3].x
                        local p3Y = playerEntity.corners[3].y + intention.y
                        local p4X = playerEntity.corners[4].x
                        local p4Y = playerEntity.corners[4].y + intention.y
                        if BoundingBox(activeMap.walks[i], p3X, p3Y) and BoundingBox(activeMap.walks[i], p4X, p4Y) then
                            -- IS INSIDE!
                            totalInside = totalInside + 1
                        elseif BoundingBox(activeMap.walks[i], p3X, p3Y) or BoundingBox(activeMap.walks[i], p4X, p4Y) then
                            local cornersIn = {false,false,false,false}
                            for j = 1 , #playerEntity.corners do
                                for k = 1, #activeMap.walks do
                                    if activeMap.walks[k].active and BoundingBox(activeMap.walks[k], playerEntity.corners[j].x, playerEntity.corners[j].y + intention.y) then
                                        cornersIn[j] = true
                                        break
                                    end
                                end
                            end
                            if cornersIn[1] and cornersIn[2] and cornersIn[3] and cornersIn[4] then
                                -- IS INSIDE ANOTHER!
                                totalInside = totalInside + 1
                            end
                        end
                    end
                end
            end
            if totalInside == 0 then
                intention.y = 0
            end
        end

        --checa, horizontal, se vai entrar numa shape "block"
        if intention.x ~= 0 then
            local willBeInside = false
            if intention.x < 0 then
                for i =1, #activeMap.blocks do
                    if activeMap.blocks[i].active then
                        local p1X = playerEntity.corners[1].x + intention.x
                        local p1Y = playerEntity.corners[1].y
                        local p4X = playerEntity.corners[4].x + intention.x
                        local p4Y = playerEntity.corners[4].y
                        if BoundingBox(activeMap.blocks[i], p1X, p1Y) or BoundingBox(activeMap.blocks[i], p4X, p4Y) then
                            -- WILL BE INSIDE =/ BLOCK IT!
                            willBeInside = true
                            break
                        end
                    end
                end
            elseif intention.x > 0 then
                for i =1, #activeMap.blocks do
                    if activeMap.blocks[i].active then
                        local p2X = playerEntity.corners[2].x + intention.x
                        local p2Y = playerEntity.corners[2].y
                        local p3X = playerEntity.corners[3].x + intention.x
                        local p3Y = playerEntity.corners[3].y
                        if BoundingBox(activeMap.blocks[i], p2X, p2Y) or BoundingBox(activeMap.blocks[i], p3X, p3Y) then
                            -- WILL BE INSIDE =/ BLOCK IT!
                            willBeInside = true
                            break
                        end
                    end
                end
            end
            if willBeInside then
                intention.x = 0
            end
        end

        --checa, vertical, se vai entrar numa shape "block"
        if intention.y ~= 0 then
            local willBeInside = false
            if intention.y < 0 then
                for i = 1, #activeMap.blocks do
                    if activeMap.blocks[i].active then
                        local p1X = playerEntity.corners[1].x
                        local p1Y = playerEntity.corners[1].y + intention.y
                        local p2X = playerEntity.corners[2].x
                        local p2Y = playerEntity.corners[2].y + intention.y
                        if BoundingBox(activeMap.blocks[i], p1X, p1Y) or BoundingBox(activeMap.blocks[i], p2X, p2Y) then
                            -- WILL BE INSIDE =/ BLOCK IT!
                            willBeInside = true
                            break
                        end
                    end
                end
            elseif intention.y > 0 then
                for i = 1, #activeMap.blocks do
                    if activeMap.blocks[i].active then
                        local p3X = playerEntity.corners[3].x
                        local p3Y = playerEntity.corners[3].y + intention.y
                        local p4X = playerEntity.corners[4].x
                        local p4Y = playerEntity.corners[4].y + intention.y
                        if BoundingBox(activeMap.blocks[i], p3X, p3Y) or BoundingBox(activeMap.blocks[i], p4X, p4Y) then
                            -- WILL BE INSIDE =/ BLOCK IT!
                            willBeInside = true
                            break
                        end
                    end
                end
            end
            if willBeInside then
                intention.y = 0
            end
        end

        -- preenche ultima pos.
        playerEntity.lastPos.x = playerEntity.pos.x
        playerEntity.lastPos.y = playerEntity.pos.y

        -- ANDA! (?)
        playerEntity.pos.x = playerEntity.pos.x + intention.x
        playerEntity.pos.y = playerEntity.pos.y + intention.y

    end,

    justDirections = {"upBtn", "rightBtn", "downBtn", "leftBtn"},
    lastPressed = {},
    solveFacingDirection = function()

        -- Esquema pra definir a direcao que o personagem esta encarando:
        -- Checa se a posicao atual esta contida no array 'lastPressed'
        -- Se sim mantem a direcao atual, se nao assume a direcao que estiver
        -- no [1] do array 'lastPressed' (acho que vai rolar :s )

        for i, v in ipairs(playerEntity.justDirections) do
            if inputs[v][1] then
                local alreadyOnLastPressed = false
                for j = 1, #playerEntity.lastPressed do
                    if playerEntity.lastPressed[j] == v then
                        alreadyOnLastPressed = true
                        break
                    end
                end
                if not alreadyOnLastPressed then
                    table.insert(playerEntity.lastPressed,1,v)
                end
            end
        end

        if playerEntity.lastPressed[1] then
            local isOnLastPressed = false
            for i = 1, #playerEntity.lastPressed do
                if string.gsub(playerEntity.lastPressed[i], "Btn", "") == playerEntity.facing then
                    isOnLastPressed = true
                    break
                end
            end
            if not isOnLastPressed then
                playerEntity.facing = string.gsub(playerEntity.lastPressed[1], "Btn", "")
            end
        end

        --[[ print facing e lastPressed
        print("facing: " .. playerEntity.facing)
        local s = "lastPressed = {"
        for i = 1, #playerEntity.lastPressed do
            if playerEntity.lastPressed[i] then
                s = s .. playerEntity.lastPressed[i]
            end
            if i ~= #playerEntity.lastPressed then
                s = s .. ", "
            end
        end
        print(s .. "}") ]]--

        for i, v in ipairs(playerEntity.justDirections) do
            if inputs[v][3] then
                for j = 0, #playerEntity.lastPressed do
                    if playerEntity.lastPressed[j] == playerEntity.justDirections[i] then
                        table.remove(playerEntity.lastPressed,j)
                        break
                    end
                end
            end
        end      
    end,

    solveAnimation = function()
        -- [FIXME] incrementar conforme tiver mais animacoes!
        if playerEntity.facing == "up" then
            playerEntity.animToPlay = "walkUp"
        elseif playerEntity.facing == "right" then
            playerEntity.animToPlay = "walkRight"
        elseif playerEntity.facing == "down" then
            playerEntity.animToPlay = "walkDown"
        elseif playerEntity.facing == "left" then
            playerEntity.animToPlay = "walkLeft"
        end
    end,
    
    updateCorners = function()
        playerEntity.corners = {
                                {x = playerEntity.pos.x - (playerEntity.bouningBox.w/2), y = playerEntity.pos.y - (playerEntity.bouningBox.h/2)},
                                {x = playerEntity.pos.x + (playerEntity.bouningBox.w/2), y = playerEntity.pos.y - (playerEntity.bouningBox.h/2)},
                                {x = playerEntity.pos.x + (playerEntity.bouningBox.w/2), y = playerEntity.pos.y + (playerEntity.bouningBox.h/2)},
                                {x = playerEntity.pos.x - (playerEntity.bouningBox.w/2), y = playerEntity.pos.y + (playerEntity.bouningBox.h/2)}
                               }
    end,

    drawCollision = function()
        love.graphics.setColor(0,255,255)
        love.graphics.rectangle("line",
                                playerEntity.corners[1].x,
                                playerEntity.corners[1].y,
                                playerEntity.bouningBox.w,
                                playerEntity.bouningBox.h
                               )
        if playerEntity.facing == "up" then
            love.graphics.line(playerEntity.corners[4].x,playerEntity.corners[4].y,playerEntity.pos.x,playerEntity.corners[1].y)
            love.graphics.line(playerEntity.corners[3].x,playerEntity.corners[3].y,playerEntity.pos.x,playerEntity.corners[1].y)
        elseif playerEntity.facing == "right" then
            love.graphics.line(playerEntity.corners[1].x,playerEntity.corners[1].y,playerEntity.corners[2].x,playerEntity.pos.y)
            love.graphics.line(playerEntity.corners[4].x,playerEntity.corners[4].y,playerEntity.corners[2].x,playerEntity.pos.y)
        elseif playerEntity.facing == "down" then
            love.graphics.line(playerEntity.corners[1].x,playerEntity.corners[1].y,playerEntity.pos.x,playerEntity.corners[3].y)
            love.graphics.line(playerEntity.corners[2].x,playerEntity.corners[2].y,playerEntity.pos.x,playerEntity.corners[3].y)
        elseif playerEntity.facing == "left" then
            love.graphics.line(playerEntity.corners[2].x,playerEntity.corners[2].y,playerEntity.corners[1].x,playerEntity.pos.y)
            love.graphics.line(playerEntity.corners[3].x,playerEntity.corners[3].y,playerEntity.corners[1].x,playerEntity.pos.y)
        end

        love.graphics.setColor(255,255,255)
    end,

    drawPerimeter = function()
        love.graphics.setColor(255,0,255)
        love.graphics.rectangle("line",
                                playerEntity.pos.x - playerEntity.perimeter,
                                playerEntity.pos.y - playerEntity.perimeter,
                                playerEntity.perimeter * 2,
                                playerEntity.perimeter * 2
                               )
        love.graphics.setColor(255,255,255)
    end
}