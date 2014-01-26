os.loadAPI("__LIB__/setclass")

local vector = {}
function vector:size()
   local count = 0

   for _ in pairs (self) do
      count = count + 1;
   end
   return count
end
function vector:add(other)
   -- Error check
   if self:size() ~= other:size() then
      error("Cannot add two vectors of different dimensions.")
   end

   local addedV = {}

   for k, v in pairs(self) do
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

   for k, v in pairs(self) do
      subtractV[k] = self.data[k] - other.data[k];
   end
   return vectorspace.new(subtractV)
end
function vector:mul(m)
   local mulV = {}

   for k, v in pairs(self) do
      mulV[k] = self.data[k] * m;
   end
   return vectorspace.new(mulV)
end
function vector:dot(other)
   -- Error check
   if self:size() ~= other:size() then
      error("Cannot compute the dot product of two vectors of different dimensions.")
   end

   local dotProd = 0

   for k, v in pairs (self) do
      dotProd = dotProd + self[k] * other[k];
   end
   return dotProd
end
function vector:length()
   local sqrLength = 0

   for k, v in pairs (self) do
      sqrLength = sqrLength + self[k] * self[k];
   end
   return math.sqrt(sqrLength)
end
-- Alias for length function
-- vector:magnitude = vector:length
function vector:normalize()
   return self:mul( 1 / self:length() )
end
function vector:round()
   local roundV = {}

   for k, v in pairs(self) do
      roundV[k] = math.floor(self.data[k] + 0.5);
   end
   return vectorspace.new(roundV)
end
function vector:tostring()
   local str = ''

   for k, v in pairs(self) do
      str = str .. self.data[k] .. ","
   end
   return string.sub(str, 1, -2)
end

local vmetatable = setclass.setclass("Vector")
function vmetatable.methods:init(t, ...)
	self.__index = vector
	self.__add = vector.add
	self.__sub = vector.sub
	self.__mul = vector.mul
	self.__unm = function( v ) return v:mul(-1) end
	self.__tostring = vector.tostring

   local v = type(t) == 'table' and t or {t, ...}
   -- Load values in from arguments
   for k, v in pairs(v) do
      self.data[k] = v
   end
end

-- Alias for new function
function new(t, ...)
   return vmetatable:new(t, ...)
end
