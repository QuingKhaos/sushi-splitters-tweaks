local khaoslib_entity = require("__khaoslib__.entity")
local khaoslib_item = require("__khaoslib__.item")
local khaoslib_recipe = require("__khaoslib__.recipe")

-- Add hint which recipe is made from splitters
local sushi_splitters_recipes = khaoslib_recipe.find(function (recipe)
  return recipe.name:match("sushi") ~= nil and recipe.name:match("upgrade") == nil
end)

for _, recipe in pairs(sushi_splitters_recipes) do
  local splitter = khaoslib_recipe.get_ingredient(recipe, function (ingredient)
    return ingredient.name:match("splitter") ~= nil and ingredient.name:match("sushi") == nil
  end)

  if splitter then
    local recipe_instance = khaoslib_recipe:load(recipe)
    if recipe_instance:count_icons() == 0 then
      recipe_instance:set_icons(khaoslib_item.get_icons(recipe_instance:get_result(function (result)
        return result.name:match("sushi") ~= nil
      end).name))
    end

    local icons = khaoslib_entity:load("splitter", data.raw["item"][splitter.name].place_result):get_icons()
    if #icons > 0 then
      recipe_instance:add_icon {icon = icons[1].icon, icon_size = icons[1].icon_size, scale = 0.25, shift = {-8, 8}}
    end

    recipe_instance:commit()
  end
end

-- Update entity icon to have the sushi splitter icon, not the splitter one
local sushi_splitters_entities = khaoslib_entity.find("splitter", function (entity)
  return entity.name:match("sushi") ~= nil
end)

for _, entity in pairs(sushi_splitters_entities) do
  khaoslib_entity:load("splitter", entity)
    :set_icons(khaoslib_item.get_icons(data.raw["splitter"][entity].minable.result))
    :commit()
end
