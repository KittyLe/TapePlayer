
-- package.loaded.bigLetters = niL
local GUI = require("GUI")
local event = require("event")
local buffer = require("doubleBuffering")
local bigLetters = require("bigLetters")
local unicode = require("unicode")
local component = require("component")
local fs = require("filesystem")
local context = require("context")
local serialization = require("serialization")
local ecs = require("ECSAPI")
local drive
local computer = require("computer")

if not component.isAvailable("tape_drive") then
os.sleep(0.1)
  computer.beep()
  os.sleep(0.1)
  computer.beep()
  os.sleep(0.1)
  computer.beep()
  os.sleep(0.1)
  computer.beep()
  os.sleep(0.1)
  computer.beep()
  GUI.alert("This program requires Tape Drive from Computronics to start!")
  computer.beep()
  os.sleep(0.1)
  computer.beep()
  return
else
  drive = component.tape_drive
end


  computer.beep()
  os.sleep(0.1)
  computer.beep()
  computer.beep()
  os.sleep(0.1)
  computer.beep()
  os.sleep(0.1)
  computer.beep()
  os.sleep(0.1)
  computer.beep()
  os.sleep(0.1)
  computer.beep()
  os.sleep(0.1)
  computer.beep()
  computer.beep()
  computer.beep()
  os.sleep(0.1)

local pathToSaveStations = "MineOS/System/Radio/Stations.cfg"
local stationNameLimit = 8
local spaceBetweenStations = 8
local countOfStationsLimit = 9
local lineHeight

local config = {
  colors = {
    background = 0x1b1b1b,
    line = 0xFFFFFF,
    lineShadow = 0x000000,
    activeStation = 0xFFA800,
    otherStation = 0xBBBBBB,
    bottomToolBarDefaultColor = 0xaaaaaa,
    bottomToolBarCurrentColor = 0xFFA800,
  },
}

--Объекты для тача
local obj = {}

local function drawStation(x, y, name, color)
  bigLetters.drawText(x, y, color, name)
end

local function drawLine()
  local x = math.floor(buffer.getWidth() / 2)
  for i = 1, lineHeight do
    buffer.text(x + 1, i, config.colors.lineShadow, "▎")
    buffer.text(x, i, config.colors.line, "▍")
  end
end


local function drawMenu()
  local width = 36 + (3 * 2 + 2)
  local x, y = math.floor(buffer.getWidth() / 2 - width / 2), lineHeight + math.floor((buffer.getHeight() - lineHeight) / 2 - 1)

  obj.volumePlus = {x, y, x + 4, y + 3}
  x = bigLetters.drawText(x, y, config.colors.bottomToolBarDefaultColor, "+", "*") + 1
  x = x + 1

  obj.tapePause = {x, y, x + 4, y + 3}
  x = bigLetters.drawText(x, y, config.colors.bottomToolBarDefaultColor, "||", "*") + 1
  x = x + 3
  
  local color
  
  x = x + 2
  obj.tapePlay = {x, y, x + 4, y + 3}
  x = bigLetters.drawText(x, y, config.colors.bottomToolBarDefaultColor, "|>", "*") + 1
  x = x + 2

  x = x + 8
  obj.volumeMinus = {x, y, x + 4, y + 3}
  x = bigLetters.drawText(x, y, config.colors.bottomToolBarDefaultColor, "-", "*") + 1
end
local function drawAll()
buffer.clear(1, 1, buffer.getWidth(), buffer.getHeight(), config.colors.background, 0xFFFFFF, " ")

  drawMenu()

  buffer.drawChanges()
end
  local v = ("0")
local function volume(i)
  if i == 1 then

  v = v + "0.1"
  drive.setVolume(v)
  else
  v = v - "0.1"
  drive.setVolume(v)
end
  end
  
local function play()
  if drive.getState() == "PLAYING" then
  GUI.alert("Tape is already playing.")
  else
  drive.play()
  end
      end
local function pause()
  if drive.getState() == "STOPPED" then
  GUI.alert("Tape is already stopped.")
  else
  drive.stop()
  end
      end

buffer.flush()
lineHeight = math.floor(buffer.getHeight() * 0.7)
drawAll()

