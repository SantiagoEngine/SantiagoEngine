package;

#if android
import android.content.Context;
#end
import debug.FPSCounter;
import flixel.graphics.FlxGraphic;
import flixel.addons.transition.FlxTransitionableState;

#if (cpp && windows)
import hxwindowmode.WindowColorMode;
#end

import flixel.FlxGame;
import flixel.FlxState;
import haxe.io.Path;
import openfl.Assets;
import openfl.Lib;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.display.StageScaleMode;
import flixel.util.FlxStringUtil;
import lime.app.Application;
import states.TitleState;
import states.ClickHereState;

#if linux
import lime.graphics.Image;
#end
// crash handler stuff
#if CRASH_HANDLER
import openfl.events.UncaughtErrorEvent;
import haxe.CallStack;
import haxe.io.Path;
#end

#if linux
@:cppInclude('./external/gamemode_client.h')
@:cppFileCode('
	#define GAMEMODE_AUTO
')
#end
class Main extends Sprite
{
	var game = {
		width: 1280, // WINDOW width
		height: 720, // WINDOW height
		initialState: ClickHereState, // initial game state
		zoom: -1.0, // game state bounds
		framerate: 60, // default framerate
		skipSplash: false, // if the default flixel splash screen should be skipped
		startFullscreen: false // if the game should start at fullscreen mode
	};

	public static var fpsVar:FPSCounter;

	// You can pretty much ignore everything from here on - your code should go in your states.

	public static function main():Void
	{
		Lib.current.addChild(new Main());
	}

	public function new()
	{
		super();

		FlxTransitionableState.skipNextTransIn = true;
		FlxTransitionableState.skipNextTransOut = true;

		WindowColorMode.setWindowColorMode(ClientPrefs.data.windowDarkMode);
		WindowColorMode.redrawWindowHeader();

		// Credits to MAJigsaw77 (he's the og author for this code)
		#if android
		Sys.setCwd(Path.addTrailingSlash(Context.getExternalFilesDir()));
		#elseif ios
		Sys.setCwd(lime.system.System.applicationStorageDirectory);
		#end

		if (stage != null)
		{
			init();
		}
		else
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
	}

	private function init(?E:Event):Void
	{
		if (hasEventListener(Event.ADDED_TO_STAGE))
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}

		setupGame();
	}

	private function setupGame():Void
	{
		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;

		if (game.zoom == -1.0)
		{
			var ratioX:Float = stageWidth / game.width;
			var ratioY:Float = stageHeight / game.height;
			game.zoom = Math.min(ratioX, ratioY);
			game.width = Math.ceil(stageWidth / game.zoom);
			game.height = Math.ceil(stageHeight / game.zoom);
		}

		#if LUA_ALLOWED Lua.set_callbacks_function(cpp.Callable.fromStaticFunction(psychlua.CallbackHandler.call)); #end
		Controls.instance = new Controls();
		ClientPrefs.loadDefaultKeys();
		#if ACHIEVEMENTS_ALLOWED Achievements.load(); #end
		addChild(new FlxGame(game.width, game.height, game.initialState, #if (flixel < "5.0.0") game.zoom, #end game.framerate, game.framerate,
			game.skipSplash, game.startFullscreen));

		#if !mobile
		fpsVar = new FPSCounter(10, 3, 0xFFFFFF);
		addChild(fpsVar);
		Lib.current.stage.align = "tl";
		Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
		if (fpsVar != null)
		{
			fpsVar.visible = ClientPrefs.data.showFPS;
		}
		#end

		#if linux
		var icon = Image.fromFile("icon.png");
		Lib.current.stage.window.setIcon(icon);
		#end

		#if html5
		FlxG.autoPause = false;
		FlxG.mouse.visible = false;
		#end

		#if CRASH_HANDLER
		Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onCrash);
		#end

		#if DISCORD_ALLOWED
		DiscordClient.prepare();
		#end

		// shader coords fix
		FlxG.signals.gameResized.add(function(w, h)
		{
			if (FlxG.cameras != null)
			{
				for (cam in FlxG.cameras.list)
				{
					if (cam != null && cam.filters != null)
						resetSpriteCache(cam.flashSprite);
				}
			}

			if (FlxG.game != null)
				resetSpriteCache(FlxG.game);
		});
	}

	static function resetSpriteCache(sprite:Sprite):Void
	{
		@:privateAccess {
			sprite.__cacheBitmap = null;
			sprite.__cacheBitmapData = null;
		}
	}

	#if CRASH_HANDLER
	function onCrash(e:UncaughtErrorEvent):Void
	{
		var errMsg = new StringBuf();
		var alertMsg = new StringBuf();
		var path:String;

		var safeDate = DateTools.format(Date.now(), "%Y-%m-%d_%H-%M-%S");
		path = "./crash/SantiagoEngine_" + safeDate + ".txt";

		var callStack:Array<StackItem> = CallStack.exceptionStack(true);

		errMsg.add("=== Santiago Engine Crash Report ===\n");
		errMsg.add("Time: " + Date.now().toString() + "\n");
		errMsg.add("Platform: " + Sys.systemName() + "\n");
		errMsg.add("Engine Version: " + getEngineVersion() + "\n");
		errMsg.add("_______________________________________\n\n");

		alertMsg.add("A crash occurred!\n");
		alertMsg.add("Error: " + Std.string(e.error) + "\n\n");
		alertMsg.add("Stack Trace:\n");

		for (stackItem in callStack)
		{
			switch (stackItem)
			{
				case FilePos(s, file, line, column):
					var lineStr = '$file (line $line)\n';
					errMsg.add(lineStr);
					alertMsg.add(lineStr);
				case Method(classname, method):
					var methodStr = '$classname.$method\n';
					errMsg.add(methodStr);
					alertMsg.add(methodStr);
				default:
					var other = Std.string(stackItem) + '\n';
					errMsg.add(other);
					alertMsg.add(other);
			}
		}

		errMsg.add("\nError: " + Std.string(e.error) + "\n");
		errMsg.add("If this error happened multiple times, please report it at:\n");
		errMsg.add("https://github.com/santiagocalebe/santiagoengine\n\n");
		errMsg.add("> Thank you for using Santiago Engine!\n");

		alertMsg.add("\nCrash log saved in:\n" + Path.normalize(path));
		alertMsg.add("\n\nPlease report it at:\nhttps://github.com/santiagoengine/santiagoengine/issues");

		if (!FileSystem.exists("./crash/"))
			FileSystem.createDirectory("./crash/");

		File.saveContent(path, errMsg.toString());

		Sys.println(errMsg.toString());
		Sys.println("CrashTXT saved in " + Path.normalize(path));

		Application.current.window.alert(alertMsg.toString(), "Santiago Engine - Crash");

		#if DISCORD_ALLOWED
		DiscordClient.shutdown();
		#end

		Sys.exit(1);
	}

	function getEngineVersion():String
	{
		return File.getContent('assets/config/v.txt');
	}
	#end
}
