package states;

import flixel.addons.display.FlxBackdrop;
import flixel.addons.transition.FlxTransitionableState;

#if (cpp && windows)
import hxwindowmode.WindowColorMode;
#end

class ClickHereState extends MusicBeatState
{
	var clickhere:FlxSprite;

	override function create()
	{
		super.create();

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);

		FlxTransitionableState.skipNextTransIn = true;
		FlxTransitionableState.skipNextTransOut = true;

		clickhere = new FlxSprite(0, 0, Paths.image('ClickHere'));
		clickhere.screenCenter();
		clickhere.scale.set(0.75, 0.75);
		clickhere.alpha = 1;
		add(clickhere);
	}

	override function update(elapsed:Float)
	{
		if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(clickhere))
		{
			MusicBeatState.switchState(new TitleState());
		}

		if (FlxG.mouse.overlaps(clickhere))
		{
			clickhere.scale.set(0.82, 0.82);
		} else {
			clickhere.scale.set(0.75, 0.75);
		}

		super.update(elapsed);
	}
}
