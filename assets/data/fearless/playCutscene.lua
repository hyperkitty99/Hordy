playVideo = true;
playDialogue = true;

function onEndSong()
	if not seenCutscene then
		if playVideo then
			startVideo('fearless');
			playVideo = false;
			return Function_Stop;
		end
	end
	return Function_Continue;
end