-- written by gro verbuger for g3d
-- september 2021
-- MIT license
io.stdout:setvbuf("no")
local assets = 3 + 5 + 48
local starterAssets = 1
local g3d = require "g3d"
require "joythicc"

local mercury = g3d.newModel("assets/sphere.obj", "assets/mercury.jpg", {4,0,50}, nil, 0.5)
local venus = g3d.newModel("assets/sphere.obj", "assets/venus.jpg", {4,0,60}, nil, 1)
local venusAtmosphere = g3d.newModel("assets/sphere.obj", "assets/venusAtmosphere.png", {4,0,60}, nil, 1.3)

local earth = g3d.newModel("assets/sphere.obj", "assets/earth.jpg", {4,5,0}, nil, 3)
local mars = g3d.newModel("assets/sphere.obj", "assets/mars.jpg", {4,0,60}, nil, 0.75)
local jupiter = g3d.newModel("assets/sphere.obj", "assets/jupiter.jpg", {4,0,60}, nil, 10)
local saturn = g3d.newModel("assets/sphere.obj", "assets/saturn.jpg", {4,0,60}, nil, 8)
local uranus = g3d.newModel("assets/sphere.obj", "assets/uranus.jpg", {4,0,60}, nil, 4)
local neptune = g3d.newModel("assets/sphere.obj", "assets/neptune.jpg", {4,0,60}, nil, 6)

local saturnRing = g3d.newModel("assets/cylinder.obj", "assets/saturnRing.png", {4,0,60}, nil, 5)
local moon = g3d.newModel("assets/sphere.obj", "assets/moon.jpg", {4,5,0}, nil, 0.5)
love.mouse.setVisible(false)
cursor_off = love.graphics.newImage("assets/cursor_on.png") 
cursor_on = love.graphics.newImage("assets/cursor_off.png") 
cursorStatus = cursor_on
local incSuperNova = 1
local starterW = love.graphics.getWidth()
local starterH = love.graphics.getHeight()
love.success = love.window.setMode(starterW, starterH, {borderless = false, centered = true, resizable = true, depth = 16})
wW = starterW
wH = starterH
local hMath = starterH/16
-- ENVIRONMENT LIGHTING
local lightingShader = love.graphics.newShader(g3d.path .. "/g3d.vert", "lighting.frag")
local depthShader = love.graphics.newShader(g3d.path .. "/g3d.vert","/sfbo.frag")
local uvShader = love.graphics.newShader(g3d.path .. "/g3d.vert", "uv.frag")

local canvas = love.graphics.newCanvas(1024,1024)
local SFBO = love.graphics.newCanvas(1024,1024, {readable=true, format = "depth24"})

local glaxy = g3d.newModel("assets/sphere.obj", "assets/universe.jpg", nil, nil, 500)
local lcolor = {1,0.6,0.1}
local color = {1,0.6,0.1}
local ambientcolor = {1,1,1}
local loadingTime = 0
-- SUNS
local sunPosition = {4,0,0}
local sun = g3d.newModel("assets/sphere.obj", "assets/sun.jpg", sunPosition, nil, 25)
local supernova = g3d.newModel("assets/soccerball.obj", "assets/supernova.png", {4,0,0}, nil, 25)
local superNovaSize = 0.1
local explode = g3d.newModel("assets/cylinder.obj", "assets/explosion.png", {4,0,0}, nil, 25)
local starBlast = false
local starBlasting = false
local maxStarBlasting = false
local mouseMove = false
local supernova_occurence = false
local timer = 0
local timer2 = 100
local year = 54525627 - 20
local divide = 10
local hLevels = 1.1835616 * 1000000000000 * 5000000000
local hConsum = 5000000000 * 0.152
local timeSpeed = 1
local timeTravel = 1
local sunSize = 0.001
local explosionSize = 0.1
local font = love.graphics.newFont(15)
local exploded = false
local superNovaLasting = 10

function love.load()
    joythicc:new(x, y, width, height, radius, "fill", {1,1,0},{1,0,1}, {1,0,1},{1,1,0}, border)
end

