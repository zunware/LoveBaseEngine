local FX = {}

FX.psystem = nil

function FX:init()


	local star = love.graphics.newImage('art/Effects/star1.png')
 
	self.psystem = love.graphics.newParticleSystem(star, 128) -- Max particles at a time
	self.psystem:setParticleLifetime(2, 5) -- Particles live at least 2s and at most 5s.
	self.psystem:setEmissionRate(5)
	self.psystem:setSizeVariation(1)
	self.psystem:setLinearAcceleration(-20, -20, 20, 20) -- Random movement in all directions.
	self.psystem:setColors(255, 255, 255, 255, 255, 255, 255, 0) -- Fade to transparency.

end

function FX:update(dt)
	self.psystem:update(dt)
end


function FX:draw()
	love.graphics.draw(self.psystem, love.graphics.getWidth() * 0.5, love.graphics.getHeight() * 0.5)
end

return FX