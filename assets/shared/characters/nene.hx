import flixel.group.FlxTypedSpriteGroup;
import flixel.FlxG;
import backend.ClientPrefs;

var pupil = null;
var eyeWhites:FlxSprite;
var stereoBG:FlxSprite;
var abot = null;
var abotViz = null;

	var pupilState:Int = 0;

	var PUPIL_STATE_NORMAL = 0;
	var PUPIL_STATE_LEFT = 1;
function onCreate() {
stereoBG = new FlxSprite(0, 0, Paths.image('characters/abot/stereoBG'));

				eyeWhites = new FlxSprite(0, 0).makeGraphic(160, 60, 0xFFFFFFFF);

			pupil = new FlxAnimate(0, 0);
			Paths.loadAnimateAtlas(pupil, 'characters/abot/systemEyes');
		pupil.x = PlayState.instance.gf.x;
		pupil.y = PlayState.instance.gf.y;

			abot = new FlxAnimate(0, 0);
			Paths.loadAnimateAtlas(abot, 'characters/abot/abotSystem');
		abot.x = PlayState.instance.gf.x;
		abot.y = PlayState.instance.gf.y;

		abotViz = new FlxTypedSpriteGroup();
		abotViz.x = PlayState.instance.gf.x;
		abotViz.y = PlayState.instance.gf.y;

    var visFrms:FlxAtlasFrames = Paths.getSparrowAtlas('aBotViz');
      var visStr = 'viz';

    var positionX:Array<Float> = [0, 59, 56, 66, 54, 52, 51];
    var positionY:Array<Float> = [0, -8, -3.5, -0.4, 0.5, 4.7, 7];

      var viz1:FlxSprite = new FlxSprite(0, 0);
      viz1.frames = visFrms;
      abotViz.add(viz1);

      viz1.animation.addByPrefix('VIZ', visStr + 1, 0);
      viz1.animation.play('VIZ', false, false, 6);

      var viz2:FlxSprite = new FlxSprite(59, -8);
      viz2.frames = visFrms;
      abotViz.add(viz2);

      viz2.animation.addByPrefix('VIZ', visStr + 2, 0);
      viz2.animation.play('VIZ', false, false, 6);

      var viz3:FlxSprite = new FlxSprite(115, -11.5);
      viz3.frames = visFrms;
      abotViz.add(viz3);

      viz3.animation.addByPrefix('VIZ', visStr + 3, 0);
      viz3.animation.play('VIZ', false, false, 6);

      var viz4:FlxSprite = new FlxSprite(181, -11.9);
      viz4.frames = visFrms;
      abotViz.add(viz4);

      viz4.animation.addByPrefix('VIZ', visStr + 4, 0);
      viz4.animation.play('VIZ', false, false, 6);

      var viz5:FlxSprite = new FlxSprite(235, -11.4);
      viz5.frames = visFrms;
      abotViz.add(viz5);

      viz5.animation.addByPrefix('VIZ', visStr + 5, 0);
      viz5.animation.play('VIZ', false, false, 6);

      var viz6:FlxSprite = new FlxSprite(287, -6.7);
      viz6.frames = visFrms;
      abotViz.add(viz6);

      viz6.animation.addByPrefix('VIZ', visStr + 6, 0);
      viz6.animation.play('VIZ', false, false, 6);

      var viz7:FlxSprite = new FlxSprite(338, 0.3);
      viz7.frames = visFrms;
      abotViz.add(viz7);

      viz7.animation.addByPrefix('VIZ', visStr + 7, 0);
      viz7.animation.play('VIZ', false, false, 6);
}

	var refershedLol:Bool = false;
	var VULTURE_THRESHOLD = 0.25 * 2;
	var STATE_DEFAULT = 0;
	var STATE_PRE_RAISE = 1;
	var STATE_RAISE = 2;
	var STATE_READY = 3;
	var STATE_LOWER = 4;
	var currentState:Int = STATE_DEFAULT;
	var MIN_BLINK_DELAY:Int = 3;
	var MAX_BLINK_DELAY:Int = 7;
	var blinkCountdown:Int = MIN_BLINK_DELAY;

	var start:Bool = false;

