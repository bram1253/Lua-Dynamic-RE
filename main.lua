local module = require(workspace.ModuleScript)

local function debuggerTable(id)
	return setmetatable({}, {__index = function(metatable, ...)
		print("------------------------")
		print(id)
		warn(...)
		print("------------------------")
	end})
end

local function getService(metatable, service)
	if service == "RunService" then
		return debuggerTable("runservice")
	end
end


local env = getfenv(module)
env.game = setmetatable({
	service = getService,
	GetService = getService,
}, {
	__index = warn
})

module()
