local sam, command, language = sam, sam.command, sam.language

command.set_category("bots")

command.new("bot")
    :SetPermission("bot", "admin")
    :AddArg("number", {
        hint = "number",
        default = 1,
        min = 1,
        optional = true,
        round = true
    })
    :Help("Spawn bots.")
    :OnExecute(function(ply, number)
        if game.MaxPlayers() == player.GetCount() then
            sam.player.send_message(ply, "bot_server_full")
            return
        end

        local maximum = game.MaxPlayers() - player.GetCount()

        if number == 0 then
            number = maximum
        end

        number = math.min(number, maximum)

        for i = 1, number do
            RunConsoleCommand("bot")
        end

        if number >= 1 then
            sam.player.send_message(nil, "bot_spawn_multiple", { A = ply, V = number })
        end
    end)
    :End()

language.Add("bot_server_full", "The server is full!")
language.Add("bot_spawn_multiple", "{A} spawned {V} bot(s) on the server.")

command.new("kickbots")
    :SetPermission("kickbot", "admin")
    :SetCategory("bots")
    :Help("Kick all spawned bots.")
    :OnExecute(function(ply)
        for _, bot in ipairs(player.GetBots()) do
            bot:Kick("[DG]")
        end
        sam.player.send_message(nil, "{A} kicked all spawned bots.", { A = ply })
    end)
    :End()

sam.command.new("clearpac")
    :SetPermission("admin")
    :SetCategory("PAC3")
    :Help("Clears the target's PAC3 outfit.")
    :AddArg("player")
    :OnExecute(function(calling_ply, targets)
        for i = 1, #targets do
            local target_ply = targets[i]
            target_ply:SendLua("RunConsoleCommand('pac_clear_parts')")
        end
        sam.player.send_message(nil, "{A} cleared {T}'s PAC3", { A = calling_ply, T = targets })
    end)
:End()


-- SETS ALL PLAYERS IN CATEGORIES HP
sam.command.new("hpteam")
    :SetPermission("admin")
    :SetCategory("Regiment Commands")
    :Help("Set the HP value for a Regiment / Category")
    :AddArg("text", {
        hint = "Job Category e.g Boko Haram "
    })
    :AddArg("number", {
        hint = "HP Value"
    })
    :OnExecute(function(calling_ply, category, hp_value)
        if not DarkRP.DARKRP_LOADING then
            local jobs = RPExtraTeams

            if jobs then
                local found = false

                for _, job in pairs(jobs) do
                    if job.category == category then
                        found = true
                        for _, player in ipairs(team.GetPlayers(job.team)) do
                            player:SetHealth(hp_value)
                            player:SetMaxHealth(hp_value)
                        end
                    end
                end

                if found then
                    sam.player.send_message(nil, "{A} set the health of all players in {T} to {V}.", { A = calling_ply, T = category, V = hp_value })
                else
                    sam.player.send_message(calling_ply, "Regiment Not Found")
                end
            else
                sam.player.send_message(calling_ply, "Regiment Not Found")
            end
        else
            sam.player.send_message(calling_ply, "ERROR : DarkRP Still Loading")
        end
    end)
:End()

sam.command.new("giveteam")
    :SetPermission("admin")
    :SetCategory("Regiment Commands")
    :Help("Give a weapon to all players in a job category")
    :AddArg("text", {
        hint = "Job Category (e.g., Boko Haram)"
    })
    :AddArg("text", {
        hint = "Weapon Class (e.g., weapon_physgun)"
    })
    :OnExecute(function(calling_ply, category, weapon_class)
        if not DarkRP.DARKRP_LOADING then
            local jobs = RPExtraTeams

            if jobs then
                local found = false

                for _, job in pairs(jobs) do
                    if job.category == category then
                        found = true
                        for _, player in ipairs(team.GetPlayers(job.team)) do
                            player:Give(weapon_class)
                        end
                    end
                end

                if found then
                    sam.player.send_message(nil, "{A} gave {V} to all players in {T}.", { A = calling_ply, V = weapon_class, T = category })
                else
                    sam.player.send_message(calling_ply, "Regiment Not Found")
                end
            else
                sam.player.send_message(calling_ply, "Regiment Not Found")
            end
        else
            sam.player.send_message(calling_ply, "ERROR: DarkRP Still Loading")
        end
    end)
:End()

sam.command.new("armorteam")
    :SetPermission("admin")
    :SetCategory("Regiment Commands")
    :Help("Set the armor value for a Regiment / Category")
    :AddArg("text", {
        hint = "Job Category (e.g., Boko Haram)"
    })
    :AddArg("number", {
        hint = "Armor Value"
    })
    :OnExecute(function(calling_ply, category, armor_value)
        if not DarkRP.DARKRP_LOADING then
            local jobs = RPExtraTeams

            if jobs then
                local found = false

                for _, job in pairs(jobs) do
                    if job.category == category then
                        found = true
                        for _, player in ipairs(team.GetPlayers(job.team)) do
                            player:SetArmor(armor_value)
                        end
                    end
                end

                if found then
                    sam.player.send_message(nil, "{A} set the armor of all players in {T} to {V}.", { A = calling_ply, T = category, V = armor_value })
                else
                    sam.player.send_message(calling_ply, "Regiment Not Found")
                end
            else
                sam.player.send_message(calling_ply, "Regiment Not Found")
            end
        else
            sam.player.send_message(calling_ply, "ERROR: DarkRP Still Loading")
        end
    end)
