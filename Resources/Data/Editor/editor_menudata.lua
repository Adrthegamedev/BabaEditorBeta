menufuncs =
{
	main =
	{
		button = "MainMenuButton",
		enter = 
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = screenh * 0.5 + f_tilesize * 1
				
				local disable = MF_unfinished()
				local build = generaldata.strings[BUILD]
				
				if (build ~= "m") then	
					if (build ~= "promo") then
						createbutton("custom",x,y,2,11,1,langtext("main_custom"),name,3,2,buttonid,disable)
						
						y = y + f_tilesize
						
						createbutton("editor",x,y,2,11,1,langtext("main_editor"),name,3,2,buttonid,disable)
					end
					
					y = y + f_tilesize
					
					createbutton("settings",x,y,2,11,1,langtext("settings"),name,3,2,buttonid)
					
					y = y + f_tilesize
					
					createbutton("credits",x,y,2,11,1,langtext("credits"),name,3,2,buttonid)
					
					if (build ~= "n") and (build ~= "promo") then
						y = y + f_tilesize
						
						createbutton("quit",x,y,2,11,1,langtext("main_exit"),name,3,2,buttonid)
					end
				end
				
				if (generaldata.strings[LANG] ~= "en") then
					local madeby = langtext("intro_madeby")
					
					writetext(madeby,0,screenw * 0.5,screenh - f_tilesize * 0.8,name,true,1)
				end
				
				local version = "version " .. string.lower(MF_getversion())
				
				if (build ~= "m") then
					writetext(version,0,f_tilesize * 0.2,screenh - f_tilesize * 0.4,name,false,1)
				end
			end,
		structure =
		{
			{
				{{"custom"},},
				{{"editor"},},
				{{"settings"},},
				{{"credits"},},
				{{"quit"},},
			},
		}
	},
	pause =
	{
		button = "PauseMenu",
		enter = 
			function(parent,name,buttonid)
				MF_letterclear("editorname")
				editor.values[NAMEFLAG] = 0
				
				local build = generaldata.strings[BUILD]
				
				local x = f_tilesize * 5
				local y = f_tilesize * 2
				
				local mx = screenw * 0.5
				local mult = 1
				local mult_y = 1
				
				if (build == "m") then
					mult = 2
					mult_y = 2.5
				end
				
				local leveltitle = ""
				if (string.len(generaldata.strings[LEVELNUMBER_NAME]) > 0) then
					leveltitle = generaldata.strings[LEVELNUMBER_NAME] .. ": "
				end
				
				if (editor.values[LEVELTYPE] == 1) or (build == "m") then
					leveltitle = ""
				end
				
				displaylevelname(nil,generaldata.strings[CURRLEVEL],2,name,mx,nil,true,leveltitle)
				
				if (build ~= "m") then
					y = y + f_tilesize
				else
					y = y + f_tilesize * 3
				end
				
				createbutton("resume",mx,y,2,10 * mult_y,1 * mult_y,langtext("resume"),name,1,3,buttonid)
				
				local dynamic_structure = {}
				table.insert(dynamic_structure, {{"resume"}})
				
				y = y + f_tilesize * mult_y
				
				local playstatus = editor.values[INEDITOR]
				if (playstatus == 0) then
					local returndisable = false
					if (#leveltree <= 1) then
						returndisable = true
					end
					
					if (generaldata.strings[WORLD] == generaldata.strings[BASEWORLD]) and (generaldata.strings[CURRLEVEL] == "200level") then
						returndisable = false
					end
					
					local customreturn = MF_read("level","general","customreturn")
					if (string.len(customreturn) > 0) and (generaldata.strings[WORLD] ~= generaldata.strings[BASEWORLD]) then
						returndisable = false
					end
					
					if (generaldata.strings[WORLD] ~= generaldata.strings[BASEWORLD]) and (customreturn == "_NONE_") then
						returndisable = true
					end
					
					createbutton("return",mx,y,2,10 * mult_y,1 * mult_y,langtext("pause_returnmap"),name,1,3,buttonid,returndisable)
				elseif (playstatus ~= 3) then
					createbutton("return",mx,y,2,10 * mult_y,1 * mult_y,langtext("pause_returneditor"),name,1,3,buttonid)
				else
					createbutton("return",mx,y,2,10 * mult_y,1 * mult_y,langtext("pause_returnplaylevels"),name,1,3,buttonid)
				end
				
				table.insert(dynamic_structure, {{"return"}})
				
				y = y + f_tilesize * mult_y
				
				createbutton("restart",mx,y,2,10 * mult_y,1 * mult_y,langtext("restart"),name,1,3,buttonid)
				
				table.insert(dynamic_structure, {{"restart"}})
				
				y = y + f_tilesize * mult_y
				
				createbutton("settings",mx,y,2,10 * mult_y,1 * mult_y,langtext("settings"),name,1,3,buttonid)
				
				table.insert(dynamic_structure, {{"settings"}})
				
				if (playstatus ~= 3) then
					y = y + f_tilesize * 1.5 * mult_y
				else
					y = y + f_tilesize * 1 * mult_y
				end
				
				local mainmenudisable = false
				if (editor.values[INEDITOR] > 0) and (editor.values[INEDITOR] < 3) then
					mainmenudisable = true
				end
				
				createbutton("returnmain",mx,y,2,10 * mult_y,1 * mult_y,langtext("pause_returnmain"),name,1,3,buttonid,mainmenudisable)
				
				table.insert(dynamic_structure, {{"returnmain"}})
				
				if (playstatus ~= 3) then
					y = y + f_tilesize * 1.5
				else
					y = y + f_tilesize * 1 * mult_y
					
					local disablereport = true
					if (string.len(generaldata4.strings[LEVEL_DATABASEID]) == 9) and (string.sub(generaldata4.strings[LEVEL_DATABASEID], 5, 5) == "-") then
						disablereport = false
					end
					
					createbutton("report",mx,y,2,10 * mult_y,1 * mult_y,langtext("pause_reportlevel"),name,1,3,buttonid,disablereport)
					
					table.insert(dynamic_structure, {{"report"}})
					
					y = y + f_tilesize * 1
				end
				
				if (build ~= "m") and (generaldata2.values[ENDINGGOING] == 0) then
					writerules(parent,name,mx,y)
				end
				
				buildmenustructure(dynamic_structure)
			end,
	},
	settings =
	{
		button = "SettingsButton",
		enter = 
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = 1.5 * f_tilesize
				
				local disable = MF_unfinished()
				local build = generaldata.strings[BUILD]
				
				local extrasize = 0
				local sliderxoffset = 0
				local slideryoffset = 0
				local delaytext = "settings_repeat"
				
				if (build ~= "m") then
					writetext(langtext("settings") .. ":",0,x,y,name,true,2,true)
					y = y + f_tilesize * 2
				else
					extrasize = f_tilesize * 1.5
					sliderxoffset = 0 - f_tilesize * 4
					slideryoffset = 0 - f_tilesize * 0.6
					delaytext = "settings_repeat_m"
				end
				
				x = screenw * 0.5 - f_tilesize * 1
				
				writetext(langtext("settings_music") .. ":",0,x - f_tilesize * 11.5 + sliderxoffset,y + slideryoffset,name,false,2,true)
				local mvolume = MF_read("settings","settings","music")
				slider("music",x + f_tilesize * 5 + sliderxoffset * 1.5,y + slideryoffset,8,{1,3},{1,4},buttonid,0,100,tonumber(mvolume))
				
				y = y + f_tilesize + extrasize * 0.5
				
				writetext(langtext("settings_sound") .. ":",0,x - f_tilesize * 11.5 + sliderxoffset,y + slideryoffset,name,false,2,true)
				local svolume = MF_read("settings","settings","sound")
				slider("sound",x + f_tilesize * 5 + sliderxoffset * 1.5,y + slideryoffset,8,{1,3},{1,4},buttonid,0,100,tonumber(svolume))
				
				y = y + f_tilesize + extrasize * 0.5
				
				writetext(langtext(delaytext) .. ":",0,x - f_tilesize * 11.5 + sliderxoffset,y + slideryoffset,name,false,2,true)
				local delay = MF_read("settings","settings","delay")
				slider("delay",x + f_tilesize * 5 + sliderxoffset * 1.5,y + slideryoffset,8,{1,3},{1,4},buttonid,7,20,tonumber(delay))
				
				x = screenw * 0.5
				y = y + f_tilesize * 2 + extrasize
				
				local s,c,icon = 0,{0,3},""
				
				if (build ~= "m") then
					createbutton("language",x,y,2,18,1,langtext("settings_language"),name,3,2,buttonid)
				
					y = y + f_tilesize
				end
				
				if (build ~= "n") and (build ~= "m") then
					createbutton("controls",x,y,2,18,1,langtext("controls"),name,3,2,buttonid)
				
					y = y + f_tilesize
				
					local fullscreen = MF_read("settings","settings","fullscreen")
					s,c = gettoggle(fullscreen)
					createbutton("fullscreen",x,y,2,18,1,langtext("settings_fullscreen"),name,3,2,buttonid,nil,s)
					
					y = y + f_tilesize
				end
				
				local grid = MF_read("settings","settings","grid")
				s,c,icon = gettoggle(grid,{"m_settings_grid_no","m_settings_grid"})
				
				if (build ~= "m") then
					createbutton("grid",x,y,2,18,1,langtext("settings_grid"),name,3,2,buttonid,nil,s)
					
					y = y + f_tilesize + extrasize
				else
					y = y - f_tilesize * 0.5
					
					createbutton("grid",x - f_tilesize * 7.5,y,2,4,4,"",name,3,2,buttonid,nil,nil,nil,bicons[icon])
				end
				
				local wobble = MF_read("settings","settings","wobble")
				s,c,icon = gettoggle(wobble,{"m_settings_wobble","m_settings_wobble_no"})
				
				if (build ~= "m") then
					createbutton("wobble",x,y,2,18,1,langtext("settings_wobble"),name,3,2,buttonid,nil,s)
					
					y = y + f_tilesize + extrasize
				else
					createbutton("wobble",x - f_tilesize * 2.5,y,2,4,4,"",name,3,2,buttonid,nil,nil,nil,bicons[icon])
				end
				
				local particles = MF_read("settings","settings","particles")
				s,c,icon = gettoggle(particles,{"m_settings_particles","m_settings_particles_no"})
				
				if (build ~= "m") then
					createbutton("particles",x,y,2,18,1,langtext("settings_particles"),name,3,2,buttonid,nil,s)
					
					y = y + f_tilesize + extrasize
				else
					createbutton("particles",x + f_tilesize * 2.5,y,2,4,4,"",name,3,2,buttonid,nil,nil,nil,bicons[icon])
				end
				
				local shake = MF_read("settings","settings","shake")
				s,c,icon = gettoggle(shake,{"m_settings_shake","m_settings_shake_no"})
				
				if (build ~= "m") then
					createbutton("shake",x,y,2,18,1,langtext("settings_shake"),name,3,2,buttonid,nil,s)
				else
					createbutton("shake",x + f_tilesize * 7.5,y,2,4,4,"",name,3,2,buttonid,nil,nil,nil,bicons[icon])
					
					y = y + f_tilesize
				end
				
				y = y + f_tilesize + extrasize
				
				local contrast = MF_read("settings","settings","contrast")
				s,c = gettoggle(contrast)
				
				if (build ~= "m") then
					createbutton("contrast",x,y,2,18,1,langtext("settings_palette"),name,3,2,buttonid,nil,s)
				else
					createbutton("contrast",x,y,2,32,3,langtext("settings_palette"),name,3,2,buttonid,nil,s)
					
					y = y + f_tilesize
				end
				
				y = y + f_tilesize + extrasize
				
				local blinking = MF_read("settings","settings","blinking")
				s,c = gettoggle(blinking)
				
				if (build ~= "m") then
					createbutton("blinking",x,y,2,18,1,langtext("settings_blinking"),name,3,2,buttonid,nil,s)
				else
					createbutton("blinking",x,y,2,32,3,langtext("settings_blinking"),name,3,2,buttonid,nil,s)
					
					y = y + f_tilesize
				end
				
				y = y + f_tilesize + extrasize
				
				local restartask = MF_read("settings","settings","restartask")
				s,c = gettoggle(restartask)
				
				if (build ~= "m") then
					createbutton("restartask",x,y,2,18,1,langtext("settings_restart"),name,3,2,buttonid,nil,s)
				else
					createbutton("restartask",x,y,2,32,3,langtext("settings_restart"),name,3,2,buttonid,nil,s)
					
					y = y + f_tilesize * 0.5
				end
				
				y = y + f_tilesize + extrasize
				
				--[[
				local zoom = MF_read("settings","settings","zoom")
				s,c = gettoggle(zoom)
				createbutton("zoom",x,y,2,16,1,langtext("settings_zoom"),name,3,2,buttonid,nil,s)
				]]--
				
				if (build ~= "m") then
					writetext(langtext("settings_zoom") .. ":",0,x - f_tilesize * 15.5,y,name,false,2,true)
					
					local zoom = tonumber(MF_read("settings","settings","zoom")) or 0
					createbutton("zoom1",x - f_tilesize * 4.5,y,2,7,1,langtext("zoom1"),name,3,2,buttonid,nil)
					createbutton("zoom2",x + f_tilesize * 3.5,y,2,7,1,langtext("zoom2"),name,3,2,buttonid,nil)
					createbutton("zoom3",x + f_tilesize * 11.5,y,2,7,1,langtext("zoom3"),name,3,2,buttonid,nil)
					
					makeselection({"zoom2","zoom1","zoom3"},tonumber(zoom) + 1)
					
					y = y + f_tilesize
				end
				
				if (build == "n") then
					local disablestick = generaldata5.values[DISABLESTICK] + 1
					createbutton("disable_stick",x,y,2,18,1,langtext("controls_disablestick"),name,3,2,buttonid)
					makeselection({"","disable_stick"},disablestick)
					
					y = y + f_tilesize
				end
				
				if (build ~= "m") then
					createbutton("return",x,y,2,18,1,langtext("return"),name,3,2,buttonid)
				else
					createbutton("return",x,y,2,24,2,langtext("return"),name,3,2,buttonid)
				end
			end,
		structure =
		{
			{
				{{"music",-392},},
				{{"sound",-392},},
				{{"delay",-392},},
				{{"language"},},
				{{"controls"},},
				{{"fullscreen"},},
				{{"grid"},},
				{{"wobble"},},
				{{"particles"},},
				{{"shake"},},
				{{"contrast"},},
				{{"blinking"},},
				{{"restartask"},},
				{{"zoom1"},{"zoom2"},{"zoom3"},},
				{{"return"},},
			},
			n = {
				{{"music",-392},},
				{{"sound",-392},},
				{{"delay",-392},},
				{{"language"},},
				{{"grid"},},
				{{"wobble"},},
				{{"particles"},},
				{{"shake"},},
				{{"contrast"},},
				{{"blinking"},},
				{{"restartask"},},
				{{"zoom1"},{"zoom2"},{"zoom3"},},
				{{"disable_stick"},},
				{{"return"},},
			},
			m = {
				{{"music",-340},},
				{{"sound",-340},},
				{{"delay",-340},},
				{{"grid"},{"wobble"},{"particles"},{"shake"},},
				{{"contrast"},{"blinking"},},
				{{"restartask"},},
				{{"return"},},
			},
		}
	},
	controls =
	{
		button = "ControlsButton",
		enter = 
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = 3 * f_tilesize
				
				writetext(langtext("controls_setup") .. ":",0,x,y,name,true,2,true)
				
				local pad,padname = MF_profilefound()
				local padtext = langtext("controls_noconnectedgamepad")
				
				if (pad ~= nil) then
					if pad then
						padtext = langtext("controls_gamepadname") .. ": " .. string.lower(string.sub(padname, 1, math.min(string.len(padname), 25)))
					else
						padtext = langtext("controls_unknowngamepad")
					end
				end
				
				y = y + f_tilesize * 1
				
				writetext(padtext,0,x,y,name,true,2,true)

				y = y + f_tilesize * 2
				
				createbutton("detect",x,y,2,16,1,langtext("controls_detectgamepad"),name,3,2,buttonid)
				
				y = y + f_tilesize * 2
				
				createbutton("gamepad",x,y,2,16,1,langtext("controls_gamepadsetup"),name,3,2,buttonid)
				
				y = y + f_tilesize
				
				createbutton("default_gamepad",x,y,2,16,1,langtext("controls_defaultgamepad"),name,3,2,buttonid)
				
				y = y + f_tilesize
				
				local disablegamepad = generaldata4.values[DISABLEGAMEPAD] + 1
				local disablegamepad_opts = {"controls_disablegamepad_off","controls_disablegamepad_on"}
				createbutton("disable_gamepad",x,y,2,16,1,"",name,3,2,buttonid,nil,nil,nil,bicons[disablegamepad_opts[disablegamepad]])
				
				y = y + f_tilesize * 1.5
				
				createbutton("keyboard",x,y,2,16,1,langtext("controls_keysetup"),name,3,2,buttonid)
				
				y = y + f_tilesize
				
				createbutton("default_keyboard",x,y,2,16,1,langtext("controls_defaultkey"),name,3,2,buttonid)

				y = y + f_tilesize * 2
				
				createbutton("return",x,y,2,16,1,langtext("return"),name,3,2,buttonid)
			end,
		structure =
		{
			{
				{{"detect"},},
				{{"gamepad"},},
				{{"default_gamepad"},},
				{{"disable_gamepad"},},
				{{"keyboard"},},
				{{"default_keyboard"},},
				{{"return"},},
			},
		}
	},
	gamepad =
	{
		button = "KeyConfigButton",
		enter = 
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = 3 * f_tilesize
				
				createbutton("return",x,y,2,16,1,langtext("return"),name,3,2,buttonid)

				x = x + f_tilesize * 1.5
				y = y + f_tilesize * 2
				
				createbutton("move",x - f_tilesize * 8,y,2,6,1,langtext("move"),name,3,2,buttonid)
				createcontrolicon("move",true,x - f_tilesize * 3.5,y,buttonid)
				
				createbutton("move2",x + f_tilesize * 3,y,2,6,1,langtext("move") .. " 2",name,3,2,buttonid)
				createcontrolicon("move2",true,x + f_tilesize * 7.5,y,buttonid)
				
				y = y + f_tilesize * 1.4
				
				createbutton("idle",x - f_tilesize * 8,y,2,6,1,langtext("idle"),name,3,2,buttonid)
				createcontrolicon("idle",true,x - f_tilesize * 3.5,y,buttonid)
				
				createbutton("idle2",x + f_tilesize * 3,y,2,6,1,langtext("idle") .. " 2",name,3,2,buttonid)
				createcontrolicon("idle2",true,x + f_tilesize * 7.5,y,buttonid)
				
				y = y + f_tilesize * 1.4
				
				createbutton("undo",x - f_tilesize * 8,y,2,6,1,langtext("undo"),name,3,2,buttonid)
				createcontrolicon("undo",true,x - f_tilesize * 3.5,y,buttonid)
				
				createbutton("undo2",x + f_tilesize * 3,y,2,6,1,langtext("undo") .. " 2",name,3,2,buttonid)
				createcontrolicon("undo2",true,x + f_tilesize * 7.5,y,buttonid)
				
				y = y + f_tilesize * 1.4
				
				createbutton("restart",x - f_tilesize * 8,y,2,6,1,langtext("controls_restart"),name,3,2,buttonid)
				createcontrolicon("restart",true,x - f_tilesize * 3.5,y,buttonid)
				
				createbutton("restart2",x + f_tilesize * 3,y,2,6,1,langtext("controls_restart") .. " 2",name,3,2,buttonid)
				createcontrolicon("restart2",true,x + f_tilesize * 7.5,y,buttonid)
				
				y = y + f_tilesize * 1.4
				
				createbutton("confirm",x - f_tilesize * 8,y,2,6,1,langtext("confirm"),name,3,2,buttonid)
				createcontrolicon("confirm",true,x - f_tilesize * 3.5,y,buttonid)
				
				createbutton("confirm2",x + f_tilesize * 3,y,2,6,1,langtext("confirm") .. " 2",name,3,2,buttonid)
				createcontrolicon("confirm2",true,x + f_tilesize * 7.5,y,buttonid)
				
				y = y + f_tilesize * 1.4
				
				createbutton("pause",x - f_tilesize * 3,y,2,8,1,langtext("pause"),name,3,2,buttonid)
				createcontrolicon("pause",true,x + f_tilesize * 3.5,y,buttonid)
			end,
		structure =
		{
			{
				{{"return"},},
				{{"move"},{"move2"}},
				{{"idle"},{"idle2"}},
				{{"undo"},{"undo2"}},
				{{"restart"},{"restart2"}},
				{{"confirm"},{"confirm2"}},
				{{"pause"},},
			},
		}
	},
	keyboard =
	{
		button = "KeyConfigButton",
		enter = 
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = 3 * f_tilesize
				
				createbutton("return",x,y,2,16,1,langtext("return"),name,3,2,buttonid)

				y = y + f_tilesize * 2
				
				createbutton("right",x - f_tilesize * 7,y,2,6,1,langtext("right"),name,3,2,buttonid)
				createcontrolicon("right",false,x - f_tilesize * 2.5,y,buttonid)
				
				createbutton("right2",x + f_tilesize * 4,y,2,6,1,langtext("right") .. " 2",name,3,2,buttonid)
				createcontrolicon("right2",false,x + f_tilesize * 8.5,y,buttonid)
				
				y = y + f_tilesize
				
				createbutton("up",x - f_tilesize * 7,y,2,6,1,langtext("up"),name,3,2,buttonid)
				createcontrolicon("up",false,x - f_tilesize * 2.5,y,buttonid)
				
				createbutton("up2",x + f_tilesize * 4,y,2,6,1,langtext("up") .. " 2",name,3,2,buttonid)
				createcontrolicon("up2",false,x + f_tilesize * 8.5,y,buttonid)
				
				y = y + f_tilesize
				
				createbutton("left",x - f_tilesize * 7,y,2,6,1,langtext("left"),name,3,2,buttonid)
				createcontrolicon("left",false,x - f_tilesize * 2.5,y,buttonid)
				
				createbutton("left2",x + f_tilesize * 4,y,2,6,1,langtext("left") .. " 2",name,3,2,buttonid)
				createcontrolicon("left2",false,x + f_tilesize * 8.5,y,buttonid)
				
				y = y + f_tilesize
				
				createbutton("down",x - f_tilesize * 7,y,2,6,1,langtext("down"),name,3,2,buttonid)
				createcontrolicon("down",false,x - f_tilesize * 2.5,y,buttonid)
				
				createbutton("down2",x + f_tilesize * 4,y,2,6,1,langtext("down") .. " 2",name,3,2,buttonid)
				createcontrolicon("down2",false,x + f_tilesize * 8.5,y,buttonid)
				
				y = y + f_tilesize * 1.2
				
				createbutton("idle",x - f_tilesize * 7,y,2,6,1,langtext("idle"),name,3,2,buttonid)
				createcontrolicon("idle",false,x - f_tilesize * 2.5,y,buttonid)
				
				createbutton("idle2",x + f_tilesize * 4,y,2,6,1,langtext("idle") .. " 2",name,3,2,buttonid)
				createcontrolicon("idle2",false,x + f_tilesize * 8.5,y,buttonid)
				
				y = y + f_tilesize
				
				createbutton("undo",x - f_tilesize * 7,y,2,6,1,langtext("undo"),name,3,2,buttonid)
				createcontrolicon("undo",false,x - f_tilesize * 2.5,y,buttonid)
				
				createbutton("undo2",x + f_tilesize * 4,y,2,6,1,langtext("undo") .. " 2",name,3,2,buttonid)
				createcontrolicon("undo2",false,x + f_tilesize * 8.5,y,buttonid)
				
				y = y + f_tilesize
				
				createbutton("restart",x - f_tilesize * 7,y,2,6,1,langtext("controls_restart"),name,3,2,buttonid)
				createcontrolicon("restart",false,x - f_tilesize * 2.5,y,buttonid)
				
				createbutton("restart2",x + f_tilesize * 4,y,2,6,1,langtext("controls_restart") .. " 2",name,3,2,buttonid)
				createcontrolicon("restart2",false,x + f_tilesize * 8.5,y,buttonid)
				
				y = y + f_tilesize
				
				createbutton("confirm",x - f_tilesize * 7,y,2,6,1,langtext("confirm"),name,3,2,buttonid)
				createcontrolicon("confirm",false,x - f_tilesize * 2.5,y,buttonid)
				
				createbutton("confirm2",x + f_tilesize * 4,y,2,6,1,langtext("confirm") .. " 2",name,3,2,buttonid)
				createcontrolicon("confirm2",false,x + f_tilesize * 8.5,y,buttonid)
				
				y = y + f_tilesize * 1.2
				
				createbutton("pause",x - f_tilesize * 3,y,2,8,1,langtext("pause"),name,3,2,buttonid)
				createcontrolicon("pause",false,x + f_tilesize * 3.5,y,buttonid)
			end,
		structure =
		{
			{
				{{"return"},},
				{{"right"},{"right2"}},
				{{"up"},{"up2"}},
				{{"left"},{"left2"}},
				{{"down"},{"down2"}},
				{{"move"},{"move2"}},
				{{"idle"},{"idle2"}},
				{{"undo"},{"undo2"}},
				{{"restart"},{"restart2"}},
				{{"confirm"},{"confirm2"}},
				{{"pause"},},
			},
		}
	},
	change_keyboard =
	{
		button = "Change",
		enter =
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = screenh * 0.5
				writetext(langtext("controls_pressany"),0,x,y,name,true,2,true)
			end,
	},
	change_gamepad =
	{
		button = "Change",
		enter =
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = screenh * 0.5
				writetext(langtext("controls_pressany"),0,x,y,name,true,2,true)
			end,
	},
	editor_start =
	{
		button = "EditLevels",
		escbutton = "return",
		enter = 
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = screenh * 0.5 - f_tilesize * 7
				
				writetext(langtext("editor_start_title"),0,x,y,name,true,1)
				
				y = y + f_tilesize * 3
				
				local enableworlds = true
				local build = generaldata.strings[BUILD]
				
				local enableworlds_ = tonumber(MF_read("settings","editor","mode")) or 0
				if (enableworlds_ == 1) then
					enableworlds = false
				end
				
				createbutton("editor_start_level",x,y,2,16,2,langtext("editor_start_level"),name,3,2,buttonid)
				
				y = y + f_tilesize * 2
				
				createbutton("customlevels_play_get",x,y,2,16,2,langtext("customlevels_play_get"),name,3,2,buttonid)
				
				y = y + f_tilesize * 2
				
				createbutton("editor_start_getlist",x,y,2,16,2,langtext("customlevels_play_getlist"),name,3,2,buttonid)
				
				y = y + f_tilesize * 2
				
				createbutton("editor_start_settings",x,y,2,16,2,langtext("editor_start_settings"),name,3,2,buttonid)
				
				y = y + f_tilesize * 2
				
				createbutton("return",x,y,2,16,1,langtext("return"),name,3,1,buttonid)
				
				setundo_editor()
			end,
		structure =
		{
			{
				{{"editor_start_level"},},
				{{"customlevels_play_get"},},
				{{"editor_start_getlist"},},
				{{"editor_start_settings"},},
				{{"return"},},
			},
			n = {
				{{"editor_start_level"},},
				{{"customlevels_play_get"},},
				{{"editor_start_getlist"},},
				{{"editor_start_settings"},},
				{{"return"},},
			},
			m = {
				{{"editor_start_level"},},
				{{"customlevels_play_get"},},
				{{"editor_start_getlist"},},
				{{"editor_start_settings"},},
				{{"return"},},
			},
		}
	},
	editor_start_settings =
	{
		button = "EditLevelsSettings",
		escbutton = "return",
		slide = {1,0},
		slide_leave = {-1,0},
		enter = 
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = screenh * 0.5 - f_tilesize * 7
				
				createbutton("return",x,y,2,16,1,langtext("return"),name,3,1,buttonid)
				
				y = y + f_tilesize * 3
				
				local build = generaldata.strings[BUILD]
				
				createbutton("editor_settings_help",x,y,2,16,1,langtext("editor_settings_help"),name,3,2,buttonid)
				
				y = y + f_tilesize * 1.5
				
				local tiptext = "editor_settings_tips"
				if (build == "n") then
					tiptext = "editor_settings_tips_n"
				end
				
				createbutton("editor_settings_tips",x,y,2,16,1,langtext(tiptext),name,3,2,buttonid)
				
				makeselection({"","editor_settings_tips"},editor4.values[EDITOR_DISABLETIPS] + 1)
				
				y = y + f_tilesize * 1.5
				
				createbutton("editor_settings_slide",x,y,2,16,1,langtext("editor_settings_slide"),name,3,2,buttonid)
				
				makeselection({"","editor_settings_slide"},editor4.values[EDITOR_DISABLESLIDE] + 1)
				
				y = y + f_tilesize * 1.5
				
				createbutton("editor_settings_music",x,y,2,16,1,langtext("editor_settings_music"),name,3,2,buttonid)
				
				makeselection({"","editor_settings_music"},generaldata5.values[EDITOR_MUSICTYPE] + 1)
				
				y = y + f_tilesize * 1.5
				
				createbutton("editor_settings_advanced",x,y,2,16,1,langtext("editor_settings_advanced"),name,3,2,buttonid)
				
				makeselection({"","editor_settings_advanced"},editor2.values[ADVANCEDWORDS] + 1)
			end,
		structure =
		{
			{
				{{"return"},},
				{{"editor_settings_help"},},
				{{"editor_settings_tips"},},
				{{"editor_settings_slide"},},
				{{"editor_settings_music"},},
				{{"editor_settings_advanced"},},
			},
			n = {
				{{"return"},},
				{{"editor_settings_help"},},
				{{"editor_settings_tips"},},
				{{"editor_settings_slide"},},
				{{"editor_settings_music"},},
				{{"editor_settings_advanced"},},
			},
			m = {
				{{"return"},},
				{{"editor_settings_tips"},},
				{{"editor_settings_slide"},},
				{{"editor_settings_music"},},
				{{"editor_settings_advanced"},},
			},
		}
	},
	editor_start_settings_help =
	{
		button = "EditLevelsSettingsHelp",
		escbutton = "return",
		slide = {1,0},
		slide_leave = {-1,0},
		enter = 
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = screenh * 0.5 - f_tilesize * 6
				
				createbutton("return",x,y,2,16,1,langtext("return"),name,3,1,buttonid)
				
				y = y + f_tilesize * 3
				
				createbutton("editor_settings_hotkeys",x,y,2,16,1,langtext("editor_settings_hotkeys"),name,3,2,buttonid)
				
				y = y + f_tilesize * 1.5
				
				createbutton("editor_tutorial1",x,y,2,16,1,langtext("editor_tutorial1"),name,3,2,buttonid)
				
				y = y + f_tilesize * 1
				
				createbutton("editor_tutorial2",x,y,2,16,1,langtext("editor_tutorial2"),name,3,2,buttonid)
				
				y = y + f_tilesize * 1
				
				createbutton("editor_tutorial3",x,y,2,16,1,langtext("editor_tutorial3"),name,3,2,buttonid)
				
				y = y + f_tilesize * 1
				
				createbutton("editor_tutorial4",x,y,2,16,1,langtext("editor_tutorial4"),name,3,2,buttonid)
				
				y = y + f_tilesize * 1
				
				createbutton("editor_tutorial5",x,y,2,16,1,langtext("editor_tutorial5"),name,3,2,buttonid)
				
				y = y + f_tilesize * 1
				
				createbutton("editor_tutorial6",x,y,2,16,1,langtext("editor_tutorial6"),name,3,2,buttonid)
				
				y = y + f_tilesize * 1
				
				createbutton("editor_tutorial7",x,y,2,16,1,langtext("editor_tutorial7"),name,3,2,buttonid)
				
				y = y + f_tilesize * 1
				
				createbutton("editor_tutorial8",x,y,2,16,1,langtext("editor_tutorial8"),name,3,2,buttonid)
				
				y = y + f_tilesize * 1
				
				createbutton("editor_tutorial9",x,y,2,16,1,langtext("editor_tutorial9"),name,3,2,buttonid)
			end,
		structure =
		{
			{
				{{"return"},},
				{{"editor_settings_hotkeys"},},
				{{"editor_tutorial1"},},
				{{"editor_tutorial2"},},
				{{"editor_tutorial3"},},
				{{"editor_tutorial4"},},
				{{"editor_tutorial5"},},
				{{"editor_tutorial6"},},
				{{"editor_tutorial7"},},
				{{"editor_tutorial8"},},
				{{"editor_tutorial9"},},
			},
		}
	},
	editor_hotkeys =
	{
		button = "EditLevelsHotkeys",
		escbutton = "return",
		slide_leave = {-1,0},
		enter = 
			function(parent,name,buttonid,extra)
				local x = screenw * 0.5
				local y = screenh * 0.5 - f_tilesize * 9.5
				
				MF_clearcontrolicons(0)
				
				local page = editor3.values[PAGEMENU]
				local build = generaldata.strings[BUILD]
				
				local x_ = 0
				local y_ = 0
				local hotkeylist = 
				{
					keyboard =
					{
						{
						"hotkeys_editor_rotate",
						"hotkeys_editor_copy",
						"hotkeys_editor_cut",
						"hotkeys_editor_swap",
						"hotkeys_editor_drag",
						"hotkeys_editor_cleartile",
						"hotkeys_editor_changetool",
						"hotkeys_editor_changelayer",
						"hotkeys_editor_quickbar_scroll",
						"hotkeys_editor_quickbar_lock",
						"hotkeys_editor_quickbar_reset",
						"hotkeys_editor_pickis",
						"hotkeys_editor_pickand",
						"hotkeys_editor_picknot",
						"hotkeys_editor_pickempty",
						"hotkeys_editor_massdir",
						"hotkeys_editor_moveall",
						"hotkeys_editor_rotateselection",
						"hotkeys_editor_flipselection",
						"hotkeys_editor_altselection",
						"hotkeys_editor_opencurrobjlist",
						"hotkeys_editor_openeditormenu",
						"hotkeys_editor_openeditorsettingsmenu",
						"hotkeys_editor_testlevel",
						"hotkeys_editor_windowsize",
						"hotkeys_editor_undo",
						"hotkeys_editor_save",
						"hotkeys_editor_deleteall",
						"hotkeys_editor_addobject",
						"hotkeys_editor_return",
						"hotkeys_editor_restart",
						"hotkeys_editor_autopick",
						},
						{
						"hotkeys_currobjlist_swap",
						"hotkeys_currobjlist_drag",
						"hotkeys_currobjlist_leave",
						"hotkeys_currobjlist_edit",
						"hotkeys_currobjlist_remove",
						"hotkeys_currobjlist_search",
						"hotkeys_currobjlist_autoadd",
						"hotkeys_objlist_quickadd",
						},
						{
						"hotkeys_levellist_search",
						"hotkeys_levellist_leave",
						"hotkeys_levellist_delete",
						},
					},
					gamepad =
					{
						{
						"hotkeys_editor_gpad_rotate",
						"hotkeys_editor_gpad_copy",
						"hotkeys_editor_gpad_undo",
						"hotkeys_editor_gpad_drag",
						"hotkeys_editor_gpad_openquickmenu",
						"hotkeys_editor_gpad_opencurrobjlist",
						"hotkeys_editor_gpad_changetool",
						"hotkeys_editor_gpad_changelayer",
						"hotkeys_editor_gpad_moveall",
						"hotkeys_editor_gpad_quickbar_scroll",
						"hotkeys_editor_gpad_quickbar_lock",
						"hotkeys_editor_gpad_quickbar_empty",
						"hotkeys_editor_gpad_cut",
						"hotkeys_editor_gpad_swap",
						"hotkeys_editor_gpad_emptytile",
						"hotkeys_editor_gpad_massdir",
						"hotkeys_editor_gpad_altmove",
						"hotkeys_editor_gpad_save",
						"hotkeys_editor_gpad_test",
						"hotkeys_editor_gpad_pickempty",
						"hotkeys_editor_gpad_autopick",
						"hotkeys_editor_gpad_rotateselection",
						"hotkeys_editor_gpad_flipselection",
						"hotkeys_editor_gpad_altselection",
						},
						{
						"hotkeys_currobjlist_gpad_swap",
						"hotkeys_currobjlist_gpad_drag",
						"hotkeys_currobjlist_gpad_leave",
						"hotkeys_currobjlist_gpad_edit",
						"hotkeys_currobjlist_gpad_add",
						"hotkeys_currobjlist_gpad_remove",
						"hotkeys_currobjlist_gpad_search",
						"hotkeys_currobjlist_gpad_removesearch",
						"hotkeys_currobjlist_gpad_removesearch_alt",
						"hotkeys_currobjlist_gpad_autoadd",
						"hotkeys_objlist_gpad_quickadd",
						},
						{
						"hotkeys_levellist_gpad_delete",
						"hotkeys_currobjlist_gpad_removesearch_alt",
						},
					},
				}
				
				local list = extra
				local choice = 1
				if (string.len(list) == 0) then
					local gpad = MF_profilefound()
					
					if (gpad ~= nil) then
						list = "gamepad"
					else
						list = "keyboard"
					end
				end
				
				if (build == "n") then
					list = "gamepad"
				end
				
				if (list == "keyboard") then
					choice = 1
				elseif (list == "gamepad") then
					choice = 2
				end
				
				if (editor2.values[EXTENDEDMODE] == 1) and (build ~= "n") and (build ~= "m") then
					if (page == 0) then
						table.insert(hotkeylist["keyboard"][1], "hotkeys_editor_editlevel")
						table.insert(hotkeylist["keyboard"][1], "hotkeys_editor_quickaddlevel")
						table.insert(hotkeylist["keyboard"][1], "hotkeys_editor_resetmapicon")
					end
				end
				
				x = x - f_tilesize * 17
				
				local db = hotkeylist[list][page + 1]
				local limit = 19
				local ymult = 0.9
				
				if (list == "gamepad") then
					y = y + f_tilesize * 0.4
					limit = 12
					ymult = 1.45
				end
				
				if (#db > 0) then
					for i=1,#db do
						writetext(langtext(db[i],true),0,x + x_ * 19 * f_tilesize,y + y_ * f_tilesize * ymult,name,false,1,nil,nil,nil,nil,true)
						
						y_ = y_ + 1
						
						if (y_ >= limit) then
							y_ = 0
							x_ = x_ + 1
						end
					end
				end
				
				x = screenw * 0.5
				y = screenh - f_tilesize * 2
				
				createbutton("editor",x - f_tilesize * 12,y,2,9,1,langtext("hotkeys_editor_category_editor"),name,3,2,buttonid)
				createbutton("currobjlist",x,y,2,12,1,langtext("hotkeys_editor_category_currobjlist"),name,3,2,buttonid)
				createbutton("levellist",x + f_tilesize * 12,y,2,9,1,langtext("hotkeys_editor_category_levellist"),name,3,2,buttonid)
				
				makeselection({"editor","currobjlist","levellist"},page + 1)
				
				y = y + f_tilesize * 1
				
				createbutton("return",x,y,2,12,1,langtext("return"),name,3,1,buttonid)
				
				if (build ~= "n") and (build ~= "m") then
					createbutton("keyboard",x - f_tilesize * 12,y,2,9,1,langtext("hotkeys_editor_keyboard"),name,3,2,buttonid)
					createbutton("gamepad",x + f_tilesize * 12,y,2,9,1,langtext("hotkeys_editor_gamepad"),name,3,2,buttonid)
					makeselection({"keyboard","gamepad"},choice)
				end
			end,
		structure =
		{
			{
				{{"editor"},{"currobjlist"},{"levellist"},},
				{{"keyboard"},{"return"},{"gamepad"},defaultx = 1},
			},
			n = {
				{{"editor"},{"currobjlist"},{"levellist"},},
				{{"return"}},
			},
		}
	},
	world =
	{
		button = "WorldChoice",
		escbutton = "return",
		enter = 
			function(parent,name,buttonid,extra)
			end,
	},
	level =
	{
		button = "LevelButton",
		escbutton = "return",
		enter = 
			function(parent,name,buttonid,extra)
				local x = screenw * 0.5
				local y = f_tilesize * 0.5
				
				if (generaldata.strings[WORLD] ~= "levels") then
					local worldname = MF_read("world","general","name")
					local worldauthor = editor2.strings[WORLDAUTHOR]
					MF_clearborders()
					
					local authorname = worldauthor
					
					if (string.len(worldauthor) == 0) then
						authorname = langtext("noauthor")
					end
					
					writetext(worldname .. " " .. langtext("by") .. " " .. authorname,0,x,y,name,true,2,nil,nil,nil,nil,nil,true)
				else
					writetext(langtext("editor_levellist_levels"),0,x,y,name,true,2,nil,nil,nil,nil,nil,true)
				end
				
				y = y + f_tilesize
				
				--writetext(langtext("editor_levellist_edit") .. ":",0,x,y,name,true,2)
				
				y = y + f_tilesize
				
				local dynamic_structure = {}
				
				local page = extra or 0
				page = MF_setpagemenu(name)
				local search = editor2.strings[SEARCHSTRING]
				local levels,maxpage,menustruct,page = createlevellist(buttonid,page,search)
				
				local disableaddlevels = false
				if (generaldata.strings[BUILD] == "n") and (levels >= 100) then
					disableaddlevels = true
				end
				
				local returntext = langtext("editor_levellist_return")
				if (generaldata.strings[WORLD] ~= "levels") then
					returntext = langtext("editor_levellist_returnworld")
				end
				
				createbutton("return",x,y,2,0,1,returntext,name,3,1,buttonid,nil,nil,nil,nil,nil,nil,10)
				
				table.insert(dynamic_structure, {{"return"}})
				
				if (generaldata.strings[WORLD] ~= "levels") then
					local y_ = y + f_tilesize
					
					if (generaldata.strings[WORLD] ~= "baba_editor") and (generaldata.strings[WORLD] ~= "baba") then
						createbutton("setstart",x + f_tilesize * 4.5,y_,2,8,1,langtext("editor_levellist_setstart"),name,3,2,buttonid)
						createbutton("setauthor",x - f_tilesize * 13.5,y_,2,8,1,langtext("editor_levellist_setauthor"),name,3,2,buttonid)
						createbutton("setname",x - f_tilesize * 4.5,y_,2,8,1,langtext("editor_levellist_setname"),name,3,2,buttonid)
						createbutton("setmap",x + f_tilesize * 13.5,y_,2,8,1,langtext("editor_levellist_setmap"),name,3,2,buttonid)
						
						table.insert(dynamic_structure, {{"setauthor","longcursor"},{"setname","longcursor"},{"setstart","longcursor"},{"setmap","longcursor"}})
					end
				end
				
				y = y + f_tilesize * 2
				
				createbutton("newlevel",x,y,2,10,1,langtext("editor_levellist_new"),name,3,2,buttonid,disableaddlevels)
				createbutton("sort",x - f_tilesize * 11,y,2,10,1,langtext("editor_levellist_sort"),name,3,2,buttonid)
				
				if (generaldata.strings[WORLD] ~= "levels") then
					createbutton("sorttypes",x + f_tilesize * 11,y,2,10,1,langtext("editor_levellist_sorttypes"),name,3,2,buttonid)
					makeselection({"","sorttypes"},editor2.values[SORTING_TYPES] + 1)
				
					table.insert(dynamic_structure, {{"sort"},{"newlevel"},{"sorttypes"},defaultx = 1})
				else
					table.insert(dynamic_structure, {{"sort"},{"newlevel"},defaultx = 1})
				end
				
				makeselection({"","sort"},editor2.values[SORTING] + 1)
				
				--MF_alert(tostring(extra))
				
				for a,b in ipairs(menustruct) do
					table.insert(dynamic_structure, b)
				end
				
				editor3.values[MAXPAGE] = maxpage
				
				local cannot_scroll_left = true
				local cannot_scroll_left2 = true
				local cannot_scroll_right = true
				local cannot_scroll_right2 = true
				
				if (page > 0) then
					cannot_scroll_left = false
				end
				
				if (page > 4) then
					cannot_scroll_left2 = false
				end
				
				if (page < maxpage) then
					cannot_scroll_right = false
				end
				
				if (page < maxpage - 4) then
					cannot_scroll_right2 = false
				end
				
				local dynamic_structure_row = {{"search"}}
				
				if (maxpage > 0) then
					createbutton("scroll_left",screenw * 0.5 - f_tilesize * 4,screenh - f_tilesize * 2,2,2,2,"",name,3,2,buttonid,cannot_scroll_left,nil,nil,bicons.l_arrow)
					createbutton("scroll_left2",screenw * 0.5 - f_tilesize * 7,screenh - f_tilesize * 2,2,2,2,"",name,3,2,buttonid,cannot_scroll_left,nil,nil,bicons.dl_arrow)
					createbutton("scroll_right",screenw * 0.5 + f_tilesize * 4,screenh - f_tilesize * 2,2,2,2,"",name,3,2,buttonid,cannot_scroll_right,nil,nil,bicons.r_arrow)
					createbutton("scroll_right2",screenw * 0.5 + f_tilesize * 7,screenh - f_tilesize * 2,2,2,2,"",name,3,2,buttonid,cannot_scroll_right,nil,nil,bicons.dr_arrow)
				
					writetext(langtext("editor_levellist_page") .. ": " .. tostring(page + 1) .. "/" .. tostring(maxpage + 1),0,screenw * 0.5,screenh - f_tilesize * 2,name,true,2)
					
					table.insert(dynamic_structure_row, {"scroll_left2"})
					table.insert(dynamic_structure_row, {"scroll_left"})
					table.insert(dynamic_structure_row, {"scroll_right"})
					table.insert(dynamic_structure_row, {"scroll_right2"})
				end
				
				table.insert(dynamic_structure_row, {"removesearch"})
				table.insert(dynamic_structure, dynamic_structure_row)
				
				createbutton("search",screenw * 0.5 - f_tilesize * 13,screenh - f_tilesize * 2,2,8,1,langtext("editor_levellist_search"),name,3,2,buttonid)
				
				local disableremovesearch = true
				if (string.len(editor2.strings[SEARCHSTRING]) > 0) then
					disableremovesearch = false
				end
				
				createbutton("removesearch",screenw * 0.5 + f_tilesize * 13,screenh - f_tilesize * 2,2,8,1,langtext("editor_levellist_removesearch"),name,3,2,buttonid,disableremovesearch)
				
				MF_visible("LevelButton",1)
				
				makeselection({"","setstart","setmap"}, editor.values[STATE] + 1)
				
				local mypos = editor2.values[MENU_YPOS]
				local mxdim = #dynamic_structure[#dynamic_structure]
				
				if (mypos > 0) and (mypos < #dynamic_structure - 1) then
					editor2.values[MENU_XPOS] = math.min(editor2.values[MENU_XPOS], mxdim - 1)
					editor2.values[MENU_YPOS] = #dynamic_structure - 1
				elseif (mypos > 0) and (mypos >= #dynamic_structure - 1) then
					editor2.values[MENU_XPOS] = math.min(editor2.values[MENU_XPOS], mxdim - 1)
					editor2.values[MENU_YPOS] = math.min(editor2.values[MENU_YPOS], #dynamic_structure - 1)
				else
					editor2.values[MENU_XPOS] = 0
					editor2.values[MENU_YPOS] = 0
				end
				
				setundo_editor()
				
				buildmenustructure(dynamic_structure)
			end,
		leave = 
			function(parent,name)
				MF_delete("LevelButton")
				MF_letterclear("leveltext")
				MF_letterclear("nametext")
			end,
		submenu_leave =
			function(parent,name)
				MF_visible("LevelButton",0)
				MF_letterclear("nametext")
			end,
	},
	name =
	{
		enter = 
			function(parent,name)
				local x = screenw * 0.5
				local y = f_tilesize * 1.5
				--writetext(langtext("editor_entername") .. ":",0,x,y,name,true)
			end,
		leave = 
			function(parent,name)
				MF_delete("LetterButton")
				MF_letterclear("nametext")
			end,
	},
	editor =
	{
		button = "EditorButton",
		enter = 
			function(parent,name,buttonid)
				local levelname = generaldata.strings[LEVELNAME]
				local level = generaldata.strings[CURRLEVEL]
				
				if (generaldata.strings[BUILD] ~= "n") then
					displaylevelname(levelname .. " (" .. level .. ")",level,nil,"editorname",nil,nil,true)
				else
					displaylevelname(levelname,level,nil,"editorname",nil,nil,true)
				end
				
				local x = screenw - f_tilesize * 0.8
				local y = f_tilesize * 0.75
				
				for i=0,9 do
					local hotbarid = MF_create("Editor_hotbarbutton")
					local hotbar = mmf.newObject(hotbarid)
					
					hotbar.x = x - f_tilesize * 1.25 * i
					hotbar.y = y
					hotbar.layer = 2
					hotbar.values[HOTBAR_ID] = 9 - i
					hotbar.values[BUTTON_STOREDX] = hotbar.x
					hotbar.values[BUTTON_STOREDY] = hotbar.y
					
					MF_setcolour(hotbarid,3,2)
					hotbar.strings[UI_CUSTOMCOLOUR] = "3,2"
					hotbar.strings[GROUP] = buttonid
					hotbar.flags[BUTTON_SLIDING] = false
					
					local thumbid = MF_specialcreate("Editor_thumbnail_hotbar")
					local thumb = mmf.newObject(thumbid)
					
					thumb.x = hotbar.x
					thumb.y = hotbar.y
					thumb.values[HOTBAR_ID] = 9 - i
					thumb.strings[GROUP] = buttonid
					thumb.layer = 2
					thumb.visible = false
				end
				
				x = x - f_tilesize * 1.25 * 10.25
				
				local tooliconid = MF_specialcreate("Editor_toolindicator")
				local toolicon = mmf.newObject(tooliconid)
				
				toolicon.x = x
				toolicon.y = y
				toolicon.layer = 2
				toolicon.strings[GROUP] = buttonid
				
				toolicon.strings[4] = langtext("editor_toolindicator_eraser",true)
				--toolicon.strings[5] = langtext("editor_toolindicator_quickswitch",true)
				
				x = screenw
				y = screenh - f_tilesize * 0.5
				
				if (generaldata.strings[BUILD] ~= "n") then
					local blen = getdynamicbuttonwidth(langtext("editor_mainmenu"),4)
					x = x - f_tilesize * (blen * 0.5 + 0.25)
					
					createbutton("menu",x,y,2,0,1,langtext("editor_mainmenu"),name,3,2,buttonid,nil,nil,langtext("tooltip_editor_menu",true),nil,nil,nil,4)
					
					blen = getdistancebetweenbuttons(langtext("editor_mainmenu"),langtext("editor_settingsmenu"),4)
					x = x - f_tilesize * (blen + 1)
					
					createbutton("settingsmenu",x,y,2,0,1,langtext("editor_settingsmenu"),name,3,2,buttonid,nil,nil,langtext("tooltip_editor_settingsmenu",true))
					
					blen = getdistancebetweenbuttons(langtext("editor_settingsmenu"),langtext("editor_objectlist"))
					x = x - f_tilesize * blen
					
					createbutton("objects",x,y,2,0,1,langtext("editor_objectlist"),name,3,2,buttonid,nil,nil,langtext("tooltip_editor_objects",true))
					
					blen = getdistancebetweenbuttons(langtext("editor_objectlist"),langtext("editor_savelevel"))
					x = x - f_tilesize * (blen + 1)
					
					createbutton("save",x,y,2,0,1,langtext("editor_savelevel"),name,3,2,buttonid,nil,nil,langtext("tooltip_editor_save",true))
					
					blen = getdistancebetweenbuttons(langtext("editor_savelevel"),langtext("editor_undo"))
					x = x - f_tilesize * blen
					
					local disableundo = true
					if (#undobuffer_editor > 1) then
						disableundo = false
					end
					createbutton("undo",x,y,2,0,1,langtext("editor_undo"),name,3,2,buttonid,disableundo,nil,langtext("tooltip_editor_undo",true))
					
					blen = getdistancebetweenbuttons(langtext("editor_undo"),langtext("editor_swap"))
					x = x - f_tilesize * blen
					
					createbutton("swap",x,y,2,0,1,langtext("editor_swap"),name,3,2,buttonid,nil,nil,langtext("tooltip_editor_swap",true))
					
					blen = getdistancebetweenbuttons(langtext("editor_swap"),langtext("editor_test"))
					x = x - f_tilesize * blen
					
					createbutton("test",x,y,2,0,1,langtext("editor_test"),name,3,2,buttonid,nil,nil,langtext("tooltip_editor_test",true))
				end
				
				x = screenw - f_tilesize * 0.75
				y = f_tilesize * 2
				
				createbutton("layer1",x,y,2,1.5,1,langtext("editor_l1"),name,3,2,buttonid,nil,nil,langtext("tooltip_editor_layer",true),nil,true)
				
				y = y + f_tilesize
				
				createbutton("layer2",x,y,2,1.5,1,langtext("editor_l2"),name,3,2,buttonid,nil,nil,langtext("tooltip_editor_layer",true),nil,true)
				
				y = y + f_tilesize
				
				createbutton("layer3",x,y,2,1.5,1,langtext("editor_l3"),name,3,2,buttonid,nil,nil,langtext("tooltip_editor_layer",true),nil,true)
				
				makeselection({"layer1","layer2","layer3"},editor.values[LAYER] + 1)
				
				y = y + f_tilesize * 1.5
				
				createbutton("tool_normal",x,y,2,1.5,1.5,"",name,3,2,buttonid,nil,nil,langtext("tooltip_currobjlist_tool_normal",true),bicons.t_pen,true)
				
				y = y + f_tilesize * 1.5
				
				createbutton("tool_line",x,y,2,1.5,1.5,"",name,3,2,buttonid,nil,nil,langtext("tooltip_currobjlist_tool_line",true),bicons.t_line,true)
				
				y = y + f_tilesize * 1.5
				
				createbutton("tool_rectangle",x,y,2,1.5,1.5,"",name,3,2,buttonid,nil,nil,langtext("tooltip_currobjlist_tool_rectangle",true),bicons.t_rect,true)
				
				y = y + f_tilesize * 1.5
				
				createbutton("tool_fillrectangle",x,y,2,1.5,1.5,"",name,3,2,buttonid,nil,nil,langtext("tooltip_currobjlist_tool_fillrectangle",true),bicons.t_frect,true)
				
				y = y + f_tilesize * 1.5
				
				createbutton("tool_select",x,y,2,1.5,1.5,"",name,3,2,buttonid,nil,nil,langtext("tooltip_currobjlist_tool_select",true),bicons.t_select,true)
				
				y = y + f_tilesize * 1.5
				
				createbutton("tool_fill",x,y,2,1.5,1.5,"",name,3,2,buttonid,nil,nil,langtext("tooltip_currobjlist_tool_fill",true),bicons.t_fill,true)
				
				y = y + f_tilesize * 1.5
				
				createbutton("tool_erase",x,y,2,1.5,1.5,"",name,3,2,buttonid,nil,nil,langtext("tooltip_currobjlist_tool_erase",true),bicons.t_erase,true)
				
				local selected_tool = editor2.values[EDITORTOOL]
				
				makeselection({"tool_normal","tool_line","tool_rectangle","tool_fillrectangle","tool_select","tool_fill","tool_erase"},selected_tool + 1)
				
				editor.values[STATE] = 0
				
				local pad,padname = MF_profilefound()
				
				if (pad ~= nil) or (generaldata.strings[BUILD] == "n") then
					x = f_tilesize * 3
					y = screenh - f_tilesize * 3
					
					local dpadid = MF_specialcreate("Editor_buttons_dpad")
					local dpad = mmf.newObject(dpadid)
					
					dpad.x = f_tilesize * 4
					dpad.y = screenh - f_tilesize * 4
					dpad.layer = 2
					dpad.values[8] = dpad.x
					dpad.values[9] = dpad.y
					dpad.values[10] = 2
					
					editor_buttons_getdpad(dpad)
					
					y = y - f_tilesize * 6
					
					controlicon_editor("gamepad_editor","quickmenu",x,y,buttonid,langtext("buttons_editor_quickmenu",true),3,nil,"save",langtext("buttons_editor_save",true))
					
					y = y - f_tilesize * 3
					
					controlicon_editor("gamepad_editor","currobjlist",x,y,buttonid,langtext("buttons_editor_currobjlist",true),3,nil,"test",langtext("buttons_editor_test",true))
					
					x = screenw - f_tilesize * 8
					y = f_tilesize * 2.5					
					
					controlicon_editor("gamepad_editor","scrollleft_hotbar",x,y,buttonid,langtext("buttons_editor_scrollleft_hotbar",true),3,nil,"autopick",langtext("buttons_editor_autopick",true),langtext("buttons_editor_selection_flip",true))
					
					x = x + f_tilesize * 4
					
					controlicon_editor("gamepad_editor","scrollright_hotbar",x,y,buttonid,langtext("buttons_editor_scrollright_hotbar",true),3,nil,"pickempty",langtext("buttons_editor_pickempty",true),langtext("buttons_editor_selection_mirror",true))
					
					x = x - f_tilesize * 8.25
					
					controlicon_editor("gamepad_editor","scrollright_tool",x,y,buttonid,langtext("buttons_editor_scrollright_tool",true),3,nil,"lock",langtext("buttons_editor_lock",true),langtext("buttons_editor_selection_rotate_right",true))
					
					x = x - f_tilesize * 3
					
					controlicon_editor("gamepad_editor","scrollleft_tool",x,y,buttonid,langtext("buttons_editor_scrollleft_tool",true),3,nil,"empty_hotbar",langtext("buttons_editor_empty_hotbar",true),langtext("buttons_editor_selection_rotate_left",true))
					
					if (generaldata.strings[BUILD] ~= "n") then
						x = screenw - f_tilesize * 5
						y = screenh - f_tilesize * 3
						
						controlicon_editor("gamepad_editor","drag",x,y,buttonid,langtext("buttons_editor_drag",true),nil,nil,"showdir",langtext("buttons_editor_showdir",true),langtext("buttons_editor_selection_cancel",true))
						
						y = y - f_tilesize * 1.5
						
						controlicon_editor("gamepad_editor","undo",x,y,buttonid,langtext("buttons_editor_undo",true),nil,nil,"emptytile",langtext("buttons_editor_emptytile",true),langtext("buttons_editor_selection_ignore",true))
						
						y = y - f_tilesize * 1.5
						
						controlicon_editor("gamepad_editor","copy",x,y,buttonid,langtext("buttons_editor_copy",true),nil,nil,"cut",langtext("buttons_editor_cut",true),langtext("buttons_editor_selection_cancel",true))
						
						y = y - f_tilesize * 1.5
						
						controlicon_editor("gamepad_editor","place",x,y,buttonid,langtext("buttons_editor_place",true),nil,nil,"swap",langtext("buttons_editor_swap",true),langtext("buttons_editor_selection_place",true))
					else
						x = screenw - f_tilesize * 4
						y = screenh - f_tilesize * 4
						
						controlicon_editor("gamepad_editor","x",x,y - f_tilesize,buttonid,"buttons_editor",1,true)
						controlicon_editor("gamepad_editor","y",x - f_tilesize,y,buttonid,"buttons_editor",2,true)
						controlicon_editor("gamepad_editor","b",x,y + f_tilesize,buttonid,"buttons_editor",3,true)
						controlicon_editor("gamepad_editor","a",x + f_tilesize,y,buttonid,"buttons_editor",0,true)
					end
				end
			end,
	},
	editorsettingsmenu =
	{
		button = "EditorSettingsMenuButton",
		escbutton = "closemenu",
		enter = 
			function(parent,name,buttonid)
				MF_menubackground(true)
				local x = screenw * 0.5
				local y = f_tilesize * 1.5
				
				y = y + f_tilesize * 1.5
				
				createbutton("closemenu",x,y,2,16,1,langtext("editor_menu_close"),name,3,1,buttonid)
				
				y = y + f_tilesize * 1.5
				local refx = x
				local lx = refx - f_tilesize * 14
				local mx = refx - f_tilesize * 8
				local rx = refx + f_tilesize * 8
				
				writetext(langtext("editor_levelmenu_name") .. ":",0,lx,y,name,false,nil,nil,{2,4})
				
				local lname = generaldata.strings[LEVELNAME]
				if (string.len(lname) > 24) then
					lname = string.sub(lname, 1, 21) .. "..."
				end
				
				writetext(lname,0,mx,y,name,false,nil,nil,nil,nil,nil,nil,true)
				createbutton("rename",rx,y,2,10,1,langtext("editor_levelmenu_rename"),name,3,2,buttonid)
				
				y = y + f_tilesize
				
				writetext(langtext("editor_levelmenu_author") .. ":",0,lx,y,name,false,nil,nil,{2,4})
				local author = editor2.strings[AUTHOR]
				if (string.len(author) == 0) then
					author = langtext("noauthor")
				elseif (string.len(author) > 24) then
					author = string.sub(author, 1, 21) .. "..."
				end
				
				writetext(author,0,mx,y,name,false,nil,nil,nil,nil,nil,nil,true)
				createbutton("author",rx,y,2,10,1,langtext("editor_levelmenu_changeauthor"),name,3,2,buttonid)
				
				y = y + f_tilesize
				
				writetext(langtext("editor_levelmenu_subtitle") .. ":",0,lx,y,name,false,nil,nil,{2,4})
				local subtitle = editor2.strings[SUBTITLE]
				if (string.len(subtitle) == 0) then
					subtitle = langtext("editor_levelmenu_subtitle_none")
				end
				writetext(subtitle,0,mx,y,name,false,nil,nil,nil,nil,nil,nil,true)
				createbutton("subtitle",rx,y,2,10,1,langtext("editor_levelmenu_changesubtitle"),name,3,2,buttonid)
				
				y = y + f_tilesize * 1.5
				
				writetext(langtext("editor_levelmenu_music") .. ":",0,lx,y,name,false,nil,nil,{2,4})
				local vname = langtext("music_" .. editor2.strings[LEVELMUSIC],true,true)
				if (#vname == 0) then
					vname = editor2.strings[LEVELMUSIC]
				end
				writetext(vname,0,mx,y,name,false,nil,nil,nil,nil,nil,nil,true)
				createbutton("music",rx,y,2,10,1,langtext("editor_levelmenu_changemusic"),name,3,2,buttonid)
				
				y = y + f_tilesize
				
				writetext(langtext("editor_levelmenu_particles") .. ":",0,lx,y,name,false,nil,nil,{2,4})
				local levelparts = langtext("particles_" .. editor2.strings[LEVELPARTICLES],true,true)
				if (string.len(levelparts) == 0) then
					levelparts = langtext("particles_none")
				end
				writetext(levelparts,0,mx,y,name,false,nil,nil,nil,nil,nil,nil,true)
				createbutton("particles",rx,y,2,10,1,langtext("editor_levelmenu_changeparticles"),name,3,2,buttonid)
				
				y = y + f_tilesize
				
				writetext(langtext("editor_levelmenu_palette") .. ":",0,lx,y,name,false,nil,nil,{2,4})
				vname = langtext("palettes_" .. MF_getpalettename(),true,true)
				if (#vname == 0) then
					vname = MF_getpalettename()
				end
				writetext(vname,0,mx,y,name,false,nil,nil,nil,nil,nil,nil,true)
				createbutton("palette",rx,y,2,10,1,langtext("editor_levelmenu_changepalette"),name,3,2,buttonid)
				
				y = y + f_tilesize
				
				writetext(langtext("editor_levelmenu_levelsize") .. ":",0,lx,y,name,false,nil,nil,{2,4})
				local sizetext = langtext("editor_levelmenu_levelwidth") .. " " .. tostring(roomsizex - 2) .. ", " .. langtext("editor_levelmenu_levelheight") .. " " .. tostring(roomsizey - 2)
				writetext(sizetext,0,mx,y,name,false)
				createbutton("levelsize",rx,y,2,10,1,langtext("editor_levelmenu_changelevelsize"),name,3,2,buttonid)
				
				y = y + f_tilesize * 2
				
				createbutton("disableparticles",x,y,2,16,1,langtext("editor_levelmenu_disableparticles"),name,3,2,buttonid)
				makeselection({"","disableparticles"},generaldata5.values[LEVEL_DISABLEPARTICLES] + 1)
				
				y = y + f_tilesize * 1
				
				createbutton("disableruleeffect",x,y,2,16,1,langtext("editor_levelmenu_disableruleeffect"),name,3,2,buttonid)
				makeselection({"","disableruleeffect"},generaldata5.values[LEVEL_DISABLERULEEFFECT] + 1)
				
				y = y + f_tilesize * 1
				
				createbutton("disableshake",x,y,2,16,1,langtext("editor_levelmenu_disableshake"),name,3,2,buttonid)
				makeselection({"","disableshake"},generaldata5.values[LEVEL_DISABLESHAKE] + 1)
				
				y = y + f_tilesize * 1.5
				
				writetext(langtext("editor_levelmenu_autodelay") .. ":",0,x - f_tilesize * 9.25,y,name,false,2,true)
				slider("autodelay",x + f_tilesize * 0.75,y,8,{1,3},{1,4},buttonid,1,30,generaldata5.values[AUTO_DELAY])
			end,
		structure =
		{
			n = {
				{{"closemenu"},},
				{{"rename"},},
				{{"author"},},
				{{"subtitle"},},
				{{"music"},},
				{{"particles"},},
				{{"palette"},},
				{{"levelsize"},},
				{{"disableparticles"},},
				{{"disableruleeffect"},},
				{{"disableshake"},},
				{{"autodelay",-238},},
			},
			{
				{{"closemenu"},},
				{{"rename"},},
				{{"author"},},
				{{"subtitle"},},
				{{"music"},},
				{{"particles"},},
				{{"palette"},},
				{{"levelsize"},},
				{{"disableparticles"},},
				{{"disableruleeffect"},},
				{{"disableshake"},},
				{{"autodelay",-238},},
			},
		}
	},
	editormenu =
	{
		button = "EditorMenuButton",
		escbutton = "closemenu",
		slide = {0,1},
		enter = 
			function(parent,name,buttonid)
				MF_menubackground(true)
				
				local x = screenw * 0.5
				local y = f_tilesize * 5.0
				
				createbutton("closemenu",x,y,2,16,1,langtext("editor_menu_close"),name,3,1,buttonid)
				
				if (generaldata.strings[BUILD] ~= "n") then
					y = y + f_tilesize
					
					createbutton("test",x,y,2,16,1,langtext("editor_menu_test"),name,3,2,buttonid,nil,nil,langtext("tooltip_editor_menu_test",true))
				end
				
				y = y + f_tilesize
				
				local levelfound = MF_findfile("Data/Worlds/" .. generaldata.strings[WORLD] .. "/" .. generaldata.strings[CURRLEVEL] .. ".ld")
				local disableupload = true
				if levelfound then
					disableupload = false
				end
				createbutton("upload",x,y,2,16,1,langtext("editor_menu_upload"),name,3,2,buttonid,disableupload,nil,langtext("tooltip_editor_menu_upload",true))
				
				y = y + f_tilesize * 1.5
				
				createbutton("theme",x,y,2,16,1,langtext("editor_menu_themes"),name,3,2,buttonid,nil,nil,langtext("tooltip_editor_menu_theme",true))
				
				y = y + f_tilesize * 1.5
				
				createbutton("return",x,y,2,16,1,langtext("editor_menu_return"),name,3,1,buttonid,nil,nil,langtext("tooltip_editor_menu_return",true))
				
				y = y + f_tilesize
				
				createbutton("returnfull",x,y,2,16,1,langtext("editor_menu_returnfull"),name,3,1,buttonid,nil,nil,langtext("tooltip_editor_menu_returnfull",true))
				
				y = y + f_tilesize * 2
				
				createbutton("delete",x,y,2,16,1,langtext("editor_menu_delete"),name,3,2,buttonid,nil,nil,langtext("tooltip_editor_menu_delete",true))
				
				y = y + f_tilesize * 1
				
				local levels = MF_filelist("Data/Worlds/levels/","*.ld")
				local disablecopy = false
				if (generaldata.strings[BUILD] == "n") and (#levels >= 100) then
					disablecopy = true
				end
				
				if disableupload then
					disablecopy = true
				end
				
				createbutton("copy",x,y,2,16,1,langtext("editor_menu_copy"),name,3,2,buttonid,disablecopy,nil,langtext("tooltip_editor_menu_copy",true))
				
				y = y + f_tilesize * 1
				
				--createbutton("convert",x,y,2,16,1,"debug - old level conversion",name,3,2,buttonid)
			end,
		submenu_return =
			function(parent,name)
				MF_visible("EditorMenuButton",1)
				local x = f_tilesize * 0.5
				local y = f_tilesize * 0.5

				if (parent == "name") then
					MF_letterclear("editorname")
					writetext(generaldata.strings[LEVELNAME],0,x,y,"editorname",false,2,nil,nil,nil,nil,nil,true)
					MF_letterhide("editorname",1)
					--writetext(editor.strings[5],renamebuttonid,0,0,name,true)
				end
			end,
		structure =
		{
			{
				{{"closemenu"},},
				{{"test"},},
				{{"upload"},},
				{{"theme"},},
				{{"return"},},
				{{"returnfull"},},
				{{"delete"},},
				{{"copy"},},
			},
			n = {
				{{"closemenu"},},
				{{"upload"},},
				{{"theme"},},
				{{"return"},},
				{{"returnfull"},},
				{{"delete"},},
				{{"copy"},},
			},
		}
	},
	editorquickmenu =
	{
		button = "EditorQuickMenuButton",
		escbutton = "closemenu",
		slide = {0,1},
		enter = 
			function(parent,name,buttonid)
				MF_menubackground(true)
				
				local x = screenw * 0.5
				local y = f_tilesize * 6.5
				
				createbutton("closemenu",x,y,2,16,2,langtext("editor_menu_close"),name,3,1,buttonid)
				
				y = y + f_tilesize * 2
				
				createbutton("save",x,y,2,16,2,langtext("editor_savelevel"),name,3,2,buttonid)
				
				y = y + f_tilesize * 2
				
				createbutton("test",x,y,2,16,2,langtext("editor_testlevel"),name,3,2,buttonid)
				
				y = y + f_tilesize * 2
				
				createbutton("editorsettingsmenu",x,y,2,16,2,langtext("editor_settingsmenu"),name,3,2,buttonid,nil,nil,langtext("tooltip_quickmenu_editorsettingsmenu",true))
				
				y = y + f_tilesize * 2
				
				createbutton("editormenu",x,y,2,16,2,langtext("editor_editormenu"),name,3,2,buttonid,nil,nil,langtext("tooltip_quickmenu_editormenu",true))
			end,
		structure =
		{
			{
				{{"closemenu"},},
				{{"save"},},
				{{"test"},},
				{{"editorsettingsmenu"},},
				{{"editormenu"},},
			},
		}
	},
	musicload =
	{
		button = "MusicLoad",
		escbutton = "return",
		slide = {1,0},
		slide_leave = {-1,0},
		enter = 
			function(parent,name,buttonid)
				menudata_customscript.musiclist(parent,name,buttonid)
			end,
	},
	particlesload =
	{
		button = "ParticlesLoad",
		escbutton = "return",
		slide = {1,0},
		slide_leave = {-1,0},
		enter = 
			function(parent,name,buttonid)
				menudata_customscript.particleslist(parent,name,buttonid)
			end,
	},
	paletteload =
	{
		button = "PaletteLoad",
		escbutton = "return",
		slide = {1,0},
		slide_leave = {-1,0},
		enter = 
			function(parent,name,buttonid)
				menudata_customscript.palettelist(parent,name,buttonid)
			end,
	},
	levelsize =
	{
		button = "LevelSize",
		escbutton = "return",
		slide = {1,0},
		slide_leave = {-1,0},
		enter = 
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = screenh * 0.5 - f_tilesize * 7.0
				
				local xoff = f_tilesize * 2
				
				createbutton("return",x,y,2,16,1,langtext("return"),name,3,1,buttonid)
				
				x = f_tilesize * 5.0
				local bx = x + f_tilesize * 5.0
				y = y + f_tilesize * 3.5
				
				writetext(langtext("editor_levelsize_width") .. ":",0,x,y,name,false,2)
				
				y = y + f_tilesize
				
				createbutton("w--",bx - xoff * 2,y,2,2,1,"--",name,3,2,buttonid)
				createbutton("w-",bx - xoff * 0.5,y,2,2,1,"-",name,3,2,buttonid)
				createbutton("w+",bx + xoff,y,2,2,1,"+",name,3,2,buttonid)
				createbutton("w++",bx + xoff * 2.5,y,2,2,1,"++",name,3,2,buttonid)
				
				local wcountid = MF_specialcreate("Editor_counter")
				local wcount = mmf.newObject(wcountid)
				wcount.x = bx + xoff + f_tilesize * 4.5
				wcount.y = y
				wcount.values[COUNTER_VALUE] = roomsizex - 2
				wcount.strings[COUNTER_ID] = "levelw"
				wcount.values[6] = wcount.x
				wcount.values[7] = wcount.y
				
				y = y + f_tilesize * 2
				
				writetext(langtext("editor_levelsize_height") .. ":",0,x,y,name,false,2)
				
				y = y + f_tilesize
				
				createbutton("h--",bx - xoff * 2,y,2,2,1,"--",name,3,2,buttonid)
				createbutton("h-",bx - xoff * 0.5,y,2,2,1,"-",name,3,2,buttonid)
				createbutton("h+",bx + xoff,y,2,2,1,"+",name,3,2,buttonid)
				createbutton("h++",bx + xoff * 2.5,y,2,2,1,"++",name,3,2,buttonid)
				
				local hcountid = MF_specialcreate("Editor_counter")
				local hcount = mmf.newObject(hcountid)
				hcount.x = bx + xoff + f_tilesize * 4.5
				hcount.y = y
				hcount.values[COUNTER_VALUE] = roomsizey - 2
				hcount.strings[COUNTER_ID] = "levelh"
				hcount.values[6] = hcount.x
				hcount.values[7] = hcount.y
				
				y = y + f_tilesize * 2
				
				createbutton("apply",bx,y,2,10,1,langtext("editor_levelsize_apply"),name,3,2,buttonid)
				
				x = screenw * 0.5
				y = y + f_tilesize * 3
				
				writetext(langtext("editor_levelsize_quick") .. ":",0,x,y,name,true,2)
				
				y = y + f_tilesize
				
				createbutton("s148",x + f_tilesize * -14,y,2,3,1,"12x6",name,3,2,buttonid)
				createbutton("s1710",x + f_tilesize * -10,y,2,3,1,"15x8",name,3,2,buttonid)
				createbutton("s1616",x + f_tilesize * -6,y,2,3,1,"14x14",name,3,2,buttonid)
				createbutton("s2616",x + f_tilesize * -2,y,2,3,1,"24x14",name,3,2,buttonid)
				createbutton("s3018",x + f_tilesize * 2,y,2,3,1,"28x16",name,3,2,buttonid)
				createbutton("s2020",x + f_tilesize * 6,y,2,3,1,"18x18",name,3,2,buttonid)
				createbutton("s2620",x + f_tilesize * 10,y,2,3,1,"24x18",name,3,2,buttonid)
				createbutton("s3520",x + f_tilesize * 14,y,2,3,1,"33x18",name,3,2,buttonid)
				
				local frameid = MF_specialcreate("Editor_levelsizeframe")
				local frame = mmf.newObject(frameid)
				
				x = screenw * 0.5 + f_tilesize * 7.0
				y = screenh * 0.5 + f_tilesize * 1.0
				
				frame.x = x
				frame.y = y
				frame.layer = 2
				
				frame.values[XPOS] = x
				frame.values[YPOS] = y
				
				local c1,c2 = getuicolour("edge")
				MF_setcolour(frameid, c1, c2)
				
				local wlineid1 = MF_specialcreate("Editor_levelsize_w")
				local wline1 = mmf.newObject(wlineid1)
				wline1.layer = 2
				
				local wlineid2 = MF_specialcreate("Editor_levelsize_w")
				local wline2 = mmf.newObject(wlineid2)
				wline2.layer = 2
				wline2.values[1] = 1
				
				local hlineid1 = MF_specialcreate("Editor_levelsize_h")
				local hline1 = mmf.newObject(hlineid1)
				hline1.layer = 2
				
				local hlineid2 = MF_specialcreate("Editor_levelsize_h")
				local hline2 = mmf.newObject(hlineid2)
				hline2.layer = 2
				hline2.values[1] = 1
				
				MF_setcolour(wlineid1, 2, 2)
				MF_setcolour(wlineid2, 2, 2)
				MF_setcolour(hlineid1, 2, 2)
				MF_setcolour(hlineid2, 2, 2)
			end,
		leave = 
			function(parent,name)
				MF_delete("LevelSize")
				MF_removecounter("levelw")
				MF_removecounter("levelh")
			end,
		structure =
		{
			{
				{{"return"},},
				{{"w--"},{"w-"},{"w+"},{"w++"},},
				{{"h--"},{"h-"},{"h+"},{"h++"},},
				{{"apply"},},
				{{"s148"},{"s1710"},{"s1616"},{"s2616"},{"s3018"},{"s2020"},{"s2620"},{"s3520"},},
			},
		}
	},
	spriteselect =
	{
		button = "SpriteSelect",
		escbutton = "return",
		enter =
			function(parent,name,buttonid,extra)
				menudata_customscript.spritelist(parent,name,buttonid,extra)
			end,
		leave = 
			function(parent,name)
				MF_delete("SpriteButton")
				MF_letterclear("leveltext")
			end,
	},
	iconselect =
	{
		button = "IconButton",
		escbutton = "return",
		slide = {1,0},
		slide_leave = {-1,0},
		enter =
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = f_tilesize * 1.5
				
				createbutton("return",x,y,2,16,1,langtext("return"),name,3,1,buttonid)
				
				y = y + f_tilesize * 2
				
				local dynamic_structure = {}
				table.insert(dynamic_structure, {{"return"}})
				
				local y_ = 0
				local dynamic_structure_row = {}
				local count = generaldata2.values[ICONCOUNT]
				
				for i=1,count do
					local iconid = MF_create("Editor_spritebutton")
					
					local x,y = iconlist(iconid,i-1)
					
					if (y ~= y_) then
						y_ = y
						table.insert(dynamic_structure, dynamic_structure_row)
						dynamic_structure_row = {}
					end
					
					table.insert(dynamic_structure_row, {tostring(i - 1), "cursor"})
					
					if (i == count) then
						table.insert(dynamic_structure, dynamic_structure_row)
						dynamic_structure_row = {}
					end
				end
				
				buildmenustructure(dynamic_structure)
			end,
	},
	icons =
	{
		button = "IconButton",
		escbutton = "return",
		slide = {1,0},
		slide_leave = {-1,0},
		enter =
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = f_tilesize * 1.5
				
				createbutton("return",x,y,2,16,1,langtext("return"),name,3,1,buttonid)
				
				y = y + f_tilesize * 2
				
				local dynamic_structure = {}
				table.insert(dynamic_structure, {{"return"}})
				
				local y_ = 0
				local dynamic_structure_row = {}
				local count = generaldata2.values[ICONCOUNT]
				
				for i=1,count do
					local iconid = MF_create("Editor_spritebutton")
					
					local x,y = iconlist(iconid,i-1)
					
					if (y ~= y_) then
						y_ = y
						table.insert(dynamic_structure, dynamic_structure_row)
						dynamic_structure_row = {}
					end
					
					table.insert(dynamic_structure_row, {tostring(i - 1), "cursor"})
					
					if (i == count) then
						table.insert(dynamic_structure, dynamic_structure_row)
						dynamic_structure_row = {}
					end
				end
				
				buildmenustructure(dynamic_structure)
			end,
	},
	deleteconfirm =
	{
		button = "DeleteConfirm",
		escbutton = "no",
		enter = 
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = screenh * 0.5 - f_tilesize * 3
				
				writetext(langtext("editor_delete_confirm"),0,x,y,name,true)
				
				y = y + f_tilesize * 2
				
				createbutton("yes",x,y,2,16,1,langtext("yes"),name,3,2,buttonid)
				
				y = y + f_tilesize * 2
				
				createbutton("no",x,y,2,16,1,langtext("no"),name,3,2,buttonid)
			end,
		structure =
		{
			{
				{{"yes"},},
				{{"no"},},
			},
		}
	},
	unsaved_confirm =
	{
		button = "UnsavedConfirm",
		escbutton = "no",
		enter = 
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = screenh * 0.5 - f_tilesize * 3
				
				writetext(langtext("editor_unsaved_confirm"),0,x,y,name,true)
				
				y = y + f_tilesize * 2
				
				createbutton("no",x,y,2,16,1,langtext("no"),name,3,2,buttonid)
				
				y = y + f_tilesize * 2
				
				createbutton("yes",x,y,2,16,1,langtext("yes"),name,3,2,buttonid)
			end,
		structure =
		{
			{
				{{"no"},},
				{{"yes"},},
			},
		}
	},
	unsaved_confirmfull =
	{
		button = "UnsavedConfirmFull",
		escbutton = "no",
		enter = 
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = screenh * 0.5 - f_tilesize * 3
				
				writetext(langtext("editor_unsaved_confirm"),0,x,y,name,true)
				
				y = y + f_tilesize * 2
				
				createbutton("no",x,y,2,16,1,langtext("no"),name,3,2,buttonid)
				
				y = y + f_tilesize * 2
				
				createbutton("yes",x,y,2,16,1,langtext("yes"),name,3,2,buttonid)
			end,
		structure =
		{
			{
				{{"no"},},
				{{"yes"},},
			},
		}
	},
	uploadlevel =
	{
		button = "UploadLevel",
		escbutton = "no",
		slide = {1,0},
		slide_leave = {-1,0},
		enter = 
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = screenh * 0.5 - f_tilesize * 4
				
				writetext(langtext("editor_upload_name") .. ": $0,3" .. generaldata.strings[LEVELNAME],0,x,y,name,true,nil,nil,nil,nil,nil,nil,true)
				
				y = y + f_tilesize
				
				writetext(langtext("editor_upload_author") .. ": $0,3" .. editor2.strings[AUTHOR],0,x,y,name,true,nil,nil,nil,nil,nil,nil,true)
				
				y = y + f_tilesize
				
				writetext(langtext("editor_upload_subtitle") .. ": $0,3" .. editor2.strings[SUBTITLE],0,x,y,name,true,nil,nil,nil,nil,nil,nil,true)
				
				y = y + f_tilesize * 2
				
				writetext(langtext("editor_upload_confirm"),0,x,y,name,true)
				
				y = y + f_tilesize
				
				writetext(langtext("editor_upload_confirm_note"),0,x,y,name,true,nil,nil,{0,2})
				
				y = y + f_tilesize * 1.5
				
				--writetext(langtext("editor_upload_confirm_hint"),0,x,y,name,true,nil,nil,{0,2})
				
				y = y + f_tilesize
				
				createbutton("yes",x,y,2,16,1,langtext("yes"),name,3,2,buttonid)
				
				y = y + f_tilesize
				
				createbutton("no",x,y,2,16,1,langtext("no"),name,3,2,buttonid)
			end,
		structure =
		{
			{
				{{"yes"},},
				{{"no"},},
			},
		}
	},
	upload_do =
	{
		button = "UploadDo",
		enter = 
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = screenh * 0.5
				
				writetext(langtext("editor_upload_uploading"),0,x,y,name,true)
			end,
	},
	upload_done =
	{
		button = "UploadDone",
		escbutton = "return",
		enter = 
			function(parent,name,buttonid,extra)
				local x = screenw * 0.5
				local y = screenh * 0.5 - f_tilesize * 3.5
				
				MF_cursorvisible(1)
				
				local levelid,success,skipstoring = "",false,false
				
				if (extra ~= nil) and (#extra > 0) then
					levelid = extra[1]
					success = extra[2]
					skipstoring = extra[3] or false
				end
				
				if success then
					writetext(langtext("editor_upload_done"),0,x,y,name,true)
					
					y = y + f_tilesize * 2
					
					writetext(levelid,0,x,y,name,true)
					
					if (skipstoring == false) then
						storelevelcode(generaldata.strings[CURRLEVEL],levelid)
					end
				else
					writetext(langtext("editor_upload_failed"),0,x,y,name,true)
					
					y = y + f_tilesize * 2
					
					writetext(levelid,0,x,y,name,true)
				end
				
				if (generaldata.strings[BUILD] ~= n) then
					y = y + f_tilesize * 2
					
					local disablecopy = true
					if success then disablecopy = false end
					
					createbutton("copy",x,y,2,16,1,langtext("editor_upload_copy"),name,3,2,buttonid,disablecopy)
					
					y = y + f_tilesize * 1
					
					writetext(langtext("editor_upload_copyhint"),0,x,y,name,true,nil,nil,{0,2})
				end
				
				y = y + f_tilesize * 2
				
				createbutton("return",x,y,2,16,1,langtext("return"),name,3,1,buttonid)
			end,
		structure =
		{
			n = {
				{{"return"},},
			},
			{
				{{"copy"},},
				{{"return"},},
			},
		}
	},
	copyconfirm =
	{
		button = "CopyConfirm",
		escbutton = "no",
		enter = 
			function(parent,name,buttonid,lname)
				local x = screenw * 0.5
				local y = screenh * 0.5 - f_tilesize * 3
				
				writetext(langtext("editor_copy_confirm"),0,x,y,name,true)
				
				y = y + f_tilesize * 1
				
				writetext(langtext("editor_copy_confirm_name") .. " '" .. lname .. "'",0,x,y,name,true,nil,nil,nil,nil,nil,nil,true)
				
				y = y + f_tilesize * 2
				
				createbutton("yes",x,y,2,16,1,langtext("yes"),name,3,2,buttonid)
				
				y = y + f_tilesize * 2
				
				createbutton("no",x,y,2,16,1,langtext("no"),name,3,2,buttonid)
			end,
		structure =
		{
			{
				{{"yes"},},
				{{"no"},},
			},
		}
	},
	copydone =
	{
		button = "CopyDone",
		escbutton = "ok",
		enter = 
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = screenh * 0.5 - f_tilesize * 3
				
				writetext(langtext("editor_copy_done"),0,x,y,name,true)
				
				y = y + f_tilesize * 2
				
				createbutton("ok",x,y,2,16,1,langtext("return"),name,3,2,buttonid)
			end,
		structure =
		{
			{
				{{"ok"},},
			},
		}
	},
	setpath =
	{
		button = "PathButton",
		escbutton = "return",
		enter = 
			function(parent,name,buttonid,targeted_)
				local x = screenw * 0.5
				local y = screenh * 0.5 - f_tilesize * 5
				
				writetext(langtext("editor_path_settings"),0,x,y,name,true)
				
				y = y + f_tilesize * 2
				
				local pathobj = getactualdata_objlist(editor.strings[PATHOBJECT],"name") or "unknown"
				
				local targeted = targeted_ or 0
				if (targeted == 1) then
					local unitid = editor.values[EDITTARGET]
					local unit = mmf.newObject(unitid)
					
					editor.values[PATHSTYLE] = unit.values[PATH_STYLE]
					editor.values[PATHGATE] = unit.values[PATH_GATE]
					editor.values[PATHREQUIREMENT] = unit.values[PATH_REQUIREMENT]
					pathobj = getactualdata_objlist(unit.strings[PATHOBJECT],"name") or "unknown"
				end
				
				writetext(langtext("editor_path_object") .. ": " .. pathobj,0,x,y,name,true,nil,nil,nil,nil,nil,nil,true)
				
				y = y + f_tilesize * 2
				
				createbutton("hidden",x - f_tilesize * 4,y,2,8,1,langtext("editor_path_pathstate_hidden"),name,3,2,buttonid)
				createbutton("visible",x + f_tilesize * 4,y,2,8,1,langtext("editor_path_pathstate_visible"),name,3,2,buttonid)
				
				makeselection({"hidden","visible"},editor.values[PATHSTYLE] + 1)
				
				y = y + f_tilesize * 2
				
				writetext(langtext("editor_path_locked"),0,x,y,name,true)
				
				y = y + f_tilesize * 1
				
				createbutton("s1",x - f_tilesize * 12,y,2,6,1,langtext("no"),name,3,2,buttonid)
				
				createbutton("s2",x - f_tilesize * 6,y,2,6,1,langtext("editor_path_locked_levels"),name,3,2,buttonid)
				
				createbutton("s3",x,y,2,6,1,langtext("editor_path_locked_maps"),name,3,2,buttonid)
				
				createbutton("s4",x + f_tilesize * 6,y,2,6,1,langtext("editor_path_locked_orbs"),name,3,2,buttonid)
				
				createbutton("s5",x + f_tilesize * 12,y,2,6,1,langtext("editor_path_locked_loclevels"),name,3,2,buttonid)
				
				makeselection({"s1","s2","s3","s4","s5"},editor.values[PATHGATE] + 1)
				
				y = y + f_tilesize * 1
				
				local symbolid = MF_specialcreate("Editor_number")
				local symbol = mmf.newObject(symbolid)
				symbol.x = x
				symbol.y = y
				symbol.layer = 3
				symbol.strings[GROUP] = "PathSetup"
				
				createbutton("y--",x - f_tilesize * 2,y,2,1,1,"<<",name,3,2,buttonid)
				createbutton("y-",x - f_tilesize * 1,y,2,1,1,"<",name,3,2,buttonid)
				createbutton("y+",x + f_tilesize * 1,y,2,1,1,">",name,3,2,buttonid)
				createbutton("y++",x + f_tilesize * 2,y,2,1,1,">>",name,3,2,buttonid)
				
				y = y + f_tilesize * 2
				
				createbutton("return",x,y,2,16,1,langtext("return"),name,3,1,buttonid)
			end,
		structure =
		{
			{
				{{"hidden"},{"visible"}},
				{{"s1"},{"s2"},{"s3"},{"s4"},{"s5"}},
				{{"y--"},{"y-"},{"y+"},{"y++"}},
				{{"return"}},
			},
		},
	},
	objectedit =
	{
		button = "ObjectEditButton",
		escbutton = "return",
		slide = {1,0},
		slide_leave = {-1,0},
		enter = 
			function(parent,name,buttonid,unitname)
				local x = screenw * 0.5
				local y = f_tilesize * 2.5
				
				createbutton("return",x,y,2,16,1,langtext("return"),name,3,1,buttonid)
				
				local dynamic_structure = {}
				table.insert(dynamic_structure, {{"return"}})
				
				local extended = false
				local extended_ = tonumber(MF_read("settings","editor","mode")) or 0
				if (extended_ == 1) then
					extended = true
				end
				
				y = y + f_tilesize * 2
				
				local realname = unitreference[unitname]
				local currname = unitname
				local unittype = getactualdata_objlist(realname,"unittype")
				
				local unitid = MF_create(realname)
				local unit = mmf.newObject(unitid)
				
				unit.x = f_tilesize * 5
				unit.y = f_tilesize * 5
				unit.scaleX = 5
				unit.scaleY = 5
				unit.layer = 2
				editor.values[EDITTARGET] = unitid
				
				getmetadata(unit)
				if (changes[realname] ~= nil) then
					dochanges(unitid)
				end
				setcolour(unitid)
				
				if (extended == false) then
					y = y + f_tilesize * 1
				end
				
				x = screenw * 0.6
				
				writetext(tostring(currname) .. " (" .. tostring(realname) .. ") - " .. tostring(unittype),0,x,y,"objectinfo",true,nil,nil,nil,nil,nil,nil,true)
				
				y = y + f_tilesize * 1
				
				createbutton("sprite",x,y,2,16,1,langtext("editor_object_sprite"),name,3,2,buttonid)
				
				table.insert(dynamic_structure, {{"sprite"}})
				
				if extended then
					y = y + f_tilesize * 1
					
					createbutton("name",x,y,2,16,1,langtext("editor_object_name"),name,3,2,buttonid)
					table.insert(dynamic_structure, {{"name"}})
					
					y = y + f_tilesize * 1
					
					createbutton("type",x,y,2,16,1,langtext("editor_object_type"),name,3,2,buttonid)
					table.insert(dynamic_structure, {{"type"}})
				
					y = y + f_tilesize * 1
				else
					y = y + f_tilesize * 2
				end
				
				x = screenw * 0.5
				
				writetext(langtext("editor_object_colour") .. ":",0,x,y,name,true)
				
				y = y + f_tilesize * 1
				
				local dynamic_structure_row = {}
				
				if (unittype == "text") then
					createbutton("colour",x - f_tilesize * 6.5,y,2,12,1,langtext("editor_object_colour_base"),name,3,2,buttonid)
					table.insert(dynamic_structure_row, {"colour"})
					
					createbutton("acolour",x + f_tilesize * 6.5,y,2,12,1,langtext("editor_object_colour_active"),name,3,2,buttonid)
					table.insert(dynamic_structure_row, {"acolour"})
				else
					createbutton("colour",x,y,2,12,1,langtext("editor_object_colour_onlybase"),name,3,2,buttonid)
					table.insert(dynamic_structure_row, {"colour"})
				end
				
				table.insert(dynamic_structure, dynamic_structure_row)
				
				y = y + f_tilesize * 2
				
				x = screenw * 0.5
				
				writetext(langtext("editor_object_zlevel") .. ":",0,x,y,name,true)
				
				y = y + f_tilesize * 1
				
				createbutton("l-",x - f_tilesize * 1,y,2,1,1,"<",name,3,2,buttonid)
				createbutton("l+",x + f_tilesize * 1,y,2,1,1,">",name,3,2,buttonid)
				
				table.insert(dynamic_structure, {{"l-","cursor"},{"l+","cursor"}})
				
				local symbolid2 = MF_specialcreate("Editor_number")
				local symbol2 = mmf.newObject(symbolid2)
				symbol2.x = x
				symbol2.y = y
				symbol2.layer = 3
				symbol2.values[1] = -1
				symbol2.strings[OWNERMENU] = "objectedit"
				symbol2.strings[GROUP] = "ZLevel"
				symbol2.values[6] = x
				symbol2.values[7] = y
				
				symbol2.values[TYPE] = getactualdata(realname,"layer")
				
				y = y + f_tilesize * 1
				
				table.insert(dynamic_structure, {{"reset"}})
				
				createbutton("reset",x,y,2,16,1,langtext("editor_object_reset"),name,3,2,buttonid)
				
				buildmenustructure(dynamic_structure)
			end,
		leave = 
			function(parent,name)
				MF_delete("ObjectEditButton")
				MF_letterclear("objectinfo",0)
			end,
		submenu_leave = 
			function(parent,name)
				MF_visible("ObjectEditButton",0)
				MF_letterclear("objectinfo",0)
			end,
		submenu_return = 
			function(parent,name)
				MF_visible("ObjectEditButton",1)
				
				local x = screenw * 0.6
				local y = f_tilesize * 4.5
				
				local unitid = editor.values[EDITTARGET]
				local unit = mmf.newObject(unitid)
				
				local currname = unit.strings[UNITNAME]
				local realname = unit.className
				local unittype = unit.strings[UNITTYPE]
				
				writetext(currname .. " (" .. realname .. ") - " .. unittype,0,x,y,"objectinfo",true,nil,nil,nil,nil,nil,nil,true)
			end,
	},
	object_colour =
	{
		button = "ColourButton",
		escbutton = "return",
		enter =
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = f_tilesize * 2
				
				writetext(langtext("editor_object_colour_select"),0,x,y,name,true)
				
				y = y + f_tilesize
				
				local paletteid = MF_specialcreate("Editor_colourselector")
				local palette = mmf.newObject(paletteid)
				
				palette.layer = 2
				palette.x = screenw * 0.5
				palette.y = screenh * 0.5 - f_tilesize * 2.5
				
				palette.values[3] = palette.x
				palette.values[4] = palette.y
				
				local palettefile,paletteroot = MF_getpalettedata()
				local palettepath = getpath(paletteroot) .. "Palettes/" .. palettefile
				
				palette.strings[1] = palettepath
				palette.strings[2] = "object_colour"
				
				MF_loadcolourselector(paletteid,palettepath)
				
				palette.scaleX = 24
				palette.scaleY = 24
				palette.values[PALETTE_WIDTH] = 7
				palette.values[PALETTE_HEIGHT] = 5
				
				createbutton("return",x,y,2,8,1,langtext("return"),name,3,1,buttonid)
				
				y = y + f_tilesize
			end,
		leave = 
			function(parent,name)
				MF_delete("ColourButton")
			end,
		structure =
		{
			{
				{{"return"}},
			},
		},
	},
	themes =
	{
		button = "ThemeEditor",
		escbutton = "return",
		slide = {1,0},
		slide_leave = {-1,0},
		enter = 
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = f_tilesize * 4.5
				--writetext(langtext("editor_theme_edit") .. ":",0,x,y,name,true,1)
				
				createbutton("return",x,y,2,16,1,langtext("return"),name,3,1,buttonid)
				
				y = y + f_tilesize * 2
				
				createbutton("loadtheme",x,y,2,16,1,langtext("editor_theme_load"),name,3,2,buttonid)
				
				y = y + f_tilesize
				
				createbutton("savetheme",x,y,2,16,1,langtext("editor_theme_save"),name,3,2,buttonid)
				
				y = y + f_tilesize
				
				createbutton("deletetheme",x,y,2,16,1,langtext("editor_theme_delete"),name,3,2,buttonid)
			end,
		structure =
		{
			{
				{{"return"},},
				{{"loadtheme"},},
				{{"savetheme"},},
				{{"deltheme"},},
			},
		}
	},
	themeload =
	{
		button = "ThemeLoad",
		escbutton = "return",
		slide = {1,0},
		enter = 
			function(parent,name,buttonid,extra)
				menudata_customscript.themelist(parent,name,buttonid,extra)
			end,
	},
	themeload_confirm =
	{
		button = "ThemeLoadConfirm",
		escbutton = "no",
		enter = 
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = screenh * 0.5 - f_tilesize * 3
				
				writetext(langtext("editor_theme_load_confirm"),0,x,y,name,true,2,true)
				
				y = y + f_tilesize
				
				writetext(langtext("editor_theme_load_confirm_hint"),0,x,y,name,true,2,true)
				
				y = y + f_tilesize * 2
				
				createbutton("no",x,y,2,16,1,langtext("no"),name,3,2,buttonid)
				
				y = y + f_tilesize * 2
				
				createbutton("yes",x,y,2,16,1,langtext("yes"),name,3,2,buttonid)
			end,
		structure =
		{
			{
				{{"no"},},
				{{"yes"},},
			},
		}
	},
	themeload_confirm_newlevel =
	{
		button = "ThemeLoadConfirmNew",
		escbutton = "no",
		enter = 
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = screenh * 0.5 - f_tilesize * 3
				
				writetext(langtext("editor_theme_load_confirm_newlevel"),0,x,y,name,true,2,true)
				
				y = y + f_tilesize * 2
				
				createbutton("no",x,y,2,16,1,langtext("no"),name,3,2,buttonid)
				
				y = y + f_tilesize * 2
				
				createbutton("yes",x,y,2,16,1,langtext("yes"),name,3,2,buttonid)
			end,
		structure =
		{
			{
				{{"no"},},
				{{"yes"},},
			},
		}
	},
	themedelete =
	{
		button = "ThemeDelete",
		escbutton = "return",
		slide = {1,0},
		slide_leave = {-1,0},
		enter = 
			function(parent,name,buttonid)
				menudata_customscript.themelist(parent,name,buttonid)
			end,
	},
	themedelete_confirm =
	{
		button = "EraseConfirm",
		escbutton = "no",
		enter = 
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = screenh * 0.5 - f_tilesize * 3
				
				writetext(langtext("editor_theme_delete_confirm"),0,x,y,name,true,2,true)
				
				y = y + f_tilesize * 2
				
				createbutton("no",x,y,2,16,1,langtext("no"),name,3,2,buttonid)
				
				y = y + f_tilesize * 2
				
				createbutton("yes",x,y,2,16,1,langtext("yes"),name,3,2,buttonid)
			end,
		structure =
		{
			{
				{{"no"},},
				{{"yes"},},
			},
		}
	},
	themesave_confirm =
	{
		button = "EraseConfirm",
		escbutton = "no",
		enter = 
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = screenh * 0.5 - f_tilesize * 3
				
				writetext(langtext("editor_theme_save_confirm"),0,x,y,name,true,2,true)
				
				y = y + f_tilesize * 2
				
				createbutton("no",x,y,2,16,1,langtext("no"),name,3,2,buttonid)
				
				y = y + f_tilesize * 2
				
				createbutton("yes",x,y,2,16,1,langtext("yes"),name,3,2,buttonid)
			end,
		structure =
		{
			{
				{{"no"},},
				{{"yes"},},
			},
		}
	},
	themeselect =
	{
		escbutton = "return",
		enter = 
			function(parent,name)
				local x = roomsizex * f_tilesize * 0.5 * spritedata.values[TILEMULT]
				local y = f_tilesize * 1.5
				writetext(langtext("editor_theme_use") .. ":",0,x,y,name,true,2)

				y = y + f_tilesize
				
				createbutton("return",x,y,2,16,1,langtext("editor_theme_return"),name,3,1,"ThemeButton")
			end,
		leave = 
			function(parent,name)
				MF_delete("ThemeButton")
				MF_delete("ThemeChoice")
				MF_letterclear("themes")
			end,
	},
	restartconfirm =
	{
		escbutton = "no",
		button = "RestartConfirm",
		enter = 
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = screenh * 0.5 - f_tilesize * 3
				
				local build = generaldata.strings[BUILD]
				
				if (build ~= "m") then
					writetext(langtext("restart_confirm"),0,x,y,name,true,2,true)
					
					y = y + f_tilesize * 1
					
					writetext(langtext("restart_tip"),0,x,y,name,true,2,true,{1,4})
				else
					y = screenh * 0.5 - f_tilesize * 4.5
					
					writetext(langtext("restart_confirm_m"),0,x,y,name,true,2,true)
					
					y = y + f_tilesize * 2
					
					writetext(langtext("restart_tip_m_1"),0,x,y,name,true,2,true,{1,4})
					
					y = y + f_tilesize * 1.5
					
					writetext(langtext("restart_tip_m_2"),0,x,y,name,true,2,true,{1,4})
				end
				
				if (build ~= "m") then
					y = y + f_tilesize * 2
				
					createbutton("no",x,y,2,16,1,langtext("no"),name,3,2,buttonid)
					
					y = y + f_tilesize * 2
					
					createbutton("yes",x,y,2,16,1,langtext("yes"),name,3,2,buttonid)
				else
					y = y + f_tilesize * 4
					
					createbutton("yes",x - f_tilesize * 7,y,2,5,5,"",name,3,2,buttonid,nil,nil,nil,bicons.yes)
					createbutton("no",x + f_tilesize * 7,y,2,5,5,"",name,3,2,buttonid,nil,nil,nil,bicons.no)
				end
			end,
		leave = 
			function(parent,name)
				MF_delete("RestartConfirm")
			end,
	},
	playlevels =
	{
		button = "PlayLevels",
		escbutton = "return",
		enter = 
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = screenh * 0.5 - f_tilesize * 6.5
				
				createbutton("return",x,y,2,16,1,langtext("return"),name,3,1,buttonid)
				
				y = y + f_tilesize * 3
				
				local levels = MF_filelist("Data/Worlds/levels/","*.ld")
				local worlds = MF_dirlist("Data/Worlds/*")
				
				--writetext(langtext("customlevels") .. ":",0,x,y,name,true,1)
				
				local enablelevels = false
				local enableworlds = false
				
				local enablelevels = true
				local enableworlds = true
				
				if (#levels > 0) then
					enablelevels = false
				end
				
				for i,v in ipairs(worlds) do
					local worldfolder = string.sub(v, 2, string.len(v) - 1)
					
					if (worldfolder ~= "levels") then
						enableworlds = false
					end
				end
				
				createbutton("customlevels_play_single",x,y,2,16,2,langtext("customlevels_play_singular"),name,3,2,buttonid,enablelevels)
				
				y = y + f_tilesize * 2
				
				createbutton("customlevels_play_get",x,y,2,16,2,langtext("customlevels_play_get"),name,3,2,buttonid)
				
				y = y + f_tilesize * 2
				
				createbutton("customlevels_play_getlist",x,y,2,16,2,langtext("customlevels_play_getlist"),name,3,2,buttonid)
				
				y = y + f_tilesize * 2
				
				createbutton("customlevels_play_changename",x,y,2,16,2,langtext("customlevels_play_changename"),name,3,2,buttonid)
				
				y = y + f_tilesize * 2
				
				createbutton("customlevels_play_eraseslot",x,y,2,16,2,langtext("customlevels_play_eraseslot"),name,3,2,buttonid)
			end,
		structure =
		{
			{
				{{"return"},},
				{{"customlevels_play_single"},},
				{{"customlevels_play_get"},},
				{{"customlevels_play_getlist"},},
				{{"customlevels_play_changename"},},
				{{"customlevels_play_eraseslot"},},
			},
			n = 
			{
				{{"return"},},
				{{"customlevels_play_single"},},
				{{"customlevels_play_get"},},
				{{"customlevels_play_getlist"},},
				{{"customlevels_play_changename"},},
				{{"customlevels_play_eraseslot"},},
			},
		}
	},
	playlevels_single =
	{
		button = "PlayLevels_pack",
		escbutton = "return",
		enter = 
			function(parent,name,buttonid,page)
				menudata_customscript.playlevels_single(parent,name,buttonid,page)
			end,
		leave = 
			function(parent,name)
				MF_clearthumbnails("")
			end,
	},
	playlevels_pack =
	{
		button = "PlayLevels_pack",
		escbutton = "return",
		enter = 
			function(parent,name,buttonid,page)
				menudata_customscript.playlevels_pack(parent,name,buttonid,page)
			end,
		leave = 
			function(parent,name)
				MF_clearthumbnails("")
			end,
	},
	playlevels_featured =
	{
		button = "PlayLevels_featured",
		escbutton = "return",
		enter = 
			function(parent,name,buttonid,page)
				menudata_customscript.playlevels_featured(parent,name,buttonid,page)
			end,
		leave = 
			function(parent,name)
				MF_clearthumbnails("")
			end,
	},
	playlevels_featured_fail =
	{
		button = "FeaturedError",
		escbutton = "return",
		enter = 
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = screenh * 0.5 - f_tilesize * 2
				
				writetext(langtext("playlevels_featured_fail"),0,x,y,name,true,2,true)
				
				y = y + f_tilesize * 1
				
				writetext(langtext("playlevels_featured_fail_reason") .. ": " .. editor2.strings[ERRORCODE],0,x,y,name,true,2,true)
			
				y = y + f_tilesize * 2
				
				createbutton("return",x,y,2,16,1,langtext("return"),name,3,1,buttonid)
			end,
		structure =
		{
			{
				{{"return"},},
			},
		}
	},
	playlevels_getmenu =
	{
		button = "PlayLevelsGetMenu",
		escbutton = "return",
		enter = 
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = screenh * 0.5 - f_tilesize * 6.5
				
				createbutton("return",x,y,2,16,1,langtext("return"),name,3,1,buttonid)
				
				y = y + f_tilesize * 3
				
				--[[
				createbutton("playlevels_get_newest",x,y,2,16,2,langtext("customlevels_play_singular"),name,3,2,buttonid)
				
				y = y + f_tilesize * 2
				]]--
				
				createbutton("playlevels_get_featured",x,y,2,16,2,langtext("playlevels_get_featured"),name,3,2,buttonid)
				
				y = y + f_tilesize * 2
				
				createbutton("playlevels_get_code",x,y,2,16,2,langtext("playlevels_get_code"),name,3,2,buttonid)
			end,
		structure =
		{
			{
				{{"return"},},
				--{{"playlevels_get_newest"},},
				{{"playlevels_get_featured"},},
				{{"playlevels_get_code"},},
			},
		}
	},
	playlevels_getlist =
	{
		button = "PlayLevels_getlist",
		escbutton = "return",
		slide = {1,0},
		enter = 
			function(parent,name,buttonid)
				menudata_customscript.playlevels_getlist(parent,name,buttonid)
			end,
	},
	playlevels_get_wait =
	{
		button = "PlayLevelsGetWait",
		enter = 
			function(parent,name,buttonid,page)
				local x = screenw * 0.5
				local y = screenh * 0.5
				
				writetext(langtext("customlevels_get_wait"),0,x,y,name,true,2,true)
			end,
	},
	playlevels_get_success =
	{
		button = "PlayLevelsGetSuccess",
		escbutton = "return",
		enter = 
			function(parent,name,buttonid,extra)
				local x = screenw * 0.5
				local y = screenh * 0.5 - f_tilesize * 4.5
				
				writetext(langtext("customlevels_get") .. "!",0,x,y,name,true,2,true)
				
				y = y + f_tilesize * 2
				
				local lname = extra[1]
				local lauthor = extra[2]
				local lsubtitle = extra[3]
				
				local levels = MF_filelist("Data/Worlds/levels/","*.ld")
				local disablesave = false
				if (generaldata.strings[BUILD] == "n") and (#levels >= 100) then
					disablesave = true
				end
				
				writetext(langtext("editor_upload_name") .. ": $0,3" .. lname,0,x,y,name,true,2,true,nil,nil,nil,nil,true)
				
				y = y + f_tilesize * 1
				
				writetext(langtext("editor_upload_author") .. ": $0,3" .. lauthor,0,x,y,name,true,2,true,nil,nil,nil,nil,true)
				
				y = y + f_tilesize * 1
				
				writetext(langtext("editor_upload_subtitle") .. ": $0,3" .. lsubtitle,0,x,y,name,true,2,true,nil,nil,nil,nil,true)
				
				y = y + f_tilesize * 2
				
				createbutton("get_save",x,y,2,16,2,langtext("customlevels_get_save"),name,3,2,buttonid,disablesave)
				
				y = y + f_tilesize * 2
				
				createbutton("get_nosave",x,y,2,16,2,langtext("customlevels_get_nosave"),name,3,2,buttonid)
				
				y = y + f_tilesize * 2
				
				createbutton("return",x,y,2,16,1,langtext("customlevels_get_cancel"),name,3,1,buttonid)
			end,
		structure =
		{
			{
				{{"get_save"},},
				{{"get_nosave"},},
				{{"return"},},
			},
		}
	},
	playlevels_get_play =
	{
		button = "PlayLevelsGetPlay",
		escbutton = "return",
		enter = 
			function(parent,name,buttonid,extra)
				local x = screenw * 0.5
				local y = screenh * 0.5 - f_tilesize * 4.5
				
				writetext(langtext("customlevels_get_saved") .. "!",0,x,y,name,true,2,true)
				
				y = y + f_tilesize * 2
				
				local lname = extra[1]
				local lauthor = extra[2]
				local lsubtitle = extra[3]
				
				writetext(langtext("editor_upload_name") .. ": $0,3" .. lname,0,x,y,name,true,2,true,nil,nil,nil,nil,true)
				
				y = y + f_tilesize * 1
				
				writetext(langtext("editor_upload_author") .. ": $0,3" .. lauthor,0,x,y,name,true,2,true,nil,nil,nil,nil,true)
				
				y = y + f_tilesize * 1
				
				writetext(langtext("editor_upload_subtitle") .. ": $0,3" .. lsubtitle,0,x,y,name,true,2,true,nil,nil,nil,nil,true)
				
				y = y + f_tilesize * 2
				
				createbutton("get_play",x,y,2,16,2,langtext("customlevels_get_play"),name,3,2,buttonid)
				
				y = y + f_tilesize * 2
				
				createbutton("get_levellist",x,y,2,16,2,langtext("customlevels_get_levellist"),name,3,2,buttonid)
				
				y = y + f_tilesize * 2
				
				createbutton("return",x,y,2,16,1,langtext("return"),name,3,1,buttonid)
			end,
		structure =
		{
			{
				{{"get_play"},},
				{{"get_levellist"},},
				{{"return"},},
			},
		}
	},
	playlevels_get_fail =
	{
		button = "PlayLevelsGetFail",
		escbutton = "return",
		enter = 
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = screenh * 0.5 - f_tilesize * 2
				
				writetext(langtext("customlevels_get_fail"),0,x,y,name,true,2,true)
				
				y = y + f_tilesize * 1
				
				writetext(langtext("customlevels_get_fail_reason") .. ": " .. editor2.strings[ERRORCODE],0,x,y,name,true,2,true,nil,nil,nil,nil,true)
			
				y = y + f_tilesize * 2
				
				createbutton("return",x,y,2,16,1,langtext("return"),name,3,1,buttonid)
			end,
		structure =
		{
			{
				{{"return"},},
			},
		}
	},
	playlevels_eraseslot =
	{
		button = "PlayLevelsEraseConfirm",
		escbutton = "no",
		slide = {1,0},
		slide_leave = {-1,0},
		enter = 
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = screenh * 0.5 - f_tilesize * 3
				
				writetext(langtext("erase_confirm"),0,x,y,name,true,2,true)
				y = y + f_tilesize * 1
				writetext(langtext("customlevels_play_eraseslot_tip"),0,x,y,name,true,2,true,{1,4})
				
				y = y + f_tilesize * 2
				
				createbutton("no",x,y,2,16,1,langtext("no"),name,3,2,buttonid)
				
				y = y + f_tilesize * 2
				
				createbutton("yes",x,y,2,16,1,langtext("yes"),name,3,2,buttonid)
			end,
		structure =
		{
			{
				{{"no"},},
				{{"yes"},},
			},
		}
	},
	slots_playlevels =
	{
		button = "PlayLevelSlotMenu",
		escbutton = "return",
		slide = {0,1},
		enter = 
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = 5 * f_tilesize
				
				local world = generaldata.strings[BASEWORLD]
				
				writetext(langtext("slots_select") .. ":",0,x,y,name,true,2,true)

				y = y + f_tilesize * 2.5
				
				for saveslot=1,3 do
					local savefile = tostring(saveslot - 1) .. "ba.ba"
					MF_setfile("save",savefile)
					prizes = tonumber(MF_read("save",world .. "_prize","total")) or 0
					clears = tonumber(MF_read("save",world .. "_clears","total")) or 0
					bonus = tonumber(MF_read("save",world .. "_bonus","total")) or 0
					timer = tonumber(MF_read("save",world,"time")) or 0
					win = tonumber(MF_read("save",world,"end")) or 0
					done = tonumber(MF_read("save",world,"done")) or 0
					
					minutes = string.sub("00" .. tostring(math.floor(timer / 60) % 60), -2)
					hours = tostring(math.floor(timer / 3600))
					
					slotname = langtext("slot") .. " " .. tostring(saveslot)
					
					local fullslotname = MF_read("settings","slotnames",tostring(saveslot - 1))
					
					if (string.len(fullslotname) > 0) then
						slotname = slotname .. " - " .. fullslotname
					end
					
					local buttoncode = tostring(saveslot)
					createbutton(buttoncode,x,y,2,16,2,slotname,name,3,2,buttonid)
					
					y = y + f_tilesize * 2
				end
				
				MF_setfile("save","ba.ba")
				
				y = y + f_tilesize * 0.5
				
				createbutton("return",x,y,2,16,1,langtext("return"),name,3,1,buttonid)
			end,
		structure =
		{
			{
				{{"1"},},
				{{"2"},},
				{{"3"},},
				{{"return"},},
			},
		}
	},
	languages =
	{
		button = "LanguageMenu",
		enter = 
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = screenh * 0.5 - f_tilesize * 6
				
				writetext(langtext("lang_setup") .. ":",0,x,y,name,true,2,true)
				
				local langs = MF_filelist("Data/Languages/","*.txt")
				
				y = y + f_tilesize * 2
				
				local selection = 0
				local options = {}
				
				x = x - f_tilesize * 6
				local x_ = 0
				
				local dynamic_structure = {{}}
				local dynamic_structure_y = 1
				local dynamic_structure_x = dynamic_structure[dynamic_structure_y]
				
				for c,d in ipairs(langs) do
					MF_setfile("lang",d)
					
					local buttonname = string.sub(d, 1, string.len(d) - 4)
					local langname = MF_read("lang","general","name")
					
					if (generaldata4.values[CUSTOMFONT] == 0) then
						langname = string.lower(langname)
					end
					
					createbutton(buttonname,x + x_ * 12 * f_tilesize,y,2,10,1,langname,name,3,2,buttonid)
					
					if (generaldata.strings[LANG] == string.sub(buttonname, 6)) then
						selection = c
					end
					
					table.insert(options, buttonname)
					
					table.insert(dynamic_structure_x, {buttonname})
					
					x_ = x_ + 1
					if (x_ > 1) and (c < #langs) then
						x_ = 0
						y = y + f_tilesize
						
						table.insert(dynamic_structure, {})
						dynamic_structure_y = dynamic_structure_y + 1
						dynamic_structure_x = dynamic_structure[dynamic_structure_y]
					end
				end
				
				makeselection(options,selection)
				
				MF_setfile("lang","lang_" .. generaldata.strings[LANG] .. ".txt")
				
				x = screenw * 0.5
				y = y + f_tilesize
				
				createbutton("return",x,y,2,16,1,langtext("return"),name,3,2,buttonid)
				
				editor2.values[MENU_XDIM] = 1
				editor2.values[MENU_YDIM] = math.floor(#langs / 2) + 1
				
				table.insert(dynamic_structure, {{"return"}})
				buildmenustructure(dynamic_structure)
			end,
	},
	enterlevel_multiple =
	{
		button = "MultipleLevels",
		escbutton = "return",
		enter = 
			function(parent,name,buttonid,extra)
				local x = screenw * 0.5
				local y = f_tilesize * 4.5
				
				local build = generaldata.strings[BUILD]
				
				if (build ~= "m") then
					createbutton("return",x,y,2,16,1,langtext("return"),name,3,2,buttonid)
					
					y = y + f_tilesize * 2
					
					writetext(langtext("enterlevel_multiple") .. ":",0,x,y,name,true,2)
					
					y = y + f_tilesize * 1
					
					editor2.values[MENU_YDIM] = #extra
					
					for i,v in ipairs(extra) do
						y = y + f_tilesize * 1
						
						local levelunit = v[1]
						local levelfile = v[3]
						
						local lunit = mmf.newObject(levelunit)
						
						local levelname = ""
						
						if (generaldata.strings[WORLD] == generaldata.strings[BASEWORLD]) then
							levelname = langtext(levelfile,true)
						else
							levelname = langtext(generaldata.strings[WORLD] .. "_" .. levelfile,true)
						end
						
						if (levelname == "not found") then
							levelname = v[2]
						end
						
						createbutton(tostring(i) .. "," .. fixed_to_str(levelunit),x,y,2,16,1,levelname,name,3,2,buttonid)
					end
				else
					y = f_tilesize * 4
					
					createbutton("return",x,y,2,16,3,langtext("return"),name,3,2,buttonid)
					
					y = y + f_tilesize * 2.5
					
					writetext(langtext("enterlevel_multiple_m") .. ":",0,x,y,name,true,2)
					
					y = y - f_tilesize * 0.5
					
					editor2.values[MENU_YDIM] = #extra
					
					for i,v in ipairs(extra) do
						y = y + f_tilesize * 3
						
						local levelunit = v[1]
						local levelname = v[2]
						createbutton(tostring(i) .. "," .. fixed_to_str(levelunit),x,y,2,16,3,levelname,name,3,2,buttonid)
					end
				end
			end,
	},
	objlist =
	{
		button = "EditorObjectList",
		escbutton = "return",
		enter = 
			function(parent,name,buttonid,extra)
				editor2.values[OBJLISTTYPE] = 0
				editor_objects_build(nil,nil)
				
				local x = 2
				local y = 2
				
				local dynamic_structure = {}
				
				createbutton("return",6 * f_tilesize,y * f_tilesize,2,6,1,langtext("return"),name,3,1,buttonid)
				
				table.insert(dynamic_structure, {{"return"}})
				
				y = 3
				
				local deletesearchdisable = false
				if (string.len(objlistdata.search) == 0) then
					deletesearchdisable = true
				end
				
				createbutton("search_edit",7 * f_tilesize,y * f_tilesize,2,8,1,langtext("editor_objectlist_search_edit"),name,3,2,buttonid)
				createbutton("search_remove",16 * f_tilesize,y * f_tilesize,2,8,1,langtext("editor_objectlist_search_remove"),name,3,2,buttonid,deletesearchdisable)
				createbutton("search_tags",24 * f_tilesize,y * f_tilesize,2,6,1,langtext("editor_objectlist_tags"),name,3,2,buttonid)
				
				table.insert(dynamic_structure, {{"search_edit"},{"search_remove"},{"search_tags"}})
				
				y = 4
				
				local subline = ""
				
				if (string.len(objlistdata.search) > 0) then
					subline = langtext("editor_objectlist_result") .. " '" .. objlistdata.search .. "'"
					
					if (#objlistdata.tags > 0) then
						subline = subline .. ", "
					end
				end
				
				if (#objlistdata.tags > 0) then
					if (#objlistdata.tags == 1) then
						subline = subline .. langtext("editor_objectlist_tag") .. ": "
					else
						subline = subline .. langtext("editor_objectlist_tags") .. ": "
					end
					
					for i,v in ipairs(objlistdata.tags) do
						subline = subline .. v
						
						if (i < #objlistdata.tags) then
							subline = subline .. ", "
						end
					end
				end
				
				if (string.len(subline) == 0) then
					subline = langtext("editor_objectlist_search_none")
				end
				
				writetext(subline,0,3 * f_tilesize,y * f_tilesize,name,false,2,nil,nil,nil,nil,nil,true)
				
				y = 3.5
				
				local xdim = (screenw - f_tilesize * 4) / (f_tilesize * 2)
				
				local pagesize = 60
				local page = extra or 0
				page = MF_setpagemenu(name)
				local maxpage = math.ceil((#editor_objects-1) / pagesize)
				local minobj = page * pagesize + 1
				local maxobj = math.min((page + 1) * pagesize, #editor_objects)
				
				editor3.values[MAXPAGE] = maxpage
				
				local dynamic_structure_row = {}
				
				local total = #editor_currobjlist
				local disableall = false
				if (total >= 150) then
					disableall = true
				end
				
				local i_ = 1
				
				for i=minobj,maxobj do
					local id = editor_objects[i]["objlistid"]
					local v = editor_objlist[id]
					
					local inuse = false
					if (objlistdata.objectreference[id] ~= nil) then
						inuse = true
					end
					
					if disableall then
						inuse = true
					end
					
					local bid = createbutton_objlist(tostring(id),x * (f_tilesize * 2),y * (f_tilesize * 2),name,3,2,buttonid,nil,inuse)
					--local bid = createbutton(tostring(i),x * (f_tilesize * 2),y * (f_tilesize * 2),2,2,2,"<empty>",name,3,2,buttonid)
					
					local imagefile = v.sprite or v.name
					local c = v.colour_active or v.colour
					local c1 = c[1] or 0
					local c2 = c[2] or 3
					
					if inuse then
						c1 = 0
						c2 = 1
					end
					
					local imagepath = "Sprites/"
					
					if (v.sprite_in_root ~= nil) and (v.sprite_in_root == false) then
						imagepath = "Worlds/" .. generaldata.strings[WORLD] .. "/Sprites/"
					end
					
					imagefile = imagefile .. "_0_1"
					MF_thumbnail(imagepath,imagefile,i_-1,0,0,bid,c1,c2,0,0,buttonid,"")
					
					table.insert(dynamic_structure_row, {tostring(id),"cursor"})
					
					x = x + 1
					i_ = i_ + 1
					
					if (x > xdim + 1) then
						x = 2
						y = y + 1
						
						table.insert(dynamic_structure, dynamic_structure_row)
						dynamic_structure_row = {}
					end
					
					if (i == maxobj) and (#dynamic_structure_row > 0) then
						table.insert(dynamic_structure, dynamic_structure_row)
						dynamic_structure_row = {}
					end
				end
				
				local cannot_scroll_left = true
				local cannot_scroll_right = true
				
				if (page > 0) then
					cannot_scroll_left = false
				end
				
				if (page < maxpage - 1) then
					cannot_scroll_right = false
				end
				
				if (maxpage > 1) then
					createbutton("scroll_left",screenw * 0.5 - f_tilesize * 4,screenh - f_tilesize * 2,2,2,2,"",name,3,2,buttonid,cannot_scroll_left,nil,nil,bicons.l_arrow)
					createbutton("scroll_left2",screenw * 0.5 - f_tilesize * 7,screenh - f_tilesize * 2,2,2,2,"",name,3,2,buttonid,cannot_scroll_left,nil,nil,bicons.dl_arrow)
					createbutton("scroll_right",screenw * 0.5 + f_tilesize * 4,screenh - f_tilesize * 2,2,2,2,"",name,3,2,buttonid,cannot_scroll_right,nil,nil,bicons.r_arrow)
					createbutton("scroll_right2",screenw * 0.5 + f_tilesize * 7,screenh - f_tilesize * 2,2,2,2,"",name,3,2,buttonid,cannot_scroll_right,nil,nil,bicons.dr_arrow)
					
					table.insert(dynamic_structure, {{"scroll_left2"},{"scroll_left"},{"scroll_right"},{"scroll_right2"}})
				
					writetext(langtext("editor_objectlist_page") .. ": " .. tostring(page + 1) .. "/" .. tostring(maxpage),0,screenw * 0.5,screenh - f_tilesize * 2,name,true,2)
				end
				
				editor2.values[MENU_YPOS] = math.min(editor2.values[MENU_YPOS], #dynamic_structure - 1)
				
				buildmenustructure(dynamic_structure)
			end,
		leave = 
			function(parent,name)
				MF_clearthumbnails("EditorObjectList")
			end,
	},
	objlist_update =
	{
		button = "EditorObjectList_update",
		enter = 
			function(parent,name,buttonid,extra)
				MF_clearthumbnails("")
			end,
	},
	objlist_tags =
	{
		button = "EditorObjectList_tags",
		escbutton = "return",
		slide = {1,0},
		slide_leave = {-1,0},
		enter = 
			function(parent,name,buttonid)
				local x = 2
				local y = 2
				
				createbutton("return",6 * f_tilesize,2 * f_tilesize,2,8,1,langtext("return"),name,3,1,buttonid)
				
				createbutton("cleartags",15 * f_tilesize,2 * f_tilesize,2,8,1,langtext("editor_objectlist_tags_cleartags"),name,3,1,buttonid)
				
				local dynamic_structure = {}
				table.insert(dynamic_structure, {{"return"},{"cleartags"}})
				
				y = 3
				
				writetext(langtext("editor_objectlist_tags_select"),0,x * f_tilesize,y * f_tilesize,name,false,2)
				
				x = 0.75
				y = 4
				
				local xdim = (screenw - f_tilesize * 16) / (f_tilesize * 8)
				
				local tagdata = objlistdata.tags
				if (editor2.values[OBJLISTTYPE] == 1) then
					tagdata = objlistdata.tags_currobjlist
				end
				
				local dynamic_structure_row = {}
				
				for i,tag in ipairs(objlistdata.alltags) do
					if (tag ~= "special") then
						local tag_ = langtext("tag_" .. tag)
						if (tag_ == "not found") then
							tag_ = tag
						end
						
						local used = 0
						for a,b in ipairs(tagdata) do
							if (b == tag) then
								used = 1
							end
						end
						
						s,c = gettoggle(used)
						
						local bid = createbutton("tag," .. tag,x * f_tilesize * 8,y * f_tilesize,2,8,1,tag_,name,3,2,buttonid,nil,s)
						
						table.insert(dynamic_structure_row, {"tag," .. tag, "longcursor"})
						
						x = x + 1
						
						if (x >= xdim + 2) then
							x = 0.75
							y = y + 1
							
							table.insert(dynamic_structure, dynamic_structure_row)
							dynamic_structure_row = {}
						end
						
						if (i == #objlistdata.alltags) and (#dynamic_structure_row > 0) then
							table.insert(dynamic_structure, dynamic_structure_row)
							dynamic_structure_row = {}
						end
					end
				end
				
				buildmenustructure(dynamic_structure)
			end,
	},
	currobjlist =
	{
		button = "CurrentObjectList",
		escbutton = "editor_return",
		enter = 
			function(parent,name,buttonid,extra)
				editor2.values[OBJLISTTYPE] = 1
				editor_objects_build(nil,nil)
				
				local total = #editor_objects
				local total_ = #editor_currobjlist
				
				local ymult = 1.5
				
				local x_ = 1.5 * f_tilesize
				local y_ = 2 * f_tilesize
				
				local dynamic_structure = {}
				
				createbutton("tool_normal",x_,y_,2,2,2,"",name,3,2,buttonid,nil,nil,langtext("tooltip_currobjlist_tool_normal",true),bicons.t_pen,true)
				createbutton("tool_line",x_ + f_tilesize * 2,y_,2,2,2,"",name,3,2,buttonid,nil,nil,langtext("tooltip_currobjlist_tool_line",true),bicons.t_line,true)
				createbutton("tool_rectangle",x_ + f_tilesize * 4,y_,2,2,2,"",name,3,2,buttonid,nil,nil,langtext("tooltip_currobjlist_tool_rectangle",true),bicons.t_rect,true)
				createbutton("tool_fillrectangle",x_ + f_tilesize * 6,y_,2,2,2,"",name,3,2,buttonid,nil,nil,langtext("tooltip_currobjlist_tool_fillrectangle",true),bicons.t_frect,true)
				createbutton("tool_select",x_ + f_tilesize * 8,y_,2,2,2,"",name,3,2,buttonid,nil,nil,langtext("tooltip_currobjlist_tool_select",true),bicons.t_select,true)
				createbutton("tool_fill",x_ + f_tilesize * 10,y_,2,2,2,"",name,3,2,buttonid,nil,nil,langtext("tooltip_currobjlist_tool_fill",true),bicons.t_fill,true)
				createbutton("tool_erase",x_ + f_tilesize * 12,y_,2,2,2,"",name,3,2,buttonid,nil,nil,langtext("tooltip_currobjlist_tool_erase",true),bicons.t_erase,true)
				
				local selected_tool = editor2.values[EDITORTOOL]
				
				makeselection({"tool_normal","tool_line","tool_rectangle","tool_fillrectangle","tool_select","tool_fill","tool_erase"},selected_tool + 1)
				
				local searchdisable = true
				if (total_ > 1) then
					searchdisable = false
				end
				
				local deletesearchdisable = searchdisable
				
				if (string.len(objlistdata.search_currobjlist) == 0) then
					deletesearchdisable = true
				end
				
				createbutton("search_edit",x_ + f_tilesize * 14.5,y_,2,2,2,"",name,3,2,buttonid,searchdisable,nil,langtext("tooltip_currobjlist_search_edit",true),bicons.search)
				createbutton("search_remove",x_ + f_tilesize * 16.5,y_,2,2,2,"",name,3,2,buttonid,deletesearchdisable,nil,langtext("tooltip_currobjlist_search_remove",true),bicons.rsearch)
				createbutton("search_tags",x_ + f_tilesize * 18.5,y_,2,2,2,"",name,3,2,buttonid,searchdisable,nil,langtext("tooltip_currobjlist_search_tags",true),bicons.tags)
				
				ymult = ymult + 1
				
				local atlimit = false
				if (total_ >= 150) then
					atlimit = true
				end
				createbutton("add",x_ + f_tilesize * 21,y_,2,2,2,"",name,3,2,buttonid,atlimit,nil,langtext("tooltip_currobjlist_add",true),bicons.o_add)
				
				local removedisable = true
				if (total_ > 0) then
					removedisable = false
				end
				
				createbutton("remove",x_ + f_tilesize * 23,y_,2,2,2,"",name,3,2,buttonid,removedisable,nil,langtext("tooltip_currobjlist_remove",true),bicons.o_del)
				createbutton("editobject",x_ + f_tilesize * 25,y_,2,2,2,"",name,3,2,buttonid,removedisable,nil,langtext("tooltip_currobjlist_editobject",true),bicons.o_edit)
				
				local pair_option_names = {"l_separate", "l_pairs"}
				local pair_option = editor2.values[DOPAIRS] + 1
				local pair_option_ = pair_option_names[pair_option]
				
				--createbutton("nothing",24.5 * f_tilesize,ymult * f_tilesize - f_tilesize,2,8,1,langtext("editor_objectlist_nothing"),name,3,2,buttonid)
				createbutton("dopairs",x_ + f_tilesize * 27.5,y_,2,2,2,"",name,3,2,buttonid,nil,nil,langtext("tooltip_currobjlist_dopairs",true),bicons[pair_option_])
				
				local this_structure = {{"tool_normal","cursor"},{"tool_line","cursor"},{"tool_rectangle","cursor"},{"tool_fillrectangle","cursor"},{"tool_select","cursor"},{"tool_fill","cursor"},{"tool_erase","cursor"},{"search_edit","cursor"},{"search_remove","cursor"},{"search_tags","cursor"},{"add","cursor"},{"remove","cursor"},{"editobject","cursor"},{"dopairs","cursor"}}
				
				if (pair_option == 2) then
					createbutton("swap",x_ + f_tilesize * 29.5,y_,2,2,2,"",name,3,2,buttonid,nil,nil,langtext("tooltip_currobjlist_swap",true),bicons.swap)
					table.insert(this_structure, {"swap","cursor"})
				end
				
				if (generaldata.strings[BUILD] ~= "n") then
					table.insert(this_structure, {"editor_return","cursor"})
					createbutton("editor_return",x_ + f_tilesize * 32,y_,2,2,2,"",name,3,2,buttonid,nil,nil,langtext("tooltip_currobjlist_return",true),bicons.cross)
				end
				
				table.insert(dynamic_structure, this_structure)
				
				ymult = ymult + 1
				
				local subline = ""
				
				if (string.len(objlistdata.search_currobjlist) > 0) then
					subline = langtext("editor_objectlist_result") .. " '" .. objlistdata.search_currobjlist .. "'"
					
					if (#objlistdata.tags_currobjlist > 0) then
						subline = subline .. ", "
					end
				end
				
				if (#objlistdata.tags_currobjlist > 0) then
					if (#objlistdata.tags_currobjlist == 1) then
						subline = subline .. langtext("editor_objectlist_tag") .. ": "
					else
						subline = subline .. langtext("editor_objectlist_tags") .. ": "
					end
					
					for i,v in ipairs(objlistdata.tags_currobjlist) do
						subline = subline .. v
						
						if (i < #objlistdata.tags_currobjlist) then
							subline = subline .. ", "
						end
					end
				end
				
				if (string.len(subline) == 0) then
					subline = langtext("editor_objectlist_search_none")
				end
				
				writetext(subline,0,1.5 * f_tilesize,ymult * f_tilesize,name,false,2,nil,nil,nil,nil,nil,true)
				
				local xmaxdim = 15
				local ymaxdim = 9
				
				local yoff = ymult * f_tilesize
				local xoff = f_tilesize * 0.5 + 6
				local tsize = 36
				
				for a=1,xmaxdim do
					for b=1,(ymaxdim+1) do
						local backid = MF_currobjlist_back(xoff + a * tsize, yoff + b * tsize, 1)
					end
				end
				
				if (total > 0) then
					local x = 1
					local y = 1
					
					local ydim = math.floor(math.sqrt(total))
					local xdim = math.floor(total / ydim)
					
					ydim = math.min(ymaxdim, ydim)
					local maxtotal = xdim * ydim
					
					while (total > maxtotal) do
						xdim = xdim + 1
						maxtotal = xdim * ydim
					end
					
					local struct = {}
					
					MF_setobjlisttopleft(tsize + xoff,tsize + yoff)
					
					for i=1,total do
						local iddata = editor_objects[i]
						local id = iddata.objlistid
						local oid = iddata.databaseid
						
						local gx = x
						local gy = y
						
						local obj = editor_currobjlist[oid]
						
						if (editor2.values[DOPAIRS] == 1) then
							if (obj.grid_overlap ~= nil) then
								local gridpos = obj.grid_overlap
								gx = gridpos[1] + 1
								gy = gridpos[2] + 1
							end
						elseif (editor2.values[DOPAIRS] == 0) then
							if (obj.grid_full ~= nil) then
								local gridpos = obj.grid_full
								gx = gridpos[1] + 1
								gy = gridpos[2] + 1
							end
						end
						
						local v = editor_objlist[id]
						local name = getactualdata_objlist(obj.object, "name")
						
						local objword = editor2.values[OBJECTWORDSWAP]
						local objwords = {["object"] = 0, ["text"] = 1}
						local ut = objwords[v.unittype] or 0
						local valid = true
						
						if (editor2.values[DOPAIRS] == 1) and ((v.unpaired == nil) or (v.unpaired == false)) and ((obj.pair ~= nil) and (obj.pair ~= 0)) then
							if (v.type == 0) and (ut ~= objword) then
								valid = false
							end
						end
						
						if valid then
							local buttonfunc = tostring(oid) .. "," .. name .. "," .. tostring(i)
							local bid = createbutton_objlist(buttonfunc,gx * tsize + xoff,gy * tsize + yoff,name,3,2,buttonid,2)
							MF_setbuttongrid(bid,gx - 1,gy - 1,obj.object)
							
							local imagefile = getactualdata_objlist(obj.object, "sprite")
							local ut = getactualdata_objlist(obj.object, "unittype")
							local root = getactualdata_objlist(obj.object, "sprite_in_root")
							local c = {}
							
							if (ut == "object") then
								c = getactualdata_objlist(obj.object, "colour")
							elseif (ut == "text") then
								c = getactualdata_objlist(obj.object, "active")
							end
							
							if (root == nil) then
								root = true
							end
							
							local c1 = c[1] or 0
							local c2 = c[2] or 3
							
							local folder = "Sprites/"
							
							if (root == false) then
								local world = generaldata.strings[WORLD]
								folder = "Worlds/" .. world .. "/Sprites/"
							end
							
							--MF_alert(name .. ", " .. obj.object .. ", " .. imagefile)
							imagefile = imagefile .. "_0_1"
							MF_thumbnail(folder,imagefile,i-1,0,0,bid,c1,c2,0,0,buttonid,obj.object)
							
							x = x + 1
							
							if (x > xdim) then
								x = 1
								y = y + 1
							end
						end
					end
				end
				
				if (generaldata.strings[BUILD] ~= "n") then
					local dir = editor.values[EDITORDIR]
					
					local dir_x = screenw - f_tilesize * 5
					local dir_y = f_tilesize * 7.6
					
					createbutton("dir_right",dir_x + f_tilesize * 2.5,dir_y,2,2.5,2.5,"",name,3,2,buttonid,nil,nil,langtext("tooltip_currobjlist_dir_right",true),bicons.r_arrow)
					createbutton("dir_up",dir_x,dir_y - f_tilesize * 2.5,2,2.5,2.5,"",name,3,2,buttonid,nil,nil,langtext("tooltip_currobjlist_dir_up",true),bicons.u_arrow)
					createbutton("dir_left",dir_x - f_tilesize * 2.5,dir_y,2,2.5,2.5,"",name,3,2,buttonid,nil,nil,langtext("tooltip_currobjlist_dir_left",true),bicons.l_arrow)
					createbutton("dir_down",dir_x,dir_y + f_tilesize * 2.5,2,2.5,2.5,"",name,3,2,buttonid,nil,nil,langtext("tooltip_currobjlist_dir_down",true),bicons.d_arrow)
					
					makeselection({"dir_right","dir_up","dir_left","dir_down"},dir + 1)
				end
				
				local dir_x = screenw - f_tilesize * 5
				local dir_y = f_tilesize * 4.6
				
				--table.insert(dynamic_structure, {{"currobjlist","custom"}})
				
				local x = screenw - f_tilesize * 7
				local y = f_tilesize * 14.5
				
				if (generaldata.strings[BUILD] ~= "n") then
					controlicon_editor("gamepad_currobjlist","tooltip",x,y,buttonid,langtext("buttons_currobjlist_tooltip",true))
					
					y = y - f_tilesize * 1.25
					
					controlicon_editor("gamepad_currobjlist","swap",x,y,buttonid,langtext("buttons_currobjlist_swap",true))
					
					y = y - f_tilesize * 1.25
					
					controlicon_editor("gamepad_currobjlist","drag",x,y,buttonid,langtext("buttons_currobjlist_drag",true))
					
					y = y - f_tilesize * 1.25
					
					controlicon_editor("gamepad_currobjlist","select",x,y,buttonid,langtext("buttons_currobjlist_select",true))
				else
					x = screenw - f_tilesize * 5
					y = f_tilesize * 13
					
					controlicon_editor("gamepad_currobjlist","x",x + f_tilesize,y,buttonid,"buttons_currobjlist",0,true)
					controlicon_editor("gamepad_currobjlist","y",x,y - f_tilesize,buttonid,"buttons_currobjlist",1,true)
					controlicon_editor("gamepad_currobjlist","b",x - f_tilesize,y,buttonid,"buttons_currobjlist",2,true)
					controlicon_editor("gamepad_currobjlist","a",x,y + f_tilesize,buttonid,"buttons_currobjlist",3,true)
				end
				
				x = screenw - f_tilesize * 6
				y = f_tilesize * 4
				
				controlicon_editor("gamepad_currobjlist","scrollleft",x - f_tilesize,y,buttonid,langtext("buttons_currobjlist_scrollleft",true),2)
				controlicon_editor("gamepad_currobjlist","scrollright",x + f_tilesize,y,buttonid,langtext("buttons_currobjlist_scrollright",true),0)
				
				controlicon_editor("gamepad_currobjlist","autoadd",x - f_tilesize,y + f_tilesize * 2,buttonid,langtext("buttons_currobjlist_autoadd",true),2)
				controlicon_editor("gamepad_editor","scrollright_hotbar",x + f_tilesize,y + f_tilesize * 2,buttonid,langtext("buttons_currobjlist_removesearch",true),0)
				
				dir_y = f_tilesize * 5 + f_tilesize * 5
				
				if (string.len(editor4.strings[EDITOR_CURROBJTARGET]) > 0) then
					MF_positioncurrobjselector(editor4.strings[EDITOR_CURROBJTARGET])
					editor4.strings[EDITOR_CURROBJTARGET] = ""
				end
				
				buildmenustructure(dynamic_structure)
			end,
		leave = 
			function(parent,name)
				MF_clearthumbnails("CurrentObjectList")
				MF_currobjlist_backdel()
			end,
	},
	currobjlist_update =
	{
		button = "EditorObjectList_update",
		enter = 
			function(parent,name,buttonid,extra)
				MF_clearthumbnails("")
			end,
	},
	currobjlist_update_objects =
	{
		button = "EditorObjectList_update_objects",
		enter = 
			function(parent,name,buttonid,extra)
				local total = #editor_objects
				
				for i=1,total do
					local iddata = editor_objects[i]
					local id = iddata.objlistid
					local oid = iddata.databaseid
					
					local data = editor_objlist[id]
					local obj = editor_currobjlist[oid]
					
					local name = obj.name
					
					local objword = editor2.values[OBJECTWORDSWAP]
					local objwords = {["object"] = 0, ["text"] = 1}
					local ut = objwords[data.unittype] or 0
					
					if (obj.pair ~= nil) and (obj.pair ~= 0) and (ut ~= objword) then
						local buttonfunc = tostring(oid) .. "," .. name .. "," .. tostring(i)
						local objbuttonid = MF_getobjbuttonid(buttonfunc)
						
						if (objbuttonid ~= 0) then
							MF_clearthumbnail_withowner(objbuttonid)
							local objbutton = mmf.newObject(objbuttonid)
							
							local pairobjid = obj.pair
							local pairobj = editor_currobjlist[pairobjid]
							local v = editor_objlist[pairobj.id]
							
							local tempid = 0
							for a,b in ipairs(editor_objects) do
								if (b.databaseid == obj.pair) then
									tempid = a
									break
								end
							end
							
							if (tempid > 0) then
								local newbuttonfunc = tostring(obj.pair) .. "," .. pairobj.name .. "," .. tostring(tempid)
								objbutton.strings[BUTTONFUNC] = newbuttonfunc
								
								local imagefile = getactualdata_objlist(pairobj.object, "sprite")
								local c = {}
								local ut_ = getactualdata_objlist(pairobj.object, "unittype")
								
								if (ut_ == "object") then
									c = getactualdata_objlist(pairobj.object, "colour")
								elseif (ut_ == "text") then
									c = getactualdata_objlist(pairobj.object, "active")
								end
								
								local c1 = c[1] or 0
								local c2 = c[2] or 3
								
								imagefile = imagefile .. "_0_1"
								MF_thumbnail("Sprites/",imagefile,i-1,0,0,objbuttonid,c1,c2,0,0,"CurrentObjectList",pairobj.object)
							end
						end
					end
				end
				
				closemenu()
			end,
	},
	playlevels_single_deleteconfirm =
	{
		button = "SingleDeleteConfirm",
		escbutton = "no",
		enter = 
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = screenh * 0.5 - f_tilesize * 3
				
				writetext(langtext("customlevels_deleteconfirm_single"),0,x,y,name,true)
				
				y = y + f_tilesize * 2
				
				createbutton("yes",x,y,2,16,1,langtext("yes"),name,3,2,buttonid)
				
				y = y + f_tilesize * 2
				
				createbutton("no",x,y,2,16,1,langtext("no"),name,3,2,buttonid)
			end,
		structure =
		{
			{
				{{"yes"},},
				{{"no"},},
			},
		}
	},
	playlevels_pack_deleteconfirm =
	{
		button = "PackDeleteConfirm",
		escbutton = "no",
		enter = 
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = screenh * 0.5 - f_tilesize * 3
				
				writetext(langtext("customlevels_deleteconfirm_pack"),0,x,y,name,true)
				
				y = y + f_tilesize * 2
				
				createbutton("yes",x,y,2,16,1,langtext("yes"),name,3,2,buttonid)
				
				y = y + f_tilesize * 2
				
				createbutton("no",x,y,2,16,1,langtext("no"),name,3,2,buttonid)
			end,
		structure =
		{
			{
				{{"yes"},},
				{{"no"},},
			},
		}
	},
	mobile_tuto1 =
	{
		button = "MobileTuto1",
		escbutton = "ok",
		enter = 
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = screenh * 0.5 - f_tilesize * 3
				
				MF_menubackground(1)
				editor.values[EDITORDELAY] = 10
				editor2.values[MENU_YPOS] = 0
				
				writetext(langtext("mobile_tuto1a"),0,x,y - f_tilesize * 2,name,true)
				writetext(langtext("mobile_tuto1b"),0,x,y,name,true)
				writetext(langtext("mobile_tuto1c"),0,x,y + f_tilesize * 2,name,true)
				
				y = y + f_tilesize * 6
				
				createbutton("ok",x,y,2,16,4,langtext("tutorial_continue"),name,3,2,buttonid)
			end,
		structure =
		{
			{
				{{"ok"},},
			},
		}
	},
	mobile_tuto2 =
	{
		button = "MobileTuto2",
		escbutton = "ok",
		enter = 
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = screenh * 0.5 - f_tilesize * 3
				
				MF_menubackground(1)
				editor.values[EDITORDELAY] = 10
				editor2.values[MENU_YPOS] = 0
				
				writetext(langtext("mobile_tuto2a"),0,x,y - f_tilesize * 2,name,true)
				writetext(langtext("mobile_tuto2b"),0,x,y,name,true)
				writetext(langtext("mobile_tuto2c"),0,x,y + f_tilesize * 2,name,true)
				
				y = y + f_tilesize * 6
				
				createbutton("ok",x,y,2,16,4,langtext("tutorial_continue"),name,3,2,buttonid)
			end,
		structure =
		{
			{
				{{"ok"},},
			},
		}
	},
	reportlevel_confirm =
	{
		button = "ReportLevelConfirm",
		escbutton = "no",
		enter = 
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = screenh * 0.5 - f_tilesize * 2
				
				writetext(langtext("reportlevel_confirm"),0,x,y,name,true)
				
				y = y + f_tilesize * 2
				
				createbutton("no",x,y,2,16,1,langtext("no"),name,3,2,buttonid)
				
				y = y + f_tilesize
				
				createbutton("yes",x,y,2,16,1,langtext("yes"),name,3,2,buttonid)
			end,
		structure =
		{
			{
				{{"no"},},
				{{"yes"},},
			},
		}
	},
	reportlevel_result =
	{
		button = "ReportLevel",
		escbutton = "return",
		enter = 
			function(parent,name,buttonid,result)
				local x = screenw * 0.5
				local y = screenh * 0.5 - f_tilesize * 3
				
				if (result == 1) then
					writetext(langtext("reportlevel_success"),0,x,y,name,true)
				elseif (result == 0) then
					writetext(langtext("reportlevel_fail"),0,x,y,name,true)
				end
				
				y = y + f_tilesize * 2
				
				createbutton("return",x,y,2,16,1,langtext("reportlevel_ok"),name,3,2,buttonid)
			end,
		structure =
		{
			{
				{{"return"},},
			},
		}
	},
	playlevels_featured_wait =
	{
		button = "FeaturedWait",
		enter = 
			function(parent,name,buttonid,page_)
				local x = screenw * 0.5
				local y = screenh * 0.5 - f_tilesize * 3
				
				createbutton("return",x,y,2,16,1,langtext("return"),name,3,1,buttonid)
			
				y = y + f_tilesize * 2
				
				writetext(langtext("playlevels_featured_wait"),0,x,y,name,true)
				
				local dynamic_structure = {{{"return"}}}
				
				local total = generaldata3.values[LEVELCOUNT]
				editor2.values[MENU_YDIM] = total
				local page = page_ or 0
				local amount = 6
				local maxpage = math.floor((total-1) / amount)
				page = math.min(page, maxpage)
				
				editor2.values[MENU_XDIM] = 1
				
				local cannot_scroll_left = true
				local cannot_scroll_left2 = true
				local cannot_scroll_right = true
				local cannot_scroll_right2 = true
				
				if (page > 0) then
					cannot_scroll_left = false
				end
				
				if (page > 4) then
					cannot_scroll_left2 = false
				end
				
				if (page < maxpage) then
					cannot_scroll_right = false
				end
				
				if (page < maxpage - 4) then
					cannot_scroll_right2 = false
				end
				
				if (maxpage > 0) then
					createbutton("scroll_left",screenw * 0.5 - f_tilesize * 4,screenh - f_tilesize * 1.2,2,2,2,"",name,3,2,buttonid,cannot_scroll_left,nil,nil,bicons.l_arrow)
					createbutton("scroll_left2",screenw * 0.5 - f_tilesize * 7,screenh - f_tilesize * 1.2,2,2,2,"",name,3,2,buttonid,cannot_scroll_left,nil,nil,bicons.dl_arrow)
					createbutton("scroll_right",screenw * 0.5 + f_tilesize * 4,screenh - f_tilesize * 1.2,2,2,2,"",name,3,2,buttonid,cannot_scroll_right,nil,nil,bicons.r_arrow)
					createbutton("scroll_right2",screenw * 0.5 + f_tilesize * 7,screenh - f_tilesize * 1.2,2,2,2,"",name,3,2,buttonid,cannot_scroll_right,nil,nil,bicons.dr_arrow)
				
					writetext(langtext("editor_spritelist_page") .. ": " .. tostring(page + 1) .. "/" .. tostring(maxpage + 1),0,screenw * 0.5,screenh - f_tilesize * 1.2,name,true,2)
					
					table.insert(dynamic_structure, {{"scroll_left2"},{"scroll_left"},{"scroll_right"},{"scroll_right2"},})
				end
				
				makeselection({"","remove"},editor.values[STATE] + 1)
				
				local mypos = editor2.values[MENU_YPOS]
				local mxdim = #dynamic_structure[#dynamic_structure]
				
				if (mypos > 0) and (mypos < #dynamic_structure - 1) then
					editor2.values[MENU_XPOS] = math.min(editor2.values[MENU_XPOS], mxdim - 1)
					editor2.values[MENU_YPOS] = #dynamic_structure - 1
				elseif (mypos > 0) and (mypos >= #dynamic_structure - 1) then
					editor2.values[MENU_XPOS] = math.min(editor2.values[MENU_XPOS], mxdim - 1)
					editor2.values[MENU_YPOS] = math.min(editor2.values[MENU_YPOS], #dynamic_structure - 1)
				else
					editor2.values[MENU_XPOS] = 0
					editor2.values[MENU_YPOS] = 0
				end
				
				buildmenustructure(dynamic_structure)
			end,
	},
	editorbeta_warning =
	{
		button = "Warning",
		escbutton = "return",
		enter = 
			function(parent,name,buttonid,result)
				local x = screenw * 0.5
				local y = screenh * 0.5 - f_tilesize * 7
				
				writetext(langtext("editorbeta_warning_1a"),0,x,y,name,true,1)
				
				y = y + f_tilesize * 1
				
				local text = wordwrap(langtext("editorbeta_warning_1b",true),screenw * 0.75,true)
				for i,v in ipairs(text) do
					writetext(v,0,x,y,name,true,1)
					y = y + f_tilesize * 1
				end
				
				y = y + f_tilesize * 1.5
				
				text = wordwrap(langtext("editorbeta_warning_1c",true),screenw * 0.75,true)
				for i,v in ipairs(text) do
					writetext(v,0,x,y,name,true,1)
					y = y + f_tilesize * 1
				end
				
				y = y + f_tilesize * 1.5
				
				text = wordwrap(langtext("editorbeta_warning_1d",true),screenw * 0.75,true)
				for i,v in ipairs(text) do
					writetext(v,0,x,y,name,true,1)
					y = y + f_tilesize * 1
				end
				
				y = y + f_tilesize * 1
				
				createbutton("return",x,y,2,16,1,langtext("return"),name,3,2,buttonid)
			end,
		structure =
		{
			{
				{{"return"},},
			},
		}
	},
	upload_do_ask =
	{
		button = "UploadConfirm2",
		escbutton = "no",
		enter = 
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = screenh * 0.5 - f_tilesize * 2
				
				writetext(langtext("editor_upload_confirm"),0,x,y,name,true)
				
				y = y + f_tilesize * 2
				
				createbutton("yes",x,y,2,16,1,langtext("yes"),name,3,2,buttonid)
				
				y = y + f_tilesize
				
				createbutton("no",x,y,2,16,1,langtext("no"),name,3,2,buttonid)
			end,
		structure =
		{
			{
				{{"yes"},},
				{{"no"},},
			},
		}
	},
}

menudata_customscript =
{
	worldlist =
		function(parent,name,buttonid,page_)
		end,
	spritelist =
		function(parent,name,buttonid,data)
			local x = screenw * 0.5
			local y = f_tilesize * 1.5
			
			createbutton("return",x,y,2,16,1,langtext("return"),name,3,1,buttonid)
			
			y = y + f_tilesize * 2
			
			writetext(langtext("editor_spritelist_title") .. ":",0,x,y,name,true,2)
			
			y = y + f_tilesize * 2
			
			local search = editor2.strings[SEARCHSTRING]
			
			local world = generaldata.strings[WORLD]
			
			local generalsprites = MF_filelist("Data/Sprites/","*_0_1.png")
			local generalsprites2 = {}
			local generalsprites3 = {}
			local generalsprites4 = {}
			local generalsprites5 = {}
			
			local worldsprites = MF_filelist("Data/Worlds/" .. world .. "/Sprites/","*_0_1.png")
			local worldsprites2 = {}
			local worldsprites3 = {}
			local worldsprites4 = {}
			local worldsprites5 = {}
			
			local full = data[2] or 0
			
			if (full == 1) then
				generalsprites2 = MF_filelist("Data/Sprites/","*_8_1.png")
				generalsprites3 = MF_filelist("Data/Sprites/","*_16_1.png")
				generalsprites4 = MF_filelist("Data/Sprites/","*_24_1.png")
				generalsprites5 = MF_filelist("Data/Sprites/","icon_*.png")
				
				worldsprites2 = MF_filelist("Data/Worlds/" .. world .. "/Sprites/","*_8_1.png")
				worldsprites3 = MF_filelist("Data/Worlds/" .. world .. "/Sprites/","*_16_1.png")
				worldsprites4 = MF_filelist("Data/Worlds/" .. world .. "/Sprites/","*_24_1.png")
				worldsprites5 = MF_filelist("Data/Worlds/" .. world .. "/Sprites/","icon_*.png")
			end
			
			local sprites = {}
			local sprites_ = {}
			
			for i,v in ipairs(generalsprites) do
				if (string.sub(v, 1, 5) == "text_") then
					table.insert(sprites_, string.sub(v, 6) .. "_TEXT_")
				elseif (string.sub(v, 1, 5) ~= "icon_") or (full == 1) then
					table.insert(sprites_, v)
				end
			end
			
			if (full == 1) then
				for i,v in ipairs(generalsprites2) do
					if (string.sub(v, 1, 5) == "text_") then
						table.insert(sprites_, string.sub(v, 6) .. "_TEXT_")
					else
						table.insert(sprites_, v)
					end
				end
				
				for i,v in ipairs(generalsprites3) do
					if (string.sub(v, 1, 5) == "text_") then
						table.insert(sprites_, string.sub(v, 6) .. "_TEXT_")
					else
						table.insert(sprites_, v)
					end
				end
				
				for i,v in ipairs(generalsprites4) do
					if (string.sub(v, 1, 5) == "text_") then
						table.insert(sprites_, string.sub(v, 6) .. "_TEXT_")
					else
						table.insert(sprites_, v)
					end
				end
				
				for i,v in ipairs(generalsprites5) do
					if (string.sub(v, 1, 5) == "text_") then
						table.insert(sprites_, string.sub(v, 6) .. "_TEXT_")
					else
						table.insert(sprites_, v)
					end
				end
			end
			
			if (#sprites_ > 0) then
				table.sort(sprites_)
			end
			
			local worldsprite_cutoff = #sprites_
			local wsprites_ = {}
			
			for i,v in ipairs(worldsprites) do
				if (string.sub(v, 1, 5) == "text_") then
					table.insert(wsprites_, string.sub(v, 6) .. "_TEXT_")
				elseif (string.sub(v, 1, 5) ~= "icon_") or (full == 1) then
					table.insert(wsprites_, v)
				end
			end
			
			if (full == 1) then
				for i,v in ipairs(worldsprites2) do
					if (string.sub(v, 1, 5) == "text_") then
						table.insert(wsprites_, string.sub(v, 6) .. "_TEXT_")
					else
						table.insert(wsprites_, v)
					end
				end
				
				for i,v in ipairs(worldsprites3) do
					if (string.sub(v, 1, 5) == "text_") then
						table.insert(wsprites_, string.sub(v, 6) .. "_TEXT_")
					else
						table.insert(wsprites_, v)
					end
				end
				
				for i,v in ipairs(worldsprites4) do
					if (string.sub(v, 1, 5) == "text_") then
						table.insert(wsprites_, string.sub(v, 6) .. "_TEXT_")
					else
						table.insert(wsprites_, v)
					end
				end
				
				for i,v in ipairs(worldsprites5) do
					if (string.sub(v, 1, 5) == "text_") then
						table.insert(wsprites_, string.sub(v, 6) .. "_TEXT_")
					else
						table.insert(wsprites_, v)
					end
				end
			end
			
			if (#wsprites_ > 0) then
				table.sort(wsprites_)
				
				for i,v in ipairs(wsprites_) do
					table.insert(sprites_, v)
				end
			end
			
			if (string.len(search) == 0) then
				sprites = sprites_
			else
				for i,v in ipairs(sprites_) do
					if (string.find(v, search) ~= nil) then
						table.insert(sprites, v)
					end
				end
			end
			
			if (#sprites == 0) then
				writetext(langtext("editor_spritelist_none"),0,x,y,name,true,2)
			end
			
			local amount = 80
			local maxpage = math.floor((#sprites-1) / amount)
			local page = data[1] or 0
			page = MF_setpagemenu(name)
			page = math.min(maxpage, page)
			
			editor3.values[MAXPAGE] = maxpage
			
			local page_min,page_max = 0,0
			page_min = page * amount
			page_max = math.min(((page + 1) * amount) - 1, #sprites - 1)
			
			local dynamic_structure = {{{"return"}}}
			local curr_dynamic_structure = {}
			
			if (#sprites > 0) then
				table.insert(dynamic_structure, {})
				curr_dynamic_structure = dynamic_structure[#dynamic_structure]
			end
			
			local by_ = -1
			
			if (#sprites > 0) then
				local i_ = 1
				for i=page_min,page_max do
					local v = sprites[i + 1]
					
					if (string.sub(v, -6) == "_TEXT_") then
						v = "text_" .. string.sub(v, 1, string.len(v) - 6)
					end
					
					local spritefile = v
					local spritename = string.sub(v, 1, string.len(v) - 4)
					local spriteid = spritename .. tostring(i)
					
					--MF_alert(tostring(i) .. ", " .. v)
					
					local unitid = MF_create("Editor_spritebutton")
					local unit = mmf.newObject(unitid)
					unit.strings[BUTTONNAME] = spritename
					unit.strings[BUTTONFUNC] = spriteid
					unit.layer = 2
					
					local path = "Data/Sprites/"
					unit.values[MODE] = 1
					if (i >= worldsprite_cutoff) then
						unit.values[MODE] = 0
						path = "Data/Worlds/" .. world .. "/Sprites/"
					end
					
					local bx,by = spritelist(unitid,i_ - 1)
					
					if (by_ ~= by) then
						if (by_ ~= -1) then
							table.insert(dynamic_structure, {})
							curr_dynamic_structure = dynamic_structure[#dynamic_structure]
						end
						
						by_ = by
					end
					
					table.insert(curr_dynamic_structure, {spriteid,"cursor"})
					
					local thumbid = MF_specialcreate("Editor_thumbnail_sprite")
					local thumb = mmf.newObject(thumbid)
					thumb.values[OWNER] = unitid
					thumb.layer = 2
					thumb.strings[BUTTONID] = buttonid
					
					--MF_alert(path .. spritefile)
					
					MF_thumbnail_loadimage(thumbid,0,i_-1,path .. spritefile)
					
					i_ = i_ + 1
				end
			end
			
			editor2.values[MENU_XDIM] = 1
			editor2.values[MENU_YDIM] = 1
			
			local cannot_scroll_left = true
			local cannot_scroll_left2 = true
			local cannot_scroll_right = true
			local cannot_scroll_right2 = true
			
			if (page > 0) then
				cannot_scroll_left = false
			end
			
			if (page > 4) then
				cannot_scroll_left2 = false
			end
			
			if (page < maxpage) then
				cannot_scroll_right = false
			end
			
			if (page < maxpage - 4) then
				cannot_scroll_right2 = false
			end
			
			local dynamic_structure_row = {}
			table.insert(dynamic_structure_row, {"search"})
			
			if (maxpage > 0) then
				createbutton("scroll_left",screenw * 0.5 - f_tilesize * 4,screenh - f_tilesize * 2,2,2,2,"",name,3,2,buttonid,cannot_scroll_left,nil,nil,bicons.l_arrow)
				createbutton("scroll_left2",screenw * 0.5 - f_tilesize * 7,screenh - f_tilesize * 2,2,2,2,"",name,3,2,buttonid,cannot_scroll_left,nil,nil,bicons.dl_arrow)
				createbutton("scroll_right",screenw * 0.5 + f_tilesize * 4,screenh - f_tilesize * 2,2,2,2,"",name,3,2,buttonid,cannot_scroll_right,nil,nil,bicons.r_arrow)
				createbutton("scroll_right2",screenw * 0.5 + f_tilesize * 7,screenh - f_tilesize * 2,2,2,2,"",name,3,2,buttonid,cannot_scroll_right,nil,nil,bicons.dr_arrow)
			
				writetext(langtext("editor_spritelist_page") .. ": " .. tostring(page + 1) .. "/" .. tostring(maxpage + 1),0,screenw * 0.5,screenh - f_tilesize * 2,name,true,2)
				
				table.insert(dynamic_structure_row, {"scroll_left2"})
				table.insert(dynamic_structure_row, {"scroll_left"})
				table.insert(dynamic_structure_row, {"scroll_right"})
				table.insert(dynamic_structure_row, {"scroll_right2"})
			end
			
			table.insert(dynamic_structure_row, {"removesearch"})
			table.insert(dynamic_structure, dynamic_structure_row)
			
			createbutton("search",screenw * 0.5 - f_tilesize * 13,screenh - f_tilesize * 2,2,8,1,langtext("editor_levellist_search"),name,3,2,buttonid)
			
			local disableremovesearch = true
			if (string.len(editor2.strings[SEARCHSTRING]) > 0) then
				disableremovesearch = false
			end
			
			createbutton("removesearch",screenw * 0.5 + f_tilesize * 13,screenh - f_tilesize * 2,2,8,1,langtext("editor_levellist_removesearch"),name,3,2,buttonid,disableremovesearch)
			
			local mypos = editor2.values[MENU_YPOS]
			local mxdim = #dynamic_structure[#dynamic_structure]
			
			if (mypos > 0) and (mypos < #dynamic_structure - 1) then
				editor2.values[MENU_XPOS] = math.min(editor2.values[MENU_XPOS], mxdim - 1)
				editor2.values[MENU_YPOS] = #dynamic_structure - 1
			elseif (mypos > 0) and (mypos >= #dynamic_structure - 1) then
				editor2.values[MENU_XPOS] = math.min(editor2.values[MENU_XPOS], mxdim - 1)
				editor2.values[MENU_YPOS] = math.min(editor2.values[MENU_YPOS], #dynamic_structure - 1)
			else
				editor2.values[MENU_XPOS] = 0
				editor2.values[MENU_YPOS] = 0
			end
			
			buildmenustructure(dynamic_structure)
		end,
	themelist =
		function(parent,name,buttonid,extra)
			local x = screenw * 0.5
			local y = f_tilesize * 1.5
			
			local menutype = extra or false
			
			if (menutype == false) then
				createbutton("return",x,y,2,16,1,langtext("return"),name,3,1,buttonid)
			else
				createbutton("return",x,y,2,16,1,langtext("editor_theme_done"),name,3,1,buttonid)
			end
			
			y = y + f_tilesize * 2
			
			if (buttonid == "ThemeLoad") then
				writetext(langtext("editor_theme_themeload") .. ":",0,x,y,name,true,2)
			elseif (buttonid == "ThemeDelete") then
				writetext(langtext("editor_theme_themedelete") .. ":",0,x,y,name,true,2)
			end
			
			y = y + f_tilesize * 2
			
			local world = generaldata.strings[WORLD]
			
			local themes = MF_filelist("Data/Themes/","*.txt")
			local worldthemes = MF_filelist("Data/Worlds/" .. world .. "/Themes/","*.txt")
			
			if ((#themes == 0) and (#worldthemes == 0)) or ((buttonid == "ThemeDelete") and (#worldthemes == 0)) then
				writetext(langtext("editor_theme_none"),0,x,y,name,true,2)
			end
			
			local dynamic_structure = {{{"return"}}}
			local curr_dynamic_structure = {}
			
			x = x - f_tilesize * 5
			local x_ = 0
			local y_ = 0
			
			table.insert(dynamic_structure, {})
			curr_dynamic_structure = dynamic_structure[#dynamic_structure]
			
			if (buttonid ~= "ThemeDelete") then
				for i,v in ipairs(themes) do
					local themefile = v
					MF_setfile("level","Data/Themes/" .. v)
					
					local themename = MF_read("level","general","name")
					local themebutton = v .. ",1"
					local vname = langtext("themes_" .. string.lower(themename),true,true)
					if (#vname == 0) then
						vname = themename
					end
					
					createbutton(themebutton,x + x_ * f_tilesize * 10,y + y_ * f_tilesize,2,8,1,vname,name,3,2,buttonid)
					
					table.insert(curr_dynamic_structure, {themebutton})
					
					x_ = x_ + 1
					
					if (x_ > 1) and ((#worldthemes > 0) or (i < #themes)) then
						x_ = 0
						y_ = y_ + 1
						
						table.insert(dynamic_structure, {})
						curr_dynamic_structure = dynamic_structure[#dynamic_structure]
					end
				end
			end
			
			for i,v in ipairs(worldthemes) do
				local themefile = v
				MF_setfile("level","Data/Worlds/" .. world .. "/Themes/" .. v)
				
				local themename = MF_read("level","general","name")
				local themebutton = v .. ",0"
				local vname = langtext("themes_" .. string.lower(themename),true,true)
				if (#vname == 0) then
					vname = themename
				end
				
				createbutton(themebutton,x + x_ * f_tilesize * 10,y + y_ * f_tilesize,2,8,1,vname .. " (U)",name,3,2,buttonid)
				
				table.insert(curr_dynamic_structure, {themebutton})
				
				x_ = x_ + 1
				
				if (x_ > 1) and (i < #worldthemes) then
					x_ = 0
					y_ = y_ + 1
					
					table.insert(dynamic_structure, {})
					curr_dynamic_structure = dynamic_structure[#dynamic_structure]
				end
			end
			
			if (#editor_currobjlist == 0) then
				editor3.values[NOTHEMECONFIRM] = 1
			end
			
			local level = generaldata.strings[CURRLEVEL]
			MF_setfile("level","Data/Worlds/" .. world .. "/" .. level .. ".ld")
			
			editor2.values[MENU_XPOS] = 0
			editor2.values[MENU_YPOS] = 0
			editor2.values[MENU_XDIM] = 1
			editor2.values[MENU_YDIM] = math.floor((#themes + #worldthemes) / 2) + 1
			
			buildmenustructure(dynamic_structure)
		end,
	palettelist =
		function(parent,name,buttonid)
			local x = screenw * 0.5
			local y = f_tilesize * 1.5
			
			createbutton("return",x,y,2,16,1,langtext("return"),name,3,1,buttonid)
			
			y = y + f_tilesize * 2
			
			writetext(langtext("editor_palette_select") .. ":",0,x,y,name,true,2)
			
			y = y + f_tilesize * 2
			
			local world = generaldata.strings[WORLD]
			
			local opts = MF_filelist("Data/Palettes/","*.png")
			local worldopts = MF_filelist("Data/Worlds/" .. world .. "/Palettes/","*.png")
			
			if (#opts == 0) and (#worldopts == 0) then
				writetext(langtext("editor_palette_none"),0,x,y,name,true,2)
			end
			
			local paletteid = MF_specialcreate("Editor_colourselector")
			local palette = mmf.newObject(paletteid)
			
			palette.layer = 2
			palette.x = screenw * 0.5 + f_tilesize * 10
			palette.y = screenh * 0.5 - f_tilesize * 3
			palette.scaleX = 24
			palette.scaleY = 24
			palette.visible = false
			
			palette.values[3] = palette.x
			palette.values[4] = palette.y
			
			local dynamic_structure = {{{"return"}}}
			local curr_dynamic_structure = {}
			
			x = x - f_tilesize * 10
			local x_ = 0
			local y_ = 0
			
			table.insert(dynamic_structure, {})
			curr_dynamic_structure = dynamic_structure[#dynamic_structure]
			
			for i,v in ipairs(opts) do
				local optbutton = v .. ",1"
				local optname = string.sub(v, 1, string.len(v) - 4)
				local vname = langtext("palettes_" .. optname,true,true)
				if (#vname == 0) then
					vname = optname
				end
				
				createbutton(optbutton,x + x_ * f_tilesize * 10,y + y_ * f_tilesize,2,8,1,vname,name,3,2,buttonid)
				
				table.insert(curr_dynamic_structure, {optbutton})
				
				x_ = x_ + 1
				
				if (x_ > 1) and ((#worldopts > 0) or (i < #opts)) then
					x_ = 0
					y_ = y_ + 1
					
					table.insert(dynamic_structure, {})
					curr_dynamic_structure = dynamic_structure[#dynamic_structure]
				end
			end
			
			for i,v in ipairs(worldopts) do
				local optbutton = v .. ",0"
				local optname = string.sub(v, 1, string.len(v) - 4)
				local vname = langtext("palettes_" .. optname,true,true)
				if (#vname == 0) then
					vname = optname
				end
				
				createbutton(optbutton,x + x_ * f_tilesize * 10,y + y_ * f_tilesize,2,8,1,vname .. " (U)",name,3,2,buttonid)
				
				table.insert(curr_dynamic_structure, {optbutton})
				
				x_ = x_ + 1
				
				if (x_ > 1) and (i < #worldopts) then
					x_ = 0
					y_ = y_ + 1
					
					table.insert(dynamic_structure, {})
					curr_dynamic_structure = dynamic_structure[#dynamic_structure]
				end
			end
			
			editor2.values[MENU_XPOS] = 0
			editor2.values[MENU_YPOS] = 0
			editor2.values[MENU_XDIM] = 1
			editor2.values[MENU_YDIM] = math.floor((#opts + #worldopts) / 2) + 1
			
			buildmenustructure(dynamic_structure)
		end,
	musiclist =
		function(parent,name,buttonid)
			local x = screenw * 0.5
			local y = f_tilesize * 1.5
			
			createbutton("return",x,y,2,16,1,langtext("return"),name,3,1,buttonid)
			
			y = y + f_tilesize * 2
			
			writetext(langtext("editor_music_select") .. ":",0,x,y,name,true,2)
			
			y = y + f_tilesize * 2
			
			local world = generaldata.strings[WORLD]
			
			local opts = MF_filelist("Data/Music/","*.ogg")
			local worldopts = MF_filelist("Data/Worlds/" .. world .. "/Music/","*.ogg")
			
			if (#opts == 0) and (#worldopts == 0) then
				writetext(langtext("editor_music_none"),0,x,y,name,true,2)
			end
			
			local dynamic_structure = {{{"return"}}}
			local curr_dynamic_structure = {}
			
			x = x - f_tilesize * 5
			local x_ = 0
			local y_ = 0
			
			table.insert(dynamic_structure, {})
			curr_dynamic_structure = dynamic_structure[#dynamic_structure]
			
			for i,v in ipairs(opts) do
				local optbutton = v .. ",0"
				local optname = string.sub(v, 1, string.len(v) - 4)
				local vname = langtext("music_" .. optname,true,true)
				if (#vname == 0) then
					vname = optname
				end
				
				createbutton(optbutton,x + x_ * f_tilesize * 10,y + y_ * f_tilesize,2,8,1,vname,name,3,2,buttonid)
				
				table.insert(curr_dynamic_structure, {optbutton})
				
				x_ = x_ + 1
				
				if (x_ > 1) and ((#worldopts > 0) or (i < #opts)) then
					x_ = 0
					y_ = y_ + 1
					
					table.insert(dynamic_structure, {})
					curr_dynamic_structure = dynamic_structure[#dynamic_structure]
				end
			end
			
			for i,v in ipairs(worldopts) do
				local optbutton = v .. ",1"
				local optname = string.sub(v, 1, string.len(v) - 4)
				local vname = langtext("music_" .. optname,true,true)
				if (#vname == 0) then
					vname = optname
				end
				
				createbutton(optbutton,x + x_ * f_tilesize * 10,y + y_ * f_tilesize,2,8,1,vname .. " (U)",name,3,2,buttonid)
				
				table.insert(curr_dynamic_structure, {optbutton})
				
				x_ = x_ + 1
				
				if (x_ > 1) and (i < #worldopts) then
					x_ = 0
					y_ = y_ + 1
					
					table.insert(dynamic_structure, {})
					curr_dynamic_structure = dynamic_structure[#dynamic_structure]
				end
			end
			
			editor2.values[MENU_XPOS] = 0
			editor2.values[MENU_YPOS] = 0
			editor2.values[MENU_XDIM] = 1
			editor2.values[MENU_YDIM] = math.floor((#opts + #worldopts) / 2) + 1
			
			buildmenustructure(dynamic_structure)
		end,
	particleslist =
		function(parent,name,buttonid)
			local x = screenw * 0.5
			local y = f_tilesize * 1.5
			
			createbutton("return",x,y,2,16,1,langtext("return"),name,3,1,buttonid)
			
			y = y + f_tilesize * 2
			
			writetext(langtext("editor_particles_select") .. ":",0,x,y,name,true,2)
			
			y = y + f_tilesize * 2
			
			local world = generaldata.strings[WORLD]
			local opts = {}
			
			table.insert(opts, "none")
			
			for i,v in pairs(particletypes) do
				table.insert(opts, i)
			end
			
			local count = 0
			for i,v in pairs(opts) do
				count = count + 1
			end

			if (count == 0) then
				writetext(langtext("editor_particles_none"),0,x,y,name,true,2)
			end
			
			local dynamic_structure = {{{"return"}}}
			local curr_dynamic_structure = {}
			
			x = x - f_tilesize * 5
			local x_ = 0
			local y_ = 0
			
			table.insert(dynamic_structure, {})
			curr_dynamic_structure = dynamic_structure[#dynamic_structure]
			
			local count_ = 0
			for i,v in ipairs(opts) do
				count_ = count_ + 1
				local vname = langtext("particles_" .. v,true,true)
				if (#vname == 0) then
					vname = v
				end
				
				createbutton(v,x + x_ * f_tilesize * 10,y + y_ * f_tilesize,2,8,1,vname,name,3,2,buttonid)
				
				table.insert(curr_dynamic_structure, {v})
				
				x_ = x_ + 1
				
				if (x_ > 1) and (count_ < count) then
					x_ = 0
					y_ = y_ + 1
					
					table.insert(dynamic_structure, {})
					curr_dynamic_structure = dynamic_structure[#dynamic_structure]
				end
			end
			
			editor2.values[MENU_XPOS] = 0
			editor2.values[MENU_YPOS] = 0
			editor2.values[MENU_XDIM] = 1
			editor2.values[MENU_YDIM] = math.floor(count / 2) + 1
			
			buildmenustructure(dynamic_structure)
		end,
	playlevels_pack =
		function(parent,name,buttonid,page_)
			local x = screenw * 0.5
			local y = f_tilesize * 1.5
			
			createbutton("return",x - f_tilesize * 5,y,2,8,1,langtext("return"),name,3,1,buttonid)
			
			createbutton("remove",x + f_tilesize * 5,y,2,8,1,langtext("customlevels_forget"),name,3,2,buttonid)
			
			y = y + f_tilesize * 2
			
			writetext(langtext("customlevels_pack") .. ":",0,x,y,name,true,1)
			
			local worlds = MF_dirlist("Data/Worlds/*")
			
			editor2.values[MENU_YDIM] = #worlds - 1
			
			local actual_i = 1
			
			for i,v_ in ipairs(worlds) do
				local v = string.sub(v_, 2, string.len(v_) - 1)
				if (v == "levels") then
					table.remove(worlds, i)
					break
				end
			end
			
			for i,v_ in ipairs(worlds) do
				local v = string.sub(v_, 2, string.len(v_) - 1)
				if (v == "baba") then
					table.remove(worlds, i)
					break
				end
			end
			
			local page = page_ or 0
			page = MF_setpagemenu(name)
			local amount = 8
			local maxpage = math.floor((#worlds-1) / amount)
			page = math.min(page, maxpage)
			
			editor3.values[MAXPAGE] = maxpage
			
			local page_min = page * amount
			local page_max = math.min(((page + 1) * amount) - 1, #worlds - 1)
			
			local dynamic_structure = {{{"return"},{"remove"}}}
			local curr_dynamic_structure = {}
			
			x = x - f_tilesize * 8.5
			local x_ = 0
			local y_ = 0
			
			table.insert(dynamic_structure, {})
			curr_dynamic_structure = dynamic_structure[#dynamic_structure]
			
			y = y + f_tilesize * 3
			
			for i=page_min,page_max do
				local v = worlds[i + 1]
				local worldfolder = string.sub(v, 2, string.len(v) - 1)
				
				if (worldfolder ~= "levels") then
					MF_setfile("world","Data/Worlds/" .. worldfolder .. "/world_data.txt")
					
					local worldfolder_ = tostring(actual_i) .. "," .. worldfolder
					
					local prizes = tonumber(MF_read("save",worldfolder .. "_prize","total")) or 0
					local clears = tonumber(MF_read("save",worldfolder .. "_clears","total")) or 0
					local bonus = tonumber(MF_read("save",worldfolder .. "_bonus","total")) or 0
					local timeplayed = tonumber(MF_read("save",worldfolder,"time")) or 0
					local win = tonumber(MF_read("save",worldfolder,"end")) or 0
					local done = tonumber(MF_read("save",worldfolder,"done")) or 0
					
					local minutes = math.floor(timeplayed / 60) % 60
					local hours = math.floor(timeplayed / 3600)
					
					local desc = ""
					
					if (timeplayed > 0) then						
						if (generaldata4.values[CUSTOMFONT] == 0) then
							desc = desc .. hours .. ":" .. minutes .. "£  " .. tostring(prizes) .. "🤣  " .. tostring(clears) .. "¤"
						else
							desc = desc .. hours .. ":" .. minutes .. "💀  " .. tostring(prizes) .. "😈  " .. tostring(clears) .. "😠"
						end
					
						if (bonus > 0) then
							desc = desc .. "  (+" .. tostring(bonus) .. ")"
						end
					else
						desc = langtext("customlevels_pack_emptysave")
					end
					
					local worldname = MF_read("world","general","name")
					local worldauthor = MF_read("world","general","author")
					
					if (string.len(worldname) > 24) then
						worldname = string.sub(worldname, 1, 21) .. "..."
					end
					
					if (string.len(worldauthor) == 0) then
						worldauthor = langtext("noauthor")
					elseif (string.len(worldauthor) > 24) then
						worldauthor = string.sub(worldauthor, 1, 21) .. "..."
					end
					
					local bid = createbutton(worldfolder_,x + x_ * 17 * f_tilesize,y + y_ * 3 * f_tilesize,1,16,3,"",name,3,2,buttonid,nil,nil,nil,nil,nil,true)
					writetext(worldname,0,x + x_ * 17 * f_tilesize - f_tilesize * 5,y + y_ * 3 * f_tilesize - f_tilesize * 0.8,name,false,2,nil,{0,3},nil,1,nil,true)
					writetext(langtext("by") .. " " .. worldauthor,0,x + x_ * 17 * f_tilesize - f_tilesize * 5,y + y_ * 3 * f_tilesize,name,false,2,nil,{1,4},nil,1,nil,true)
					writetext(desc,0,x + x_ * 17 * f_tilesize - f_tilesize * 5,y + y_ * 3 * f_tilesize + f_tilesize * 0.8,name,false,2,nil,{0,3},nil,1,nil,true)
					
					local iconpath = "Worlds/" .. worldfolder .. "/"
					local imagefile = "icon"
					
					local icon_exists = MF_findfile("Data/" .. iconpath .. imagefile .. ".png")
					
					if icon_exists then
						MF_thumbnail(iconpath,imagefile,actual_i-1,0,0,bid,0,3,0-f_tilesize * 6.5,0,buttonid,"")
					end
					
					for j=1,2 do
						if ((j == 1) and (win > 0)) or ((j == 2) and (done > 0)) then
							local iconid = MF_create("Hud_completionicon")
							local icon = mmf.newObject(iconid)
							
							icon.x = x + x_ * 17 * f_tilesize + f_tilesize * 7.2
							icon.y = y + y_ * 3 * f_tilesize
							icon.layer = 2
							icon.strings[GROUP] = buttonid
							icon.values[XPOS] = icon.x
							icon.values[YPOS] = icon.y
							
							if (j == 1) then
								--icon.direction = 0
								icon.y = icon.y - f_tilesize * 0.75
								icon.values[COUNTER_VALUE] = 0
							elseif (j == 2) then
								--icon.direction = 4
								icon.y = icon.y - f_tilesize * 0.75
								icon.x = icon.x - f_tilesize * 1
								icon.values[COUNTER_VALUE] = 4
							end
							
							icon.values[XPOS] = icon.x
							icon.values[YPOS] = icon.y
							icon.values[BUTTON_STOREDX] = icon.x
							icon.values[BUTTON_STOREDY] = icon.y
						end
					end
					
					table.insert(curr_dynamic_structure, {worldfolder_})
					
					x_ = x_ + 1
					if (x_ > 1) and (i < page_max) then
						x_ = 0
						y_ = y_ + 1
						
						table.insert(dynamic_structure, {})
						curr_dynamic_structure = dynamic_structure[#dynamic_structure]
					end
					
					actual_i = actual_i + 1
				end
			end
			
			editor2.values[MENU_XDIM] = 1
			
			-- Korjaa tämä
			editor2.values[MENU_YDIM] = 1
			
			local cannot_scroll_left = true
			local cannot_scroll_left2 = true
			local cannot_scroll_right = true
			local cannot_scroll_right2 = true
			
			if (page > 0) then
				cannot_scroll_left = false
			end
			
			if (page > 4) then
				cannot_scroll_left2 = false
			end
			
			if (page < maxpage) then
				cannot_scroll_right = false
			end
			
			if (page < maxpage - 4) then
				cannot_scroll_right2 = false
			end
			
			if (maxpage > 0) then
				createbutton("scroll_left",screenw * 0.5 - f_tilesize * 4,screenh - f_tilesize * 2,2,2,2,"",name,3,2,buttonid,cannot_scroll_left,nil,nil,bicons.l_arrow)
				createbutton("scroll_left2",screenw * 0.5 - f_tilesize * 7,screenh - f_tilesize * 2,2,2,2,"",name,3,2,buttonid,cannot_scroll_left,nil,nil,bicons.dl_arrow)
				createbutton("scroll_right",screenw * 0.5 + f_tilesize * 4,screenh - f_tilesize * 2,2,2,2,"",name,3,2,buttonid,cannot_scroll_right,nil,nil,bicons.r_arrow)
				createbutton("scroll_right2",screenw * 0.5 + f_tilesize * 7,screenh - f_tilesize * 2,2,2,2,"",name,3,2,buttonid,cannot_scroll_right,nil,nil,bicons.dr_arrow)
			
				writetext(langtext("editor_spritelist_page") .. ": " .. tostring(page + 1) .. "/" .. tostring(maxpage + 1),0,screenw * 0.5,screenh - f_tilesize * 2,name,true,2)
				
				table.insert(dynamic_structure, {{"scroll_left2"},{"scroll_left"},{"scroll_right"},{"scroll_right2"},})
			end
			
			makeselection({"","remove"},editor.values[STATE] + 1)
			
			local mypos = editor2.values[MENU_YPOS]
			local mxdim = #dynamic_structure[#dynamic_structure]
			
			if (mypos > 0) and (mypos < #dynamic_structure - 1) then
				editor2.values[MENU_XPOS] = math.min(editor2.values[MENU_XPOS], mxdim - 1)
				editor2.values[MENU_YPOS] = #dynamic_structure - 1
			elseif (mypos > 0) and (mypos >= #dynamic_structure - 1) then
				editor2.values[MENU_XPOS] = math.min(editor2.values[MENU_XPOS], mxdim - 1)
				editor2.values[MENU_YPOS] = math.min(editor2.values[MENU_YPOS], #dynamic_structure - 1)
			else
				editor2.values[MENU_XPOS] = 0
				editor2.values[MENU_YPOS] = 0
			end
			
			buildmenustructure(dynamic_structure)
		end,
	playlevels_single =
		function(parent,name,buttonid,page_)
			local x = screenw * 0.5
			local y = f_tilesize * 1.5
			
			createbutton("return",x - f_tilesize * 5,y,2,8,1,langtext("return"),name,3,1,buttonid)
			
			createbutton("remove",x + f_tilesize * 5,y,2,8,1,langtext("customlevels_delete"),name,3,2,buttonid)
			
			y = y + f_tilesize * 2
			
			writetext(langtext("customlevels_single") .. ":",0,x,y,name,true,1)
			
			local worlds = MF_filelist("Data/Worlds/levels/","*.l")
			local dynamic_structure = {{{"return"},{"remove"}}}
			
			if (#worlds > 0) then
				editor2.values[MENU_YDIM] = #worlds - 1
				
				local actual_i = 1
				
				local page = page_ or 0
				page = MF_setpagemenu(name)
				local amount = 8
				local maxpage = math.floor((#worlds-1) / amount)
				page = math.min(page, maxpage)
				
				local targetlevel = editor3.strings[PREVLEVELFILE] .. ".l"
				if (string.len(targetlevel) > 0) then
					for i,v in ipairs(worlds) do
						if (v == targetlevel) then
							page = math.floor(i / amount)
							editor3.values[PAGE] = page
						end
					end
				end
				
				editor3.strings[PREVLEVELFILE] = ""
				editor3.values[MAXPAGE] = maxpage
				
				local page_min = page * amount
				local page_max = math.min(((page + 1) * amount) - 1, #worlds - 1)
				
				local curr_dynamic_structure = {}
				
				x = x - f_tilesize * 8.5
				local x_ = 0
				local y_ = 0
				
				table.insert(dynamic_structure, {})
				curr_dynamic_structure = dynamic_structure[#dynamic_structure]
				
				y = y + f_tilesize * 3
				
				for i=page_min,page_max do
					local v = worlds[i + 1]
					local leveldata = v .. "d"
					local levelid = string.sub(v, 1, string.len(v) - 2)
					
					MF_setfile("level","Data/Worlds/levels/" .. leveldata)
					
					local levelname = MF_read("level","general","name")
					local levelauthor = MF_read("level","general","author")
					local levelsubtitle = MF_read("level","general","subtitle")
					
					if (string.len(levelname) > 24) then
						levelname = string.sub(levelname, 1, 21) .. "..."
					end
					
					if (string.len(levelauthor) == 0) then
						levelauthor = langtext("noauthor")
					elseif (string.len(levelauthor) > 24) then
						levelauthor = string.sub(levelauthor, 1, 21) .. "..."
					end
					
					local bid = createbutton(levelid .. "," .. levelname,x + x_ * 17 * f_tilesize,y + y_ * 3 * f_tilesize,1,16,3,"",name,3,2,buttonid,nil,nil,nil,nil,nil,true)
					writetext(levelname,0,x + x_ * 17 * f_tilesize - f_tilesize * 4,y + y_ * 3 * f_tilesize - f_tilesize * 0.8,name,false,2,nil,{0,3},nil,1,nil,true)
					writetext(langtext("by") .. " " ..  levelauthor,0,x + x_ * 17 * f_tilesize - f_tilesize * 4,y + y_ * 3 * f_tilesize,name,false,2,nil,{1,4},nil,1,nil,true)
					writetext(levelsubtitle,0,x + x_ * 17 * f_tilesize - f_tilesize * 4,y + y_ * 3 * f_tilesize + f_tilesize * 0.8,name,false,2,nil,{1,3},nil,1,nil,true)
					
					local imagefile = levelid
					MF_thumbnail("Worlds/levels/",imagefile,actual_i-1,0,0,bid,0,3,0-f_tilesize * 6,0,buttonid,"")
					
					table.insert(curr_dynamic_structure, {levelid .. "," .. levelname})
					
					local beaten = tonumber(MF_read("save","levels",levelid)) or 0
					local bonus = tonumber(MF_read("save","levels_bonus",levelid)) or 0
					local converted = tonumber(MF_read("save","levels_converts_single",levelid)) or 0
					local ended = tonumber(MF_read("save","levels_end_single",levelid)) or 0
					local doned = tonumber(MF_read("save","levels_done_single",levelid)) or 0
					
					for j=1,5 do
						if ((j == 1) and (beaten == 3)) or ((j == 2) and (bonus > 0)) or ((j == 3) and (converted > 0)) or ((j == 4) and (ended > 0)) or ((j == 5) and (doned > 0)) then
							local iconid = MF_create("Hud_completionicon")
							local icon = mmf.newObject(iconid)
							
							icon.x = x + x_ * 17 * f_tilesize + f_tilesize * 7.2
							icon.y = y + y_ * 3 * f_tilesize
							icon.layer = 2
							icon.strings[GROUP] = buttonid
							icon.values[XPOS] = icon.x
							icon.values[YPOS] = icon.y
							
							if (j == 1) then
								--icon.direction = 0
								icon.y = icon.y - f_tilesize * 0.75
								icon.values[COUNTER_VALUE] = 0
							elseif (j == 2) then
								--icon.direction = 1
								icon.y = icon.y - f_tilesize * 0.75
								icon.x = icon.x - f_tilesize * 1
								icon.values[COUNTER_VALUE] = 1
							elseif (j == 3) then
								--icon.direction = 2
								icon.y = icon.y + f_tilesize * 0.25
								icon.values[COUNTER_VALUE] = 2
							elseif (j == 4) then
								--icon.direction = 3
								icon.x = icon.x - f_tilesize * 1
								icon.y = icon.y + f_tilesize * 0.25
								icon.values[COUNTER_VALUE] = 3
							elseif (j == 5) then
								--icon.direction = 3
								icon.x = icon.x - f_tilesize * 0.5
								icon.y = icon.y + f_tilesize * 0.75
								icon.values[COUNTER_VALUE] = 4
							end
							
							icon.values[XPOS] = icon.x
							icon.values[YPOS] = icon.y
							icon.values[BUTTON_STOREDX] = icon.x
							icon.values[BUTTON_STOREDY] = icon.y
						end
					end
					
					x_ = x_ + 1
					if (x_ > 1) and (i < page_max) then
						x_ = 0
						y_ = y_ + 1
						
						table.insert(dynamic_structure, {})
						curr_dynamic_structure = dynamic_structure[#dynamic_structure]
					end
					
					actual_i = actual_i + 1
				end
				
				editor2.values[MENU_XDIM] = 1
				
				-- Korjaa tämä
				editor2.values[MENU_YDIM] = 1
				
				local cannot_scroll_left = true
				local cannot_scroll_left2 = true
				local cannot_scroll_right = true
				local cannot_scroll_right2 = true
				
				if (page > 0) then
					cannot_scroll_left = false
				end
				
				if (page > 4) then
					cannot_scroll_left2 = false
				end
				
				if (page < maxpage) then
					cannot_scroll_right = false
				end
				
				if (page < maxpage - 4) then
					cannot_scroll_right2 = false
				end
				
				if (maxpage > 0) then
					createbutton("scroll_left",screenw * 0.5 - f_tilesize * 4,screenh - f_tilesize * 2,2,2,2,"",name,3,2,buttonid,cannot_scroll_left,nil,nil,bicons.l_arrow)
					createbutton("scroll_left2",screenw * 0.5 - f_tilesize * 7,screenh - f_tilesize * 2,2,2,2,"",name,3,2,buttonid,cannot_scroll_left,nil,nil,bicons.dl_arrow)
					createbutton("scroll_right",screenw * 0.5 + f_tilesize * 4,screenh - f_tilesize * 2,2,2,2,"",name,3,2,buttonid,cannot_scroll_right,nil,nil,bicons.r_arrow)
					createbutton("scroll_right2",screenw * 0.5 + f_tilesize * 7,screenh - f_tilesize * 2,2,2,2,"",name,3,2,buttonid,cannot_scroll_right,nil,nil,bicons.dr_arrow)
				
					writetext(langtext("editor_spritelist_page") .. ": " .. tostring(page + 1) .. "/" .. tostring(maxpage + 1),0,screenw * 0.5,screenh - f_tilesize * 2,name,true,2)
					
					table.insert(dynamic_structure, {{"scroll_left2"},{"scroll_left"},{"scroll_right"},{"scroll_right2"},})
				end
				
				local mypos = editor2.values[MENU_YPOS]
				local mxdim = #dynamic_structure[#dynamic_structure]
				
				if (mypos > 0) and (mypos < #dynamic_structure - 1) then
					editor2.values[MENU_XPOS] = math.min(editor2.values[MENU_XPOS], mxdim - 1)
					editor2.values[MENU_YPOS] = #dynamic_structure - 1
				elseif (mypos > 0) and (mypos >= #dynamic_structure - 1) then
					editor2.values[MENU_XPOS] = math.min(editor2.values[MENU_XPOS], mxdim - 1)
					editor2.values[MENU_YPOS] = math.min(editor2.values[MENU_YPOS], #dynamic_structure - 1)
				else
					editor2.values[MENU_XPOS] = 0
					editor2.values[MENU_YPOS] = 0
				end
			else
				editor2.values[MENU_YDIM] = 1
				changemenu("playlevels")
			end
			
			makeselection({"","remove"},editor.values[STATE] + 1)
			
			editor2.values[MENU_YPOS] = math.min(editor2.values[MENU_YPOS], #dynamic_structure - 1)
			
			buildmenustructure(dynamic_structure)
		end,
	playlevels_featured =
		function(parent,name,buttonid,page_)
			local x = screenw * 0.5
			local y = f_tilesize * 0.6
			
			createbutton("return",x,y,2,16,1,langtext("return"),name,3,1,buttonid)
			
			y = y + f_tilesize * 1
			
			writetext(langtext("playlevels_get_featured") .. ":",0,x,y,name,true,1)
			
			local amount = MF_getlevelcount()
			local pagecount = MF_getpagecount()
			local total = amount * pagecount
			
			local dynamic_structure = {{{"return"}}}
			
			local actual_i = 1
			
			if (total > 0) then
				local page = page_ or 0
				local maxpage = pagecount - 1
				page = math.min(page, maxpage)
				
				editor3.strings[PREVLEVELFILE] = ""
				editor3.values[MAXPAGE] = maxpage
				
				local page_min = page * amount
				local page_max = math.min(((page + 1) * amount) - 1, total-1)
				
				page_min = 0
				page_max = amount - 1
				
				local curr_dynamic_structure = {}
				
				x = x - f_tilesize * 8.5
				local x_ = 0
				local y_ = 0
				
				table.insert(dynamic_structure, {})
				curr_dynamic_structure = dynamic_structure[#dynamic_structure]
				
				y = y + f_tilesize * 3
				
				for i=page_min,page_max do
					local levelid,levelname,levelauthor,levelsubtitle,leveltagline,thumbnail = MF_getlistlevel(i)
					
					if (string.len(levelname) > 24) then
						levelname = string.sub(levelname, 1, 21) .. "..."
					end
					
					if (string.len(levelauthor) == 0) then
						levelauthor = langtext("noauthor")
					elseif (string.len(levelauthor) > 24) then
						levelauthor = string.sub(levelauthor, 1, 21) .. "..."
					end
					
					local bid = createbutton(levelid .. "," .. levelname,x + x_ * 17 * f_tilesize,y + y_ * 3 * f_tilesize,1,16,5,"",name,3,2,buttonid,nil,nil,nil,nil,nil,true)
					writetext(levelname,0,x + x_ * 17 * f_tilesize - f_tilesize * 4,y + y_ * 3 * f_tilesize - f_tilesize * 1.8,name,false,2,nil,{0,3},nil,1,nil,true)
					writetext(langtext("by") .. " " ..  levelauthor,0,x + x_ * 17 * f_tilesize - f_tilesize * 4,y + y_ * 3 * f_tilesize - f_tilesize,name,false,2,nil,{1,4},nil,1,nil,true)
					writetext(levelsubtitle,0,x + x_ * 17 * f_tilesize - f_tilesize * 4,y + y_ * 3 * f_tilesize - f_tilesize * 0.2,name,false,2,nil,{1,3},nil,1,nil,true)
					
					if (#leveltagline >= 73) then
						leveltagline = string.sub(leveltagline, 1, 69) .. "..."
					end
					
					local taglines = wordwrap(leveltagline, f_tilesize * 13, true)
					local tg1 = taglines[1]
					local tg2 = taglines[2] or ""
					local tg3 = taglines[3] or ""
					
					writetext(tg1,0,x + x_ * 17 * f_tilesize - f_tilesize * 7.75,y + y_ * 3 * f_tilesize + f_tilesize * 0.8,name,false,2,nil,{0,3},nil,1,nil,true)
					
					if (#tg2 > 0) then
						writetext(tg2,0,x + x_ * 17 * f_tilesize - f_tilesize * 7.75,y + y_ * 3 * f_tilesize + f_tilesize * 1.8,name,false,2,nil,{0,3},nil,1,nil,true)
					end
					
					if (#tg3 > 0) then
						writetext(tg3,0,x + x_ * 17 * f_tilesize - f_tilesize * 7.75,y + y_ * 3 * f_tilesize + f_tilesize * 2.8,name,false,2,nil,{0,3},nil,1,nil,true)
					end
					
					local imagefile = levelid
					MF_thumbnail("Temp/",imagefile,actual_i-1,0,0,bid,0,3,0-f_tilesize * 6,0-f_tilesize,buttonid,"")
					
					table.insert(curr_dynamic_structure, {levelid .. "," .. levelname})
					
					x_ = x_ + 1
					if (x_ > 1) and (i < page_max) then
						x_ = 0
						y_ = y_ + 1.75
						
						table.insert(dynamic_structure, {})
						curr_dynamic_structure = dynamic_structure[#dynamic_structure]
					end
					
					actual_i = actual_i + 1
				end
				
				editor2.values[MENU_XDIM] = 1
				
				local cannot_scroll_left = true
				local cannot_scroll_left2 = true
				local cannot_scroll_right = true
				local cannot_scroll_right2 = true
				
				if (page > 0) then
					cannot_scroll_left = false
				end
				
				if (page > 4) then
					cannot_scroll_left2 = false
				end
				
				if (page < maxpage) then
					cannot_scroll_right = false
				end
				
				if (page < maxpage - 4) then
					cannot_scroll_right2 = false
				end
				
				if (maxpage > 0) then
					createbutton("scroll_left",screenw * 0.5 - f_tilesize * 4,screenh - f_tilesize * 1.2,2,2,2,"",name,3,2,buttonid,cannot_scroll_left,nil,nil,bicons.l_arrow)
					createbutton("scroll_left2",screenw * 0.5 - f_tilesize * 7,screenh - f_tilesize * 1.2,2,2,2,"",name,3,2,buttonid,cannot_scroll_left,nil,nil,bicons.dl_arrow)
					createbutton("scroll_right",screenw * 0.5 + f_tilesize * 4,screenh - f_tilesize * 1.2,2,2,2,"",name,3,2,buttonid,cannot_scroll_right,nil,nil,bicons.r_arrow)
					createbutton("scroll_right2",screenw * 0.5 + f_tilesize * 7,screenh - f_tilesize * 1.2,2,2,2,"",name,3,2,buttonid,cannot_scroll_right,nil,nil,bicons.dr_arrow)
				
					writetext(langtext("editor_spritelist_page") .. ": " .. tostring(page + 1) .. "/" .. tostring(maxpage + 1),0,screenw * 0.5,screenh - f_tilesize * 1.2,name,true,2)
					
					table.insert(dynamic_structure, {{"scroll_left2"},{"scroll_left"},{"scroll_right"},{"scroll_right2"},})
				end
				
				makeselection({"","remove"},editor.values[STATE] + 1)
				
				local mypos = editor2.values[MENU_YPOS]
				local mxdim = #dynamic_structure[#dynamic_structure]
				
				if (mypos > 0) and (mypos < #dynamic_structure - 1) then
					editor2.values[MENU_XPOS] = math.min(editor2.values[MENU_XPOS], mxdim - 1)
					editor2.values[MENU_YPOS] = #dynamic_structure - 1
				elseif (mypos > 0) and (mypos >= #dynamic_structure - 1) then
					editor2.values[MENU_XPOS] = math.min(editor2.values[MENU_XPOS], mxdim - 1)
					editor2.values[MENU_YPOS] = math.min(editor2.values[MENU_YPOS], #dynamic_structure - 1)
				else
					editor2.values[MENU_XPOS] = 0
					editor2.values[MENU_YPOS] = 0
				end
			end
			
			buildmenustructure(dynamic_structure)
		end,
	playlevels_getlist =
		function(parent,name,buttonid)
			local x = screenw * 0.5
			local y = f_tilesize * 1.25
			
			createbutton("return",x,y,2,8,1,langtext("return"),name,3,1,buttonid)
			
			y = y + f_tilesize * 1
			
			writetext(langtext("customlevels_getlist") .. ":",0,x,y,name,true,1)
			
			y = y + f_tilesize * 1
			
			writetext(langtext("customlevels_getlist2"),0,x,y,name,true,1,nil,{1,3})
			
			local dynamic_structure = {{{"return"}}}
			y = y + f_tilesize * 1
			
			writetext(langtext("customlevels_getlist_download") .. ":",0,screenw * 0.5 - f_tilesize * 8.5,y,name,true,1)
			writetext(langtext("customlevels_getlist_upload") .. ":",0,screenw * 0.5 + f_tilesize * 8.5,y,name,true,1)
			
			local column1 = {}
			local column2 = {}
			
			local uploads = math.min(15, tonumber(MF_read("settings","get_u","total")) or 0)
			local downloads = math.min(15, tonumber(MF_read("settings","get_d","total")) or 0)
			
			y = y + f_tilesize * 1
			
			if (downloads > 0) then
				for i=1,downloads do
					local lcode = MF_read("settings","get_d",tostring(i-1) .. "code")
					local lname = MF_read("settings","get_d",tostring(i-1) .. "name")
					
					local combo = lname .. ", " .. lcode
					
					createbutton(tostring(i) .. "a," .. lcode,x - f_tilesize * 8.5,y + (i - 1) * f_tilesize,2,16,1,combo,name,3,2,buttonid)
					
					table.insert(column1, {tostring(i) .. "a," .. lcode})
				end
			end
			
			if (uploads > 0) then
				for i=1,uploads do
					local lcode = MF_read("settings","get_u",tostring(i-1) .. "code")
					local lname = MF_read("settings","get_u",tostring(i-1) .. "name")
					
					local combo = lname .. ", " .. lcode
					
					createbutton(tostring(i) .. "b," .. lcode,x + f_tilesize * 8.5,y + (i - 1) * f_tilesize,2,16,1,combo,name,3,2,buttonid)
					
					table.insert(column2, {tostring(i) .. "b," .. lcode})
				end
			end
			
			local ydim_ = math.max(#column1, #column2)
			
			for i=1,ydim_ do
				local c1 = column1[i] or nil
				local c2 = column2[i] or nil
				
				local result = {}
				
				if (c1 ~= nil) then
					table.insert(result, c1)
				end
				
				if (c2 ~= nil) then
					table.insert(result, c2)
				end
				
				table.insert(dynamic_structure, result)
			end
			
			editor2.values[MENU_XPOS] = 0
			editor2.values[MENU_YPOS] = 0
			editor2.values[MENU_XDIM] = 1
			
			-- Korjaa tämä
			editor2.values[MENU_YDIM] = 1
			
			buildmenustructure(dynamic_structure)
		end,
}