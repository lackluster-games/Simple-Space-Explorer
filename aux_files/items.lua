--File contains functions for generating and using ITEM objects

ITEM = {name = nil, func = nil, price = nil, quant = nil, item_type = nil}
ITEM.__index = ITEM

--list of names for rare items
local RARE_ITEMS = {
                    "Mystery Box","E.T. Cartridge Game","Sonichu Medallion","Asperchu Medallion","Spock's Brain",
                    "Kurlan Naiskos","D.B. Cooper's Frozen Head","Apple Newton","Bill Of Rights","Blood's Source Code",
                    "Apolo 11 flag","Luke's Blue LightSaber", "Duke Nukem's blessing","Hand sanitizer","Toilet Paper",
                    "Hypoallergenic Peanuts","Romulan Ale","Purple Space Bazooka","Action Comics #1","Nugget of Kryptonite",
                    "Space Twinkie","Nukie VHS","Cyborg Bill Doll","Alabam Man Doll"
                }


--Generate new ITEM object
function ITEM:new(name,func,price,quant,type)
    local o     = setmetatable({},ITEM)
    o.name      = name
    o.func      = func
    o.price     = price
    o.quant     = quant
    o.item_type = item_type
    return o
end

--Make a Rare ITEM object
function makeRareItem(rand)
    local i = rand(1,#RARE_ITEMS)
    return ITEM:new(RARE_ITEMS[i],nil,rand(200,800),1,"Rare")
end

--adds rare items to player's inventory.
function playerAddRareItems(inv,rand,min,max)
    local n = rand(min,max)
    for i = 1,n,1 do
        local item
        repeat
            item = makeRareItem(rand)
        until(inv[item.name] == nil)
        inv[item.name] = item
    end
end

--Player can upgrade their ship's weapon
local function upgradeWeapon(name,print_str)
    if print_str == nil then
        print_str = true
    end
    local weapon
    if name == "Weapon I" and PLAYER.attk_level < 1 then
        weapon = PLAYER.attk / 4
        PLAYER.attk_level = 1
        PLAYER_SCORE = PLAYER_SCORE + 10
    elseif name == "Weapon II"  and PLAYER.attk_level < 2 then
        if PLAYER.attk_level < 2 then
            upgradeWeapon("Weapon I",false)
        end
        weapon = PLAYER.attk / 3
        PLAYER.attk_level = 2
        PLAYER_SCORE = PLAYER_SCORE + 20
    elseif name == "Weapon III" and PLAYER.attk_level < 3 then
        if PLAYER.attk_level < 2 then
            upgradeWeapon("Weapon II",false)
        end
         weapon = PLAYER.attk / 2
         PLAYER.attk_level = 3
        PLAYER_SCORE = PLAYER_SCORE + 30
    else
        return string.format("%s wasn't able to upgrade their weapons",PLAYER.name),false
    end
    local prev_weapon = PLAYER.attk
    PLAYER.attk = PLAYER.attk + weapon
    return string.format("%s upgraded their weapon from %d to %d",PLAYER.name,prev_weapon,PLAYER.attk),print_str
end

--sets the price of weapon upgrades.
local function setWeaponPrice(rand,name)
    local min,max
    if name == "Weapon I" then
        min = 220
        max = 315
    elseif name == "Weapon II" then
        min = 415
        max = 515
    else
        min = 615
        max = 750
    end
    return rand(min,max)
end

--MAke a upgrade weapon ITEM object
local function makeUpgradedWeapon(rand)
    local n = rand(0,12)
    local name
    if n < 8 then
        name = "Weapon I"
    elseif n < 12 then
        name = "Weapon II"
    else
        name = "Weapon III"
    end
    local price = setWeaponPrice(rand,name)
    return ITEM:new(name,upgradeWeapon,price,1,"Upgrade")
end

--Player can upgrade their ship's hull
local function upgradeHull(name,print_str)
    local hull
    if print_str == nil then
        print_str = true
    end
    if name == "Hull I"  and PLAYER.hull_level < 1 then
        hull = PLAYER.hull / 4
        PLAYER.hull_level = 1
        PLAYER_SCORE = PLAYER_SCORE + 10
    elseif name == "Hull II" and PLAYER.hull_level < 2 then
        if PLAYER.hull_level < 1 then
            upgradeHull("Hull I",false)
        end
        hull = PLAYER.hull / 3
        PLAYER.hull_level = 2
        PLAYER_SCORE = PLAYER_SCORE + 20
    elseif name == "Hull III" and PLAYER.hull_level < 3 then
        if PLAYER.hull_level < 2 then
            upgradeHull("Hull II",false)
        end
        hull = PLAYER.hull / 2
        PLAYER.hull_level = 3
        PLAYER_SCORE = PLAYER_SCORE + 30
    else
        return string.format("%s wasn't able to upgrade their hull.",PLAYER.name),false
    end
    local prev_hull = PLAYER.hull
    PLAYER.hull = PLAYER.hull + hull
    return string.format("%s upgraded their hull from %d to %d",PLAYER.name,prev_hull,PLAYER.hull),print_str
end

--Set the price of hull upgrade ITEM objects
local function setHullPrice(rand,name)
    local min,max
    if name == "Hull I" then
        min = 250
        max = 375
    elseif name == "Hull II" then
        min = 475
        max = 525
    else
        min = 675
        max = 750
    end
    return rand(min,max)
end

--Generate a hull upgrade ITEM object
local function makeUpgradedHull(rand)
    local n = rand(0,12)
    local name
    if n < 8 then
        name = "Hull I"
    elseif n < 12 then
        name = "Hull II"
    else
        name = "Hull III"
    end
    local price = setHullPrice(rand,name)
    return ITEM:new(name,upgradeHull,price,1,"Upgrade")
end

--Player can upgrade thier engine
local function upgradeEngine(name,print_str)
    if print_str == nil then
        print_str = true
    end
    local speed
    if name == "Engine I"  and PLAYER.engine_level < 1 then
        speed = PLAYER.speed / 4
        PLAYER.engine_level = 1
        PLAYER_SCORE = PLAYER_SCORE + 10
    elseif name == "Engine II" and PLAYER.engine_level < 2 then
        if PLAYER.engine_level < 1 then
            upgradeEngine("Engine I",false)
        end
        speed = PLAYER.speed / 3
        PLAYER.engine_level = 2
        PLAYER_SCORE = PLAYER_SCORE + 20
    elseif name == "Engine III" and PLAYER.engine_level < 3 then
        if PLAYER.engine_level < 2 then
            upgradeEngine("Engine II",false)
        end
        speed = PLAYER.speed / 2
        PLAYER.engine_level = 3
        PLAYER_SCORE = PLAYER_SCORE + 30
    else
        return string.format("%s wasn't able to upgrade their engines",PLAYER.name),false
    end
    local prev_speed = PLAYER.speed
    PLAYER.speed = PLAYER.speed + speed
    return string.format("%s upgraded their engines from %d to %d",PLAYER.name,prev_speed,PLAYER.speed),print_str
end

--Set the price of an engine upgrade object
local function setEnginePrice(rand,name)
    local min,max
    if name == "Engine I" then
        min = 200
        max = 350
    elseif name == "Engine II" then
        min = 450
        max = 575
    else
        min = 650
        max = 750
    end
    return rand(min,max)
end

--generate a new upgrade engine ITEM object
local function makeUpgradedEngine(rand)
    local n = rand(0,12)
    local name
    if n < 8 then
        name = "Engine I"
    elseif n < 12 then
        name = "Engine II"
    else
        name = "Engine III"
    end
    local price = setEnginePrice(rand,name)
    return ITEM:new(name,upgradeEngine,price,1,"Upgrade")
end

--make fuel for inventory
function makeFuel(rand,min,max)
    local quant = rand(min,max)
    local name  = "Fuel"
    local price = rand(1,15)
    return ITEM:new(name,getFuel,price,quant,"Fuel")
end

--update the number of and item in inventory
local function updateQuantity(inv,item)
    inv[item.name].quant = inv[item.name].quant + item.quant
end

--Randomly select a new ITEM object to create
function getRandItem(rand)
   local n = rand(0,16)
   if n < 4 then
       return makeUpgradedEngine(rand)
   elseif n < 8 then
       return makeUpgradedHull(rand)
   elseif n < 11 then
       return makeUpgradedWeapon(rand)
   else
       return makeRareItem(rand)
   end
end

--add an item to inventory
function addItem(inv,item,quant)
    if inv[item.name] ~= nil then
        inv[item.name].quant = inv[item.name].quant + quant
    else
        inv[item.name] = item
    end
end

--remove item from inventory
function removeItem(inv,item,quant)
    if inv[item.name].quant <= quant then
        inv[item.name] = nil
    else
        inv[item.name].quant = inv[item.name].quant - quant
    end
end

--Make the inventory for an OBJECT
function makeInv(rand,add,min_items,max_items,func)
    local n         = rand(min_items,max_items)
    local inv       = {}
    local additem   = addItem
    for i=1,n,1 do
        local item = func(rand)
        additem(inv,item,item.quant)
    end
    return inv
end

--find the length of the longest rare item name, return the # of pixles
function findLongestName()
    local longest_name = "1"
    for i=1,#RARE_ITEMS,1 do
        if #RARE_ITEMS[i] > #longest_name then
            longest_name = RARE_ITEMS[i]
        end
    end
    return MAIN_FONT:getWidth(longest_name .. "999  ")
end

