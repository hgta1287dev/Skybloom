local Theme = {}

Theme.Primitives = {
	Colors = {
		White = Color3.fromRGB(255, 255, 255),
		Black = Color3.fromRGB(0, 0, 0),

		-- GRAY
		Gray50 = Color3.fromRGB(250, 250, 250),
		Gray100 = Color3.fromRGB(245, 245, 245),
		Gray200 = Color3.fromRGB(229, 229, 229),
		Gray300 = Color3.fromRGB(212, 212, 212),
		Gray400 = Color3.fromRGB(163, 163, 163),
		Gray500 = Color3.fromRGB(115, 115, 115),
		Gray600 = Color3.fromRGB(82, 82, 82),
		Gray700 = Color3.fromRGB(64, 64, 64),
		Gray800 = Color3.fromRGB(38, 38, 38),
		Gray900 = Color3.fromRGB(23, 23, 23),

		-- RED
		Red50 = Color3.fromRGB(254, 242, 242),
		Red100 = Color3.fromRGB(254, 226, 226),
		Red300 = Color3.fromRGB(252, 165, 165),
		Red500 = Color3.fromRGB(239, 68, 68),
		Red700 = Color3.fromRGB(185, 28, 28),
		Red900 = Color3.fromRGB(127, 29, 29),

		-- BLUE
		Blue50 = Color3.fromRGB(239, 246, 255),
		Blue100 = Color3.fromRGB(219, 234, 254),
		Blue300 = Color3.fromRGB(147, 197, 253),
		Blue500 = Color3.fromRGB(59, 130, 246),
		Blue700 = Color3.fromRGB(29, 78, 216),
		Blue900 = Color3.fromRGB(30, 58, 138),

		-- GREEN
		Green50 = Color3.fromRGB(240, 253, 244),
		Green100 = Color3.fromRGB(220, 252, 231),
		Green300 = Color3.fromRGB(134, 239, 172),
		Green500 = Color3.fromRGB(34, 197, 94),
		Green700 = Color3.fromRGB(21, 128, 61),
		Green900 = Color3.fromRGB(20, 83, 45),

		-- YELLOW
		Yellow50 = Color3.fromRGB(254, 252, 232),
		Yellow100 = Color3.fromRGB(254, 249, 195),
		Yellow300 = Color3.fromRGB(253, 224, 71),
		Yellow500 = Color3.fromRGB(234, 179, 8),
		Yellow700 = Color3.fromRGB(161, 98, 7),
		Yellow900 = Color3.fromRGB(113, 63, 18),

		-- PURPLE
		Purple50 = Color3.fromRGB(250, 245, 255),
		Purple100 = Color3.fromRGB(243, 232, 255),
		Purple300 = Color3.fromRGB(196, 181, 253),
		Purple500 = Color3.fromRGB(139, 92, 246),
		Purple700 = Color3.fromRGB(109, 40, 217),
		Purple900 = Color3.fromRGB(88, 28, 135),

		-- ORANGE
		Orange50 = Color3.fromRGB(255, 247, 237),
		Orange100 = Color3.fromRGB(255, 237, 213),
		Orange300 = Color3.fromRGB(253, 186, 116),
		Orange500 = Color3.fromRGB(249, 115, 22),
		Orange700 = Color3.fromRGB(194, 65, 12),
		Orange900 = Color3.fromRGB(124, 45, 18),

		-- PINK
		Pink50 = Color3.fromRGB(253, 242, 248),
		Pink100 = Color3.fromRGB(252, 231, 243),
		Pink300 = Color3.fromRGB(249, 168, 212),
		Pink500 = Color3.fromRGB(236, 72, 153),
		Pink700 = Color3.fromRGB(190, 24, 93),
		Pink900 = Color3.fromRGB(131, 24, 67),

		-- TEAL
		Teal50 = Color3.fromRGB(240, 253, 250),
		Teal100 = Color3.fromRGB(204, 251, 241),
		Teal300 = Color3.fromRGB(94, 234, 212),
		Teal500 = Color3.fromRGB(20, 184, 166),
		Teal700 = Color3.fromRGB(15, 118, 110),
		Teal900 = Color3.fromRGB(19, 78, 74),

		-- INDIGO
		Indigo50 = Color3.fromRGB(238, 242, 255),
		Indigo100 = Color3.fromRGB(224, 231, 255),
		Indigo300 = Color3.fromRGB(165, 180, 252),
		Indigo500 = Color3.fromRGB(99, 102, 241),
		Indigo700 = Color3.fromRGB(67, 56, 202),
		Indigo900 = Color3.fromRGB(49, 46, 129),

		-- PRIMARY
		Primary100 = Color3.fromRGB(230, 190, 190),
		Primary300 = Color3.fromRGB(210, 170, 170),
		Primary500 = Color3.fromRGB(200, 160, 160),
		Primary700 = Color3.fromRGB(170, 130, 130),
	},

	FontWeight = {
		Light = Enum.Font.SourceSansLight,
		Regular = Enum.Font.SourceSans,
		Semibold = Enum.Font.SourceSansSemibold,
		Bold = Enum.Font.SourceSansBold,
	},

	FontSize = {
		XXXL = 48,
		XXL = 32,
		XL = 24,
		LG = 20,
		MD = 16,
		SM = 14,
		XS = 12,
	},

	Radius = {
		Pill = UDim.new(1, 0),
		XXL = UDim.new(0, 32),
		XL = UDim.new(0, 24),
		LG = UDim.new(0, 16),
		MD = UDim.new(0, 8),
		SM = UDim.new(0, 4),
		None = UDim.new(0, 0),
	},

	Spacing = {
		XXL = 40,
		XL = 32,
		LG = 24,
		MD = 16,
		SM = 8,
		XS = 4,
		None = 0,
	},

	Size = {
		Full = UDim2.fromScale(1, 1),
		Half = UDim2.fromScale(0.5, 0.5),
		FillWidth = UDim2.fromScale(1, 0),
		FillHeight = UDim2.fromScale(0, 1),
	},

	Position = {
		Center = UDim2.fromScale(0.5, 0.5),
		Top = UDim2.fromScale(0.5, 0),
		Right = UDim2.fromScale(1, 0.5),
		Bottom = UDim2.fromScale(0.5, 1),
		Left = UDim2.fromScale(0, 0.5),

		TopLeft = UDim2.fromOffset(0, 0),
		TopRight = UDim2.fromOffset(1, 0),
		BottomLeft = UDim2.fromOffset(0, 1),
		BottomRight = UDim2.fromOffset(1, 1),
	},

	AnchorPoint = {
		Center = Vector2.new(0.5, 0.5),
		Top = Vector2.new(0.5, 0),
		Right = Vector2.new(1, 0.5),
		Bottom = Vector2.new(0.5, 1),
		Left = Vector2.new(0, 0.5),

		TopLeft = Vector2.new(0, 0),
		TopRight = Vector2.new(1, 0),
		BottomLeft = Vector2.new(0, 1),
		BottomRight = Vector2.new(1, 1),
	},

	Elevation = {
		Level0 = 0,
		Level1 = 10,
		Level2 = 20,
		Level3 = 30,
		Level4 = 40,
		Level5 = 50,
		Level6 = 60,
		Level7 = 70,
		Level8 = 80,
		Level9 = 90,
		Level10 = 100,
	},
}

