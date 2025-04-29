package states;

import flixel.util.FlxColor;
import states.credits.SEngineState;
import states.credits.ModsCreditsState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.display.FlxBackdrop;

class CreditsState extends MusicBeatState {
	var bg:FlxSprite;
	var checker:FlxBackdrop;
	var bars:FlxSprite;
	public var title1:FlxText;
	public var title2:FlxText;
	public var title3:FlxText;

    override function create() {
		FlxG.mouse.visible = true;

        bg = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
        bg.scale.set(1.15, 1.15);
        bg.updateHitbox();
        bg.screenCenter();
		bg.alpha = 0.5;
        bg.antialiasing = true;
        add(bg);

		checker = new FlxBackdrop(Paths.image('grid/Grid_lmao'));
		checker.updateHitbox();
		checker.scrollFactor.set(0, 0);
		checker.alpha = 0.2;
		checker.screenCenter(X);
		add(checker);

		if (ClientPrefs.data.backdrops) {
			checker.visible = false;
		} else {
			checker.visible = true;
		}

		bars = new FlxSprite();
		bars.loadGraphic(Paths.image('bars'));
		bars.scale.set(1.175, 1.175);
		bars.screenCenter();
		add(bars);

		title1 = new FlxText(0, 0, FlxG.width, "Santiago Engine TEAM");
		title1.setFormat('Pah', 80, FlxColor.WHITE, "center");
		title1.screenCenter();
		title1.y -= 75;
		add(title1);

		title2 = new FlxText(0, 0, FlxG.width, "Mods Credits"); 
		title2.setFormat('Pah', 80, FlxColor.WHITE, "center");
		title2.screenCenter();
		title2.y += 75;
		add(title2);

		super.create();
    }

	override function update(elapsed:Float) 
	{
		FlxG.mouse.visible = true;

		checker.x += .5*(elapsed/(1/120)); 
		checker.y -= 0.16;

		if (FlxG.keys.justPressed.ESCAPE) {
			FlxG.sound.play(Paths.sound('cancelMenu'));
			MusicBeatState.switchState(new MainMenuState());
		}

		if (FlxG.mouse.justPressed) {
			if (FlxG.mouse.overlaps(title1)) {
				FlxG.sound.play(Paths.sound('confirmMenu'));
				FlxTween.tween(checker, { alpha: 1 }, 0.5, { ease: FlxEase.expoInOut });
				FlxTween.tween(title2, { x: 1200 }, 1, { ease: FlxEase.expoInOut, onComplete: cast(function() {
					MusicBeatState.switchState(new SEngineState());
				})});
			} else if (FlxG.mouse.overlaps(title2)) {
				FlxG.sound.play(Paths.sound('confirmMenu'));
				FlxTween.tween(checker, { alpha: 1 }, 0.5, { ease: FlxEase.expoInOut });
				FlxTween.tween(title1, { x: 1200 }, 1, { ease: FlxEase.expoInOut, onComplete: cast(function() {
					MusicBeatState.switchState(new ModsCreditsState());
				})});
			}
		}

		if (FlxG.mouse.overlaps(title1)) {
			title1.color = FlxColor.PURPLE;
		} else {
			title1.color = FlxColor.WHITE;
		}

		if (FlxG.mouse.overlaps(title2)) {
			title2.color = FlxColor.PURPLE;
		} else {
			title2.color = FlxColor.WHITE;
		}
		
		super.update(elapsed);
	}
}
