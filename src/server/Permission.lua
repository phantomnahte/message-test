local Permission = {}

function Permission:new(id, displayName, color)
    local o = {}
    setmetatable(o, self)
    self.__index = self

    self.id = id
    self.displayName = displayName
    self.color = color or Color3.new(255, 255, 255)

    return o
end

Permission.permissions = {
    Permission:new('user', 'Default'),
    Permission:new('mod', 'Moderator'),
    Permission:new('admin', 'Administrator')
}

return Permission
