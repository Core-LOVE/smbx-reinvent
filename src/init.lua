--[[libraries]]
Signal = require("src.lib.signal")
Class = require("src.lib.middleclass")
print("Loaded Libraries...")

--[[lua modifications]]
require("src.lua.globals")
print("Loaded Lua Modifications...")

--[[modules]]
Graphics = require("src.module.graphics")
Defines = require("src.module.defines")
Assets = require("src.module.assets")
Audio = require("src.module.audio")
Input = require("src.module.input")
Files = require("src.module.files")
Game = require("src.module.game")
print("Loaded Modules...")

--[[classes]]
Config = require("src.class.config.config")
ConfigEntry = require("src.class.config.entry")

Physics = require("src.class.mixin.physics")
WeakObject = require("src.class.weakObject")
Collider = require("src.class.collider")
Object = require("src.class.object")
Pool = require("src.class.pool")
Level = require("src.class.stages.level")
Title = require("src.class.stages.title")
Section = require("src.class.section")
Player = require("src.class.player")
Camera = require("src.class.camera")
Block = require("src.class.block")
NPC = require("src.class.npc")
BGO = require("src.class.bgo")
print("Loaded Classes...")

Game:loadTitle()

function love.draw()
	Signal.emit('onDraw')
end

local accum = 0

function love.update(dt)
	accum = accum + dt
	
	while accum >= Game.dt do
		Signal.emit('onUpdate', dt)
		Signal.emit('onKeyUpdate')
		accum = accum - Game.dt
	end
end

function love.keypressed(...)
	Signal.emit('onKeyPressed', ...)
end

function love.keyreleased(...)
	Signal.emit('onKeyReleased', ...)
end