PlayerEntity = {};
 PlayerEntity.__index = PlayerEntity;

function PlayerEntity:new(name,...)
   local self = {};
   setmetatable(self, PlayerEntity); -- Set the metatable so we used Character's __index
   self.Name = name
   self.Class = select(1,...)
   self.Dmg = 0
   self.Heal = 0
   self.Kicks = 0
   return self;
end

function PlayerEntity:DAMAGE(a)
  self.Dmg  = self.Dmg + a
end
