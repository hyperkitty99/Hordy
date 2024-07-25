package options;

class GraphicsSettingsSubState extends BaseOptionsMenu {
	public function new() {
		var option:Option = new Option('FPS Counter', 'If unchecked, hides FPS Counter.', 'showFPS', 'bool');
		addOption(option);
		option.onChange = onChangeFPSCounter;

		addOption(new Option('Anti-Aliasing', 'If unchecked, disables anti-aliasing, increases performance\nat the cost of sharper visuals.', 'antialiasing', 'bool'));
		addOption(new Option('GPU Caching', "If checked, allows the GPU to be used for caching textures, decreasing RAM usage.\nDon't turn this on if you have a shitty Graphics Card.", 'cacheOnGPU', 'bool'));
		addOption(new Option('Shaders', "If unchecked, disables shaders.\nIt's used for some visual effects, and also CPU intensive for weaker PCs.", 'shaders', 'bool'));
		addOption(new Option('Flashing Lights', "Uncheck this if you're sensitive to flashing lights!", 'flashing', 'bool'));

		super();
	}

	function onChangeFPSCounter() if(Main.fpsVar != null) Main.fpsVar.visible = ClientPrefs.data.showFPS;
}