--------------------------------------------------------------------------------
-- Unit testing functions
--------------------------------------------------------------------------------

function ok( result, msg )
    if msg then
        msg = "ok - " .. msg
    else
        msg = "ok"
    end
    if not result then
        msg = "not " .. msg
    end
    print( msg )
    return result
end

function nok( result, msg )
    return ok( not result, msg )
end

function is( value, expect, msg )
    if not ok( value == expect, msg ) then
        print( "#      got: " .. tostring(value) )
        print( "# expected: " .. tostring(expect) )
    end
end 

function diag( msg )
    print( "# " .. msg )
end

function fit( pattern, str )
    ok( (pattern *-1):match(str), "== '" .. str .. "'" )
end

function nofit( pattern, str )
    nok( (pattern * -1):match(str), "~= '" .. str .. "'" )
end

