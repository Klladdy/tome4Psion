-- ToME - Tales of Maj'Eyal:
-- Copyright (C) 2009 - 2019 Nicolas Casalini
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.
--
-- Nicolas Casalini "DarkGod"
-- darkgod@te4.org

local Particles = require "engine.Particles"
local ParticlesCallback = require "engine.ParticlesCallback"

getBirthDescriptor("class", "Psionic").descriptor_choices.subclass["Psion"] = "allow"
getBirthDescriptor("class", "Psionic").locked = nil

newBirthDescriptor{
	type = "subclass",
	name = "Psion",
	locked = function() return profile.mod.allow_build.psionic_psion end,
	locked_desc = _t"Some creatures have a lot of big brain moments --todo",
	desc = {
		_t"Mindslayers specialize in direct and brutal application of mental forces to their immediate surroundings.",
		_t"When Mindslayers do battle, they will most often be found in the thick of the fighting, vast energies churning around them and telekinetically-wielded weapons hewing nearby foes at the speed of thought.",
		_t"Their most important stats are: Willpower and Cunning",
		_t"#GOLD#Stat modifiers:",
		_t"#LIGHT_BLUE# * +1 Strength, +0 Dexterity, +0 Constitution",
		_t"#LIGHT_BLUE# * +0 Magic, +4 Willpower, +4 Cunning",
		_t"#GOLD#Life per level:#LIGHT_BLUE# -2",
	},
	power_source = {psionic=true, technique=true},
	stats = { dex=1, wil=4, cun=4, },
	birth_example_particles = {
		function(actor)
			if core.shader.active(4) then actor:addParticles(Particles.new("shader_shield", 1, {size_factor=1.1, img="shield5"}, {type="shield", ellipsoidalFactor=1, time_factor=-10000, llpow=1, aadjust=3, color={1, 0, 0.3}}))
			else actor:addParticles(Particles.new("generic_shield", 1, {r=1, g=0, b=0.3, a=0.5}))
			end
		end,
		function(actor)
			if core.shader.active(4) then actor:addParticles(Particles.new("shader_shield", 1, {size_factor=1.1, img="shield5"}, {type="shield", ellipsoidalFactor=1, time_factor=-10000, llpow=1, aadjust=3, color={0.3, 1, 1}}))
			else actor:addParticles(Particles.new("generic_shield", 1, {r=0.3, g=1, b=1, a=0.5}))
			end
		end,
		function(actor)
			if core.shader.active(4) then actor:addParticles(Particles.new("shader_shield", 1, {size_factor=1.1, img="shield5"}, {type="shield", ellipsoidalFactor=1, time_factor=-10000, llpow=1, aadjust=3, color={0.8, 1, 0.2}}))
			else actor:addParticles(Particles.new("generic_shield", 1, {r=0.8, g=1, b=0.2, a=0.5}))
			end
		end,
	},
	talents_types = {
		--Level 0 trees:
		["psionic/absorption"]={true, 0.3},
		["psionic/projection"]={true, 0.3},
		["psionic/psi-fighting"]={true, 0.3},
		["psionic/focus"]={true, 0.3},
		["psionic/voracity"]={true, 0.3},
		["psionic/augmented-mobility"]={true, 0.3},
		["psionic/augmented-striking"]={true, 0.3},
		["psionic/finer-energy-manipulations"]={true, 0.3},
		--Level 10 trees:
		["psionic/kinetic-mastery"]={false, 0.3},
		["psionic/thermal-mastery"]={false, 0.3},
		["psionic/charged-mastery"]={false, 0.3},
		--Miscellaneous trees:
		["cunning/survival"]={true, 0},
		["technique/combat-training"]={true, 0},
	},
	talents = {
		[ActorTalents.T_KINETIC_SHIELD] = 1,
		[ActorTalents.T_KINETIC_AURA] = 1,
		[ActorTalents.T_SKATE] = 1,
		[ActorTalents.T_TELEKINETIC_SMASH] = 1,
		[ActorTalents.T_WEAPONS_MASTERY] = 1,
		[ActorTalents.T_WEAPON_COMBAT] = 1,
	},
	copy = {
		max_life = 110,
		resolvers.auto_equip_filters{
			MAINHAND = {type="weapon", special=function(e, filter) -- Allow standard 2H strength weapons
				local who = filter._equipping_entity
				if who and e.subtype and (e.subtype == "battleaxe" or e.subtype == "greatsword" or e.subtype == "greatmaul") then return true end
			end},
			OFFHAND = {special=function(e, filter) -- only allow if there is already a weapon in MAINHAND
				local who = filter._equipping_entity
				if who then
					local mh = who:getInven(who.INVEN_MAINHAND) mh = mh and mh[1]
					if mh and (not mh.slot_forbid or not who:slotForbidCheck(e, who.INVEN_MAINHAND)) then return true end
				end
				return false
			end},
		},
		resolvers.equipbirth{ id=true,
			{type="armor", subtype="cloth", name="linen robe", autoreq=true, ego_chance=-1000},
			{type="weapon", subtype="greatsword", name="iron greatsword", autoreq=true, ego_chance=-1000},
			{type="weapon", subtype="greatsword", name="iron greatsword", autoreq=true, ego_chance=-1000, force_inven = "PSIONIC_FOCUS"}
		},
		resolvers.inventorybirth{ id=true,
			{type="weapon", subtype="mindstar", name="mossy mindstar", autoreq=true, ego_chance=-1000},
			{type="weapon", subtype="mindstar", name="mossy mindstar", autoreq=true, ego_chance=-1000},
			{type="gem",},
		},
	},
	copy_add = {
		life_rating = -2,
	},
}
