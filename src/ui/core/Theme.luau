local Theme = {}

Theme.Colors = {
	Background = Color3.fromRGB(255, 255, 255),
	Primary = Color3.fromRGB(200, 160, 160),
	Secondary = Color3.fromRGB(230, 190, 190),
	Text = Color3.fromRGB(200, 160, 160),

	MainBackground = Color3.fromRGB(255, 255, 255),
	SubBackground = Color3.fromRGB(245, 245, 245),

	MainText = Color3.fromRGB(200, 160, 160),
	SubText = Color3.fromRGB(200, 160, 160),
	Surface = Color3.fromRGB(45, 45, 45),
	Border = Color3.fromRGB(70, 70, 70),

	Success = Color3.fromRGB(80, 200, 120),
	Danger = Color3.fromRGB(220, 70, 70),
}

Theme.Fonts = {
	MainText = Enum.Font.SourceSansBold,
	SubText = Enum.Font.SourceSansLight,

	Display = Enum.Font.SourceSansBold,
	Title = Enum.Font.SourceSansBold,
	Subtitle = Enum.Font.SourceSansLight,
	Body = Enum.Font.SourceSans,
	BodySmall = Enum.Font.SourceSansLight,

	Light = Enum.Font.SourceSansLight,
	Regular = Enum.Font.SourceSans,
	Semibold = Enum.Font.SourceSansSemibold,
	Bold = Enum.Font.SourceSansBold,
}

Theme.FontSize = {
	Display = 32,
	Title = 24,
	Subtitle = 20,
	Body = 16,
	BodySmall = 14,

	XS = 12,
	SM = 14,
	MD = 16,
	LG = 20,
	XL = 24,
	XXL = 32,
}

Theme.Radius = {
	None = UDim.new(0, 0),
	Default = UDim.new(0, 20),
	Pill = UDim.new(1, 0),

	XS = UDim.new(0, 4),
	SM = UDim.new(0, 8),
	MD = UDim.new(0, 12),
	LG = UDim.new(0, 16),
	XL = UDim.new(0, 24),
}

Theme.Spacing = {
	DefaultHorizontal = 10,
	DefaultVertical = 14,
	None = 0,
	XXS = 2,
	XS = 4,
	SM = 8,
	MD = 12,
	LG = 16,
	XL = 24,
	XXL = 32,
}

return Theme
