package objects;

import openfl.utils.ByteArray;
import openfl.media.SoundMixer; // Certifique-se de importar a classe corretamente

/*
Aqui estamos criando um "wrapper" para o método computeSpectrum de SoundMixer.
Usamos @:native para forçar o link para o código nativo que chama a função do SoundMixer.
*/

@:native("openfl.media.SoundMixer")
extern class SoundMixerAccess
{
    public static function computeSpectrum(data:ByteArray, FFTMode:Bool = false, stretchFactor:Int = 0):Void;
}
