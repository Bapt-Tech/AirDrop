-- Déclaration du mod
airdrop = {}

-- Liste des items possibles avec leur indice de rareté (1 = très commun, 10 = très rare)
local possible_items = {
    {name = "mcl_tools:axe_netherite", rarity = 5},
    {name = "mcl_tools:pick_netherite", rarity = 5},
    {name = "mcl_tools:shovel_netherite", rarity = 5},
    {name = "mcl_tools:sword_netherite", rarity = 6},
    {name = "mcl_armor:boots_netherite", rarity = 4},
    {name = "mcl_armor:helmet_netherite", rarity = 4},
    {name = "mcl_armor:leggings_netherite", rarity = 7},
    {name = "mcl_armor:chestplate_netherite", rarity = 7},
    {name = "mcl_core:apple_gold_enchanted", rarity = 10},
    {name = "mcl_nether:netherite_ingot", rarity = 2},
    {name = "mcl_hamburger:hamburger", rarity = 3},
    {name = "mcl_totems:totem", rarity = 5},
    {name = "mcl_core:diamond", rarity = 2},
    {name = "mcl_core:emerald", rarity = 3},
    {name = "mcl_core:stick", rarity = 1},
    {name = "mcl_bows:rocket", rarity = 4},
    {name = "mcl_mobspawners:spawner", rarity = 10},
    {name = "mcl_armor:elytra", rarity = 10}
}

-- Fonction pour générer des items aléatoires en fonction de la rareté
local function get_random_items()
    local items = {}
    for _, item_info in ipairs(possible_items) do
        -- Calculer la probabilité d'apparition en fonction de la rareté
        local chance = 11 - item_info.rarity
        if math.random(1, 10) <= chance then
            local count = math.random(1, math.ceil(10 / item_info.rarity)) -- Nombre d'unités de cet item influencé par la rareté
            table.insert(items, {name = item_info.name, count = count})
        end
    end
    return items
end

-- Fonction pour générer le coffre avec des items aléatoires
function airdrop.spawn_airdrop(pos)
    -- Création de la structure
    local structure_height = 10
    for y = 0, structure_height do
        minetest.set_node({x = pos.x, y = pos.y + y, z = pos.z}, {name = "mcl_core:wood"})
    end

    -- Création du coffre
    minetest.set_node({x = pos.x, y = pos.y + structure_height + 1, z = pos.z}, {name = "mcl_chests:chest"})

    -- Ajout des items au coffre
    local chest_meta = minetest.get_meta({x = pos.x, y = pos.y + structure_height + 1, z = pos.z})
    local inv = chest_meta:get_inventory()
    local items = get_random_items()
    
    local slots_filled = {}
    for _, item in ipairs(items) do
        local slot
        repeat
            slot = math.random(0, inv:get_size("main") - 1)
        until not slots_filled[slot]
        slots_filled[slot] = true
        inv:set_stack("main", slot + 1, item.name .. " " .. item.count)
    end
end

-- Commande /airdrop
minetest.register_chatcommand("airdrop", {
    description = "Spawns an airdrop structure with a chest at a random location near (1000, 0, 1000) with items based on their rarity",
    privs = {server=true},
    func = function(name)
        -- Génère une position aléatoire proche de (1000, 0, 1000)
        local pos = {
            x = 1000 + math.random(-100, 100),
            y = math.random(50, 100),
            z = 1000 + math.random(-100, 100)
        }

        -- Appelle la fonction pour générer l'airdrop
        airdrop.spawn_airdrop(pos)

        -- Informe le joueur
        local message = "-!- AirDrop -!- x: " .. pos.x .. " y: " .. pos.y .. " z: " .. pos.z
        minetest.chat_send_player(name, message)

        return true
    end,
})

-- Enregistre le mod
minetest.log("action", "[Airdrop] Mod loaded.")
