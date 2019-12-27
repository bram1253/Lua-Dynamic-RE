local module = require(workspace.ModuleScript)


local function getService(service)
	for i,v in pairs(service) do
		print(i,v)
	end
end


local env = getfenv(module)
env.game = setmetatable({
	service = getService,
	GetService = getService,
}, {
	__index = game
})

module()
