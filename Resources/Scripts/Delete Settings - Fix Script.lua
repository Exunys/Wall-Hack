pcall(function()
	local Title, Functions = game:HttpGet("https://raw.githubusercontent.com/Exunys/Wall-Hack/main/Resources/Information/Title.txt"), getgenv().WallHack.Functions

	if isfolder(Title) then
		delfolder(Title)

		if Functions then
			Functions:Restart()
		end
	end
end)
