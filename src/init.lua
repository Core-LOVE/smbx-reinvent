--[[libraries]]
Signal = require("src.lib.signal")
Class = require("src.lib.middleclass")
Timer = require("src.lib.timer")
Stateful = require("src.lib.stateful")
print("Loaded Libraries...")

--[[lua modifications]]
require("src.lua.globals")
print("Loaded Lua Modifications...")

--[[modules]]
Graphics = require("src.module.graphics")
NetPlay = require("src.module.netplay")
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
-- Pool = require("src.class.pool")
Section = require("src.class.section")
Player = require("src.class.player")
Camera = require("src.class.camera")
Block = require("src.class.block")
Warp = require("src.class.warp")
NPC = require("src.class.npc")
BGO = require("src.class.bgo")

Level = require("src.class.stages.level")
Title = require("src.class.stages.title")
print("Loaded Classes...")

Game:loadTitle()

function love.draw()
	Signal.emit('onDraw')
end

local accum = 0

function love.update(dt)
	local maxDT = Game.dt
	accum = accum + dt
	
	while accum >= maxDT do
		Signal.emit('onUpdate', dt)
		Signal.emit('onKeyUpdate')
		accum = accum - maxDT
	end
end

function love.keypressed(...)
	Signal.emit('onKeyPressed', ...)
end

function love.keyreleased(...)
	Signal.emit('onKeyReleased', ...)
end

local console_toggle = require("src.lib.console.console")

function love.textinput(text, ...)
	console_toggle(text)
	Signal.emit('onTextInput', text, ...)
end