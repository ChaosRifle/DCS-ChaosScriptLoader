------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------  CONFIG  -------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
--PreReqs: MissionName = 'defined by doScript on mission start.' --used by LifeHandler, KillTracker, BPK, and basically anything else that relies on tableIO (used as prefix for save data filenames). This needs to be configured in a missionStart trigger in miz
--place other config scripts here that need to load before their main script. if they must load before the config, they should be loaded by the other script loader, but still configured here.


--ControlAPI communications

--BPK

--missionSequencing

--skynet

--LifeHandler

--CarrierConfigurator






--ScriptLoader post-config
local fList = { 'tableIO.lua', 'ChaosTools.lua', 'CTLD-2.lua', 'KillTracker.lua', 'LifeHandler.lua', 'CarrierConfigurator.lua' }
for i = 1, #fList do
    env.info("Chaos Log: Loading: " .. fList[i])
    assert(loadfile(FilePath .. fList[i]))()
end

env.info("Chaos Log: all scripts loaded!")
