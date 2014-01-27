-- N-Gram Library
-- From wikipedia:
-- In the fields of computational linguistics and probability,
-- an n-gram is a contiguous sequence of n items from a given
-- sequence of text or speech. The items can be phonemes, syllables,
-- letters, words or base pairs according to the application. The
-- n-grams typically are collected from a text or speech corpus.
--
-- For now this library will only use characters as the gram unit.

-- Load vector space library
os.loadAPI("__LIB__/vectorspace")

local ngram = {}
function ngram:tostring()
   return textutils.serialize(self.data)
end
function ngram.strToVector( str, n )
   -- Default n
   if n == nil then
      n = 3
   end

   -- Table for creating our vector
   local vTable = {}
   -- number of interations on a string l - n + 1
   for i=1, (string.len(str) - n + 1) do
      local key = string.sub(str, i, i+n)
      print('key: '..key)
      if vTable[key] == nil then vTable[key] = 0 end
      vTable[key] = vTable + 1
   end
   return vectorspace.new(vTable)
end

local ngrams = setclass.setclass("ngram",nil,{
	__tostring = ngram.tostring,
})

function ngrams.methods:init(str, n)
   if str == '' then error('string cannot be blank') end
   self.data = ngram.strToVector(str,n)
end

function ngrams.methods:cosSim(other)
   return self.data:dot(other.data) / (self.data:length() * other.data:length())
end

function ngrams.methods:mostSim(tableOfNgrams)
   local highest
   local highestSim = 0
   for k, v in pairs(tableOfNgrams) do
      local sim = self:cosSim(v)
      -- Check if more similar
      if sim > highestSim then
         -- If so set key to highest and the similarity number to the highest sim
         highest = k
         highestSim = sim
      end
   end
   return {hightest = tableOfNgrams[highest]}
end

-- Alias for new function
function new(...)
   return ngrams:new(...)
end
