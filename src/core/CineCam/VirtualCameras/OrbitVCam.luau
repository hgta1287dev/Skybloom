local ReplicatedStorage = game:GetService("ReplicatedStorage")
local InputService = require(ReplicatedStorage.Shared.Core.InputService)
local CameraContext = require(script.Parent.Parent.Context.CameraContext)
local CameraLookAtModule = require(script.Parent.Parent.Pipe.Modules.Aim.CameraLookAtModule)
local CameraOffsetModule = require(script.Parent.Parent.Pipe.Modules.Noise.CameraOffsetModule)
local CameraOrbitModule = require(script.Parent.Parent.Pipe.Modules.Body.CameraOrbitModule)
local BaseVirtualCamera = require(script.Parent.Parent.VirtualCameras.BaseVCam)
local CameraTargetObjectModule = require(script.Parent.Parent.Pipe.Modules.Extensions.CameraTargetObjectModule)

-- * Orbit
local OrbitVCam = {}
OrbitVCam.__index = OrbitVCam

-- * Types
type CameraContext = CameraContext.CameraContext

-- * Helpers
local function GetTestPart()
	local part = Instance.new("Part")
	part.Anchored = true
	part.Size = Vector3.one * 2
	part.Parent = workspace
	return part
end

-- * Constructor
function OrbitVCam.new()
	local orbitModule = CameraOrbitModule.new()
	local lookAtModule = CameraLookAtModule.new()
	local offsetModule = CameraOffsetModule.new()
	local objectTargetModule = CameraTargetObjectModule.new(nil, GetTestPart())

	orbitModule.Yaw.SmoothFactor = 4
	orbitModule.Pitch.SmoothFactor = 5
	orbitModule.Distance.SmoothFactor = 6

	local self = setmetatable(
		BaseVirtualCamera.new({
			objectTargetModule,
			orbitModule,
			lookAtModule,
			offsetModule,
		}),
		OrbitVCam
	)

	self.direction = Vector2.zero

	local mapper = InputService:GetActionMapper()
	local lookAction: InputAction = mapper:GetAction("Gameplay", "Look")
	local zoomDistanceAction: InputAction = mapper:GetAction("Gameplay", "ZoomDistance")

	lookAction.StateChanged:Connect(function(direction: Vector2)
		self.direction = direction * Vector2.new(1, -1)
	end)

	zoomDistanceAction.StateChanged:Connect(function(distance: number)
		orbitModule.Distance:AdjustTarget(-distance)
	end)

	function self:_onUpdate()
		orbitModule.Yaw:AdjustTarget(self.direction.X)
		orbitModule.Pitch:AdjustTarget(self.direction.Y)
	end

	return self
end

-- * Methods
function OrbitVCam:Update(context: CameraContext, output)
	self:_onUpdate()

	-- ouput
	local result = BaseVirtualCamera.Update(self, context)
	output.Cframe = result.Body * result.Aim * result.Noise
	output.Fov = result.Fov
end

return OrbitVCam
