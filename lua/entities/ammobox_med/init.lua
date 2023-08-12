AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

function ENT:Initialize()
    if SERVER then
        self:SetModel(self.Model)
        self:SetSolid(SOLID_VPHYSICS)
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetUseType(SIMPLE_USE)

        local phys = self:GetPhysicsObject()
        if IsValid(phys) then
            phys:Wake()
        end
		
		self:SetHealth(350)
    end
end

function ENT:Use(activator, caller)
	
	local activeWeapon = caller:GetActiveWeapon()
	
	local ammoType1 = activeWeapon:GetPrimaryAmmoType()
	local ammoType2 = activeWeapon:GetSecondaryAmmoType()
	local clip1 = activeWeapon:GetMaxClip1()
	
	local ammoCount = IsValid(activeWeapon) and clip1 or 0
	
	if IsValid(activeWeapon) then
        allammocount = caller:GetAmmoCount(ammoType1)
    end
	
	if (!(allammocount > -1 and ammoCount > -1 and activeWeapon.PrintName ~= nil)) then return end
	
    if IsValid(caller) and caller:IsPlayer() then
		activator:GiveAmmo(clip1 / 4, ammoType1, false)
		activator:GiveAmmo(1, ammoType2, false)
        self:EmitSound("items/ammo_pickup.wav") -- You can change the sound if desired
    end
end

function ENT:OnTakeDamage(damage)
	self:SetHealth(self:Health() - damage:GetDamage())
	if (self:Health() <= 0) then
		self:EmitSound("ambient/explosions/explode_3.wav")
		local effectdata = EffectData()
		effectdata:SetOrigin( self:GetPos() )
		util.Effect("Explosion", effectdata)
		self:Remove()
	end
end