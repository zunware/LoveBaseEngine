--------------------------------------------------
-- Defines the unit tests for the LLBase
--------------------------------------------------
require 'busted.runner'()


--------------------------------------------------
-- Checks if the file exists
--------------------------------------------------
local function file_exists(name)
   local f = io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end

describe("Main", function() 
-- [[ LLBase tests ]]
describe("LLBase", function()

	local count = 0
	local clr = require 'trepl.colorize'
	local moduleName = ""

  -- Crete the printing function
  	local function ll(message)
      print(clr.red("[") .. clr.Blue("Test #" .. count) .. clr.red("]") .. "{ ".. message .. " }")
	end
	
	before_each(function()
		print("")
		count = count + 1
		print ("[]-> " .. moduleName .." test #" .. count)
	end)

	after_each(function()
		print(" -> Done testing")
	end)

	it("should print in colors", function()
		ll("Hola")
	end)

	it("should import the module", function()
		local Base = require("LLBase.ObjectFactory")
		assert.truthy(Base)
	end)

	it("should have a conf.lua file", function()
		local config = require("conf")
	end)

	it("should have a \"run\" file", function()
		assert.truthy(file_exists("run"))
	end)
end)

--[[ Object Factory tests]]
describe("ObjectFactory", function()
	local count = 0
	local clr = require 'trepl.colorize'

	  -- Crete the printing function
  	local function ll(message)
      print(clr.red("[") .. clr.Blue("Test #" .. count) .. clr.red("]") .. "{ ".. message .. " }")
	end

	before_each(function()
		print("")
		count = count + 1
		ll("---> Starting Object Factory test #" .. count)
	end)

	describe("when creating new instances,", function() 
		
		it("should allocate", function()
			local Factory = require("LLBase.ObjectFactory")
			assert.truthy(Factory)

			local newInstance = Factory:new(fakeImg, 100, 200)

			assert.falsy(newInstance)
			-- assert.are.same(newInstance.x, 100)
			-- assert.are.same(newInstance.y, 200)
		end)

		it("should fail for bad parameters", function()
			local Factory = require("LLBase.ObjectFactory")
			assert.truthy(Factory)

			local obj2 = Factory:new(nil, nil, nil)
			assert.falsy(obj2)

			local obj3 = Factory:new(nil, 1, 1)
			assert.falsy(obj3)

			local obj4 = Factory:new(nil, nil, 0)
			assert.falsy(obj4)
		end)
	end)
end)
end)