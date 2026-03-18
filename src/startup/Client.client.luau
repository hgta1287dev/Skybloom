local ReplicatedStorage = game:GetService("ReplicatedStorage")

local KnitBootstrap = require(ReplicatedStorage.SharedStartup.KnitBootstrap)
local LoggerBootstap = require(ReplicatedStorage.SharedStartup.LoggerBootstap)
local ServiceLoader = require(ReplicatedStorage.SharedStartup.ServiceLoader)

LoggerBootstap:Init()

ServiceLoader:Init()
KnitBootstrap:Init()
