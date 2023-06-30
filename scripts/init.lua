require("globals")

Class = require("utils.middleclass")
Timer = require("utils.timer")
Signal = require("utils.signal")

Defines = require("defines")
Files = require("modules.files")
Assets = require("modules.assets")
Draw = require("modules.draw")
Play = require("modules.play")
Input = require("modules.input")

Level = require("stage.level")
Map = require("stage.map")

Collider = require("collider")
ColliderGroup = require("colliderGroup")
Defines = require("defines")
Config = require("config")
Transform = require("transform")
Object = require("object")
Game = require("game")

Section = require("class.section")
NPC = require("class.npc")
BGO = require("class.bgo")
Block = require("class.block")
Player = require("class.player")
Camera = require("class.camera")
Effect = require("class.effect")
Warp = require("class.warp")
Zone = require("class.zone")
Tile = require("class.map.tile")

-- BoxCollider = require("class.collider.boxcollider")

function love.draw()
	Signal.emit('onDraw')
end

local accum = 0
-- local step = 0.016 -- fixed time step

function love.update(dt)
	accum = accum + dt
	
	while accum >= Game.dt do
		Timer.update(Game.dt)
		
		if not Game.paused then
			Signal.emit('onUpdate', Game.dt)
		end
		
		Signal.emit('onKeyUpdate')
		accum = accum - Game.dt
	end
end

function love.lowmemory()
	Signal.emit('onLowMemory')
end

function love.quit()
	Signal.emit('onQuit')
end

function love.keypressed(...)
	Signal.emit('onKeyPressed', ...)
end

function love.keyreleased(...)
	Signal.emit('onKeyReleased', ...)
end

local console_toggle = require("console.console")

function love.textinput(text, ...)
	console_toggle(text)
	Signal.emit('onTextInput', text, ...)
end