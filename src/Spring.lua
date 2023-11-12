--!strict

--[[
	Modified Spring module made by BlackShibe. Author of edit - Atlantos_1
	Original: https://www.roblox.com/library/5692144533/spring
	Features:
		- Luau Typecheck
		- Non-FPS Dependant
		- Customizable
	Example of usage:
		```lua
			-- Instead of <number> put your numbers. Instead "path_to_spring" write your variable to require spring module.
			local RecoilSpring = require(path_to_spring).new()
			RecoilSpring.Mass = <number>
			RecoilSpring.Force = <number>
			RecoilSpring.Damping = <number>
			RecoilSpring.Speed = <number>
			
			game:GetService("RenderStepped"):Connect(function(dt: number)
				local updateDelta: Vector3 = path_to_spring:UpdateDelta(dt)
				workspace.CurrentCamera.CFrame *= CFrame.Angles(math.rad(updateDelta.X), math.rad(updateDelta.Y), math.rad(updateDelta.Z))
			end)
			
			-- Instead of <number> put your numbers.
			local function pew(): ()
				path_to_spring:Impulse(Vector3.new(<number>, <number>, <number>))
			end
		```
]]-- 

-->> Module <<--
local Main = {}
local ClassSpring = {}
ClassSpring.__index = Main

-->> Typecheck <<--
export type Public<T...> = {
	Target: Vector3;
	Position: Vector3;
	Velocity: Vector3;
	
	Mass: number;
	Force: number;
	Damping: number;
	Speed: number;
	
	CurrentDelta: number;

	Impulse: (self: Public<T...>, Force: Vector3) -> ();
	UpdateDelta: (self: Public<T...>, deltaTime: number) -> (Vector3);
}

-->> Functions <<--
function ClassSpring.new<T...>(mass: number?, force: number?, damping: number?, speed: number?): Public<T...>
	local self: Public<T...> = setmetatable({
		Target	 = Vector3.zero;
		Position = Vector3.zero;
		Velocity = Vector3.zero;

		Mass = mass or 5;
		Force = force or 50;
		Damping = damping or 4;
		Speed = speed or 4;
		CurrentDelta = 0;
	}, ClassSpring) :: any

	return self
end

function Main.Impulse<T...>(self: Public<T...>, force: Vector3): ()
	local x: number, y: number, z: number = force.X, force.Y, force.Z

	if x == math.huge or x == -math.huge then
		x = 0
	end

	if y == math.huge or y == -math.huge then
		y = 0
	end

	if z == math.huge or z == -math.huge then
		z = 0
	end

	self.Velocity = self.Velocity + self.CurrentDelta * 60 * Vector3.new(x, y, z)
end

function Main.UpdateDelta<T...>(self: Public<T...>, deltaTime: number): (Vector3)
	local scaledDeltaTime: number = math.min(deltaTime, 1) * self.Speed / 8
	self.CurrentDelta = deltaTime

	for i = 1, 8 do
		local iterationForce: Vector3 = self.Target - self.Position
		local acceleration = (iterationForce * self.Force) / self.Mass

		acceleration = acceleration - self.Velocity * self.Damping

		self.Velocity = self.Velocity + acceleration * scaledDeltaTime
		self.Position = self.Position + self.Velocity * scaledDeltaTime
	end

	return self.Position
end

return ClassSpring
