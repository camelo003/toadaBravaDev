tempChar = {
    x = 60,
    y = 60,
    w = 50,
    h = 20,
    velX = 100,
    velY = 100,
    drawCollision = function(offsetX,offsetY)
        love.graphics.setColor(0,255,255)
        love.graphics.rectangle("line",(tempChar.x-(tempChar.w/2))+offsetX,(tempChar.y-(tempChar.h/2)) + offsetY,tempChar.w,tempChar.h)
        love.graphics.setColor(255,255,255)
    end ,
    update = function(dt, walkBoxes, blockBoxes) -- [to-do] OPTIMIZAR!!! usar lógica: input -> intencao -> checagens -> movimentação (ou não); Vai ficar bom!
        local tempX = (tempChar.x-(tempChar.w/2))
        local tempY = (tempChar.y-(tempChar.h/2))

        if love.keyboard.isDown('w') then
            for i=1, #walkBoxes do
                local topLeftCorner = BoundingBox(walkBoxes[i], tempX, tempY - (tempChar.velY * dt))
                if topLeftCorner and BoundingBox(walkBoxes[i], tempX + tempChar.w, tempY -(tempChar.velY * dt)) then
                    local blocked = false
                    for j = 1, #blockBoxes do
                        topLeftCorner = BoundingBox(blockBoxes[j], tempX, tempY - (tempChar.velY * dt))
                        if topLeftCorner or BoundingBox(blockBoxes[j], tempX + tempChar.w, tempY -(tempChar.velY * dt)) then
                            blocked = true
                            break
                        end
                    end
                    if not blocked then
                        tempChar.y = tempChar.y - (tempChar.velY * dt)
                        break
                    end
                end
            end

        elseif love.keyboard.isDown('s') then
            for i=1, #walkBoxes do
                local bottomLeftCorner = BoundingBox(walkBoxes[i], tempX, tempY + tempChar.h + (tempChar.velY * dt))
                if bottomLeftCorner and BoundingBox(walkBoxes[i], tempX + tempChar.w, tempY + tempChar.h + (tempChar.velY * dt)) then
                    local blocked = false
                    for j = 1, #blockBoxes do
                        bottomLeftCorner = BoundingBox(blockBoxes[j], tempX, tempY + tempChar.h + (tempChar.velY * dt))
                        if bottomLeftCorner or BoundingBox(blockBoxes[j], tempX + tempChar.w, tempY + tempChar.h + (tempChar.velY * dt)) then
                            blocked = true
                            break
                        end
                    end
                    if not blocked then
                        tempChar.y = tempChar.y + (tempChar.velY * dt)
                        break
                    end
                end
            end
        end
        if love.keyboard.isDown('d') then
            for i=1, #walkBoxes do
                local topRightCorner = BoundingBox(walkBoxes[i], tempX + tempChar.w + (tempChar.velX * dt), tempY)
                if topRightCorner and BoundingBox(walkBoxes[i], tempX + tempChar.w + (tempChar.velX * dt), tempY + tempChar.h) then
                    local blocked = false
                    for j = 1, #blockBoxes do
                        topRightCorner = BoundingBox(blockBoxes[j], tempX + tempChar.w + (tempChar.velX * dt), tempY)
                        if topRightCorner or BoundingBox(blockBoxes[j], tempX + tempChar.w + (tempChar.velX * dt), tempY + tempChar.h) then
                            blocked = true
                            break
                        end
                    end
                    if not blocked then
                        tempChar.x = tempChar.x + (tempChar.velX * dt)
                        break
                    end
                end
            end
        elseif love.keyboard.isDown('a') then
            for i=1, #walkBoxes do
                local topLeftCorner = BoundingBox(walkBoxes[i], tempX - (tempChar.velX * dt), tempY)
                if topLeftCorner and BoundingBox(walkBoxes[i], tempX - (tempChar.velX * dt), tempY + tempChar.h) then
                    local blocked = false
                    for j = 1, #blockBoxes do
                        topLeftCorner = BoundingBox(blockBoxes[j], tempX - (tempChar.velX * dt), tempY)
                        if topLeftCorner or BoundingBox(blockBoxes[j], tempX - (tempChar.velX * dt), tempY + tempChar.h) then
                            blocked = true
                            break
                        end
                    end
                    if not blocked then
                        tempChar.x = tempChar.x - (tempChar.velX * dt)
                        break
                    end
                end
            end
        end
        -- get collision box!
    end
}

playerEntity = {
    activeChar = {}, -- anim loaded table with charLoader() function of the char that the player are controlling
    pos = {x = 0, y = 0},
    vel = 150,
    bouningBox = {w = 10, h = 5},
    corners = {{x = 0, y = 0},{x = 0, y = 0},{x = 0, y = 0},{x = 0, y = 0}},
    facing = "",
    drawCollisionBox = true,
    isResponding = true,

    perimeter = 75, -- area que cerca o jogardor para procurar por colisoes (312 e um bom valor!)
    drawPerimeterBox = true,

    update = function(dt, activeMap)
        playerEntity.updateCorners()
        playerEntity.solveWalk(dt, playerEntity.corners, activeMap)
    end,

    draw = function(offsetX,offsetY) -- draw the player's char!
        -- charPlayer
        if playerEntity.drawCollisionBox then
            playerEntity.drawCollision(offsetX,offsetY)
        end

        if playerEntity.drawPerimeterBox then
            playerEntity.drawPerimeter(offsetX,offsetY)
        end
    end,

    -- P L A Y E R   E N T I T Y   H E L P E R   F U N C T I O N S !

    solveWalk = function(dt, corners, activeMap)
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

        playerEntity.pos.x = playerEntity.pos.x + intention.x
        playerEntity.pos.y = playerEntity.pos.y + intention.y

    end,

    solveFacingDirection = function()

    end,

    updateCorners = function()
        playerEntity.corners = {
                                {x = playerEntity.pos.x - (playerEntity.bouningBox.w/2), y = playerEntity.pos.y - (playerEntity.bouningBox.h/2)},
                                {x = playerEntity.pos.x + (playerEntity.bouningBox.w/2), y = playerEntity.pos.y - (playerEntity.bouningBox.h/2)},
                                {x = playerEntity.pos.x + (playerEntity.bouningBox.w/2), y = playerEntity.pos.y + (playerEntity.bouningBox.h/2)},
                                {x = playerEntity.pos.x - (playerEntity.bouningBox.w/2), y = playerEntity.pos.y + (playerEntity.bouningBox.h/2)}
                               }
    end,

    drawCollision = function(offsetX,offsetY)
        love.graphics.setColor(0,255,255)
        love.graphics.rectangle("line",
                                playerEntity.corners[1].x + offsetX,
                                playerEntity.corners[1].y + offsetY,
                                playerEntity.bouningBox.w,
                                playerEntity.bouningBox.h
                               )
        love.graphics.setColor(255,255,255)
    end,

    drawPerimeter = function(offsetX,offsetY)
        love.graphics.setColor(255,0,255)
        love.graphics.rectangle("line",
                                playerEntity.pos.x - playerEntity.perimeter + offsetX,
                                playerEntity.pos.y - playerEntity.perimeter + offsetY,
                                playerEntity.perimeter * 2,
                                playerEntity.perimeter * 2
                               )
        love.graphics.setColor(255,255,255)
    end
}