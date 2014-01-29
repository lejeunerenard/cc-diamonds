-- Load dependencies
os.loadAPI('__LIB__/IdConvApi')
os.loadAPI('__LIB__/ngram')

-- Wrap peripherals
local cb = peripheral.wrap('bottom')
local me = peripheral.wrap('back')
local chestMapping = {}

-- Player mappings
chestMapping['lejeunerenard'] = 0 -- down
local ngramSize = 3

-- Helper functions
function build_ngramMap(converter, ngramSize, inv)
   local ngramMap = {}
   for k, v in pairs(inv) do
      local fullID = converter:getFullID(k)
      local item = converter:getDataFor(fullID.id,fullID.meta)
      ngramMap[k] = ngram.new(item.name, ngramSize)
   end
   return ngramMap
end

function searchInv(inv, searchStr)
   return ngram.new(searchStr):mostSim(inv)
end

-- Initialization
print("Loading item dictionary...")
-- Load converter
local converter = IdConvApi.IdConv.create('__LIB__/ItemDump')

-- Create ngrams for current inventory
local invNgrams = build_ngramMap(converter, ngramSize, me.listAll())
print("Done. Jarvis is ready to serve.")
print("Use your chat to make a request of jarvis")
print("Ex: 'give cobblestone 64'")

while true do
  event, player, message = os.pullEvent("chat")

  _, _, itemStr, amount = string.find(message, "give ([%w:]+) (%d+)")

  if itemStr and amount then

      amount = tonumber(amount)
      if amount > 64 then
         amount = 64
      end

      local direction
      direction = chestMapping[player]

      if not direction then
         cb.tell(player, "No mapping for your chest, contact lejeunerenard")
      else
         local uuid
         -- Test if just ID or should fuzzy search
         if string.match(itemStr,'[%d:]+') then
            _, _, item_id, meta = string.find(itemStr, "(%d+):(%d+)")


            if item_id and meta then
               uuid = converter:getUuid(item_id, meta)
            else
               uuid = tonumber(itemStr)
            end
         else
            -- Get uuid of closest match
            local closest = searchInv(invNgrams,itemStr)
            for k,v in pairs(closest) do
               uuid = k
            end
         end

         print(uuid)

         retrieved_amount = me.retrieve(uuid, amount, direction)
         cb.tell(player, "Sent " .. retrieved_amount .. " of " .. itemStr)
      end
   end
end
