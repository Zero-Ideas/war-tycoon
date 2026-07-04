local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local COLOR_YELLOW = BrickColor.new("New Yeller")
local COLOR_LIME   = BrickColor.new("Lime green")
local COLOR_CYAN   = BrickColor.new("Cyan")


local GRAB_COLOR_NUMBERS = {
	[COLOR_LIME.Number]   = true,
	[COLOR_CYAN.Number]   = true,
	[COLOR_YELLOW.Number] = true,
}

local function findOwnedTycoon()
	for _, v in pairs(workspace.Tycoon.Tycoons:GetChildren()) do
		if v.Owner.Value == LocalPlayer then
			return v
		end
	end
end

local tycoon = findOwnedTycoon()

local function teleportTo(cframe, waitTime)
	LocalPlayer.Character.HumanoidRootPart.CFrame = cframe
	if waitTime then
		wait(waitTime)
	end
end

local function getRebirthCost(neon)
	local digits = string.gsub(neon.UI.BillboardGui.Frame.Price.Text, "%D", "")
	if #digits == 0 then
		return false
	end
	return tonumber(digits)
end

local function canAffordRebirthCost(cost)
	return cost <= LocalPlayer.leaderstats.Rebirths.Value
end


local function grabButtons()
	local foundGrabbable

	repeat
		foundGrabbable = false
		wait(1)

		for _, v in pairs(tycoon.UnpurchasedButtons:GetDescendants()) do
			if v:IsA("TouchTransmitter") then
				local neon = v.Parent.Parent.Neon
				local color = neon.BrickColor

				if GRAB_COLOR_NUMBERS[color.Number] then
					if color == COLOR_YELLOW then
						local cost = getRebirthCost(neon)
						if cost == false or not canAffordRebirthCost(cost) then
							continue
						end
					end

					teleportTo(v.Parent.CFrame + Vector3.new(0, 5, 0), 0.45)

					if color == COLOR_LIME or color == COLOR_CYAN then
						foundGrabbable = true
					end
				end
			end
		end
	until not foundGrabbable
end
grabButtons();