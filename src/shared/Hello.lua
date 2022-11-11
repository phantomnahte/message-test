return function()
	local EventEmitter = require(game.ReplicatedStorage.Common.EventEmitter)
	local evt = EventEmitter:new()
	
	evt:on('hi', function()
		print("Hello, world!")
	end)

	evt:emit('hi')
end