function onUpdatePost() {
abot.visible = PlayState.instance.gf.visible;
eyeWhites.visible = PlayState.instance.gf.visible;
pupil.visible = PlayState.instance.gf.visible;
stereoBG.visible = PlayState.instance.gf.visible;
abotViz.visible = PlayState.instance.gf.visible;

abot.antialiasing = ClientPrefs.data.antialiasing;
eyeWhites.antialiasing = ClientPrefs.data.antialiasing;
pupil.antialiasing = ClientPrefs.data.antialiasing;
stereoBG.antialiasing = ClientPrefs.data.antialiasing;
abotViz.antialiasing = ClientPrefs.data.antialiasing;

if(start)
drawFFT();

		if (pupil.anim.isPlaying)
		{
			switch (pupilState)
			{
				case PUPIL_STATE_NORMAL:
					if (pupil.anim.curFrame >= 17)
					{
						pupilState = PUPIL_STATE_LEFT;
						pupil.anim.pause();
					}

				case PUPIL_STATE_LEFT:
					if (pupil.anim.curFrame >= 31)
					{
						pupilState = PUPIL_STATE_NORMAL;
						pupil.anim.pause();
					}

			}
		}

		if (!refershedLol)
		{
			abot.x = PlayState.instance.gf.x - 100;
			abot.y = PlayState.instance.gf.y + 316;

			abotViz.x = PlayState.instance.gf.x + 100;
			abotViz.y = PlayState.instance.gf.y + 400;

			eyeWhites.x = abot.x + 40;
			eyeWhites.y = abot.y + 250;

			pupil.x = PlayState.instance.gf.x - 607;
			pupil.y = PlayState.instance.gf.y - 176;

			stereoBG.x = abot.x + 150;
			stereoBG.y = abot.y + 30;

			PlayState.instance.addBehindGF(stereoBG);
			PlayState.instance.addBehindGF(abotViz);
			PlayState.instance.addBehindGF(eyeWhites);
			PlayState.instance.addBehindGF(pupil);
			PlayState.instance.addBehindGF(abot);

			refershedLol = true;
		}

		if (shouldTransitionState()) {
			transitionState();
		}

if (PlayState.instance.gf.animation.curAnim.finished)
{
onAnimationFinished(PlayState.instance.gf.animation.curAnim.name);
}

if (PlayState.instance.gf.animation.curAnim != null)
{
onAnimationFrame(PlayState.instance.gf.animation.curAnim.name,PlayState.instance.gf.animation.curAnim.curFrame,PlayState.instance.gf.animation.curAnim.frameIndex);
}
}

function onSongStart()
{
start = true;
}

var gfSpeed:Int = 1;

function onBeatHit()
{
if (PlayState.instance.gfSpeed != 10000000) {
gfSpeed = PlayState.instance.gfSpeed;
PlayState.instance.gfSpeed = 10000000;
}
if(PlayState.instance.gf.specialAnim == false)
{
		if (PlayState.instance.gf != null && curBeat % Math.round(gfSpeed * PlayState.instance.gf.danceEveryNumBeats) == 0 && !PlayState.instance.gf.stunned)
			dance(true);
}

if (curBeat % gfSpeed == 0)
{
	abot.anim.play("");
    	abot.anim.curFrame = 1;
}
}

function onCountdownTick(tick)
{
	abot.anim.play("");
    	abot.anim.curFrame = 1;
}

function onMoveCamera(focus:String)
{
	if (focus == 'boyfriend')
	{
movePupilsRight();
	}
	else if (focus == 'dad')
	{
movePupilsLeft();
	}
}

function goodNoteHit(note:Note)
{
		switch(note.noteType) {
			case "weekend-1-lightcan":
				movePupilsLeft();
			case "weekend-1-kickcan":
			case "weekend-1-kneecan":
			case "weekend-1-cockgun":
				movePupilsRight();
			case "weekend-1-firegun":
			default:
		}
}

function opponentNoteHit(note:Note)
{
		switch(note.noteType) {
			case "weekend-1-lightcan":
				movePupilsLeft();
			case "weekend-1-kickcan":
			case "weekend-1-kneecan":
			case "weekend-1-cockgun":
				movePupilsRight();
			case "weekend-1-firegun":
			default:
		}
}

function noteMiss(note:Note)
{
		switch(note.noteType) {
			case "weekend-1-lightcan":
				movePupilsLeft();
			case "weekend-1-kickcan":
			case "weekend-1-kneecan":
			case "weekend-1-cockgun":
				movePupilsRight();
			case "weekend-1-firegun":
			default:
		}
}

