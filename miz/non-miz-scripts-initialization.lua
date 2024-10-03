--to the guy lurking around here trying to learn from my stuff like I did with grimes work, just come ask me. -Chaos

lfs.writedir()
FilePath = lfs.writedir() .. "Missions/scripts/"           --scripts environment path relative to savedgames. this resolves to Driveletter:\Users\<username>\Saved Games\DCS.openbeta\Missions\scripts\

env.info("Chaos Log: Loading scripts in NonMiz init", 3)

if lfs and lfs.attributes then
    env.info('Chaos Log: lfs attributes exists, continuing script init')

    if lfs.attributes(FilePath, 'size') then
        env.info('Chaos Log: Environment detected')
    else
        env.error('Chaos Error: Environment could not be determined.. Check filepaths for init script, or script storage location')
        trigger.action.outText("Environment could not be determined.. Check filepaths for init script, or script storage location", 10000)
    end

else
    env.error("Chaos Error: NO LFS - GO CHANGE THIS AT: DCS World\\Scripts\\MissionScripting.lua")
    trigger.action.outText("LFS IS NOT ENABLED, GO CHANGE THIS AT: DCS World\\Scripts\\MissionScripting.lua", 10000)
end

local fList = { 'mist.lua', 'skynet-iads.lua', 'CONFIG_' .. MissionName .. '.lua' }
for i = 1, #fList do
    env.info("Chaos Log: Loading: " .. fList[i])
    assert(loadfile(FilePath .. fList[i]))()
end
