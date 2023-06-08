--note to self: six years of c# does not translate into Lua
ObjectiveTest = CustomItem:extend()
x = 0

--require "optionalPhantoon"

function ObjectiveTest:init(name, code, imagePath, imagePath1, imagePath2, phanTest)
    self:createItem(name)
    self.code = code
    self:setProperty("active", false)
    self.activeImage = ImageReference:FromPackRelativePath(imagePath)
    self.activeImage1 = ImageReference:FromPackRelativePath(imagePath1)
    self.activeImage2 = ImageReference:FromPackRelativePath(imagePath2)
    --self.disabledImage = nil --ImageReference:FromImageReference(self.activeImage, "@disabled")
    self.ItemInstance.PotentialIcon = self.activeImage
    self.phanTest = phanTest

    self:updateIcon()   
end

function ObjectiveTest:setActive(active)
    self:setProperty("active", active)
end

function ObjectiveTest:getActive()
    return self:getProperty("active")
end

function ObjectiveTest:updateIcon()
    --if self:getActive() then
    --    self.ItemInstance.Icon = self.activeImage
    --else
    --    self.ItemInstance.Icon = self.disabledImage
    if x == 0 then
      self.ItemInstance.Icon = self.activeImage
      state = false
      --phanTest:changePhantoon(false)
      --newPhantoon:OptionalPhantoon:updateIcon()
      --Class:CustomItem:OptionalPhantoon:updateIcon()
      --changePhantoon(false)
      --changePhantoon.ChangeVisiblity(false))
      --phanTest:updateIcon()
      --OptionalPhantoon:updateIcon()
      --newPhantoon:OptionalPhantoon:updateIcon()
      --self:updateIcon()
    elseif x == 1 then
      self.ItemInstance.Icon = self.activeImage1
      state = true
      --changePhantoon.ChangeVisiblity(true)
    elseif x == 2 then
      self.ItemInstance.Icon = self.activeImage2
      state = true
      --changePhantoon.ChangeVisiblity(true)
    end
end

function OptionalPhantoon:updateIcon()
    if state == false then
    self.ItemInstance.Icon = nil
    elseif self:getActive() then
        self.ItemInstance.Icon = self.disabledImage
    else
        self.ItemInstance.Icon = self.activeImage
    end
end

function OptionalPhantoon:updateIcon()
    if state == false then
    self.ItemInstance.Icon = nil
    
    elseif self:getActive() then
        self.ItemInstance.Icon = self.disabledImage
    else
        self.ItemInstance.Icon = self.activeImage
    end
end

function ObjectiveTest:onLeftClick()
    --self:setActive(true)
    x = x + 1

    if x == 3 then
        x = 0
    end
    
    self:updateIcon()  --do i need this? surely not. does it work without it? course fucking not
    
end

function ObjectiveTest:onRightClick()
    --self:setActive(false)
    x = x - 1

    if x == -1 then
        x = 2
    end
    
    self:updateIcon()  
end

function ObjectiveTest:canProvideCode(code)
    if code == self.code then
        return true
    else
        return false
    end
end

function ObjectiveTest:providesCode(code)
    if code == self.code and self.getActive() then
        return 1
    end
    return 0
end

function ObjectiveTest:advanceToCode(code)
    if code == nil or code == self.code then
        self:setActive(true)
    end
end

function ObjectiveTest:save()
    local saveData = {}
    saveData["active"] = self.getActive()
    return saveData
end

function ObjectiveTest:Load(data)
    if data["active"] ~= nil then
        self:setActive(data["active"])
    end
    return true
end

function ObjectiveTest:propertyChanged(key, value)
    self:updateIcon()
end