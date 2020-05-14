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

-- local playerEntity = {}