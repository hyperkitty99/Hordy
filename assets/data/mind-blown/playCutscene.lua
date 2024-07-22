playVideo = true;
playDialogue = true;

function onStartCountdown()
	if difficulty == 1 then
		if isStoryMode and not seenCutscene then
			if playVideo then --Video cutscene plays first
				startVideo('cutnste'); --Play video file from "videos/" folder
				playVideo = false;
				return Function_Stop; --Prevents the song from starting naturally
			end
		end
		return Function_Continue; --Played video and dialogue, now the song can start normally
    else
		if isStoryMode and not seenCutscene then
			if playVideo then --Video cutscene plays first
				startVideo('nestor_pasha'); --Play video file from "videos/" folder
				playVideo = false;
				return Function_Stop; --Prevents the song from starting naturally
			end
		end
		return Function_Continue; --Played video and dialogue, now the song can start normally
    end
end