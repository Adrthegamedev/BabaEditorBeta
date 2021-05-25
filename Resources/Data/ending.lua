function ending(enddataid)
end

function ending_load(database,name,x,y)
	local data = database[name]
	local unitid = MF_specialcreate("Ending_credits")
	local unit = mmf.newObject(unitid)
	
	unit.x = -96
	unit.y = -96
	
	unit.values[ONLINE] = 1
	unit.values[XPOS] = screenw * 0.5 + x * 96
	unit.values[YPOS] = screenh * 0.5 + y * 96
	unit.direction = data.dir
	unit.strings[2] = name
	
	MF_setcolour(unitid,data.colour[1],data.colour[2])
	
	return unitid
end

function allisdone(enddataid)
end

function dointro(introdataid)
end