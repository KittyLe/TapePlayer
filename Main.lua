
-- package.loaded.bigLetters = niL
local GUI = require("GUI")
local event = require("event")
local buffer = require("doubleBuffering")
local bigLetters = require("bigLetters")
local unicode = require("unicode")
local component = require("component")
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

  print("Tape Player Dev Edition")
  print("InfO:")
  print(drive.getLabel())
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

local lineHeight

local config = {
  colors = {
    background = 0x1b1b1b,
    bottomToolBarDefaultColor = 0xaaaaaa,
    bottomToolBarCurrentColor = 0xFFA800,
  },
}

local function drawName(x, y, name, color)
	buffer.drawText(x, y, color, name)
end

local function drawNamv()
	local prevWidth, currentWidth, nextWidth, name
  if tape.getLabel() == "" then
      name = "Not labeled."
  else
  name = drive.getLabel()
	currentWidth = bigLetters.getTextSize(name)
	local x, y = math.floor(buffer.getWidth() / 2 - currentWidth / 2), math.floor(buffer.getHeight() / 2 - 3)
	drawName(x, y, name, config.colors.bottomToolBarCurrentColor)
end
end

local obj = {}

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
  x = bigLetters.drawText(x, y, config.colors.bottomToolBarDefaultColor, "", "*") + 1
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
      end
      end
end
