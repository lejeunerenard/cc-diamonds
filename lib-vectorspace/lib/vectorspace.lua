os.loadAPI("__LIB__/setclass")

local vector = {}
function vector:add(other)
   -- Error check
   if self:size() ~= other:size() then
      error("Cannot add two vectors of different dimensions.")
   end

   local addedV = {}

   for k, v in pairs(self.data) do
      if other.data[k] == nil then other.data[k] = 0 end
      addedV[k] = self.data[k] + other.data[k];
   end
   return vectorspace.new(addedV)
end
function vector:sub(other)
   -- Error check
   if self:size() ~= other:size() then
      error("Cannot subtract two vectors of different dimensions.")
   end

   local subtractV = {}

   for k, v in pairs(self.data) do
      if other.data[k] == nil then other.data[k] = 0 end
      subtractV[k] = self.data[k] - other.data[k];
   end
   return vectorspace.new(subtractV)
end
function vector:mul(m)
   local mulV = {}

   for k, v in pairs(self.data) do
      mulV[k] = self.data[k] * m;
   end
   return vectorspace.new(mulV)
end
function vector:tostring()
   local str = ''

   for k, v in pairs(self.data) do
      str = str .. self.data[k] .. ","
   end
   return string.sub(str, 1, -2)
end
local vmetatable = setclass.setclass("Vector",nil,{
	__add = vector.add,
	__sub = vector.sub,
	__mul = vector.mul,
	__unm = function( v ) return v:mul(-1) end,
	__tostring = vector.tostring,
})
vmetatable.methods.add = vector.add
vmetatable.methods.sub = vector.sub
vmetatable.methods.mul = vector.mul
vmetatable.methods.tostring = vector.tostring

function vmetatable.methods:init(t, ...)
   self.data = {}
   local v = type(t) == 'table' and t or {t, ...}
   -- Load values in from arguments
   for k, v in pairs(v) do
      self.data[k] = v
   end
end
function vmetatable.methods:size()
   local count = 0

   for _ in pairs (self.data) do
      count = count + 1;
   end
   return count
end
function vmetatable.methods:dot(other)
   -- Error check
   --if self:size() ~= other:size() then
   --   error("Cannot compute the dot product of two vectors of different dimensions.")
   --end

   local dotProd = 0

   for k, v in pairs (self.data) do
      if other.data[k] == nil then other.data[k] = 0 end
      dotProd = dotProd + self.data[k] * other.data[k];
   end
   return dotProd
end
function vmetatable.methods:round()
   local roundV = {}

   for k, v in pairs(self.data) do
      roundV[k] = math.floor(self.data[k] + 0.5);
   end
   return vectorspace.new(roundV)
end
function vmetatable.methods:length()
   local sqrLength = 0

   for k, v in pairs (self.data) do
      sqrLength = sqrLength + self.data[k] * self.data[k];
   end
   return math.sqrt(sqrLength)
end
-- Alias for length function
-- vector:magnitude = vector:length
function vmetatable.methods:normalize()
   return self:mul( 1 / self:length() )
end

-- Alias for new function
function new(t, ...)
   return vmetatable:new(t, ...)
end