Theme.Semantic = {
	--* =========================
	--* 🎨 SURFACE (background layers)
	--* =========================
	Surface = {
		Base = Theme.Primitives.Colors.White,
		Subtle = Theme.Primitives.Colors.Gray50,
		Muted = Theme.Primitives.Colors.Gray100,
		Inverse = Theme.Primitives.Colors.Gray900,

		Card = Theme.Primitives.Colors.White,
		Overlay = Theme.Primitives.Colors.Gray100,
		OverlayTransparency = 0.8,
	},

	--* =========================
	--* 📝 TEXT
	--* =========================
	Text = {
		Primary = Theme.Primitives.Colors.Gray900,
		Secondary = Theme.Primitives.Colors.Gray600,
		Tertiary = Theme.Primitives.Colors.Gray500,
		Inverse = Theme.Primitives.Colors.White,
		Disabled = Theme.Primitives.Colors.Gray400,
		Brand = Theme.Primitives.Colors.Primary500,
	},

	--* =========================
	--* 🔲 BORDER
	--* =========================
	Border = {
		Default = Theme.Primitives.Colors.Gray200,
		Subtle = Theme.Primitives.Colors.Gray100,
		Strong = Theme.Primitives.Colors.Gray400,
		Focus = Theme.Primitives.Colors.Primary500,
		Disabled = Theme.Primitives.Colors.Gray200,
	},

	--* =========================
	--* 🎯 INTERACTIVE STATES
	--* =========================
	Interactive = {
		Primary = {
			Background = Theme.Primitives.Colors.Primary500,
			Hover = Theme.Primitives.Colors.Primary700,
			Pressed = Theme.Primitives.Colors.Primary700,
			Text = Theme.Primitives.Colors.White,
		},

		Secondary = {
			Background = Theme.Primitives.Colors.Gray100,
			Hover = Theme.Primitives.Colors.Gray200,
			Pressed = Theme.Primitives.Colors.Gray300,
			Text = Theme.Primitives.Colors.Gray900,
		},

		Ghost = {
			Background = Theme.Primitives.Colors.White,
			Hover = Theme.Primitives.Colors.Gray100,
			Pressed = Theme.Primitives.Colors.Gray200,
			Text = Theme.Primitives.Colors.Gray900,
		},

		Disabled = {
			Background = Theme.Primitives.Colors.Gray100,
			Text = Theme.Primitives.Colors.Gray400,
		},
	},

	--* =========================
	--* ⚠ STATUS
	--* =========================
	Status = {
		Success = {
			Text = Theme.Primitives.Colors.Green700,
			Background = Theme.Primitives.Colors.Green100,
		},

		Warning = {
			Text = Theme.Primitives.Colors.Primary700,
			Background = Theme.Primitives.Colors.Primary100,
		},

		Error = {
			Text = Theme.Primitives.Colors.Red700,
			Background = Theme.Primitives.Colors.Red100,
		},
	},

	--* =========================
	--* 📏 SPACING ALIASES
	--* =========================
	Spacing = {
		Section = Theme.Primitives.Spacing.XL,
		Container = Theme.Primitives.Spacing.XS,
		Component = Theme.Primitives.Spacing.MD,
		Inline = Theme.Primitives.Spacing.SM,
		Tight = Theme.Primitives.Spacing.XS,
	},

	--* =========================
	--* 🔠 TYPOGRAPHY ROLES
	--* =========================
	Typography = {
		Display = {
			Font = Theme.Primitives.FontWeight.Bold,
			Size = Theme.Primitives.FontSize.XXXL,
		},

		Heading = {
			Font = Theme.Primitives.FontWeight.Semibold,
			Size = Theme.Primitives.FontSize.XL,
		},

		Title = {
			Font = Theme.Primitives.FontWeight.Semibold,
			Size = Theme.Primitives.FontSize.LG,
		},

		Body = {
			Font = Theme.Primitives.FontWeight.Regular,
			Size = Theme.Primitives.FontSize.MD,
		},

		Caption = {
			Font = Theme.Primitives.FontWeight.Regular,
			Size = Theme.Primitives.FontSize.SM,
		},

		Button = {
			Font = Theme.Primitives.FontWeight.Semibold,
			Size = Theme.Primitives.FontSize.MD,
		},
	},

	--* =========================
	--* 🔘 RADIUS ROLES
	--* =========================
	Radius = {
		Small = Theme.Primitives.Radius.SM,
		Medium = Theme.Primitives.Radius.LG,
		Large = Theme.Primitives.Radius.LG,
		Round = Theme.Primitives.Radius.Pill,
	},

	--* =========================
	--* 🌫 ELEVATION ROLES
	--* =========================
	Elevation = {
		None = Theme.Primitives.Elevation.Level0,
		Low = Theme.Primitives.Elevation.Level1,
		Medium = Theme.Primitives.Elevation.Level3,
		High = Theme.Primitives.Elevation.Level6,
		Overlay = Theme.Primitives.Elevation.Level10,
	},
}

