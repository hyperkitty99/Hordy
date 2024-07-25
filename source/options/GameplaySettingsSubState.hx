package options;

class GameplaySettingsSubState extends BaseOptionsMenu
{
	public function new()
	{
		var option:Option = new Option('Downscroll', //Name
			'If checked, notes go Down instead of Up, simple enough.', //Description
			'downScroll', //Save data variable name
			'bool'); //Variable type
		addOption(option);

		var option:Option = new Option('Middlescroll',
			'If checked, your notes get centered.',
			'middleScroll',
			'bool');
		addOption(option);

		var option:Option = new Option('Ghost Tapping',
			"If checked, you won't get misses from pressing keys\nwhile there are no notes able to be hit.", 'ghostTapping', 'bool');
		addOption(option);

		addOption(new Option('Disable Reset Button', "If checked, pressing Reset won't do anything.", 'noReset', 'bool'));
		addOption(new Option('Guitar Hero Sustains', "Hold notes count as normal notes when missing.", 'guitarHeroSustains', 'bool'));

		// var option:Option = new Option('Safe Frames', 'Changes how many frames you have for\nhitting a note earlier or late.', 'safeFrames', 'float');
		// option.scrollSpeed = 5;
		// option.minValue = 2;
		// option.maxValue = 10;
		// option.changeValue = 0.1;
		// addOption(option);

		super();
	}
}