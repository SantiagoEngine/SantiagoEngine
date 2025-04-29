package options;

#if (cpp && windows)
import hxwindowmode.WindowColorMode;
#end

class SantiagoEngineOptionsState extends BaseOptionsMenu
{
	public function new()
	{
		title = 'SantiagoEngine Settings Menu';
		rpcTitle = 'SantiagoEngine Settings Menu'; //for Discord Rich Presence

		var option:Option = new Option('Disable Backdrops', 
			'If checked, the backdrops will be disabled.\nThis option normally doesn\'t affect performance.',
			'backdrops', 
			'bool'); 
		addOption(option);

		#if (cpp && windows)
		var option:Option = new Option('Window Dark Mode', 
			'If checked, will enable Window Dark Mode.',
			'windowDarkMode', 
			'bool'); 
		addOption(option);
		option.onChange = onChangeWindowDarkMode;
		#end
		
		super();
	}

	function onChangeHitsoundVolume()
		FlxG.sound.play(Paths.sound('hitsound'), ClientPrefs.data.hitsoundVolume);

	function onChangeAutoPause()
		FlxG.autoPause = ClientPrefs.data.autoPause;

	#if (cpp && windows)
	function onChangeWindowDarkMode()
	{
		WindowColorMode.setWindowColorMode(ClientPrefs.data.windowDarkMode);
		WindowColorMode.redrawWindowHeader();
	}
	#end
}