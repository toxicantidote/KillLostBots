require("mod-gui")

function doit(player)
	local count = 0
	for _, surface in pairs (game.surfaces) do
		local bots = surface.find_entities_filtered{type = {"logistic-robot","construction-robot"}, player.force.name }
		for _, bot in pairs (bots) do
			if bot.energy < (game.entity_prototypes[bot.name]["energy_per_move"] * 2) then
				bot.die( bot.force )
				count = count + 1
			end
		end
	end
	if count > 0 then
		if count == 1 then
			log({'KillLostBots_text', player.name, player.force.name})
			game.print({'KillLostBots_text', player.name, player.force.name})
		else
			log({'KillLostBots_text_plural', player.name, count, player.force.name})
			game.print({'KillLostBots_text_plural', player.name, count, player.force.name})
		end
	else
		log({'KillLostBots_text_none', player.name, player.force.name})
		game.print({'KillLostBots_text_none', player.name, player.force.name})
	end
end

function show_gui(player)
	local gui = mod_gui.get_button_flow(player)
	if not gui.KillLostBots then
		gui.add{
			type = "sprite-button",
			name = "KillLostBots",
			sprite = "KillLostBots_button",
			style = mod_gui.button_style,
			tooltip = {"KillLostBots_button_tooltip"}
		}
	end
end

do---- Init ----
script.on_init(function()
	for _, player in pairs(game.players) do
		if player and player.valid then show_gui(player) end
	end
end)

script.on_configuration_changed(function(data)
	for _, player in pairs(game.players) do
		if player and player.valid then show_gui(player) end
	end
end)

script.on_event({defines.events.on_player_created, defines.events.on_player_joined_game, defines.events.on_player_respawned}, function(event)
  local player = game.players[event.player_index]
  if player and player.valid then show_gui(player) end
end)

script.on_event(defines.events.on_gui_click, function(event)
  local gui = event.element
  local player = game.players[event.player_index]
  if not (player and player.valid and gui and gui.valid) then return end
	if gui.name == "KillLostBots" then doit(player) end
end)
end
