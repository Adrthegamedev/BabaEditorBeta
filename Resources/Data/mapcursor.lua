function mapcursor_load()
end

function mapcursor_idle()
end

function mapcursor_move(ox,oy,mdir)
end

function mapcursor_enter(varsunitid)
end

function mapcursor_set(x,y,dir,id)
end

function mapcursor_hardset(lunitid)
end

function mapcursor_levelstart()
end

function mapcursor_displayname()
end

function idleblockcheck()
	local cursors = getunitswitheffect("select",true)
	
	for i,unit in ipairs(cursors) do
		if (unit.values[CURSOR_ONLEVEL] ~= 0) and (unit.values[CURSOR_ONLEVEL] ~= -1) then
			local lunit = mmf.newObject(unit.values[CURSOR_ONLEVEL])
			
			if (string.len(lunit.strings[U_LEVELFILE]) > 0) then
				return true
			end
		end
	end
	
	return false
end

function cursorcheck()
	local result = 0
	
	if (featureindex["select"] ~= nil) then
		local cursors = getunitswitheffect("select",true)
		
		if (#cursors > 0) then
			result = 1
		end
	end
	
	return result
end

function mapcursor_tofront()
end

function hidecursor()
end

function mapcursor_setonlevel(value)
end