-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

local physics = require( "physics" )

physics.start()
physics.setGravity( 0, 25 )
physics.setDrawMode( "hybrid" )

local leftWall = display.newRect( 0, display.contentHeight / 2, 1, display.contentHeight )
-- myRectangle.strokeWidth = 3
-- myRectangle:setFillColor( 0.5 )
-- myRectangle:setStrokeColor( 1, 0, 0 )
leftWall.alpha = 0.0
physics.addBody( leftWall, "static", { 
    friction = 0.5, 
    bounce = 0.3 
    } )


local theGround1 = display.newImage( "./assets/sprites/land.png" )
theGround1.x = 520
theGround1.y = display.contentHeight
theGround1.id = "the ground"
physics.addBody( theGround1, "static", { 
    friction = 0.5, 
    bounce = 0.3 
    } )

local theGround2 = display.newImage( "./assets/sprites/land.png" )
theGround2.x = 1520
theGround2.y = display.contentHeight
theGround2.id = "the ground" -- notice I called this the same thing
physics.addBody( theGround2, "static", { 
    friction = 0.5, 
    bounce = 0.3 
    } )

display.setStatusBar(display.HiddenStatusBar)
 
centerX = display.contentWidth * .5
centerY = display.contentHeight * .5

local playerBullets = {} -- Table that holds the players Bullets

local shootButton = display.newImage( "./assets/sprites/jumpButton.png" )
shootButton.x = display.contentWidth - 250
shootButton.y = display.contentHeight - 80
shootButton.id = "shootButton"
shootButton.alpha = 0.5

local dPad = display.newImage( "./assets/sprites/d-pad.png" )
dPad.x = 150
dPad.y = display.contentHeight - 200
dPad.alpha = 0.50
dPad.id = "d-pad"

local jumpButton = display.newImage( "./assets/sprites/jumpButton.png" )
jumpButton.x = display.contentWidth - 80
jumpButton.y = display.contentHeight - 80
jumpButton.id = "jump button"
jumpButton.alpha = 0.5

local rightArrow = display.newImage( "./assets/sprites/rightArrow.png" )
rightArrow.x = 260
rightArrow.y = display.contentHeight - 200
rightArrow.id = "right arrow"

local leftArrow = display.newImage( "./assets/sprites/leftArrow.png" )
leftArrow.x = 40
leftArrow.y = display.contentHeight - 200
leftArrow.id = "left arrow"

local sheetOptionsIdle =
{
    width = 290,
    height = 500,
    numFrames = 10
}
local sheetIdleninjaGirl = graphics.newImageSheet( "./assets/spritesheets/ninjaGirlIdle.png", sheetOptionsIdle )

local sheetOptionsDead =
{
    width = 578,
    height = 599,
    numFrames = 10
}

local sheetDeadninjaGirl = graphics.newImageSheet( "./assets/spritesheets/ninjaGirlDead.png", sheetOptionsDead )

local sequence_data = {
    -- consecutive frames sequence
    {
        name = "idle",
        start = 1,
        count = 10,
        time = 800,
        loopCount = 0,
        sheet = sheetIdleninjaGirl
    },
    {
        name = "dead",
        start = 1,
        count = 10,
        time = 700,
        loopCount = 1,
        sheet = sheetDeadninjaGirl
    },
}

local ninjaGirl = display.newSprite( sheetIdleninjaGirl, sequence_data )
ninjaGirl.x = 1520
ninjaGirl.y = display.contentHeight - 1000
ninjaGirl.id ="ninja Girl"
ninjaGirl:setSequence( "idle" )
ninjaGirl:play()
physics.addBody( ninjaGirl, "dynamic", { 
    friction = 0.5, 
    bounce = 0.3 
    } )
ninjaGirl.isFixedRotation = true
-- rest to idle 

local sheetOptionsIdle =
{
    width = 232,
    height = 439,
    numFrames = 10
}
local sheetIdleninjaBoy = graphics.newImageSheet( "./assets/spritesheets/ninjaBoyIdle.png", sheetOptionsIdle )

local sheetOptionsWalk =
{
    width = 360,
    height = 458,
    numFrames = 10
}
local sheetWalkingninjaBoy = graphics.newImageSheet( "./assets/spritesheets/ninjaBoyWalking.png", sheetOptionsWalk )

local sheetOptionsJump =
{
    width = 362,
    height = 483,
    numFrames = 10
}

local sheetjumpingninjaBoy = graphics.newImageSheet( "./assets/spritesheets/ninjaBoyJump.png", sheetOptionsJump )
-- sequences table
local sequence_data = {
    -- consecutive frames sequence
    {
        name = "idle",
        start = 1,
        count = 10,
        time = 800,
        loopCount = 0,
        sheet = sheetIdleninjaBoy
    },
    {
        name = "walk",
        start = 1,
        count = 10,
        time = 1000,
        loopCount = 1,
        sheet = sheetWalkingninjaBoy
    },
    {
        name = "jump",
        start = 1,
        count = 10,
        time = 1000,
        loopCount = 1,
        sheet = sheetjumpingninjaBoy
    }    
}

local ninjaBoy = display.newSprite( sheetIdleninjaBoy, sequence_data )
ninjaBoy.x = display.contentCenterX - 200
ninjaBoy.y = display.contentCenterY
ninjaBoy.id = "ninja boy"
ninjaBoy:setSequence( "idle" )
ninjaBoy:play()
physics.addBody( ninjaBoy, "dynamic", { 
    density = 3.0, 
    friction = 0.5, 
    bounce = 0.3 
    } )
ninjaBoy.isFixedRotation = true

