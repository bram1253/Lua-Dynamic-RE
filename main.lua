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

local function getService(metatable, service)
	if service == "RunService" then
		return {
			IsStudio = function() return false end,
		}
	end
	
	if service == "HttpService" then
		return {
			GetAsync = function(metatable, url)
				boxedOutput(function()
					warn("ATTEMPTED CALL TO HTTPSERVICE GETASYNC")
					warn(url)
				end)
			end
		}
	end
	
	return debuggerTable(service)
end


local env = getfenv(module)
env.game = setmetatable({
	service = getService,
	GetService = getService,
}, {
	__index = debuggerTable("game")
})

module()
