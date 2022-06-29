state("Toree3D")
{
	int inLevel : "UnityPlayer.dll", 0x168EC48, 0x0, 0xCA90, 0xB0, 0x1FE0;              //1 if in level, 0 if not
	int victory : "mono-2.0-bdwgc.dll", 0x490A90, 0x1868, 0x10, 0x2B0;		            //1 if in victory sequence, 0 if not
	int load : "UnityPlayer.dll", 0x16D8C10, 0x24;							        	//4 if loading, 1 if not
	float timer : "UnityPlayer.dll", 0x16DD450, 0x127C;							        //elapsed time since start of scene
}

state("Toree3DJumbledJam")
{
	int inLevel : "UnityPlayer.dll", 0x168EC48, 0x0, 0xCA90, 0xB0, 0x1270;              //1 if in level, 0 if not
	int victory : "mono-2.0-bdwgc.dll", 0x490A90, 0x1868, 0x10, 0x2B0;		            //1 if in victory sequence, 0 if not
	int load : "UnityPlayer.dll", 0x16D8C10, 0x24;							  	        //4 if loading, 1 if not
	float timer : "UnityPlayer.dll", 0x16DD450, 0x127C;							        //elapsed time since start of scene
}

state("Toree2")
{
	int inLevel : "mono-2.0-bdwgc.dll", 0x495A90, 0x1898, 0x10, 0xF0, 0x88, 0xC;        //3 if in level, 2 if not
	int victory : "mono-2.0-bdwgc.dll", 0x495A90, 0x1858, 0x10, 0x310;		            //1 if in victory sequence, 0 if not
	int load : "UnityPlayer.dll", 0x19F52F0, 0x24;							  	        //4 if loading, 1 if not
	float timer : "UnityPlayer.dll", 0x19FAE80, 0x1280;							        //elapsed time since start of scene
}

startup
{
	settings.Add("split_late", false, "Delay splitting until menu screen (recommended for runs w/ level exit skip)");
}

init
{
	vars.firstLevel = 0;
	vars.readyToSplit = 0;
	vars.ifMenu = 0;
	vars.ifLevel = 1;
	vars.lastLev = 8;
}

update
{
	if (game.ProcessName == "Toree2") {vars.ifMenu = 2; vars.ifLevel = 3;}
	if (game.ProcessName == "Toree3DJumbledJam") {vars.lastLev = 3;}
	if ((current.victory == 1) && (current.inLevel == vars.ifLevel)) {vars.firstLevel = 0; vars.readyToSplit = 1;}
	if ((current.timer < 0.125) && (current.inLevel == vars.ifLevel) && (timer.CurrentSplitIndex == 0)) {vars.firstLevel = 1; vars.readyToSplit = 0;}
}

start
{
	return (current.timer < 0.125) && (current.inLevel == vars.ifLevel);
}

split
{
	if (settings["split_late"] && timer.CurrentSplitIndex != vars.lastLev) {
		if ((old.inLevel == vars.ifLevel) && (current.inLevel == vars.ifMenu) && (vars.readyToSplit == 1)) {vars.readyToSplit = 0; return true;};
	} else {
		return (old.victory == 0) && (current.victory == 1);
	}
}

reset
{
	return (old.timer > current.timer) && (vars.firstLevel == 1);
}

isLoading
{
	return (current.load == 4);
}