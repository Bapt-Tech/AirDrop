minetest.register_privilege("airdrop", {
    description = "Allow you to create an AirDrop.",
    give_to_singleplayer = false,
})

minetest.register_chatcommand("airdrop"
    description = "Creates an airdrop."
    privs = {airdrop = true},
)