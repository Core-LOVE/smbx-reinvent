local Defines = {}

local defaults = {}

defaults.gravity = 12
defaults.earthquake = 0
defaults.jumpheight = 20
defaults.spinjumpheight = 14
defaults.jumpheight_bounce = 20
defaults.block_jumpheight = 25
defaults.head_jumpheight = 22
defaults.npc_jumpheight = 22
defaults.spring_jumpheight = 55
defaults.player_jumpspeed = -5.7
defaults.player_runspeed = 6
defaults.player_walkspeed = 3
defaults.player_walkingAcceleration = 0.1
defaults.player_runningAcceleration = 0.05
defaults.player_turningAcceleration = 0.18
defaults.player_deceleration = 0.07
defaults.player_runToWalkDeceleration = 0.1
defaults.player_grav = 0.4

defaults.npc_timeoffscreen = 180
defaults.shell_speed = 7.1
defaults.shell_speedY = 11
defaults.npc_canhurtwait = 30
defaults.npc_walkingspeed = 1.2
defaults.npc_walkingonspeed = 1
defaults.npc_mushroomspeed = 1.8
defaults.npc_pswitch = 777
defaults.npc_grav = 0.26

defaults.player_grabSideEnabled = true
defaults.player_grabTopEnabled = true
defaults.player_grabShellEnabled = true
defaults.player_link_shieldEnabled = true
defaults.player_link_fairyVineEnabled = true

defaults.block_hit_link_rupeeID1 = 251
defaults.block_hit_link_rupeeID2 = 252
defaults.block_hit_link_rupeeID3 = 253

defaults.kill_drop_link_rupeeID1 = 251
defaults.kill_drop_link_rupeeID2 = 252
defaults.kill_drop_link_rupeeID3 = 253

defaults.pswitch_music = true

defaults.effect_Zoomer_killEffectEnabled = true

defaults.smb3RouletteScoreValueStar = 10
defaults.smb3RouletteScoreValueMushroom = 6
defaults.smb3RouletteScoreValueFlower = 8

defaults.effect_NpcToCoin = 11
defaults.sound_NpcToCoin = 14
defaults.npcToCoinValue = 1
defaults.npcToCoinValueReset = 100
defaults.coinValue = 1
defaults.coin5Value = 5
defaults.coin20Value = 20

defaults.levelFreeze = false

defaults.cheat_shadowmario = false
defaults.cheat_ahippinandahoppin = false
defaults.cheat_sonictooslow = false
defaults.cheat_illparkwhereiwant = false
defaults.cheat_wingman = false
defaults.cheat_captainn = false
defaults.cheat_flamerthrower = false
defaults.cheat_moneytree = false
defaults.cheat_speeddemon = false
defaults.cheat_donthurtme = false
defaults.cheat_stickyfingers = false
defaults.player_hasCheated = false

setmetatable(Defines, {__index = defaults})
return Defines