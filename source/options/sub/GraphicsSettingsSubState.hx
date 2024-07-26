package options.sub;

class GraphicsSettingsSubState extends BaseOptionsMenu {
	public function new() {
		var option:Option = new Option('FPS Counter', 'Shows your current framerate along with memory.', 'showFPS', 'bool');
		addOption(option);
		option.onChange = onChangeFPSCounter;

		addOption(new Option('Anti-Aliasing', "Anti-Aliasing smooths out jagged edges on curves and diagonal lines.\nIf you're not sure what this setting does, leave it on.", 'antialiasing', 'bool'));
		addOption(new Option('GPU Caching', "Allows the GPU to cache textures, decreasing RAM usage.\nDon't turn this on if you have a shitty Graphics Card.", 'cacheOnGPU', 'bool'));
		addOption(new Option('Shaders', "Shaders are used for some visual effects, and also CPU intensive for weaker PCs.", 'shaders', 'bool'));
		addOption(new Option('Flashing Lights', "Uncheck this if you're sensitive to flashing lights!", 'flashing', 'bool'));

		super();
	}

	function onChangeFPSCounter() if(Main.fpsVar != null) Main.fpsVar.visible = ClientPrefs.data.showFPS;
}