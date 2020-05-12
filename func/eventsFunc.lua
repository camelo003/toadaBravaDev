--[[##############################################
    
Funcoes que lidam com TODOS os eventos :o !

# Os eventos são objetos presentes no mapa (layer "EVENTS_") que devem vir ans seguintes especificações:

JA EXISTEM NO TILES

- id
- name (preencher!)
- type (preencher)
- x
- y
- width
- height

PRECISAM SER CRIADAS E PREENCHIDAS

- para o tipo "teleport" (ir para um ponto)

    - "map" -> arquivo *lua do mapa
    - "sendToX" -> coordenada x no mapa de destino
    - "sendToY" -> coordenada y no mapa de destino
    - "facing" -> direcao que o personagem estara encarando no destino: "up", "right", "down" e "left"
    - "trigger" -> se o evento vai acontecer ao encostar ("touch") ou ao apertar ("check")
    - "cameraX" -> coordenada x do enquadramento desejado (lateral esquerda)
    - "cameraY" -> coordenada y do enquadramento desejado (lateral superior)
    - ["activationSwitches"] -> condições para que o evento esteja funcionando (layer "_SWITCHES")
    - ["specialDrawings"] -> se o evento contem algum desenho (para o caso do desenho precisar alterado)
    - ["action"] -> caso o evento precise causar alguma ação (ex. alterar switch, alterar status dos personagens... ver 'ACOES POSSEIVEIS')   

- tipo "dialog" (inicia um texto ou diálogo)

- interação com o cenário (tipo cortar uma moita no caminho [manipula layer "sprites"])

- batalha (inicia uma batalha)

- cutscene (inicia cutscene [TRETA!])

# logica dos eventos:

1. carregada junto do mapa para uma tabela 'workingEvents'
2. são checadas dentro de 'playerEntity' (hoje em dia)
3. acionadas e manipuladas pela função 'eventHandler'

##############################################]]--

-- Some globals

isSomeEventHappening = false

-- Start declaring some locals helper functions!

local teleport

-- Local tracking variables


-- R E A L   E V E N T S   F U N C T I O N S

function enventHandler(event)
    isSomeEventHappening = true
    local type = event.type
    if type == "teleport" then
        local nextMap = {}
        local a, b, c, d, e = mapLoader("map/" .. event.properties.map .. ".lua")
        nextMap.drawings = a
        nextMap.walks = b
        nextMap.blocks = c
        nextMap.touches = d
        nextMap.checks = e

        local destination = {}
        -- destination.map = event.properties.map
        destination.sendTo = {x = event.properties.sendToX, y = event.properties.sendToY}
        destination.facing = event.properties.facing
        
        teleport(destination,nextMap)

        -- PERFORM EVENT ACTIONS

    elseif type == "dialog" then
        -- dialog!
    elseif type == "map" then
        -- map!
    elseif type == "battle" then
        -- battle!
    elseif type == "cutscene" then
        -- cutscene!
    end
end

function eventsLoader(map)
    local touchEvents, checkEvents = {}, {}
    for i=1, #map.layers do
        if map.layers[i].name == "EVENTS" then
            for j = 1, #map.layers[i].objects do
                if map.layers[i].objects[j].properties.trigger == "touch" then
                    table.insert(touchEvents,map.layers[i].objects[j])
                elseif map.layers[i].objects[j].properties.trigger == "check" then
                    table.insert(checkEvents,map.layers[i].objects[j])
                end
            end
            break
        end
    end

    return touchEvents, checkEvents
end

function drawEvents(eventArray,xOffset, yOffset)
    for i = 1, #eventArray do
        love.graphics.rectangle("line", eventArray[i].x + xOffset, eventArray[i].y + yOffset, eventArray[i].width, eventArray[i].height)
        local s = eventArray[i].name .. "(" .. eventArray[i].type .. ")"
        love.graphics.print(s, eventArray[i].x + xOffset, eventArray[i].y - 25 + yOffset)
    end
end

function checkTouchEvents(eventArray,corners)
    --[[ LEMBRETE! 
        checa se 2 pontos da tabela "corner" estao
        dentro de cada box do "eventArray".
        Se sim retorna o evento em si para então
        ser tratado pela funcao "enventHandler()".
    ]]
    for i = 1, #eventArray do
        local tempBox = {{x = eventArray[i].x, y = eventArray[i].y},
                         {x = eventArray[i].x + eventArray[i].width, y = eventArray[i].y + eventArray[i].height}}
        for j = 1, #corners do
            if j < 4 and BoundingBox(tempBox, corners[j].x, corners[j].y) then
                if BoundingBox(tempBox, corners[j+1].x, corners[j+1].y) then
                    return eventArray[i]
                elseif BoundingBox(tempBox, corners[(j-2)%4+1].x, corners[(j-2)%4+1].y) then -- valeu Bruno =] !
                    return eventArray[i]
                end
            end
        end
    end
end


-- H E L P E R   F U N C T I O N S

teleport = function(toWhere,map)
    local function activateFader() workingFader.isActive = true end
    local function deactivateFader() workingFader.isActive = false; isSomeEventHappening = false end
    local function insertMap()
        table.insert(workingMap,1,map)
        tempChar.x = toWhere.sendTo.x
        tempChar.y = toWhere.sendTo.y
    end

    flux.to(workingFader, 0.2, {opacity = 1}):onstart(activateFader):oncomplete(insertMap):after(workingFader, 0.2, {opacity = 0}):oncomplete(deactivateFader)

end