local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MemberCard = require(script.Parent.MemberCard)
local React = require(ReplicatedStorage.Packages.React)
local ListLayout = require(ReplicatedStorage.UI.core.ListLayout)
local ScrollContainer = require(ReplicatedStorage.UI.core.ScrollContainer)
local Theme = require(ReplicatedStorage.UI.core.Theme)
local Widget = require(ReplicatedStorage.UI.core.Widget)
local e = React.createElement

function GetTestMembers()
	local members = {}
	members["Host"] = e(MemberCard, { Host = true })
	for i = 1, 19 do
		members[`Member{i}`] = e(MemberCard, { Kick = true })
	end
	return members
end

export type RoomInfoProps = {
	Size: UDim2?,
	LayoutOrder: number?,
	Visible: boolean?,
}
function RoomInfo(props: RoomInfoProps)
	return e(Widget, {
		Size = props.Size or UDim2.fromScale(0.5, 1),
		LayoutOrder = props.LayoutOrder or 0,
	}, {
		ListLayout = e(
			ListLayout,
			{
				SortOrder = Enum.SortOrder.LayoutOrder,
				Spacing = Theme.Spacing.LG,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalFlex = Enum.UIFlexAlignment.Fill,
				VerticalFlex = Enum.UIFlexAlignment.Fill,
				Wraps = true,
			} :: ListLayout.ListLayoutProps
		),
		InfoContainer = e(
			"Frame",
			{
				Size = UDim2.new(0.8, 0, 0, 20),
				BackgroundColor3 = Theme.Colors.SubBackground,
				BackgroundTransparency = 0,
				LayoutOrder = 0,
			} :: ScrollContainer.ScrollContainerProps,
			{
				UICorner = e("UICorner", {
					CornerRadius = Theme.Radius.LG,
				}),
				ListLayout = e(
					ListLayout,
					{
						SortOrder = Enum.SortOrder.LayoutOrder,
						Padding = UDim.new(0, Theme.Spacing.XS),
						HorizontalAlignment = Enum.HorizontalAlignment.Left,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						FillDirection = Enum.FillDirection.Horizontal,
						HorizontalFlex = Enum.UIFlexAlignment.Fill,
						VerticalFlex = Enum.UIFlexAlignment.Fill,
					} :: ListLayout.ListLayoutProps
				),
				RoomID = e("TextLabel", {
					Text = `ID: 00000000`,
					TextSize = Theme.FontSize.Body,
					TextXAlignment = Enum.TextXAlignment.Center,
					TextYAlignment = Enum.TextYAlignment.Center,
					TextColor3 = Theme.Colors.Secondary,
					Font = Theme.Fonts.Title,
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, Theme.FontSize.Title),
					AnchorPoint = Vector2.new(0.5, 0),
					Position = UDim2.fromScale(0.5, 0),
					LayoutOrder = 1,
				}),
				Visibility = e("TextLabel", {
					Text = `Visibility: {"Public"}`,
					TextSize = Theme.FontSize.Body,
					TextXAlignment = Enum.TextXAlignment.Center,
					TextYAlignment = Enum.TextYAlignment.Center,
					TextColor3 = Theme.Colors.Secondary,
					Font = Theme.Fonts.Title,
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, Theme.FontSize.Title),
					AnchorPoint = Vector2.new(0.5, 0),
					Position = UDim2.fromScale(0.5, 0),
					LayoutOrder = 2,
				}),
				PlayerCounter = e("TextLabel", {
					Text = `Players: {0} / {0}`,
					TextSize = Theme.FontSize.Body,
					TextXAlignment = Enum.TextXAlignment.Center,
					TextYAlignment = Enum.TextYAlignment.Center,
					TextColor3 = Theme.Colors.Secondary,
					Font = Theme.Fonts.Title,
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, Theme.FontSize.Title),
					AnchorPoint = Vector2.new(0.5, 0),
					Position = UDim2.fromScale(0.5, 0),
					LayoutOrder = 3,
				}),
			}
		),
		LeaveButton = e("TextButton", {
			Text = "LEAVE",
			TextSize = Theme.FontSize.Body,
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Center,
			TextColor3 = Theme.Colors.Background,
			Font = Theme.Fonts.Display,
			BorderSizePixel = 0,
			BackgroundColor3 = Theme.Colors.Danger,
			BackgroundTransparency = 0.5,
			Size = UDim2.new(0.15, 0, 0, 20),
			LayoutOrder = 1,
		}, {
			UICorner = e("UICorner", {
				CornerRadius = Theme.Radius.LG,
			}),
		}),
		MemberList = e(
			ScrollContainer,
			{
				Size = UDim2.new(1, 0, 0.8, -20 * 3),
				SortOrder = Enum.SortOrder.LayoutOrder,
				Spacing = Theme.Spacing.LG,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Top,
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalFlex = Enum.UIFlexAlignment.None,
				VerticalFlex = Enum.UIFlexAlignment.None,
				Wraps = true,

				HorizontalSpacing = 0,
				VerticalSpacing = 0,

				LayoutOrder = 2,
			} :: ScrollContainer.ScrollContainerProps,
			GetTestMembers()
		),

		FinderContainer = e("Frame", {
			Size = UDim2.new(1, 0, 0, 20),
			LayoutOrder = 3,
			BackgroundTransparency = 1,
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
			TextBox = e("TextBox", {
				Text = "Room ID",
				TextSize = Theme.FontSize.Body,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center,
				TextColor3 = Theme.Colors.MainText,
				Font = Theme.Fonts.Body,
				BorderSizePixel = 0,
				BackgroundColor3 = Theme.Colors.SubBackground,
				BackgroundTransparency = 0,
				Size = UDim2.new(1, 0, 0, Theme.FontSize.Body),
				AnchorPoint = Vector2.new(0.5, 0),
				Position = UDim2.fromScale(0.5, 0),
				PlaceholderText = `Enter Room ID...`,
				LayoutOrder = 0,
			}, {
				UICorner = e("UICorner", {
					CornerRadius = Theme.Radius.LG,
				}),
				UIPadding = e("UIPadding", {
					PaddingLeft = UDim.new(0, Theme.Spacing.XL),
					PaddingRight = UDim.new(0, Theme.Spacing.SM),
					PaddingTop = UDim.new(0, Theme.Spacing.XS),
					PaddingBottom = UDim.new(0, Theme.Spacing.XS),
				}),
			}),
			ClearButton = e("TextButton", {
				Text = "Clear",
				TextSize = Theme.FontSize.Body,
				TextXAlignment = Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Center,
				TextColor3 = Theme.Colors.Background,
				Font = Theme.Fonts.Display,
				BorderSizePixel = 0,
				BackgroundColor3 = Theme.Colors.Secondary,
				BackgroundTransparency = 0.5,
				Size = UDim2.new(0.3, 0, 0, 20),
				LayoutOrder = 1,
			}, {
				UICorner = e("UICorner", {
					CornerRadius = Theme.Radius.LG,
				}),
			}),
		}),
		ActionContainer = e("Frame", {
			Size = UDim2.new(1, 0, 0, 20),
			LayoutOrder = 4,
			BackgroundTransparency = 1,
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
			JoinButton = e("TextButton", {
				Text = "JOIN",
				TextSize = Theme.FontSize.Body,
				TextXAlignment = Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Center,
				TextColor3 = Theme.Colors.Background,
				Font = Theme.Fonts.Display,
				BorderSizePixel = 0,
				BackgroundColor3 = Theme.Colors.Secondary,
				BackgroundTransparency = 0.5,
				Size = UDim2.new(0.3, 0, 0, 20),
				LayoutOrder = 1,
			}, {
				UICorner = e("UICorner", {
					CornerRadius = Theme.Radius.LG,
				}),
			}),
			CreateButton = e("TextButton", {
				Text = "CREATE",
				TextSize = Theme.FontSize.Body,
				TextXAlignment = Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Center,
				TextColor3 = Theme.Colors.Background,
				Font = Theme.Fonts.Display,
				BorderSizePixel = 0,
				BackgroundColor3 = Theme.Colors.Primary,
				BackgroundTransparency = 0.5,
				Size = UDim2.new(0.3, 0, 0, 20),
				LayoutOrder = 2,
			}, {
				UICorner = e("UICorner", {
					CornerRadius = Theme.Radius.LG,
				}),
			}),
		}),
	})
end

return function(props: RoomInfoProps)
	if props.Visible == false then
		return nil
	end
	return RoomInfo(props)
end
