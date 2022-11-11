local Item = {}

function Item:new(id, displayName, guiAssetID)
    local o = {}
    setmetatable(o, self)
    self.__index = self

    self.id = id
    self.displayName = displayName
    self.guiAssetID = guiAssetID
    
    return o
end

return Item
