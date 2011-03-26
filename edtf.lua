--------------------------------------------------------------------------------
--- Parse Extended Date/Time format in Lua.
--
-- This module is purely experimential for educational purpose.
--------------------------------------------------------------------------------

local lpeg = require "lpeg"

-- use LPeg functions as shortcuts
local P, -- pattern
      R, -- range
      S, -- set
      V, -- value
      C, -- capture
      Cf,
      Cg,
      Ct,
      Cc
          = lpeg.P,lpeg.R,lpeg.S,lpeg.V,
            lpeg.C,lpeg.Cf,lpeg.Cg,lpeg.Ct,lpeg.Cc

--------------------------------------------------------------------------------
--- Some handy functions and tables
--------------------------------------------------------------------------------
local function expand_scientific_notation( value, exponent )
    return tostring( tonumber(value) * 10^tonumber(exponent) )
end

local seasons = {
  ["21"] = "spring",
  ["22"] = "summer",
  ["23"] = "autumn",
  ["24"] = "winter"
}

local function season_name(s)
    return seasons[s]
end

--------------------------------------------------------------------------------
--- Formal grammar of (a subset of) EDTF
--------------------------------------------------------------------------------
EDTF = P {
 "EDTF", -- start rule

  -- '0' to '9'
  digit  = R"09",

  century = Cg( V"digit" * V"digit", "century" ),

  -- '01' to '12'
  month  = Cg( ( ( P"1" * R"02" ) + ( P"0" * R"19" ) ), "month" ),

  -- '-9999' to '9999'
  YYYY = C( P"-"^-1 * V"digit" * V"digit" * V"digit" * V"digit" ),

  -- 'y'...
  longyear1 = P"y" * C( P"-"^-1 * V"digit"^1 ),

  -- scientific notation 
  longyear2 = Cf( C( P"-"^-1 * V"digit"^1 * (P"." * V"digit"^1)^-1 ) * "e" * 
                  C( V"digit"^1  )
              , expand_scientific_notation),

  exactyear  = V"longyear1" + V"longyear2" + V"YYYY",

  year = Cg( V"approxyear" + V"exactyear" , "year" ),

  approxyear = Ct( Cg(V"exactyear","value") * Cg(Cc("approximate"),"status") ) * "~",

  
  -- 331 : season
  season_q = P"q\"" * ( Cg( ( P(1) - P'"' )^0, "season_qualifier" ) ) * P"\"",
  season = Cg( ( P"2" * R"14" ) / season_name , "season" )
           * V"season_q"^-1, 

  year_season =  V"year" * P"-" * V"season",

  year_month =  V"year" * P"-" * V"month",

  -- year | year-month | year-season | month
  basicdate = Ct( V"year_month" + V"year_season" + V"year" + V"century" ),

  ws = P" "^0,
  delim = V"ws" * P"," * V"ws",

  list_of_basicdate = (P"{" * V"ws" * Ct( V"basicdate" * (V"delim" * V"basicdate")^0 ) * V"ws" * P"}"),

  EDTF = (V"list_of_basicdate" + V"basicdate") * -1
}


--------------------------------------------------------------------------------
