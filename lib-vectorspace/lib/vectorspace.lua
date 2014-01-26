-- New Function

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
      table.insert(addedV, self[k] + other[k]);
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
      table.insert(subtractV, self[k] - other[k]);
   end
   return vectorspace.new(subtractV)
end
function vector:mul(m)
   local mulV = {}

   for k, v in pairs(self) do
      table.insert(mulV, self[k] * m);
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
vector:magnitude = vector:length
function vector:normalize()
   return self:mul( 1 / self:length() )
end
function vector:round()
   local roundV = {}

   for k, v in pairs(self) do
      table.insert(roundV, math.floor(self[k] + 0.5));
   end
   return vectorspace.new(roundV)
end
function vector:tostring()
   local str = ''

   for k, v in pairs(self) do
      str = str .. self[k] .. ","
   end
   return string.sub(str, 1, -2)
end

local vmetatable = {
	__index = vector,
	__add = vector.add,
	__sub = vector.sub,
	__mul = vector.mul,
	__unm = function( v ) return v:mul(-1) end,
	__tostring = vector.tostring,
}

function new(t, ...)
   local v = (type(t) == 'table') ? t : {t, ...}
   setmetatable(v, vmetatable)
   return v
end
