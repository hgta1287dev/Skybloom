local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local Button = require(ReplicatedStorage.UI.core.Button)
local Theme = require(ReplicatedStorage.UI.core.Theme)
local e = React.createElement

--* Constants
local Size = 55

--* Types
export type RoomCardProps = {
	Size: UDim2?,
	Name: string?,
	Thumbnail: string?,
	LayoutOrder: number?,
}

function RoomCard(props: RoomCardProps)
	return e("Frame", {
		Size = props.Size or UDim2.new(1, 0, 0, Size),
		BackgroundTransparency = 0,
		BackgroundColor3 = Theme.Colors.SubBackground,
		LayoutOrder = props.LayoutOrder or 0,
	}, {
		UIListLayout = e("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, Theme.Spacing.LG),
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalFlex = Enum.UIFlexAlignment.Fill,
			VerticalFlex = Enum.UIFlexAlignment.Fill,
		}),
		UICorner = e("UICorner", {
			CornerRadius = Theme.Radius.Default,
		}),
		UIPadding = e("UIPadding", {
			PaddingLeft = UDim.new(0, Theme.Spacing.SM),
			PaddingRight = UDim.new(0, Theme.Spacing.SM),
			PaddingTop = UDim.new(0, Theme.Spacing.XS),
			PaddingBottom = UDim.new(0, Theme.Spacing.XS),
		}),
		UIGradient = e("UIGradient", {
			Rotation = 15,
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0.95),
				NumberSequenceKeypoint.new(0.1, 0.6),
				NumberSequenceKeypoint.new(0.5, 0.25),
				NumberSequenceKeypoint.new(0.7, 0),
				NumberSequenceKeypoint.new(1, 0.3),
			}),
		}),
		ThumbnailContainer = e("Frame", {
			Size = UDim2.fromScale(0, 1),
			BackgroundTransparency = 1,
			LayoutOrder = 0,
		}, {
			AspectRatio = e("UIAspectRatioConstraint", {
				AspectRatio = 1,
				AspectType = Enum.AspectType.ScaleWithParentSize,
			}),
			Thumbnail = e("ImageLabel", {
				Size = UDim2.new(1, 15, 1, 15),
				Image = props.Thumbnail or "",
				ScaleType = Enum.ScaleType.Crop,
				BackgroundColor3 = Theme.Colors.SubBackground,
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5),
				-- BackgroundTransparency = 1,
				BorderSizePixel = 0,
				LayoutOrder = 0,
			}, {

				UICorner = e("UICorner", {
					CornerRadius = Theme.Radius.Pill,
				}),
			}),
		}),

		InfoContainer = e("Frame", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			LayoutOrder = 1,
		}, {
			UIListLayout = e("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 0),
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalFlex = Enum.UIFlexAlignment.Fill,
				VerticalFlex = Enum.UIFlexAlignment.Fill,
				Wraps = false,
			}),
			RoomName = e("TextLabel", {
				Text = props.Name or `Host`,
				TextSize = Theme.FontSize.Title,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center,
				TextColor3 = Theme.Colors.Primary,
				Font = Theme.Fonts.Title,
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, Theme.FontSize.Title),
				AnchorPoint = Vector2.new(0.5, 0),
				Position = UDim2.fromScale(0.5, 0),
				LayoutOrder = 0,
			}),
			PlayerCounter = e("TextLabel", {
				Text = `Players: {0} / {0}`,
				TextSize = Theme.FontSize.BodySmall,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center,
				TextColor3 = Theme.Colors.Secondary,
				Font = Theme.Fonts.Body,
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, Theme.FontSize.BodySmall),
				AnchorPoint = Vector2.new(0.5, 0),
				Position = UDim2.fromScale(0.5, 0),
				LayoutOrder = 1,
			}),
			Visibility = e("TextLabel", {
				Text = `Public`,
				TextSize = Theme.FontSize.BodySmall,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center,
				TextColor3 = Theme.Colors.Secondary,
				Font = Theme.Fonts.Body,
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, Theme.FontSize.BodySmall),
				AnchorPoint = Vector2.new(0.5, 0),
				Position = UDim2.fromScale(0.5, 0),
				LayoutOrder = 1,
			}),
		}),
		ButtonContainer = e("Frame", {
			Size = UDim2.new(0, 150, 1, 0),
			LayoutOrder = 2,
			BackgroundTransparency = 1,
		}, {
			JoinButton = e(Button, {
				Text = "JOIN",
				TextSize = Theme.FontSize.Body,
				TextXAlignment = Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Center,
				TextColor3 = Theme.Colors.Background,
				TextTruncate = Enum.TextTruncate.AtEnd,
				Font = Theme.Fonts.Display,
				BorderSizePixel = 0,
				BackgroundColor3 = Theme.Colors.Primary,
				BackgroundTransparency = 0.5,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromScale(1, 0.5),
			}, {
				UICorner = e("UICorner", {
					CornerRadius = Theme.Radius.LG,
				}),
			}),
		}),
	})
end

return RoomCard
