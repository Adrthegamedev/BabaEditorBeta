mod_hook_functions =
{
	level_start =
	{
		-- Functions added to this table will be called on level start.
	},
	level_end =
	{
		-- Functions added to this table will be called on level end.
	},
	level_win =
	{
		-- Functions added to this table will be called on level win.
	},
	level_restart =
	{
		-- Functions added to this table will be called when the player restarts a level.
	},
	rule_update =
	{
		-- Functions added to this table will be called when rules are updated. Extra data: {is_this_a_repeated_update [false = no, true = yes]} <-- the extra variable is true e.g. when Word-related rules require the rules to be refreshed multiple times in a row.
	},
	rule_baserules =
	{
		-- Functions added to this table will be called as the game adds the base rules into the rule list (i.e. ones that aren't visible in the rule list). You can use baserule(word 1, word 2, word 3) here to add your own base rules.
	},
	rule_update_after =
	{
		-- Functions added to this table will be called after rules have been updated. Extra data: {is_this_a_repeated_update [false = no, true = yes]} <-- the extra variable is true e.g. when Word-related rules require the rules to be refreshed multiple times in a row.
	},
	command_given =
	{
		-- Functions added to this table will be called when a player command starts resolving. Extra data: {command, player_id}
	},
	turn_auto =
	{
		-- Functions added to this table will be called when a turn starts resolving due to 'Level Is Auto'. Extra data: {player_1_direction, player_2_direction, is_a_player_moving [false = no, true = yes]}
	},
	turn_end =
	{
		-- Functions added to this table will be called when a turn end. Extra data: {player_found [0 = no, 1 = yes]}
	},
	effect_once =
	{
		-- Functions added to this table will be called once at the end of every turn.
	},
	effect_always =
	{
		-- Functions added to this table will be called every frame.
	},
	undoed =
	{
		-- Functions added to this table will be called when the player does an undo input.
	},
	undoed_after =
	{
		-- Functions added to this table will be called after undo has taken effect.
	},
	levelpack_end =
	{
		-- Functions added to this table will be called when the player does the Level Is End ending in a levelpack. Note that if any functions are run here, the normal victory effects won't be displayed.
	},
	levelpack_done =
	{
		-- Functions added to this table will be called when the player does the All Is Done ending in a levelpack. Note that if any functions are run here, the normal victory effects won't be displayed.
	},
}

function do_mod_hook(name,extra_)
	local extra = extra_ or {}
	local mods_run = false
	
	return mods_run
end