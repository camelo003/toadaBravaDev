-- funcao de assitencia para qubrar o nome dos arquivos
-- 'https://stackoverflow.com/questions/1426954/split-string-in-lua'
function mySplit (inputstr, sep)
  if sep == nil then
          sep = "%s"
  end
  local t={}
  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
          table.insert(t, str)
  end
  return t
end

function love.load()
  -- carrega uma tabela com a lista de todos os arquivos
  local i, fileNames, popen = 0, {}, io.popen
  local lista = popen("dir /b")
  for filename in lista:lines() do
      i = i + 1
      fileNames[i] = filename
  end

  -- tabela que vai ser usada de ref para desenhar o spritesheet
  allAnims = {}

  local lastAnim = ""
  local actualAnim = ""
  local row = 0

  -- filtra arquivos png, organiza e preenche 'allAnims' com nome dos arquivos ordenados
  for i = 1, #fileNames do
    if string.find(fileNames[i], ".png") or string.find(fileNames[i], ".PNG") then
      local a = mySplit(fileNames[i],"_")
      actualAnim = a[1]
      if not (actualAnim == lastAnim) then
        row = row + 1
        allAnims[row] = {}
        table.insert(allAnims[row], fileNames[i])
      else
        table.insert(allAnims[row], fileNames[i])
      end
    end
    lastAnim = actualAnim
  end

  for i = 1, #allAnims do
    for j = 1, #allAnims[i] do
    allAnims[i][j] = love.graphics.newImage(allAnims[i][j])
    end
  end

  w = allAnims[1][1]:getWidth()
  h = allAnims[1][1]:getHeight()

  local longestAnim = 0
  for i = 1, #allAnims do
    if #allAnims[i] > longestAnim then
      longestAnim = #allAnims[i]
    end
  end

  exportCanvas = love.graphics.newCanvas(w * longestAnim, h * #allAnims)

end

firstRun = true

function love.draw()
  if firstRun then

    f = function()
      for i = 1, #allAnims do
        for j = 1, #allAnims[i] do
          local x = w * (j-1)
          local y = h * (i-1)
          love.graphics.draw(allAnims[i][j], x, y, 0, 1, 1, 0, 0, 0, 0)
        end
      end
    end

    exportCanvas:renderTo(f)

    local defaultSavePath = love.filesystem.getSaveDirectory()
    local imagedata = exportCanvas:newImageData():encode("png","renomeiePorFavor.png")

    defaultSavePath = string.gsub(defaultSavePath,"/","\\")

    local popen = io.popen
    local s = popen("move " .. defaultSavePath .. "\\renomeiePorFavor.png .\\export")

    love.event.quit()
    firstRun = false
  end
end