while true do
  local e = {event.pull()}
  if e[1] == "touch" then
    if e[5] == 0 then
      if ecs.clickedAtArea(e[3], e[4], obj.tapePlay[1], obj.tapePlay[2], obj.tapePlay[3], obj.tapePlay[4]) then
       bigLetters.drawText(obj.tapePlay[1], obj.tapePlay[2], config.colors.bottomToolBarDefaultColor, "|>", "*") 
       buffer.drawChanges()
        os.sleep(0.2)
        play()
        drawAll()
      elseif ecs.clickedAtArea(e[3], e[4], obj.tapePause[1], obj.tapePause[2], obj.tapePause[3], obj.tapePause[4]) then
        bigLetters.drawText(obj.tapePause[1], obj.tapePause[2], config.colors.bottomToolBarDefaultColor, "||", "*") 
        buffer.drawChanges()
        os.sleep(0.2)
        pause()
        drawAll()
      elseif ecs.clickedAtArea(e[3], e[4], obj.volumePlus[1], obj.volumePlus[2], obj.volumePlus[3], obj.volumePlus[4]) then
        bigLetters.drawText(obj.volumePlus[1], obj.volumePlus[2], config.colors.bottomToolBarCurrentColor, "+", "*" )
        buffer.drawChanges()
        volume(1)
        os.sleep(0.2)
        drawAll()
      elseif ecs.clickedAtArea(e[3], e[4], obj.volumeMinus[1], obj.volumeMinus[2], obj.volumeMinus[3], obj.volumeMinus[4]) then
        bigLetters.drawText(obj.volumeMinus[1], obj.volumeMinus[2], config.colors.bottomToolBarCurrentColor, "-", "*" )
        buffer.drawChanges()
        volume(-1)
        os.sleep(0.2)
        drawAll()
      end
    else
      local action = context.menu(e[3], e[4], {"Добавить станцию", #radioStations >= countOfStationsLimit}, {"Удалить станцию", #radioStations < 2}, "-", {"О программе"}, "-", {"Выход"})
      if action == "Добавить станцию" then
        local data = ecs.universalWindow("auto", "auto", 36, 0x262626, true,
          {"EmptyLine"},
          {"CenterText", ecs.colors.orange, "Добавить станцию"},
          {"EmptyLine"},
          {"Input", 0xFFFFFF, ecs.colors.orange, "Название станции"},
          {"Input", 0xFFFFFF, ecs.colors.orange, "URL-ссылка на стрим"},
          {"EmptyLine"},
          {"Button", {ecs.colors.orange, 0x262626, "OK"}, {0x999999, 0xffffff, "Отмена"}}
        )
        if data[3] == "OK" then
          table.insert(radioStations, {name = data[1], url = data[2]})
          saveStations()
          drawAll()
        end
      elseif action == "Удалить станцию" then
        table.remove(radioStations, radioStations.currentStation)
        saveStations()
        drawAll()

      elseif action == "О программе" then
        ecs.universalWindow("auto", "auto", 36, 0x262626, true, 
          {"EmptyLine"},
          {"CenterText", ecs.colors.orange, "Radio v1.0"}, 
          {"EmptyLine"},
          {"CenterText", 0xFFFFFF, "Автор:"},
          {"CenterText", 0xBBBBBB, "Тимофеев Игорь"},
          {"CenterText", 0xBBBBBB, "vk.com/id7799889"},
          {"EmptyLine"},
          {"CenterText", 0xFFFFFF, "Тестер:"},
          {"CenterText", 0xBBBBBB, "Олег Гречкин"}, 
          {"CenterText", 0xBBBBBB, "http://vk.com/id250552893"},
          {"EmptyLine"},
          {"CenterText", 0xFFFFFF, "Автор идеи:"},
          {"CenterText", 0xBBBBBB, "MrHerobrine с Dreamfinity"}, 
          {"EmptyLine"},
          {"Button", {ecs.colors.orange, 0xffffff, "OK"}}
        )
      elseif action == "Выход" then
        buffer.square(1, 1, buffer.getWidth(), buffer.getHeight(), config.colors.background, 0xFFFFFF, " ")
        buffer.draw()
        ecs.prepareToExit()
        radio.stop()
        return
      end
    end

  elseif e[1] == "scroll" then
    switchStation(e[5])
    drawAll()
  end
end







