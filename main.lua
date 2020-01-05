-- The ModuleScript needs to return a function, so if it doesn't, wrap it in a function.
local module = require(workspace.ModuleScript)


local function boxedOutput(func)
	print("------------------------")
	func()
	print("------------------------")
end

local function debuggerTable(id)
	return setmetatable({}, {__index = function(metatable, ...)
		boxedOutput(function(...)
			print(id)
			warn(...)
		end)
	end})
end

local function emptyIndex(id)
	return function(metatable, ...)
		local args = {...}
		boxedOutput(function()
			for _, v in pairs(args) do
				warn(id .. " tried to index " .. v)
			end
		end)
	end
end

local function getService(metatable, service)
	if service == "RunService" then
		return setmetatable({
			IsStudio = function() return false end,
		}, {
			__index = emptyIndex("RunService")
		})
	end
	
	if service == "HttpService" then
		return setmetatable({
			GetAsync = function(metatable, url)
				boxedOutput(function()
					warn("ATTEMPTED CALL TO HTTPSERVICE GETASYNC")
					warn(url)
				end)
			end
		}, {
			__index = emptyIndex("HttpService")
		})
	end
	
	return debuggerTable(service)
end


local env = getfenv(module)
env.game = setmetatable({
	service = getService,
	GetService = getService,
}, {
	__index = emptyIndex("game")
})

module()
