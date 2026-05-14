local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local WindShakeModule = require(ReplicatedStorage.Shared.Services.WindService.WindShakeModule)
local Components = require(ReplicatedStorage.Shared.Ecs.Components.Components)
local ECS = require(ReplicatedStorage.Shared.Ecs.ECS)

local function newParams()
	local params = OverlapParams.new()
	params.FilterType = Enum.RaycastFilterType.Include
	return params
end

local CONFIG = {
	Plant = {
		Tag = "Plant",
		Params = newParams(),
	},
	Climb = {
		Tag = "Climbable",
		Params = newParams(),
	},
	Obstacle = {
		Tag = "Obstacle",
		Params = newParams(),
	},
}
local ATTRIBUTES = {
	Light = "Light",
}

local function getWeight(node, branching)
	local model = node.instance :: Model?
	local age = tick() - node.started
	local scale = model and model:GetScale() or 1
	local light = model and model:GetAttribute(ATTRIBUTES.Light) or 0

	-- convert light
	if light == nil then
		model:SetAttribute(ATTRIBUTES.Light, 0)
		light = 0
	end

	-- weight
	return 0.5 -- base chance
		+ age * branching.ageWeight
		+ light * branching.lightWeight
		+ scale * branching.scaleWeight
end

local function pickWeighted(nodes, branching): number?
	if #nodes == 0 then
		return nil
	end

	local total = 0

	for _, n in ipairs(nodes) do
		total += getWeight(n, branching)
	end

	local r = math.random() * total
	local acc = 0

	for i, n in ipairs(nodes) do
		acc += getWeight(n, branching)
		if acc >= r then
			return i
		end
	end

	return math.random(1, #nodes)
end

local function findValidPosition(node, branching): Vector3?
	local climbParams = CONFIG.Climb.Params
	climbParams.FilterDescendantsInstances = CollectionService:GetTagged(CONFIG.Climb.Tag)

	local obstacleParams = CONFIG.Obstacle.Params
	obstacleParams.FilterDescendantsInstances = CollectionService:GetTagged(CONFIG.Obstacle.Tag)

	local plantParams = CONFIG.Plant.Params
	plantParams.FilterDescendantsInstances = CollectionService:GetTagged(CONFIG.Plant.Tag)

	for _, part: BasePart in pairs(workspace:GetPartBoundsInRadius(node.position, branching.climbRadius, climbParams)) do
		local target = part:GetClosestPointOnSurface(node.position)

		-- check distance
		if (target - node.position).Magnitude > branching.climbRadius * 1.1 then
			continue
		end

		-- check obstacle on the way
		local rayRes = workspace:Raycast(node.position, (target - node.position))
		if not rayRes or rayRes.Instance ~= part then
			continue
		end

		-- check count of neighbors
		local plants = workspace:GetPartBoundsInRadius(target, branching.plantRadius, plantParams)
		if #plants >= branching.plantCount then
			continue
		end

		-- check config
		local res = rayRes.Position + rayRes.Normal * branching.surfaceOffset

		local obstacles = workspace:GetPartBoundsInRadius(res, branching.obstacleRadius, obstacleParams)
		if #obstacles >= branching.obstacleCount then
			continue
		end

		return res
	end
	return nil
end

return ECS.CreateSystem({
	name = "Test",
	after = { "HandleGrown" },
	system = function(world: ECS.World, state: ECS.State)
		for id, plant, growth, branching in
			world:query(Components.Plant.Plant, Components.Plant.Behaviors.Branching, Components.Plant.Growth)
		do
			-- check template before create nodes
			local template = plant.config.nodeTemplate

			if not template then
				continue
			end

			-- check nodes
			local nodes = plant.nodes
			if #nodes == 0 then
				continue
			end

			-- try to create nodes
			for i = 1, branching.attempts do
				local selectedId = pickWeighted(nodes, branching)
				local selected = selectedId and nodes[selectedId]
				local targetPos = selected and findValidPosition(selected, branching)

				-- check valid target postion
				if not targetPos then
					continue
				end

				-- * caculate direction for the new node
				local targetDir = selected.direction

				-- base direction on surface normal
				if targetDir.Magnitude > 0 then
					targetDir = targetDir.Unit
				else
					targetDir = Vector3.new(0, 1, 0)
				end

				-- add noise
				targetDir = targetDir
					+ Vector3.new(
						math.random() * branching.directionNoise,
						math.random() * branching.directionNoise,
						math.random() * branching.directionNoise
					)
				targetDir = targetDir.Unit

				-- * handle kind of node
				local kind = "Leaf" -- TODO handle this later

				-- create new model
				local newModel = template:Clone()
				newModel.CFrame = CFrame.new(targetPos, targetPos + targetDir)
				newModel.Parent = workspace -- TODO change parent later!

				-- add windshake
				if kind == "Leaf" then
					CollectionService:AddTag(newModel, WindShakeModule.CollectionTag)
				end

				-- * creating new node
				local newNode = {
					parent = selectedId,
					instance = newModel,
					position = targetPos,
					direction = targetDir,
					started = tick(),
				}

				-- update plant nodes data
				local newNodes = table.clone(nodes)
				table.insert(newNodes, newNode)
				world:insert(
					id,
					plant:patch({
						nodes = newNodes,
					})
				)
			end
		end
	end,
})
