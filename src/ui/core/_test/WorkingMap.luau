local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local e = React.createElement

type WorkingMapProps = {
	MapSize: UDim2,
}

local function WorkingMap(props: WorkingMapProps)
	local mapRef = React.useRef(nil)
	local containerRef = React.useRef(nil)
	local draggerRef = React.useRef(nil)

	React.useEffect(function()
		local container = containerRef.current :: ScrollingFrame?
		local map = mapRef.current :: GuiObject?
		local dragger = draggerRef.current :: UIDragDetector?

		if not (container and map and dragger) then
			return
		end

		--* Dragging logic
		local lastDragPos = Vector2.zero

		local dragStartConn = dragger.DragStart:Connect(function(pos: Vector2)
			lastDragPos = pos
		end)

		local dragContinueConn = dragger.DragContinue:Connect(function(pos: Vector2)
			local delta = pos - lastDragPos

			container.CanvasPosition -= delta
			lastDragPos = pos
		end)

		--* Resizing logic
		local function updateCanvas()
			container.CanvasSize = UDim2.fromOffset(map.AbsoluteSize.X, map.AbsoluteSize.Y)
		end
		updateCanvas() -- Initial call
		local sizeChangedConn = map:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateCanvas)

		--* Disconnect
		return function()
			dragStartConn:Disconnect()
			dragContinueConn:Disconnect()
			sizeChangedConn:Disconnect()
		end
	end, {})

	return e("CanvasGroup", {
		Size = UDim2.fromScale(1, 1),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		BackgroundTransparency = 1,
	}, {
		Container = e("ScrollingFrame", {
			Size = UDim2.fromScale(1, 1),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			BackgroundTransparency = 1,
			CanvasSize = UDim2.fromOffset(0, 0),
			CanvasPosition = Vector2.zero,
			ScrollingEnabled = false,
			ScrollBarThickness = 0,
			ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0),
			ScrollBarImageTransparency = 0.5,
			ScrollingDirection = Enum.ScrollingDirection.XY,

			ref = containerRef,
		}, {
			Map = e("Frame", {
				Size = props.MapSize,
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(200, 200, 200),
				ref = mapRef,
			}, {
				UIDragDetector = e("UIDragDetector", {
					DragStyle = Enum.UIDragDetectorDragStyle.Scriptable,
					ref = draggerRef,
				}),
				TestImage = e("ImageLabel", {
					Size = UDim2.fromScale(1, 1),
					Position = UDim2.fromScale(0.5, 0.5),
					AnchorPoint = Vector2.new(0.5, 0.5),
					Image = "rbxassetid://6028276525",
					ScaleType = Enum.ScaleType.Tile,
					TileSize = UDim2.fromOffset(100, 100),
					BackgroundTransparency = 1,
				}),
			}),
		}),
	})
end

return function(props: WorkingMapProps)
	return e(WorkingMap, props, {})
end
