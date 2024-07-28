package options.sub;

class GameplaySettingsSubState extends options.sub.BaseOptionsMenu {
	public function new() {
		addOption(new Option('Downscroll', 'Notes go Down instead of Up, simple enough.', 'downScroll', 'bool'));
		addOption(new Option('Middlescroll', 'Places your strumlines in the middle	.', 'middleScroll', 'bool'));
		addOption(new Option('Ghost Tapping', "You won't miss when pressing keys while there are no notes able to be hit.", 'ghostTapping', 'bool'));
		addOption(new Option('Disable Reset Button', "Pressing the Reset button won't do anything.", 'noReset', 'bool'));
		addOption(new Option('Guitar Hero Sustains', "Hold notes count as normal notes if missed.", 'guitarHeroSustains', 'bool'));

		super();
	}
}