function love.update(dt)
    update_joysticks()
    loadingTime = loadingTime + 1 * dt
    timer = timer + timeSpeed/10 *  dt
    timer2 = timer2 +  timeSpeed/10 * dt
    timeTravel = timeTravel + 0.01 * dt
    year = year + 0.2 * timeSpeed/10 * dt
    hLevels = hLevels - 5000000000 * timeSpeed/5 * dt
    hConsum = hConsum + sunSize * 5000000000 * 0.152 * timeSpeed/10 * dt
    division = math.floor(math.log10(math.abs(year)) + 1)
  

    lightingShader:send("lightPosition", {sunPosition[1],sunPosition[2],sunPosition[3]+10})
	--lightingShader:send("lightPosition", moon.translation)
	lightingShader:send("lightColor", lcolor)
	lightingShader:send("ambientLightColor", ambientcolor)
	lightingShader:send("ambient", .2)
	lightingShader:send("viewPos", g3d.camera.position)
    uvShader:send("lightPosition",{sunPosition[1],sunPosition[2],sunPosition[3]+sunSize +10})

	--lightingShader:send("lightPosition", moon.translation)
	uvShader:send("lightColor", color)
	uvShader:send("ambientLightColor", ambientcolor)
	uvShader:send("ambient", .2)
	uvShader:send("viewPos", g3d.camera.position)
    depthShader:send("depthMap", SFBO)





    if starBlasting == true then
        sunSize = incSuperNova
    else
        sunSize = year/54525627
    end    



    mercury:setTranslation(math.cos(timer)*45 + 4, math.sin(timer)*45, 0 )
    mercury:setRotation(0, timer - math.pi/3, 0)
    venus:setTranslation(math.cos(timer2)*55 + 4, math.sin(timer2)*55, 0 )
    venus:setRotation(0, timer2 - math.pi/3, 0)
    venusAtmosphere:setTranslation(math.cos(timer2)*55 + 4, math.sin(timer2)*55, 0 )
    venusAtmosphere:setRotation(0, timer2 - math.pi/3, 0)
    earth:setTranslation(math.cos(timer)*80 + 4, math.sin(timer)*80, 0 )
    earth:setRotation(0, timer - math.pi/3, 0)
    mars:setTranslation(math.cos(timer2)*100 + 4, math.sin(timer2)*100, 0 )
    mars:setRotation(0, timer2 - math.pi/3, 0)
    jupiter:setTranslation(math.cos(timer2)*120 + 4, math.sin(timer2)*120, 0 )
    jupiter:setRotation(0, 0, timer2 - math.pi/2)
    saturn:setTranslation(math.cos(timer)*200 + 4, math.sin(timer)*200, 0 )
    saturn:setRotation(0, 0, timer - math.pi/2)
    uranus:setTranslation(math.cos(timer2)*270 + 4, math.sin(timer2)*270, 0 )
    uranus:setRotation(0, 0, timer2 - math.pi/2)
    neptune:setTranslation(math.cos(timer)*340 + 4, math.sin(timer)*340, 0 )
    neptune:setRotation(0, 0, timer - math.pi/2)

    saturnRing:setTranslation(math.cos(timer)*200 + 4, math.sin(timer)*200, 0 )
    saturnRing:setRotation(0, 0, timer - math.pi/2)
    moon:setTranslation(math.cos(timer )*80  , math.sin(timer)*80+ 10, 0)
    moon:setRotation(0, 0, timer - math.pi/2)
    saturnRing:setScale(15,15,1)

    

    if year > 54525627  then
        if starBlast then
            if incSuperNova < 1 then
                if explosionSize < 100 and explosionSize > 0.05 then
                   if exploded ~= true then
                      explosionSize = explosionSize + 20 * dt
                       else
                      explosionSize = explosionSize - 20 * dt
                   end
                end
                if superNovaSize < 50 and superNovaSize >= 0.1 then
                    superNovaSize = superNovaSize + 10 * dt
                else
                    supernova_occurence = true
                end
            end


        end
        if incSuperNova < 7 and incSuperNova > 0.05 then
                if incSuperNova <= 6 and maxStarBlasting == false then
                incSuperNova = incSuperNova + 2 * dt
                starBlasting = true
                elseif maxStarBlasting == true then
                    incSuperNova = incSuperNova - 2 * dt
                    starBlasting = true
                end
            else
              starBlast = true
              starBlasting = false
              maxStarBlasting = false
        end
    end

    if supernova_occurence  == true then
        superNovaLasting = superNovaLasting - 1 * dt
    end

    if superNovaLasting <= 0 then
        superNovaSize = 0.01
        starBlast = false
        superNovaLasting = 10
    end

    if year > 4e9 then
        if year > 41e8 then
            color = {0.4,0,0}
            ambientcolor = {0.4,0,0}
        elseif year > 45e8 then
            color = {0.7,0,0}
            ambientcolor = {0.7,0,0}
        elseif year > 5e9 then
        color = {1,0,0}
        ambientcolor = {1,0,0}
        end
    end
    if loadingTime > 5 then
        print("Loading")
        for i = starterAssets,assets ,1  do 
          starterAssets = i 
        end 
    end
    sun:setScale(sunSize,sunSize,sunSize)
    explode:setScale(explosionSize,explosionSize,1)
    supernova:setScale(superNovaSize, superNovaSize,superNovaSize)

    if love.keyboard.isDown("v") then
        year = love.system.getClipboardText()
    end
    function love.resize(w, h)
        print(("Window resized to width: %d and height: %d."):format(w, h))
        wW = w
        wH = h 
        --love.window.setMode(love.graphics.getWidth(), love.graphics.getHeight(), {depth = w/hMath})
    end
