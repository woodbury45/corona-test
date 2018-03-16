-----------------------------------------------------------------------------------------
-- This is a test
-- main.lua
--
-----------------------------------------------------------------------------------------
-- load sound and set volume
local soundTable = {
     waterDropSound = audio.loadSound("water-drop.wav"),
     tomSound = audio.loadSound("tom.wav"),
     music1 = audio.loadStream("bkmusic2.wav"),
     music2 = audio.loadStream("music2.wav"),
     music3 = audio.loadStream("arcade2.wav")
}
audio.setVolume(0.50, {channel=2})
audio.setVolume(0.20, {channel=3})

local function playNext()
    audio.play(soundTable["music3"], {channel=3, loops=-1, onComplete=play})
end
local function play()
    audio.play(soundTable["music1"], {channel=3, loops=8, onComplete=playNext})
end
play()

-- initial tap count = 0
local tapCount = 0
local hiCount = 0

-- background
local background = display.newImageRect("background.png",360,570)
background.x = display.contentCenterX
background.y = display.contentCenterY

-- sets score counter, location, font, size and color
local message = "Good Luck!"
local tapText = display.newText(tapCount, display.contentCenterX, 20, native.systemFont, 28)
local scoreLabel = display.newText("Score: ", tapText.x - 90, tapText.y, native.systemFont, 28)
local messageLabel = display.newText(message, tapText.x + 90, tapText.y, native.systemFont, 22)
local highestLabel = display.newText("Highest: ", tapText.x - 80, -10, native.systemFont, 28)
local highestScore = display.newText(hiCount, tapText.x - 1, -10, native.systemFont, 28)
local levelLabel = display.newText("Level: ", 240, -10, native.systemFont, 28)
local level = display.newText("1", 288, -10, native.systemFont, 28)


highestScore:setFillColor(0,0,0)
highestLabel:setFillColor(0,0,0)
messageLabel:setFillColor(1,1,0)
tapText:setFillColor(0,0,0)
scoreLabel:setFillColor(0,0,0)

-- platform
local platform = display.newImageRect("platform.png", 300, 50)
platform.x = display.contentCenterX
platform.y = display.contentHeight-25


-- balloon
local balloon = display.newImageRect("balloon.png", 112, 112)
balloon.x = display.contentCenterX
balloon.y = display.contentCenterY
balloon.alpha = 0.8

local bounceLevel = 0.8

local physics = require("physics")
physics.start() 

physics.addBody(platform, "static")
physics.addBody(balloon, "dynamic",{radius = 50, bounce = bounceLevel})

-- reset
local function reset()
    local balloon = display.newImageRect("balloon.png", 112, 112)
    balloon.x = display.contentCenterX
    balloon.y = display.contentCenterY
    balloon.alpha = 0.8
end

local widget = require( "widget" )
 
-- Function to handle button events
local function handleButtonEvent( event )
 
    if ( "ended" == event.phase ) then
       
    end
end
 
-- Create the widget
local button1 = widget.newButton(
    {
        label = "button",
        onEvent = handleButtonEvent,
        emboss = false,
        -- Properties for a rounded rectangle button
        shape = "roundedRect",
        width = 80,
        height = 20,
        cornerRadius = 2,
        fillColor = { default={1,1,0,0.6}, over={1,0.1,0.7,0.4} },
        strokeColor = { default={1,0.4,0,0}, over={0.8,0.8,1,1} },
        strokeWidth = 2
    }
)
 
-- Center the button
button1.x = display.contentCenterX
button1.y = platform.y - -40
 
-- Change the button's label text
button1:setLabel( "Reset" )

-- function
local function pushBalloon()
    balloon:applyLinearImpulse( 0, -0.75, balloon.x, balloon.y)
    tapCount = tapCount + 1
    hiCount = tapCount
    tapText.text = tapCount
    highestScore.text = hiCount
    audio.play(soundTable["waterDropSound"], {channel=1})
    platform.y = math.random(300,500)
    messageLabel.text = "Great Job!"
    if (hiCount >= 5) then
        balloon.bounce = 1.2
        platform.bounce = 1.2
    end
end

balloon:addEventListener("tap", pushBalloon)

local function onCollision(event)
    if (event.phase == "began") then
        if (tapCount <= 0 ) then
            tapCount = tapCount
            
            messageLabel.text = "Try Again!"

        else
            tapCount = tapCount -1
            messageLabel.text = "Not Good!"

        end
        tapText.text = tapCount
        audio.play(soundTable["tomSound"], {channel=2})
       
    end
end

Runtime:addEventListener("collision", onCollision)