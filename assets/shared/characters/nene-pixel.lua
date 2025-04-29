function onCreate()

    makeAnimatedLuaSprite('bombox', 'characters/bombox', -100, 0)
    addAnimationByPrefix('bombox', 'idle', 'beat', 36, false)
    addAnimationByPrefix('bombox', 'beat1', '1beat', 48, false)
    addAnimationByPrefix('bombox', 'beat2', '2beat', 48, true)
    addAnimationByPrefix('bombox', 'beat3', '3beat', 48, true)
    addAnimationByPrefix('bombox', 'beat4', '4beat', 48, true)
    scaleObject('bombox', 6, 6)
    setProperty('bombox.antialiasing', false)
    setLuaSpriteScrollFactor('bombox', 0.97, 0.95)
    addLuaSprite('bombox', false)

    makeAnimatedLuaSprite('aBotPixel', 'characters/aBotPixel', 1800, 1220)
    addAnimationByPrefix('aBotPixel', 'idle', 'idle', 24, true)
    scaleObject('aBotPixel', 6, 6)
    setProperty('aBotPixel.antialiasing', false)
    setLuaSpriteScrollFactor('aBotPixel', 0.95, 0.95)
    addLuaSprite('aBotPixel', false)


    makeAnimatedLuaSprite('eye', 'characters/bombox', 0, 0)
    addAnimationByPrefix('eye', 'eye', 'ssseye', 36, false)
    setLuaSpriteScrollFactor('eye', 0.95, 0.95)
	scaleObject('eye', 6, 6);
    setProperty('eye.antialiasing', false)
    addLuaSprite('eye', false)

    makeAnimatedLuaSprite('eye1', 'characters/bombox', 0, 0)
    addAnimationByPrefix('eye1', 'eye1', 'adeye lef', 36, false)
    setLuaSpriteScrollFactor('eye1', 0.95, 0.95)
	scaleObject('eye1', 6, 6);
    setProperty('eye1.antialiasing', false)
    addLuaSprite('eye1', false)

    makeAnimatedLuaSprite('eye2', 'characters/bombox', 0, 0)
    addAnimationByPrefix('eye2', 'eye2', 'feeye right', 36, false)
    setLuaSpriteScrollFactor('eye2', 0.95, 0.95)
	scaleObject('eye2', 6, 6);
    setProperty('eye2.antialiasing', false)
    addLuaSprite('eye2', false)

    setProperty('eye1.x', getProperty('gf.x') +23)
    setProperty('eye2.x', getProperty('gf.x') +23)
end

local contador = 0
local si = true

local targetX1 = 0
local targetX2 = 0
local moveDuration = 0.3

function onUpdate()

    if gfName == 'nene-pixel' then

        if songName == 'thorns-(pico-mix)' then
            if curStep >= 88 and curStep < 920 then
                setProperty('bombox.x', getProperty('gf.x') - 0.9)
                setProperty('bombox.y', getProperty('gf.y') - 0)
    
                setProperty('eye.x', getProperty('gf.x')  + 38)
                setProperty('eye.y', getProperty('gf.y') + 82)
                setProperty('eye1.y', getProperty('gf.y') +80)
                setProperty('eye2.y', getProperty('gf.y') +80)
            else
                setProperty('bombox.x', getProperty('gf.x') - 0)
                setProperty('bombox.y', getProperty('gf.y') - 0)
    
                setProperty('eye.x', getProperty('gf.x')  + 24)
                setProperty('eye.y', getProperty('gf.y') + 94)
                setProperty('eye1.y', getProperty('gf.y') +90)
                setProperty('eye2.y', getProperty('gf.y') +90)
            end

            if curStep == 920 then
                setObjectOrder('bombox', getObjectOrder('animatedEvilSchool')+ 1)
                setObjectOrder('eye', getObjectOrder('animatedEvilSchool')+ 1)
                setObjectOrder('eye1', getObjectOrder('eye')+ 1)
                setObjectOrder('eye2', getObjectOrder('eye')+ 1)
            end

        else
            setProperty('bombox.x', getProperty('gf.x') - 430)
            setProperty('bombox.y', getProperty('gf.y') - 350)

            setProperty('eye.x', getProperty('gf.x')  - 0)
            setProperty('eye.y', getProperty('gf.y') + 0)
            setProperty('eye1.y', getProperty('gf.y') +0)
            setProperty('eye2.y', getProperty('gf.y') +0)
        end
    end
    if contador == 50 and si then
        triggerEvent('Play Animation','good', 'gf')
        si = false
    elseif contador == 200 and si then
        triggerEvent('Play Animation','uh', 'gf')
        si = false
    end

    if contador == 51 then
        si = true
    elseif contador == 201 then
        si = true
    end
end

function onSectionHit()
    if gfName == 'nene-pixel' then
        if songName == 'thorns-(pico-mix)' then
            if curStep >= 88 and curStep < 920 then
                if not mustHitSection then
                    targetX1 = getProperty('gf.x') +35
                    targetX2 = getProperty('gf.x') +33
                else
                    targetX1 = getProperty('gf.x')  +37
                    targetX2 = getProperty('gf.x') +37
                end
            else
                if not mustHitSection then
                    targetX1 = getProperty('gf.x') +20
                    targetX2 = getProperty('gf.x') +18
                else
                    targetX1 = getProperty('gf.x')  +23
                    targetX2 = getProperty('gf.x') +23
                end
            end
        else
            if not mustHitSection then
                targetX1 = getProperty('gf.x') +20
                targetX2 = getProperty('gf.x') +18
            else
                targetX1 = getProperty('gf.x') +23
                targetX2 = getProperty('gf.x') +23
            end
        end

        doTweenX('eye1Tween', 'eye1', targetX1, moveDuration, 'sineOut')
        doTweenX('eye2Tween', 'eye2', targetX2, moveDuration, 'sineOut')

    end
end

function onStepHit()
    if curStep == 75 then
        playAnim('bombox','beat',false)
    end 
    if curStep == 0 or curStep == 8 or curStep == 16 or curStep == 20 or curStep == 24 or curStep == 29 or curStep == 32 or curStep == 40 or curStep == 48 or curStep == 52 or curStep == 70 or curStep == 77 or curStep == 924 then
        playAnim('bombox','beat1',false)
    end   
    if curStep == 56 or curStep == 612 then
        playAnim('bombox','beat2',false)
    end 
    if curStep == 64 or curStep == 72 or curStep == 80 or curStep == 600 or curStep == 792 then
        playAnim('bombox','beat3',false)
    end 
    if curStep == 664 then
        playAnim('bombox','beat4',false)
    end 

    if curStep == 539 or curStep == 544 or curStep == 552 or curStep == 560 or curStep == 568 or curStep == 576 or curStep == 584 or curStep == 592 or curStep == 604 then
        playAnim('bombox','beat1',false)
    end 
end

function goodNoteHit(id, direction, noteType, isSustainNote)
    if not isSustainNote then
        contador = contador + 1
    end
end

function noteMiss()
    contador = 0
end