function checkCharacterPosition( event )

    if ninjaBoy.y > display.contentHeight + 500 then
        ninjaBoy.x = display.contentCenterX - 200
        ninjaBoy.y = display.contentCenterY
    end
end


local function checkPlayerBulletsOutOfBounds()
    -- check if any bullets have gone off the screen
    local bulletCounter

    if #playerBullets > 0 then
        for bulletCounter = #playerBullets, 1 , -1 do
            if playerBullets[bulletCounter].x > display.contentWidth + 1000 then
                playerBullets[bulletCounter]:removeSelf()
                playerBullets[bulletCounter] = nil
                table.remove(playerBullets, bulletCounter)
                print("remove bullet")
            end
        end
    end
end

local function onCollision( event )
 
    if ( event.phase == "began" ) then
 
        local obj1 = event.object1
        local obj2 = event.object2
        local whereCollisonOccurredX = obj1.x
        local whereCollisonOccurredY = obj1.y

        if ( ( obj1.id == "ninja Girl" and obj2.id == "bullet" ) or
             ( obj1.id == "bullet" and obj2.id == "ninja Girl" ) ) then
            -- Remove both the laser and asteroid
            --display.remove( obj1 )
            --display.remove( obj2 )
            
            -- remove the bullet
            local bulletCounter = nil
            
            for bulletCounter = #playerBullets, 1, -1 do
                if ( playerBullets[bulletCounter] == obj1 or playerBullets[bulletCounter] == obj2 ) then
                    playerBullets[bulletCounter]:removeSelf()
                    playerBullets[bulletCounter] = nil
                    table.remove( playerBullets, bulletCounter )
                    break
                end
            end

            --remove character
            ninjaGirl:setSequence( "dead" )
            ninjaGirl:play()
            timer.performWithDelay( 4000 )

            -- Increase score
            print ("you could increase a score here.")

            -- make an explosion sound effect
            local expolsionSound = audio.loadStream( "./assets/sounds/8bit_bomb_explosion.wav" )
            local explosionChannel = audio.play( expolsionSound )

            -- make an explosion happen
            -- Table of emitter parameters
            local emitterParams = {
                startColorAlpha = 1,
                startParticleSizeVariance = 250,
                startColorGreen = 0.3031555,
                yCoordFlipped = -1,
                blendFuncSource = 770,
                rotatePerSecondVariance = 153.95,
                particleLifespan = 0.7237,
                tangentialAcceleration = -1440.74,
                finishColorBlue = 0.3699196,
                finishColorGreen = 0.5443883,
                blendFuncDestination = 1,
                startParticleSize = 400.95,
                startColorRed = 0.8373094,
                textureFileName = "./assets/sprites/boom.png",
                startColorVarianceAlpha = 1,
                maxParticles = 256,
                finishParticleSize = 540,
                duration = 0.25,
                finishColorRed = 1,
                maxRadiusVariance = 72.63,
                finishParticleSizeVariance = 250,
                gravityy = -671.05,
                speedVariance = 90.79,
                tangentialAccelVariance = -420.11,
                angleVariance = -142.62,
                angle = -244.11
            }
            local emitter = display.newEmitter( emitterParams )
            emitter.x = whereCollisonOccurredX
            emitter.y = whereCollisonOccurredY

        end
    end
end

function shootButton:touch( event )
    if ( event.phase == "began" ) then
        -- make a bullet appear
        local aSingleBullet = display.newImage( "./assets/sprites/fireball.png" )
        aSingleBullet.x = ninjaBoy.x
        aSingleBullet.y = ninjaBoy.y
        physics.addBody( aSingleBullet, 'dynamic' )
        -- Make the object a "bullet" type object
        aSingleBullet.isBullet = true
        aSingleBullet.isFixedRotation = true
        aSingleBullet.gravityScale = 0
        aSingleBullet.id = "bullet"
        aSingleBullet:setLinearVelocity( 1500, 0 )

        table.insert(playerBullets,aSingleBullet)
        print("# of bullet: " .. tostring(#playerBullets))
    end

    return true
end

function jumpButton:touch( event )
    if ( event.phase == "ended" ) then
        -- make the character jump
        transition.moveBy( ninjaBoy, {
            x = 0,
            y = -350,
            time = 700
            } )
        ninjaBoy:setSequence( "jump" )
        ninjaBoy:play()
    end

    return true
end

function rightArrow:touch( event )
    if ( event.phase == "ended" ) then
        -- move the character up
        transition.moveBy( ninjaBoy, { 
            x = 150, 
            y = 0, 
            time = 1000 
            } )
        ninjaBoy:setSequence( "walk" )
        ninjaBoy:play()
    end

    return true
end
-- rest to idle 
local function resetToIdle (event)
    if event.phase == "ended" then
        ninjaBoy:setSequence("idle")
        ninjaBoy:play()
    end
end

function leftArrow:touch( event )
    if ( event.phase == "ended" ) then
        -- move the character up
        transition.moveBy( ninjaBoy, {
                x = -50, -- move 0 in the x direction
                y = 0, -- move down 50 pixels
                time = 100 --move in a 1/10 of a second
                } ) 
    end

    return true
end

ninjaBoy.collision = checkCharacterCollision

Runtime:addEventListener( "collision", onCollision )
leftArrow:addEventListener( "touch", leftArrow )
rightArrow:addEventListener( "touch", rightArrow )
ninjaBoy:addEventListener("sprite", resetToIdle)
jumpButton:addEventListener( "touch", jumpButton )
Runtime:addEventListener( "enterFrame", checkCharacterPosition )
shootButton:addEventListener( "touch", shootButton )
Runtime:addEventListener( "enterFrame", checkPlayerBulletsOutOfBounds )