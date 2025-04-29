package states.editors;

class CrashState extends MusicBeatState
{
    override function create()
    {
        var crashText = new FlxText(0, FlxG.height / 2 - 10, FlxG.width, 'PRESS ENTER TO CRASH');
        crashText.setFormat("PhantomMuff 1.5", 64, FlxColor.WHITE, CENTER);
        add(crashText);

        super.create();
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if (FlxG.keys.justPressed.ENTER)
            forceCrash();
    }

    function forceCrash()
    {
        trace('Crashing...');
        null.getClass(); //Well.. I think this is gonna get a Null Object reference ig lol ignore this shit
    }
}