:End()

sam.command.new("buddhateam")
    :SetPermission("admin")
    :SetCategory("Regiment Commands")
    :Help("Enable Buddha mode for a Regiment / Category")
    :AddArg("text", {
        hint = "Job Category (e.g., Boko Haram)"
    })
    :OnExecute(function(calling_ply, category)
        if not DarkRP.DARKRP_LOADING then
            local jobs = RPExtraTeams

            if jobs then
                local found = false

                for _, job in pairs(jobs) do
                    if job.category == category then
                        found = true
                        for _, player in ipairs(team.GetPlayers(job.team)) do
                            player.sam_buddha = true
                        end
                    end
                end

                if found then
                    sam.player.send_message(nil, "{A} enabled Buddha for all players in {T}.", { A = calling_ply, T = category })
                else
                    sam.player.send_message(calling_ply, "Regiment Not Found")
                end
            else
                sam.player.send_message(calling_ply, "Regiment Not Found")
            end
        else
            sam.player.send_message(calling_ply, "ERROR: DarkRP Still Loading")
        end
    end)
:End()

sam.command.new("unbuddhateam")
    :SetPermission("admin")
    :SetCategory("Regiment Commands")
    :Help("Disable Buddha mode for a Regiment / Category")
    :AddArg("text", {
        hint = "Job Category (e.g., Boko Haram)"
    })
    :OnExecute(function(calling_ply, category)
        if not DarkRP.DARKRP_LOADING then
            local jobs = RPExtraTeams

            if jobs then
                local found = false

                for _, job in pairs(jobs) do
                    if job.category == category then
                        found = true
                        for _, player in ipairs(team.GetPlayers(job.team)) do
                            player.sam_buddha = nil
                        end
                    end
                end

                if found then
                    sam.player.send_message(nil, "{A} disabled Buddha for all players in {T}.", { A = calling_ply, T = category })
                else
                    sam.player.send_message(calling_ply, "Regiment Not Found")
                end
            else
                sam.player.send_message(calling_ply, "Regiment Not Found")
            end
        else
            sam.player.send_message(calling_ply, "ERROR: DarkRP Still Loading")
        end
    end)
:End()

if SERVER then
    hook.Add("EntityTakeDamage", "SAM.BuddhaMode", function(ply, info)
        if ply.sam_buddha and ply:Health() - info:GetDamage() <= 0 then
            ply:SetHealth(1)
            return true
        end
    end)
end

sam.command.new("setmodelteam")
    :SetPermission("admin")
    :SetCategory("Regiment Commands")
    :Help("Set the player model for all players in jobs within a category")
    :AddArg("text", {hint = "category"})
    :AddArg("text", {hint = "model"})
    :OnExecute(function(calling_ply, category, model)
        if not DarkRP.DARKRP_LOADING then
            local jobs = RPExtraTeams

            if jobs then
                local found = false
                local originalCategory = category -- Store the original category value
                category = category:lower() -- Convert category to lowercase

                for _, job in pairs(jobs) do
                    if job.category:lower() == category then -- Compare lowercase categories
                        found = true
                        local players = team.GetPlayers(job.team)

                        for i = 1, #players do
                            players[i]:SetModel(model)
                        end
                    end
                end

                if found then
                    sam.player.send_message(nil, "{A} set the model for all players in {T} to {V}.", { A = calling_ply, T = originalCategory, V = model }) -- Use originalCategory instead of category
                else
                    sam.player.send_message(calling_ply, "No jobs found in the specified category.")
                end
            else
                sam.player.send_message(calling_ply, "No jobs found.")
            end
        else
            sam.player.send_message(calling_ply, "ERROR: DarkRP is still loading.")
        end
    end)
:End()

-- SAM Admin Warp --

local savedPos = {}

sam.command.new("setwarp")
    :SetPermission("admin")
    :SetCategory("Teleport")
    :Help("Sets a warp position.")
    :AddArg("text", { hint = "name" })
    :OnExecute(function(calling_ply, args)
        local name = args
        if not name then return end

        savedPos[name] = calling_ply:GetPos()

        for _, v in ipairs(player.GetAll()) do
            if v:IsAdmin() then
                sam.player.send_message(v, "A new warp location has been created: " .. name)
            end
        end

    end)
:End()

sam.command.new("warp")
    :SetPermission("admin")
    :SetCategory("Teleport")
    :Help("Warps to a set position.")
    :AddArg("text", { hint = "name" })
    :OnExecute(function(calling_ply, args)
        local name = args
        if not name then return end

        local pos = savedPos[name]
        if pos then
            calling_ply:SetPos(pos)
            sam.player.send_message(calling_ply, "warped to {V}.", { V = name })
        else
            sam.player.send_message(calling_ply, "Warp location not found: " .. name)
        end
    end)
:End()







