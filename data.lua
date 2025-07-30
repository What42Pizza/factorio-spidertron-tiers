require("utils")



function addSpidertronLevel(level)
	local name = "spidertron-mk" .. level
	local prev_name = "spidertron-mk" .. (level - 1)
	if level == 2 then prev_name = "spidertron" end
	local grid_height = 4 + 2 * level
	local recipe_cost_mult = math.pow(3, level - 1)
	local research_cost = math.pow(3, level - 2) * 10000
	
	
	-- entity
	local entity = table.deepcopy(data.raw["spider-vehicle"]["spidertron"])
	entity.name = name
	entity.minable.result = name
	entity.equipment_grid = name .. "-equipment-grid"
	entity.inventory_size = entity.inventory_size + 10 * (level - 1)
	entity.max_health = entity.max_health * (1.0 + 0.1 * (level - 1))
	entity.torso_rotation_speed = entity.torso_rotation_speed * (1.0 + 0.15 * (level - 1))
	
	
	-- guns
	local gun1 = table.deepcopy(data.raw.gun["spidertron-rocket-launcher-1"])
	local gun2 = table.deepcopy(data.raw.gun["spidertron-rocket-launcher-2"])
	local gun3 = table.deepcopy(data.raw.gun["spidertron-rocket-launcher-3"])
	local gun4 = table.deepcopy(data.raw.gun["spidertron-rocket-launcher-4"])
	gun1.name = setNameNumber(gun1.name, level * 4 - 3)
	gun2.name = setNameNumber(gun2.name, level * 4 - 2)
	gun3.name = setNameNumber(gun3.name, level * 4 - 1)
	gun4.name = setNameNumber(gun4.name, level * 4 - 0)
	gun1.attack_parameters.range = gun1.attack_parameters.range * (1.0 + 0.25 * (level - 1))
	gun2.attack_parameters.range = gun2.attack_parameters.range * (1.0 + 0.25 * (level - 1))
	gun3.attack_parameters.range = gun3.attack_parameters.range * (1.0 + 0.25 * (level - 1))
	gun4.attack_parameters.range = gun4.attack_parameters.range * (1.0 + 0.25 * (level - 1))
	gun1.attack_parameters.cooldown = gun1.attack_parameters.cooldown * (1.0 - 0.05 * (level - 1))
	gun2.attack_parameters.cooldown = gun2.attack_parameters.cooldown * (1.0 - 0.05 * (level - 1))
	gun3.attack_parameters.cooldown = gun3.attack_parameters.cooldown * (1.0 - 0.05 * (level - 1))
	gun4.attack_parameters.cooldown = gun4.attack_parameters.cooldown * (1.0 - 0.05 * (level - 1))
	
	entity.guns = {
		gun1.name,
		gun2.name,
		gun3.name,
		gun4.name,
	}
	
	
	-- equipment grid
	local equipment_grid = table.deepcopy(data.raw["equipment-grid"]["spidertron-equipment-grid"])
	equipment_grid.name = name .. "-equipment-grid"
	equipment_grid.height = grid_height
	
	
	-- item
	local item = table.deepcopy(data.raw["item-with-entity-data"]["spidertron"])
	item.name = name
	item.place_result = name
	
	
	-- recipes
	local recipe = {
		type = "recipe",
		name = name,
		ingredients = {
			{
				type = "item",
				name = prev_name,
				amount = 3,
			},
		},
		results = {
			{
				type = "item",
				name = name,
				amount = 1,
			},
		},
		energy_required = 10,
		order = intToOrder(3 * 26 * 26 + level),
		enabled = false,
	}
	
	
	-- technology
	local technology = table.deepcopy(data.raw.technology["spidertron"])
	technology.name = name
	technology.prerequisites = {
		prev_name
	}
	if level == 2 then
		table.insert(technology.prerequisites, "space-science-pack")
	end
	technology.unit = {
		count = research_cost,
		ingredients = {
			{"automation-science-pack", 1},
			{"logistic-science-pack", 1},
			{"military-science-pack", 1},
			{"chemical-science-pack", 1},
			{"utility-science-pack", 1},
			{"space-science-pack", 1}
		},
		time = 60,
	}
	technology.effects = {
		{
			type = "unlock-recipe",
			recipe = recipe.name
		},
	}
	
	
	-- finish
	data:extend{
		entity,
		gun1,
		gun2,
		gun3,
		gun4,
		equipment_grid,
		item,
		recipe,
		recipe,
		technology,
	}
end



for i = 2,10 do
	addSpidertronLevel(i)
end
