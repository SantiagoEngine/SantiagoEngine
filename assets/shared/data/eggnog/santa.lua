local cutsceneTime = false

precacheImage('week5/santa_speaks_assets/spritemap1')
precacheImage('week5/parents_shoot_assets/spritemap1')

luaDebugMode = true
function onCreatePost()
    makeFlxAnimateSprite('santaDead', 0, 0, 'week5/santa_speaks_assets')
    addAnimationBySymbol('santaDead', 'talkAnim', 'santa whole scene', 24, false)
    setProperty('santaDead.x', -458)
    setProperty('santaDead.y', 498)
    setObjectOrder('santaDead', getObjectOrder('santa'))
    addLuaSprite('santaDead')

    makeFlxAnimateSprite('parentsShoot', 0, 0, 'week5/parents_shoot_assets')
    addAnimationBySymbol('parentsShoot', 'shootthisbitch', 'parents whole scene', 24, false)
    setProperty('parentsShoot.x', -516)
    setProperty('parentsShoot.y', 503)
    setObjectOrder('parentsShoot', getObjectOrder('santaDead'))
    addLuaSprite('parentsShoot')

    setProperty('santaDead.alpha', 0.001)
    setProperty('parentsShoot.alpha', 0.001)
end

function startCutscene()
    setProperty('santa.visible', false)
    setProperty('dad.visible', false)
    
    setProperty('santaDead.alpha', 1)
    setProperty('parentsShoot.alpha', 1)
    playAnim('santaDead', 'talkAnim')
    playAnim('parentsShoot', 'shootthisbitch')

    startTween('camTween1', 'camFollow', {x = getProperty('santaDead.x')+300, y = getProperty('santaDead.y')}, 2.8, {ease = 'expoOut'})
    startTween('zoomTween1', 'game', {defaultCamZoom = 0.73}, 2, {ease = 'quadInOut'})

    playSound('santa_emotion', 1.0)
    
    runTimer('tmr1', 2.8)
    runTimer('tmr2', 11.375)
    runTimer('tmr3', 12.83)
    runTimer('tmr4', 15)
    runTimer('tmr5', 16)
end

function onTimerCompleted(tag)
    if tag == 'tmr1' then
        startTween('camTween2', 'camFollow', {x = getProperty('santaDead.x')+150, y = getProperty('santaDead.y')}, 9, {ease = 'quartInOut'})
        startTween('zoomTween2', 'game', {defaultCamZoom = 0.79}, 9, {ease = 'quadInOut'})
    end

    if tag == 'tmr2' then
        playSound('santa_shot_n_falls', 1)
    end

    if tag == 'tmr3' then
        runHaxeCode("FlxG.camera.shake(0.005, 0.2);")
        startTween('camTween3', 'camFollow', {x = getProperty('santaDead.x')+160, y = getProperty('santaDead.y')+80}, 5, {ease = 'expoOut'})
    end

    if tag == 'tmr4' then
        callMethod('camHUD.fade', {0x000000, 1, false, nil, true})
    elseif tag == 'tmr5' then
        callMethod('camHUD.fade', {0x000000, 0.5, true, nil, true})
        endSong(true)
    end
end

function onEndSong()
    if not cutsceneTime then
        cutsceneTime = true
        startCutscene()
        return Function_Stop;
    end
    return Function_Continue;
end