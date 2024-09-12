-------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------  CONFIGURATION  ----------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------  Pre-Req's  ------------------------------------------------------------------
--MissionName = 'defined by doScript on mission start.' used by basically anything that relies on tableIO (used as prefix for save data filenames). This needs to be configured in a missionStart trigger in miz
--place other config scripts here that need to load before their main script. if they must load before the config, they should be loaded by the other script loader, but still configured here.
----------------------------------------------------------------- Script Config -----------------------------------------------------------------






--------------------------------------------------------- ChaosScriptLoader Post-Config ---------------------------------------------------------
-- put the file names of the scripts desired to load below. Load Order (for dependancies) is in the order you place them. ie: {TableIO.lua, ChaosTools.lua} will make TableIO load first.
-- if a script does not *require* init at before mission start, or need config *after* it is loaded, then place the script here, otherwise place them in the miz scriptloader. 
local fList = { 'tableIO.lua', 'ChaosTools.lua', 'CTLD-2.lua', 'KillTracker.lua', 'LifeHandler.lua', 'CarrierConfigurator.lua' }
for i = 1, #fList do
    env.info("ChaosScriptLoader - Loading: " .. fList[i])
    assert(loadfile(FilePath .. fList[i]))()
end

env.info("ChaosScriptLoader: all scripts sucessfully loaded!")
