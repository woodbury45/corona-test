-----------------------------------------------------------------------------------------
-- This is a test2
-- main.lua
--
-----------------------------------------------------------------------------------------
-- initial tap count = 0
local _W = display.contentWidth 
local bounceLevel = 0.8
local tapCount = 0
local hiCount = 0
local pushball
local level = 1
local ball = {}
local startGame
local floatPlatform
local title
local tapMessage
local onCollision
local reset


-- load sound and set volume
local soundTable = {
     waterDropSound = audio.loadSound("water-drop.wav"),
     tomSound = audio.loadSound("tom.wav"),
     music1 = audio.loadStream("bkmusic2.wav"),
     music2 = audio.loadStream("music2.wav"),
     music3 = audio.loadStream("arcade2.wav"),
     levelSound = audio.loadSound("levelSound.wav")
}
audio.setVolume(0.10, {channel=2})
audio.setVolume(0.20, {channel=3})

local function playNext()
    audio.play(soundTable["music3"], {channel=3, loops=-1, onComplete=play})
end
local function play()
    audio.play(soundTable["music1"], {channel=3, loops=8, onComplete=playNext})
end
play()



-- background
local background = display.newImageRect("background.png",360,570)
background.x = display.contentCenterX
background.y = display.contentCenterY

-- Tray

local tray = display.newRect(0,0,_W*2,100)
tray:setFillColor(0,0,0,0.3)

-- sets score counter, location, font, size and color
local message = "Good Luck!"
local tapText = display.newText(tapCount, display.contentCenterX, 20, native.systemFont, 28)
local scoreLabel = display.newText("Score: ", tapText.x - 90, tapText.y, native.systemFont, 28)
local messageLabel = display.newText(message, tapText.x + 90, tapText.y, native.systemFont, 22)
local highestLabel = display.newText("Highest: ", tapText.x - 80, -10, native.systemFont, 28)
local highestScore = display.newText(hiCount, tapText.x - 1, -10, native.systemFont, 28)
local levelLabel = display.newText("Level: ", 240, -10, native.systemFont, 28)
local levelNum = display.newText(tostring(level), 288, -10, native.systemFont, 28)



highestScore:setFillColor(0,0,0)
highestLabel:setFillColor(0,0,0)
messageLabel:setFillColor(1,1,0)
tapText:setFillColor(0,0,0)
scoreLabel:setFillColor(0,0,0)

-- ground
local ground = display.newImageRect("sand.png", 360, 200)
ground.x = display.contentCenterX
ground.y = display.contentHeight-25

-- platform
local platform = display.newImageRect("vNet.png", 300, 100)
platform.x = display.contentCenterX
platform.y = display.contentHeight
platform:scale(1,2)

-- physics
local physics = require("physics")
physics.start() 


-- function
function clearTitle()
    display.remove(title)
    display.remove(tapMessage)
    display.remove(ball)
    tapCount = 0
    hiCount = 0
    level = 1

    -- call Game
    startGame()
end

function startGame()
    ball = display.newImageRect("volleyball.png", 112, 112)
    ball.x = display.contentCenterX
    ball.y = display.contentCenterY
    physics.addBody(ball, "dynamic",{radius = 50, bounce = bounceLevel})
    physics.addBody(platform, "static")

    timer.performWithDelay(1500, floatPlatform,0)
    ball:addEventListener("tap", pushball)

end

function floatPlatform()
   -- platform.y = math.random(300,500)
    transition.to(platform, {time=1500, y=math.random(200,500)})
end

function pushball()
    ball:applyLinearImpulse( 0, -0.75, ball.x, ball.y)
    tapCount = tapCount + 1
    tapText.text = tapCount

    if (hiCount == 0) then
        hiCount = hiCount + 1
        highestScore.text = hiCount  
    elseif (tapCount > hiCount) then
        hiCount = hiCount + 1
        highestScore.text = hiCount  
    end

    audio.play(soundTable["waterDropSound"], {channel=1})
    messageLabel.text = "Great Job!"

        if (hiCount == 25) then
            level = level + 1 
            levelNum.text = tostring(level)
            audio.play(soundTable["levelSound"])
        elseif (hiCount == 50) then
            level = level + 1 
            levelNum.text = tostring(level)
            audio.play(soundTable["levelSound"])
        elseif (hiCount == 75) then
            level = level + 1 
            levelNum.text = tostring(level)
            audio.play(soundTable["levelSound"])

        elseif (hiCount == 125) then
                level = level + 1 
                levelNum.text = tostring(level)
                audio.play(soundTable["levelSound"])

        elseif (hiCount == 175) then
                level = level + 1 
                levelNum.text = tostring(level)
                audio.play(soundTable["levelSound"])

        elseif (hiCount == 200) then
                level = level + 1 
                levelNum.text = tostring(level)
                audio.play(soundTable["levelSound"])

        end    
end


function onCollision(event)
    if (event.phase == "began") then
        if (tapCount <= 0 ) then
            tapCount = tapCount
            
            messageLabel.text = "Try Again!"

        else
            tapCount = tapCount -1
            messageLabel.text = "Come On!"

        end
        tapText.text = tapCount
        audio.play(soundTable["tomSound"], {channel=2})
       
    end
end

--reset
function reset()
    display.remove(ball)
    display.remove(platform)
    intro()
end

--intro
function intro()
  
    title = display.newImageRect("title.png", 300, 100)
    tapMessage = display.newText("Tap Here. Let's Play!", display.contentCenterX - 100, display.contentCenterY + 70 ,Helvetica,30)

    title.alpha = 0
    transition.to( title, {8000, x = display.contentCenterX, y = display.contentCenterY, rotation=-10, alpha = 1 })
    transition.to( tapMessage, {10000, x = display.contentCenterX, y = display.contentCenterY + 70 })
    
    tapMessage:addEventListener("tap", clearTitle)
    Runtime:addEventListener("collision", onCollision)  
end
intro()

tray:addEventListener("tap", reset)

tapMessage:addEventListener("tap", clearTitle)

Runtime:addEventListener("collision", onCollision)