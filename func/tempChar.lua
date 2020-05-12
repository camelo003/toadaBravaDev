tempChar = {
    x = 60,
    y = 60,
    w = 7,
    h = 7,
    velX = 100,
    velY = 100,
    draw = function(offsetX,offsetY)
        love.graphics.rectangle("fill",tempChar.x + offsetX,tempChar.y + offsetY,tempChar.w,tempChar.h)
    end ,
    update = function(dt, walkBoxes, blockBoxes) -- OPTIMIZAR!!! usar lógica: input -> intencao -> checagens -> movimentação (ou não); Vai ficar bom!
        if love.keyboard.isDown('w') then
            for i=1, #walkBoxes do
                local topLeftCorner = BoundingBox(walkBoxes[i], tempChar.x, tempChar.y - (tempChar.velY * dt))
                if topLeftCorner and BoundingBox(walkBoxes[i], tempChar.x + tempChar.w, tempChar.y -(tempChar.velY * dt)) then
                    local blocked = false
                    for j = 1, #blockBoxes do
                        topLeftCorner = BoundingBox(blockBoxes[j], tempChar.x, tempChar.y - (tempChar.velY * dt))
                        if topLeftCorner or BoundingBox(blockBoxes[j], tempChar.x + tempChar.w, tempChar.y -(tempChar.velY * dt)) then
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
                local bottomLeftCorner = BoundingBox(walkBoxes[i], tempChar.x, tempChar.y + tempChar.h + (tempChar.velY * dt))
                if bottomLeftCorner and BoundingBox(walkBoxes[i], tempChar.x + tempChar.w, tempChar.y + tempChar.h + (tempChar.velY * dt)) then
                    local blocked = false
                    for j = 1, #blockBoxes do
                        bottomLeftCorner = BoundingBox(blockBoxes[j], tempChar.x, tempChar.y + tempChar.h + (tempChar.velY * dt))
                        if bottomLeftCorner or BoundingBox(blockBoxes[j], tempChar.x + tempChar.w, tempChar.y + tempChar.h + (tempChar.velY * dt)) then
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
                local topRightCorner = BoundingBox(walkBoxes[i], tempChar.x + tempChar.w + (tempChar.velX * dt), tempChar.y)
                if topRightCorner and BoundingBox(walkBoxes[i], tempChar.x + tempChar.w + (tempChar.velX * dt), tempChar.y + tempChar.h) then
                    local blocked = false
                    for j = 1, #blockBoxes do
                        topRightCorner = BoundingBox(blockBoxes[j], tempChar.x + tempChar.w + (tempChar.velX * dt), tempChar.y)
                        if topRightCorner or BoundingBox(blockBoxes[j], tempChar.x + tempChar.w + (tempChar.velX * dt), tempChar.y + tempChar.h) then
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
                local topLeftCorner = BoundingBox(walkBoxes[i], tempChar.x - (tempChar.velX * dt), tempChar.y)
                if topLeftCorner and BoundingBox(walkBoxes[i], tempChar.x - (tempChar.velX * dt), tempChar.y + tempChar.h) then
                    local blocked = false
                    for j = 1, #blockBoxes do
                        topLeftCorner = BoundingBox(blockBoxes[j], tempChar.x - (tempChar.velX * dt), tempChar.y)
                        if topLeftCorner or BoundingBox(blockBoxes[j], tempChar.x - (tempChar.velX * dt), tempChar.y + tempChar.h) then
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
    end
}

-- local playerEntity = {}