Theme.Components = {
	Pane = {
		Size = UDim2.fromScale(1, 1),
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Rotation = 0,

		Elevation = Theme.Semantic.Elevation.Medium,
		Color = Theme.Semantic.Surface.Base,
		BorderSize = 0,
		Transparency = 0,
		Clips = false,

		LayoutOrder = 0,
		ZIndex = 0,
		Visible = true,
	},

	ScrollPane = {
		Size = UDim2.fromScale(1, 1),
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Rotation = 0,

		ScrollingDirection = Enum.ScrollingDirection.Y,
		CanvasSize = UDim2.fromScale(0, 0),

		Elevation = Theme.Semantic.Elevation.Medium,
		Color = Theme.Semantic.Surface.Base,
		BorderSize = 0,
		Transparency = 1,
		Clips = true,

		ScrollBarThickness = 4,
		ScrollBarColor = Theme.Semantic.Text.Primary,
		ScrollBarTransparency = 0.5,

		SortOrder = Enum.SortOrder.LayoutOrder,
		Spacing = Theme.Semantic.Spacing.Container,
		HorizontalAlignment = Enum.HorizontalAlignment.Left,
		VerticalAlignment = Enum.VerticalAlignment.Top,
		FillDirection = Enum.FillDirection.Vertical,
		HorizontalFlex = Enum.UIFlexAlignment.Fill,
		VerticalFlex = Enum.UIFlexAlignment.None,
		Wraps = false,

		LayoutOrder = 0,
		ZIndex = 0,
		Visible = true,
	},

	Image = {
		Size = UDim2.fromScale(1, 1),
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Rotation = 0,

		Color = Theme.Semantic.Surface.Base,
		BorderSize = 0,
		Transparency = 1,
		Clips = false,

		Image = "",
		ImageColor = Theme.Primitives.Colors.White,
		ImageTransparency = 0,
		TileSize = UDim2.fromOffset(25, 25),
		ScaleType = Enum.ScaleType.Stretch,
		SliceCenter = Rect.new(0, 0, 0, 0),
		SliceScale = 0,

		LayoutOrder = 0,
		Visible = true,
	},

	Text = {
		Size = UDim2.fromScale(1, 1),
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Rotation = 0,

		Color = Theme.Semantic.Surface.Base,
		BorderSize = 0,
		Transparency = 0,
		Clips = false,

		Text = "",
		Variant = "Body",
		TextColor = Theme.Semantic.Text.Primary,
		TextTransparency = 0,
		RichText = false,

		TextXAlignment = Enum.TextXAlignment.Center,
		TextYAlignment = Enum.TextYAlignment.Center,
		TextWrapped = false,
		TextTruncate = Enum.TextTruncate.AtEnd,

		LayoutOrder = 0,
		ZIndex = 0,
		Visible = true,
	},

	Button = {
		Size = UDim2.fromScale(1, 1),
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Rotation = 0,

		Color = Theme.Semantic.Surface.Base,
		BorderSize = 0,
		Transparency = 0,
		Clips = false,

		Text = "",
		Variant = "Body",
		TextColor = Theme.Semantic.Text.Primary,
		TextTransparency = 0,
		RichText = false,

		TextXAlignment = Enum.TextXAlignment.Center,
		TextYAlignment = Enum.TextYAlignment.Center,
		TextWrapped = false,
		TextTruncate = Enum.TextTruncate.AtEnd,

		LayoutOrder = 0,
		ZIndex = 0,
		Visible = true,
	},

	Divider = {
		Vertical = false,

		Length = UDim.new(0.8, 0),
		Thickness = 2,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),

		Color = Theme.Semantic.Text.Primary,
		Radius = Theme.Semantic.Radius.Round,
		BorderSize = 0,
		Transparency = 0,

		LayoutOrder = 0,
		ZIndex = 0,
		Visible = true,
	},

	Corner = {
		Radius = Theme.Semantic.Radius.Medium,
	},

	Padding = {
		HorizontalSpacing = Theme.Semantic.Spacing.Container,
		VerticalSpacing = Theme.Semantic.Spacing.Container,
	},

	ListLayout = {
		SortOrder = Enum.SortOrder.LayoutOrder,
		Spacing = Theme.Semantic.Spacing.Container,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		VerticalAlignment = Enum.VerticalAlignment.Center,
		FillDirection = Enum.FillDirection.Vertical,
		HorizontalFlex = Enum.UIFlexAlignment.Fill,
		VerticalFlex = Enum.UIFlexAlignment.Fill,
		Wraps = false,
	},
}
return Theme
