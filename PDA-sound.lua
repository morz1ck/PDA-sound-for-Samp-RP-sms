script_author('morz1ck');
script_name('PDA-SOUND');

require('lib.moonloader');
sampev = require("lib.samp.events");


local inicfg = require('inicfg');
local IniFilename = 'PDAconfig.ini';

local ini = inicfg.load({
    enabled = {
        isActive = false;
        volume = 100;
    }
}, IniFilename);
inicfg.save(ini, IniFilename);

local soundPath = getWorkingDirectory() .. '\\resource\\pda.mp3';
local sound = loadAudioStream(soundPath);
assert(sound, 'File not found!');


local tag = '[PDA-SOUND]: ';
local main_color = 0xFF1493;
local white_color = '{ffffff}'

function main()
    if not isSampAvailable() then wait(0) end
    sampAddChatMessage(tag.. white_color .. 'ПДА активирован, чтобы включить или выключить звук введите {FFC0CB}/pda.' .. white_color .." Автор: {FF1493}morz1ck", main_color);
    sampRegisterChatCommand('pda', function ()
        ini.enabled.isActive = not ini.enabled.isActive;
        inicfg.save(ini, IniFilename);
        sampAddChatMessage(tag .. (ini.enabled.isActive and '{7FFF00}Включен.' or '{FF0000}Выключен.'), -1); end);
    sampRegisterChatCommand('pdavol', cmd_pdavol);
    setAudioStreamVolume(sound, ini.enabled.volume / 100)

    wait(-1);
end


function sampev.onServerMessage(color, text)
    if not ini.enabled.isActive then return end;

    if text:find('SMS:') and text:find('Отправитель: ') then
        setAudioStreamState(sound, 0);
        setAudioStreamState(sound, 1);
    end
end

function cmd_pdavol(arr)
    if tonumber(arr) and (tonumber(arr) >= 0 and tonumber(arr) <= 1000) then
        arr = arr / 100;
        ini.enabled.volume = arr;
        inicfg.save(ini, IniFilename);
        setAudioStreamVolume(sound, ini.enabled.volume / 100);
        sampAddChatMessage(tag .. white_color .. "Громкость звука установлена на " .. arr * 100 .." процентов громкости.", main_color); 
    else sampAddChatMessage(tag .. white_color .. '{FFFFFF}Введите /pdavol [0-100]', main_color); end
end

-- default sound
function sampev.onPlaySound(soundId, position)
    if soundId == 1052 then return false; end
end

