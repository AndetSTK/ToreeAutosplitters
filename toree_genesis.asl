state("Toree Genesis")
{
	int victory : "mono-2.0-bdwgc.dll", 0x3A1574, 0x820, 0x8, 0x25DC;        //2 if victory sequence, 1 if not
	int load : "UnityPlayer.dll", 0x1477DE8, 0x14;  		                 //4 if loading, 1 if not
	float timer : "UnityPlayer.dll", 0x147AF08, 0x1260;                      //elapsed time since start of scene
}

startup
{
	settings.Add("any_split", false, "Any% splitting");
}

start
{
	return (current.timer < 0.125);
}

split
{
	if (settings["any_split"]) {
		return (old.load == 1) && (current.load == 4);
	} else {
		return (old.victory == 1) && (current.victory == 2);
	}
}

isLoading
{
	return (current.load == 4);
}