var hasDanced:Bool = true;

	function dance(forceRestart:Bool) {
		switch(currentState) {
			case STATE_DEFAULT:
				if (hasDanced) {
					PlayState.instance.gf.playAnim('danceRight', forceRestart);
				} else {
					PlayState.instance.gf.playAnim('danceLeft', forceRestart);
				}
				hasDanced = !hasDanced;
			case STATE_PRE_RAISE:
				PlayState.instance.gf.playAnim('danceLeft', false);
				hasDanced = false;
			case STATE_READY:
				if (blinkCountdown == 0) {
					PlayState.instance.gf.playAnim('idleKnife', false);
					blinkCountdown = FlxG.random.int(MIN_BLINK_DELAY, MAX_BLINK_DELAY);
				} else {
					blinkCountdown--;
				}
			default:
		}
	}

	function movePupilsLeft() {
		if (pupilState == PUPIL_STATE_LEFT) return;
		pupil.anim.play('');
		pupil.anim.curFrame = 0;
	}

	function movePupilsRight() {
		if (pupilState == PUPIL_STATE_NORMAL) return;
		pupil.anim.play('');
		pupil.anim.curFrame = 17;
	}

	function shouldTransitionState():Bool {
		return PlayState.instance.boyfriend.curCharacter != "pico-blazin";
	}

	var animationFinished:Bool = false;

	function onAnimationFinished(name:String) {
		switch(currentState) {
			case STATE_RAISE:
				if (name == "raiseKnife") {
					animationFinished = true;
					transitionState();
				}
			case STATE_LOWER:
				if (name == "lowerKnife") {
					animationFinished = true;
					transitionState();
				}
			default:
		}
	}

	function onAnimationFrame(name:String, frameNumber:Int, frameIndex:Int) {
		switch(currentState) {
			case STATE_PRE_RAISE:
				if (name == "danceLeft" && frameNumber == 14) {
					animationFinished = true;
					transitionState();
				}
			default:
		}
	}

	function transitionState() {
		switch (currentState) {
			case STATE_DEFAULT:
				if (PlayState.instance.health <= VULTURE_THRESHOLD) {
					currentState = STATE_PRE_RAISE;
				} else {
					currentState = STATE_DEFAULT;
				}
			case STATE_PRE_RAISE:
				if (PlayState.instance.health > VULTURE_THRESHOLD) {
					currentState = STATE_DEFAULT;
				} else if (animationFinished) {
					currentState = STATE_RAISE;
					PlayState.instance.gf.playAnim('raiseKnife');
					animationFinished = false;
				}
			case STATE_RAISE:
				if (animationFinished) {
					currentState = STATE_READY;
					animationFinished = false;
				}
			case STATE_READY:
				if (PlayState.instance.health > VULTURE_THRESHOLD) {
					currentState = STATE_LOWER;
					PlayState.instance.gf.playAnim('lowerKnife');
				}
			case STATE_LOWER:
				if (animationFinished) {
					currentState = STATE_DEFAULT;
					animationFinished = false;
				}
			default:
				currentState = STATE_DEFAULT;
		}
	}

		function drawFFT()
		{
			var snd = FlxG.sound.music;

			var currentTime = snd.time;
			
			var buffer = snd._sound.__buffer;
			var bytes = buffer.data.buffer;
			
			var length = bytes.length - 1;
			var khz = (buffer.sampleRate / 1000);
			var channels = buffer.channels;
			var stereo = channels > 1;
			
			var index = Math.floor(currentTime * khz);

			var sampl = [];
			
			for (i in index...index + abotViz.members.length) {
				if (i >= 0) {
					var byte = bytes.getUInt16(i * channels * 2);

					if (byte > 65535 / 2) byte -= 65535;

					sampl.push(byte / 65535 * 5);
				}
			}

    for (i in 0...abotViz.members.length)
    {
      var animFrame:Int = Math.round(sampl[i] * 5);
      animFrame = Math.round(animFrame * FlxG.sound.volume);

      animFrame = Math.floor(Math.min(5, animFrame));
      animFrame = Math.floor(Math.max(0, animFrame));

      animFrame = Std.int(Math.abs(animFrame - 5));

      abotViz.members[i].animation.curAnim.curFrame = animFrame;
    }
		}