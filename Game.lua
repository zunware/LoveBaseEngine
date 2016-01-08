--[[ Game.lua by jose@josellausas.com ]]
local Camera 			= require("LLBase.LLCamera")
local ObjectFactory 	= require("LLBase.ObjectFactory")
local UIMan 			= require("LLBase.UIManager")
local ColMan 			= require("LLBase.CollisionManager")
local EffectsMan		= require("LLBase.EffectsMan")


-- Defaults fro the camera
local cameraSpeed 	= 800
local camScale 		= 2

-- The game object
local game = {
	player = nil,
	team = {},
	enemies = {},
	currentLevelSettings = nil,
	loadedImages = {
		playerTile = nil,
		ship = nil,
	},
	showUI = true,
}


-- Window width
local function getWidth()
	return love.graphics.getWidth()
end

-- Window height
local function getHeight()
	return love.graphics.getHeight()
end

--[[ Loads an image to the loaded images dictionary ]]
function game:loadImage(name, path)

	if not (self.loadedImages[name] == nil) then
		print("RELOADING AN IMAGE!!!")
	end
	
	self.loadedImages[name] = love.graphics.newImage(path)
end


--[[ Loads a gameLevel]]
function game:loadLevel(levelName)

	math.randomseed(os.time())


	print("Loading images")
		-- Load the images here
		-- TODO: get these from the settings
		self:loadImage("player", "art/tileBlue_04.png")
		self:loadImage("ship", "art/playerShip3_blue.png")
	print("Done loading images")



	print("Starting level " .. levelName)
		-- Load level settings from file
		local levelSettings = require("levels."..levelName)
		self.currentLevelSettings = levelSettings
	print("Level settings loaded!")


	print("Initializing Collisions")
		-- We are using 10x10 grids for now.
		ColMan:init(levelSettings.mapWidth, levelSettings.mapHeight, 10, 10)
	print("Done creating collision map")


	print("Creating Player")
		self.player = ObjectFactory:new(self.loadedImages["player"], 200, 200)
		ColMan:registerObject(self.player)
	print("Done creating Player")


	
	print("Creating AI")
		local radius 		= levelSettings.targetRadius
		local speedRange 	= levelSettings.targetRadius

		for i=1,levelSettings.numAI do
			local posX = math.random(0, levelSettings.mapWidth)
			local posY = math.random(0, levelSettings.mapHeight)

			self:createAI(radius, speedRange, posX, posY)
		end
	print("Done creating AI")

end

function game:createAI(radius, speedRange, posX, posY)
	-- Use the object factory
	local enemyAI = ObjectFactory:newAI(self.loadedImages["ship"], posX, posY, nil)
	enemyAI.speed = math.random(speedRange)
	table.insert(self.enemies, enemyAI)
	ColMan:registerObject(enemyAI)

	enemyAI:seek(self.player)
end


local function loadUserSettings()
	-- TODO: Implement this
	return {currentLevel = "level01"}
end

function game:init(settings)
	-- Fail if we have nil settings 
	if settings == nil then print("Failed to load settings") return nil end;

	-- Start the necesary shit for the ui Manager
	

	-- Start to launch the game
	print("Launching " .. settings.gameTitle .. "...")

	-- Starts the Shiny stuff
	print("Initializing Particles...")
		EffectsMan:init({hola="Hola"})
	print("Done with particle setup.")

	-- Start UI
	print("Starting UI...")
		UIMan:init({hola="hola"})
	print("Done with UI.")



	-- Load the levelNames
	local levelNames = settings.levels

	print("Attempting to load "..#levelNames.." levels...")


	
	local successCount = 0
	for i,filename in ipairs(levelNames) do
		-- Load level file
		local path = "levels."..filename
		local levelSettings = require(path)

		if not (levelSettings == nil) then
			print("Level "..levelSettings.name.. " was loaded!")
			successCount = successCount + 1
		end
	end

	print("Finished loading "..successCount.." levels")

	print("Loading user settings ...")
	-- Load the user settings
	local userSettings = loadUserSettings()

	print("Finished loading user settings ...")

	-- Get the users current level
	self:loadLevel(userSettings.currentLevel)
end

local function getCameraDeltas(dt)

	local moveAmount = dt * cameraSpeed

	local deltaX = 0
	local deltaY = 0

	if love.keyboard.isDown("left") then
		deltaX = -moveAmount
	elseif love.keyboard.isDown("right")then
		deltaX = moveAmount
	end

	if love.keyboard.isDown("up") then
		deltaY = -moveAmount
	elseif love.keyboard.isDown("down")then
		deltaY = moveAmount
	end

	return deltaX, deltaY
end

function game:update(dt)

	ColMan:update(dt, self.player)

	-- Refresh the things
	UIMan:update(dt)

	ObjectFactory:update(dt)

	-- Refresh the thing that views the things
	local camDx, camDy = getCameraDeltas(dt)
	Camera:move(camDx, camDy)

	-- Update shiny stuff
	EffectsMan:update(dt)
end 


function game:draw()
	-- All a matter of perspective ;)
	Camera:set()
		-- Draw the objects
		ObjectFactory:draw()
		-- Draw the shiny shit on-top
		EffectsMan:draw()
	Camera:unset()

	-- This goes on top of anything else
	UIMan:draw()

end


function game:zoomOut()
	camScale = camScale * 2
	Camera:setScale(camScale,camScale)
end

function game:zoomIn()
	camScale = camScale / 2
	Camera:setScale(camScale,camScale)
end

return game

