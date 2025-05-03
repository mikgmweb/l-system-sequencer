-- currently the program functions as a D0L-system
-- 
-- usage:
-- put in an initial state!
-- ex: AB
-- declare a rule
-- ex: A=BA B=A
-- the program processes and replaces letters as the rules indicate
-- ex: AB --> BAA --> ABABA --> BAABAABA --> ABABAABABAABA --> etc.

-- print("enter rules")
-- rulein = io.read()
-- rules = {}
local midi = require ('LuaMidi')
local Track = midi.Track
local NoteEvent = midi.NoteEvent
local Writer = midi.Writer
local chordb = true

-- get pattern from user
print("enter starting pattern (A-G)")
local patternstart = io.read()
-- get iteration number from user
print("how many iterations?")
local maxiter = tonumber(io.read())
-- get whether the output should be a chord or not, repeat if invalid value
while true do
  print("enter 1 for chord, 0 for sequence")
  local chord = tonumber(io.read())
  if chord == 0 then
    chordb = true
    break
  elseif chord == 1 then
    chordb = false
    break
  else
    print("invalid number!")
  end
end
local patternproc = {}
-- set rules
dofile("config.lua")
-- set output notes here
local notesin = {"A4", "B4", "C5", "D5", "E5", "F5", "G5"}
local rules = {rulea, ruleb, rulec, ruled, rulee, rulef, ruleg}
local iter = 1

--make a string out of a table
function serialize(t)
  local serializedValues = {}
  local value, serializedValue
  --get each item from the input table and put it into a new table
  for i=1,#t do
    value = t[i]
    --detect whether input value can be serialized
    serializedValue = type(value)=='table' and serialize(value) or value
    --add values to new table iteratively
    table.insert(serializedValues, serializedValue)
  end
  --format the final table as a string
  return string.format("%s", table.concat(serializedValues) )
end

--initial
function initialize(s)
  --make input string into a table
  for i = 1, #s do
    patternproc[i] = s:sub(i,i)
  end  
  --replace each item with the appropriate rule
  for k,v in pairs(patternproc) do
    if (v == "A") then
      patternproc[k] = rulea
    elseif (v == "B") then
      patternproc[k] = ruleb
    elseif (v == "C") then
      patternproc[k] = rulec
    elseif (v == "D") then
      patternproc[k] = ruled
    elseif (v == "E") then
      patternproc[k] = rulee
    elseif (v == "F") then
      patternproc[k] = rulef
    elseif (v == "G") then
      patternproc[k] = ruleg
    end
  end
end

--main dealings
function mainLoop(m)
  initialize(patternstart)
  while iter < m do
    initialize(serialize(patternproc))
    iter = iter + 1
  end
end
--do everything the user-defined maximum amount of times
mainLoop(maxiter)
--set the final string to be used in the midi file creation process
finals = serialize(patternproc)

--stage two: midi file creation!

--create a new midi track within the midi file
local track = Track.new("loop")
track:set_text("generated using a D0L-system")

local notes = {}

--add each value as a note to the table notes{}
for i=1, #finals do
  if finals:sub(i,i) == "A" then
    notes[i] = notesin[1]
  elseif finals:sub(i,i) == "B" then
    notes[i] = notesin[2]
  elseif finals:sub(i,i) == "C" then
    notes[i] = notesin[3]
  elseif finals:sub(i,i) == "D" then
    notes[i] = notesin[4]
  elseif finals:sub(i,i) == "E" then
    notes[i] = notesin[5]
  elseif finals:sub(i,i) == "F" then
    notes[i] = notesin[6]
  elseif finals:sub(i,i) == "G" then
    notes[i] = notesin[7]
  end
end

--put all notes into the track
track:add_events(NoteEvent.new({pitch = notes, sequential = chordb}))

--enable the track to be written to a file
local writer = Writer.new(track)
--print what's being output into the midi file
print("output pattern:")
print(finals)
print("rules used:")
for k,v in pairs(rules) do
  print(v)
end
--write the midi file as ./output/gen.mid
writer:save_MIDI(filename, 'output')
--print a success message!
print("\n")
print("successfully output to output/gen.mid")
print("\n")
