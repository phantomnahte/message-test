local EventEmitter = {
	_events = {}
}

function EventEmitter:new()
	local o = {}
	setmetatable(o, self)
	self.__index = self
	return o
end

function EventEmitter:on(evt: string, func)
	if self._events[evt] == nil then
		self._events[evt] = { { func = func, once = false } }
	else
		table.insert(self._events[evt], { func = func, once = false })
	end
end

function EventEmitter:emit(evt: string, ...)
	if self._events[evt] == nil then
		return
	else
		for _,v in pairs(self._events[evt]) do
			v.func(...)
			if v.once then
				self:off(evt, v.func)
			end
		end
	end
end

function EventEmitter:off(evt: string, func)
	if self._events[evt] == nil then return end
	for i,v in pairs(self._events[evt]) do
		if v.func == func then
			table.remove(self._events[evt], i)
		end
	end
end

function EventEmitter:once(evt: string, func)
	self:on(evt, func)
	for k,v in pairs(self._events[evt]) do
		if v.func == func then
			v.once = true
		end
	end
end

EventEmitter.addEventListener = EventEmitter.on
EventEmitter.removeEventListener = EventEmitter.off

return EventEmitter
