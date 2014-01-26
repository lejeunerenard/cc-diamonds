os.loadAPI("__LIB__/setclass")

local vmetatable = setclass.setclass("Vector")
function vmetatable.methods:size()
   local count = 0

   for _ in pairs (self.data) do
      count = count + 1;
   end
   return count
end
function vmetatable.methods:add(other)
   -- Error check
   if self:size() ~= other:size() then
      error("Cannot add two vectors of different dimensions.")
   end

   local addedV = {}

   for k, v in pairs(self.data) do
      addedV[k] = self.data[k] + other.data[k];
   end
   return vectorspace.new(addedV)
end
function vmetatable.methods:sub(other)
   -- Error check
   if self:size() ~= other:size() then
      error("Cannot subtract two vectors of different dimensions.")
   end

   local subtractV = {}

   for k, v in pairs(self.data) do
      subtractV[k] = self.data[k] - other.data[k];
   end
   return vectorspace.new(subtractV)
end
function vmetatable.methods:mul(m)
   local mulV = {}

   for k, v in pairs(self.data) do
      mulV[k] = self.data[k] * m;
   end
   return vectorspace.new(mulV)
end
function vmetatable.methods:dot(other)
   -- Error check
   if self:size() ~= other:size() then
      error("Cannot compute the dot product of two vectors of different dimensions.")
   end

   local dotProd = 0

   for k, v in pairs (self.data) do
      dotProd = dotProd + self[k] * other[k];
   end
   return dotProd
end
function vmetatable.methods:length()
   local sqrLength = 0

   for k, v in pairs (self.data) do
      sqrLength = sqrLength + self[k] * self[k];
   end
   return math.sqrt(sqrLength)
end
-- Alias for length function
-- vector:magnitude = vector:length
function vmetatable.methods:normalize()
   return self:mul( 1 / self:length() )
end
function vmetatable.methods:round()
   local roundV = {}

   for k, v in pairs(self.data) do
      roundV[k] = math.floor(self.data[k] + 0.5);
   end
   return vectorspace.new(roundV)
end
function vmetatable.methods:tostring()
   local str = ''

   for k, v in pairs(self.data) do
      str = str .. self.data[k] .. ","
   end
   return string.sub(str, 1, -2)
end
function vmetatable.methods:init(t, ...)
	self.__add = vmetatable.methods.add
	self.__sub = vmetatable.methods.sub
	self.__mul = vmetatable.methods.mul
	self.__unm = function( v ) return v:mul(-1) end
	self.__tostring = vmetatable.methods.tostring
   self.data = {}

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