if explosionSize > 99 then
    exploded = true
end

if incSuperNova >= 6 then
    maxStarBlasting = true
end
posiX, posiY = getIncX(), getIncY()
print(posiX..posiY)
    g3d.camera.firstPersonMovement(dt, posiX, posiY)
    if love.keyboard.isDown "escape" then
        love.event.push "quit"
    end
print(maxStarBlasting)
end

function love.draw()
    draw_joysticks()

    love.graphics.setBlendMode("alpha") --Default blend mode
   love.graphics.setCanvas({canvas, depth=true, depthstencil=SFBO})
    love.graphics.clear();
    g3d.camera.updateViewMatrix(depthShader)
    g3d.camera.updateProjectionMatrix(depthShader)
    drawWith(depthShader)
    love.graphics.setCanvas() 

    g3d.camera.updateViewMatrix(lightingShader)
    g3d.camera.updateProjectionMatrix(lightingShader)
    love.graphics.setFont(font)
    if year > 54525627 and exploded == true then
    drawWith(lightingShader)
    end
    supernova:draw(lightingShader)
    g3d.camera.updateViewMatrix(uvShader)
    g3d.camera.updateProjectionMatrix(uvShader)
    sun:draw(uvShader)
    explode:draw(uvShader)
    glaxy:draw()
    --love.graphics.setColor(28/255, 20/255, 0)
    --love.graphics.setBlendMode("lighten", "premultiplied")
    --love.graphics.rectangle("fill", 0, 0, wW, wH)
    --love.graphics.setBlendMode("alpha")

    love.graphics.setColor(1,1,1)
    love.graphics.draw(cursorStatus, love.mouse.getX() - cursorStatus:getWidth() / 2, love.mouse.getY() - cursorStatus:getHeight() / 2)

    love.graphics.print("Year : "..math.floor(year).."x "..timeSpeed.." "..sunSize.." \n | Consuming Hydrogen: "..hConsum.." kg".." \n | Hydrogen Left : "..hLevels)

    if starterAssets ~= assets  then
        love.graphics.setColor(0,0,0)
        love.graphics.rectangle("fill", 0, 0, wW - ((starterAssets - 1) * 5) , wH - ((starterAssets - 1) * 5) )
    love.graphics.setColor(1,1,1)
    love.graphics.print("Loading Assets : ["..starterAssets.."/"..assets.."]", wW/2, wH/2)
    end
end

function love.mousemoved(x,y, dx,dy)
    if mouseMove == true then
        g3d.camera.firstPersonLook(dx,dy)
    elseif mouseMove == false then
        if love.mouse.isDown(2) then
           cursorStatus = cursor_off
           g3d.camera.firstPersonLook(dx,dy)
        else
           cursorStatus = cursor_on
        end
    end
end

 
function love.wheelmoved(x, y)
    if y > 0 then
        if timeSpeed >= -6 and timeSpeed < 6 then
            timeSpeed = timeSpeed + 1 
        else
            timeSpeed = timeSpeed + 1000000000
        end
    elseif y < 0 then
        if timeSpeed > -6 and timeSpeed <= 6 then
            timeSpeed = timeSpeed - 1 
        else
            timeSpeed = timeSpeed - 1000000000
        end
    end
end

function drawWith(shader)
    mercury:draw(shader)
    venus:draw(shader)
    venusAtmosphere:draw(shader)
    earth:draw(shader)
    mars:draw(shader)
    jupiter:draw(shader)
    saturn:draw(shader)
    uranus:draw(shader)
    neptune:draw(shader)
    saturnRing:draw(shader)
    moon:draw(shader)
end

function love.keypressed(key, scancode, isrepeat)
    if key == "f11" then
        fullscreen = not fullscreen
        love.window.setFullscreen(fullscreen, fstype)
        love.resize(love.graphics.getDimensions())
    end
end


function sunRatio(x)
    return 0.015 * x + 0.85 - 0.6/(x - 12)
end

function getSunSize(x)
    return sunSize * sunRatio(x)
end