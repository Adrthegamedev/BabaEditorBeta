function clearunits(restore_)
	units = {}
	tiledunits = {}
	codeunits = {}
	animunits = {}
	unitlists = {}
	undobuffer = {}
	unitmap = {}
	unittypeshere = {}
	prevunitmap = {}
	ruleids = {}
	objectlist = {}
	updatelist = {}
	objectcolours = {}
	wordunits = {}
	wordrelatedunits = {}
	letterunits = {}
	letterunits_map = {}
	paths = {}
	paradox = {}
	movelist = {}
	deleted = {}
	effecthistory = {}
	notfeatures = {}
	groupfeatures = {}
	groupmembers = {}
	pushedunits = {}
	customobjects = {}
	cobjects = {}
	condstatus = {}
	emptydata = {}
	leveldata = {}
	leveldata.colours = {}
	leveldata.currcolour = 0
	
	visiontargets = {}
	
	generaldata.values[CURRID] = 0
	updateundo = true
	hiddenmap = nil
	levelconversions = {}
	last_key = 0
	auto_dir = {}
	destroylevel_check = false
	destroylevel_style = ""
	
	HACK_MOVES = 0
	HACK_INFINITY = 0
	movemap = {}
	
	local restore = true
	if (restore_ ~= nil) then
		restore = norestore_
	end
	
	if restore then
		newundo()
		
		print("clearunits")
		
		restoredefaults()
	end
end

function smallclear()
	objectdata = {}
	deleted = {}
	updatelist = {}
	movelist = {}
	pushedunits = {}
	levelconversions = {}
	
	HACK_MOVES = 0
	movemap = {}
	
	if (#units > 2000) then
		destroylevel("toocomplex")
		updateundo = true
	end
end

function clear()
	features = {}
	featureindex = {}
	condfeatureindex = {}
	visualfeatures = {}
	objectdata = {}
	deleted = {}
	ruleids = {}
	updatelist = {}
	wordunits = {}
	wordrelatedunits = {}
	letterunits_map = {}
	paradox = {}
	movelist = {}
	effecthistory = {}
	notfeatures = {}
	groupfeatures = {}
	groupmembers = {}
	pushedunits = {}
	condstatus = {}
	emptydata = {}
	leveldata = {}
	leveldata.colours = {}
	leveldata.currcolour = 0
	
	visiontargets = {}
	
	updatecode = 1
	updateundo = false
	hiddenmap = nil
	levelconversions = {}
	maprotation = 0
	mapdir = 3
	last_key = 0
	auto_dir = {}
	destroylevel_check = false
	destroylevel_style = ""
	
	HACK_MOVES = 0
	HACK_INFINITY = 0
	movemap = {}
	
	--print("clear")
	collectgarbage()
end