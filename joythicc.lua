local class = require("middleclass")
joythicc = class("joythicc")
local joysticks = {}
local originalFont = love.graphics.getFont()


function joythicc:initialize(x, y, width, height, radius, typeJoystick, joystickColor,joystickHover, circleColor, circleHover, border)

	self.x = x or 120
	self.y = y or 120
	self.width = width or 100
	self.height = height or 100
	self.r = radius or 20
	self.type = typeJoystick or "fill"
	self.jColor = joystickColor or {1,1,1}
	self.jHover = color1 or {1,1,0}
	self.cColor = joystickColor or {1,1,1}
	self.cHover = joystickColor or {1,1,0}
	self.border = border or false
	joystickDefaultX = self.x
    joystickDefaultY = self.y
    joystickX = joystickDefaultX
    joystickY = joystickDefaultY
    
    widthS = self.width + self.r
    heightS =self.height + self.r
    rectX = joystickDefaultX - widthS/2
    rectY = joystickDefaultY - heightS/2
    increaseX = 0
    increaseY = 0
    posX = 0
    posY = 0
	state = false
	table.insert(joysticks, self)
	return self


end
function getPosX()
	return posX
end
function getPosY()
	return posY
end
function getIncX()
	return increaseX
end
function getIncY()
	return increaseY
end
function getState()
	return state
end
function joythicc:update(dt)
	mouseX, mouseY = love.mouse.getPosition()
	if love.mouse.isDown(1) then

		if mouseX > rectX and mouseX < rectX + widthS and mouseY > rectY and mouseY < rectY + heightS then
			joystickX = mouseX
			joystickY = mouseY
			state = true
			increaseX = joystickDefaultX - joystickX
			increaseY = joystickDefaultY - joystickY
        else
			state = false
		end
	else
		joystickX = joystickDefaultX
		joystickY = joystickDefaultY
		increaseX = 0
		increaseY = 0
	end
	posX = posX - increaseX
	posY = posY - increaseY 
	--if mouseX > rectX and mouseX < rectX + widthS and mouseY > rectY and mouseY < rectY + heightS then
    --	joystickColor = self.jHover
	--	circleColor = self.cHover
	--else
	--	joystickColor = self.jClick
	--	circleColor = self.cClick
    --end

	circleColor = self.cColor
	joystickColor = self.jColor
end

function joythicc:draw()
    
	love.graphics.setColor(circleColor)
    love.graphics.circle("line", self.x, self.y, self.r)
	love.graphics.setColor(joystickColor)
    love.graphics.circle(self.type, joystickX, joystickY, self.r/2)
    if self.border ~= false then
    love.graphics.setColor(0, 0, 1)
    love.graphics.rectangle("line", rectX, rectY, widthS, heightS)
	end
end 

function update_joysticks()
	for i, v in pairs(joysticks) do
		v:update()
	end
end

function draw_joysticks()
	for i, v in pairs(joysticks) do
		v:draw()
	end 
end