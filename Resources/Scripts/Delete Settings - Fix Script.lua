pcall(function()
	local Title, Functions = game:HttpGet("https://pastebin.com/raw/EYGkq0gX"), getgenv().WallHack.Functions

	if isfolder(Title) then
		delfolder(Title)

		if Functions then
			Functions:Restart()
		end
	end
end)