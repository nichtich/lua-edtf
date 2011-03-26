--------------------------------------------------------------------------------
-- This file uses the EDTF parser to parse a set of examples.
--------------------------------------------------------------------------------

require 'edtf'

-- DataDumper from http://lua-users.org/wiki/DataDumper
require "dumper"

local T,F = true,false

-- the examples 
-- TODO: move this to a file, one per line
examples = {
-- simple years
"1003",T,
"123",F,
"-0378",T,

-- century
"00",T,
"03",T,
"19",T,

-- year and month
"2011-03",T,
"2011-00",F,

"2003~",T,


-- 330 - Year requiring more than four digits
"1.7e8",T,
"17e7",T,
"y170000000",T,
"-1.7e8",T,
"y-12",T,
"-y12",F,

-- 331 : Season
"2001-21",T,
"2001-23q\"xxx\"",T,
"2001-23q\"\"",T, -- empty qualifier allowed?

-- List of dates
"{2003-07, 03 , 16e2~ }",T,

-- combine some features
"1e3~-21",T,

}

-- parse examples and check result
-- TODO: check the exact structure of the result value
--for str,status in pairs(examples) do
for nr,str in ipairs(examples) do
   if (nr % 2) == 1 then
       local status = examples[nr+1]
       nr = tostring(math.floor(nr/2))
       local parsed = EDTF:match( str )
       local ok = (status and parsed) or (parsed == nil and not status)
       if parsed or not ok then -- only show errors and positive examples
           local result = ok and "" or "! "
           print( nr..": "..result.."'"..str.."'  => "..DataDumper(parsed,'') )
       end
   end
end

