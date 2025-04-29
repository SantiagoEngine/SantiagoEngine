package states;

import flixel.FlxObject;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.display.FlxBackdrop;
import sys.FileSystem;
import sys.io.File;
import lime.app.Application;
import flixel.effects.FlxFlicker; 
import states.editors.MasterEditorMenu;
import options.OptionsState;
import backend.MusicBeatSubstate;

class MainMenuState extends MusicBeatState {
    public static var psychEngineVersion:String = File.getContent('assets/config/v.txt'); // This is also used for Discord RPC
    public static var curSelected:Int = 0;

    var menuItems:FlxTypedGroup<FlxSprite>;

    var optionShit:Array<String> = [
        'story_mode',
        'freeplay',
        #if MODS_ALLOWED 'mods', #end
        'credits',
        'options'
    ];

    var magenta:FlxSprite;
    var checker:FlxBackdrop;
    var selectedSomethin:Bool = false;

    override function create() {
        #if MODS_ALLOWED
        Mods.pushGlobalMods();
        #end
        Mods.loadTopMod();

        #if DISCORD_ALLOWED
        // Updating Discord Rich Presence
        DiscordClient.changePresence("In the Menus");
        #end

        persistentUpdate = persistentDraw = true;

        var yScroll:Float = Math.max(0.25 - (0.05 * (optionShit.length - 4)), 0.1);
        var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuBG'));
        bg.antialiasing = ClientPrefs.data.antialiasing;
        bg.scrollFactor.set(0, yScroll);
        bg.setGraphicSize(Std.int(bg.width * 1.175));
        bg.updateHitbox();
        bg.screenCenter();
        add(bg);

        checker = new FlxBackdrop(Paths.image('grid/Grid_lmao'));
        checker.updateHitbox();
        checker.scrollFactor.set(0, 0);
        checker.alpha = 0.7;
        checker.screenCenter(X);
        add(checker);

        if (ClientPrefs.data.backdrops) {
            checker.visible = false;
        } else {
            checker.visible = true;
        }       

        menuItems = new FlxTypedGroup<FlxSprite>();
        add(menuItems);

        for (i in 0...optionShit.length) {
            var offset:Float = 108 - (Math.max(optionShit.length, 4) - 4) * 80;
            var menuItem:FlxSprite = new FlxSprite(0, (i * 140) + offset);
            menuItem.antialiasing = ClientPrefs.data.antialiasing;
            menuItem.frames = Paths.getSparrowAtlas('mainmenu/menu_' + optionShit[i]);
            menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
            menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
            menuItem.animation.play('idle');
            menuItems.add(menuItem);
            var scr:Float = (optionShit.length - 4) * 0.135;
            if (optionShit.length < 6)
                scr = 0;
            menuItem.scrollFactor.set(0, scr);
            menuItem.updateHitbox();
            menuItem.screenCenter(X);
        }

        var psychVer:FlxText = new FlxText(12, FlxG.height - 44, 0, "Santiago Engine " + psychEngineVersion, 12);
        psychVer.scrollFactor.set();
        psychVer.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        add(psychVer);

        var fnfVer:FlxText = new FlxText(12, FlxG.height - 24, 0, "Friday Night Funkin' v. 0.2.8", 12);
        fnfVer.scrollFactor.set();
        fnfVer.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        add(fnfVer);

        changeItem();

        #if ACHIEVEMENTS_ALLOWED
        // Unlocks "Freaky on a Friday Night" achievement if it's a Friday and between 18:00 PM and 23:59 PM
        var leDate = Date.now();
        if (leDate.getDay() == 5 && leDate.getHours() >= 18)
            Achievements.unlock('friday_night_play');

        #if MODS_ALLOWED
        Achievements.reloadList();
        #end
        #end

        super.create();
    }

    override function update(elapsed:Float) {    
        checker.x += .5 * (elapsed / (1 / 120)); 
        checker.y -= 0.16;

        if (FlxG.sound.music.volume < 0.8) {
            FlxG.sound.music.volume += 0.5 * elapsed;
            if (FreeplayState.vocals != null)
                FreeplayState.vocals.volume += 0.5 * elapsed;
        }

        if (!selectedSomethin) {
            if (controls.UI_UP_P)
                changeItem(-1);

            if (controls.UI_DOWN_P)
                changeItem(1);

            if (controls.BACK) {
                selectedSomethin = true;
                FlxG.sound.play(Paths.sound('cancelMenu'));
                MusicBeatState.switchState(new TitleState());
            }

            if (controls.ACCEPT) {
                FlxG.sound.play(Paths.sound('confirmMenu'));

                if (ClientPrefs.data.flashing)
                    FlxFlicker.flicker(menuItems.members[curSelected], 1, 0.06, false, false, function(flick:FlxFlicker) {
                        switch (optionShit[curSelected]) {
                            case 'story_mode':
                                MusicBeatState.switchState(new StoryMenuState());
                            case 'freeplay':
                                MusicBeatState.switchState(new FreeplayState());

                            #if MODS_ALLOWED
                            case 'mods':
                                MusicBeatState.switchState(new ModsMenuState());
                            #end

                            case 'credits':
                                MusicBeatState.switchState(new CreditsState());
                            case 'options':
                                MusicBeatState.switchState(new OptionsState());
                                OptionsState.onPlayState = false;
                                if (PlayState.SONG != null) {
                                    PlayState.SONG.arrowSkin = null;
                                    PlayState.SONG.splashSkin = null;
                                    PlayState.stageUI = 'normal';
                                }
                        }
                    });

                for (i in 0...menuItems.members.length) {
                    if (i == curSelected)
                        continue;
                    FlxTween.tween(menuItems.members[i], {x: 1200}, 0.4, {
                        ease: FlxEase.expoInOut,
                        onComplete: function(twn:FlxTween) {
                            menuItems.members[i].kill();
                        }
                    });
                }
            }
        }

        #if desktop
        if (controls.justPressed('debug_1'))
        {
            selectedSomethin = true;
            FlxG.mouse.visible = false;
            MusicBeatState.switchState(new MasterEditorMenu());
        }
        #end

        super.update(elapsed);
    }

    function changeItem(huh:Int = 0) {
        FlxG.sound.play(Paths.sound('scrollMenu'));
        menuItems.members[curSelected].animation.play('idle');
        menuItems.members[curSelected].updateHitbox();
        menuItems.members[curSelected].screenCenter(X);

        curSelected += huh;

        if (curSelected >= menuItems.length)
            curSelected = 0;
        if (curSelected < 0)
            curSelected = menuItems.length - 1;

        menuItems.members[curSelected].animation.play('selected');
        menuItems.members[curSelected].centerOffsets();
        menuItems.members[curSelected].screenCenter(X);
    }
}
