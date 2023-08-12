DGInGame = DGInGame or {}

include("shared.lua") -- Include shared.lua on the client

function DGInGame.drawCloselessBox(width, height, color, offsetx, offsety)
	draw.RoundedBox(0, offsetx or 0, offsety or 0, width, height, color)
end

function DGInGame.drawCloselessBoxBorder(width, height, c1, c2, w, offsetx, offsety)
	if (!offsetx) then offsetx = 0 end
	if (!offsety) then offsety = 0 end

	DGInGame.drawCloselessBox(width, w, c2, offsetx, offsety)
	DGInGame.drawCloselessBox(width, w, c2, offsetx, offsety + (height - w))

	DGInGame.drawCloselessBox(w, height, c2, offsetx, offsety)
	DGInGame.drawCloselessBox(w, height, c2, offsetx + (width - w), offsety)

	DGInGame.drawCloselessBox(width - (w * 2), height - (w * 2), c1, offsetx + w, offsety + w)
end

function DGInGame.PanelHovered(panel)
	local w, h = panel:GetSize()
	local mx, my = panel:CursorPos()

	return mx > 0 and my > 0 and mx < w and my < h
end

DGInGame.lockedPagePaint = function (w, h)
	surface.SetDrawColor(27, 27, 30, 200)
	surface.SetMaterial(Material("materials/dg_tablet/lock.png"))
	surface.DrawTexturedRect(w / 4, h / 4, 200, 200)
end

DGInGame.CategoryButtons = {
	{
		title = "Deployments",
		textColor = Color(255, 0, 0),
		pagePaint = function (w, h)
			-- Custom paint for the page
			surface.SetDrawColor(Color(27, 27, 30, 0))
			surface.DrawRect(0, 0, w, h)
		end,
		buttons = {
			{
                -- 200 x 300
				paint = function (self, w, h)
					-- Custom button paint
					local color = Color(255, 255, 255)
					if not self:IsHovered() then
						local m = 0.8
						color = Color(color.r * m, color.g * m, color.b * m, color.a)
					end
					DGInGame.drawCloselessBoxBorder(w, h, Color(27, 27, 30, 255), color, 1, 0, 0)
					draw.DrawText("Predator Missile", "code_pro_23", w * 0.5, h - h * 0.125, color, TEXT_ALIGN_CENTER)
                    
                    surface.SetDrawColor(255,255,255)
                    surface.SetMaterial(Material("materials/dg_tablet/predmissile.png"))

                    local Predx = 85
                    local Predy = 245
                    surface.DrawTexturedRect((w - Predx) / 2, 20 , Predx, Predy)
				end,
				pos = { x = 50, y = 30},
				DoClick = function ()
					net.Start("GivePredatorWeapon")
					net.SendToServer()
				end
			},
            {
				paint = function (self, w, h)
					-- Custom button paint
					local color = Color(255, 255, 255)
					if not self:IsHovered() then
						local m = 0.8
						color = Color(color.r * m, color.g * m, color.b * m, color.a)
					end
					DGInGame.drawCloselessBoxBorder(w, h, Color(27, 27, 30, 255), color, 1, 0, 0)
					draw.DrawText("AC-130 Gunship", "code_pro_23", w * 0.5, h - h * 0.125, color, TEXT_ALIGN_CENTER)
                    
                    surface.SetDrawColor(255,255,255)
                    surface.SetMaterial(Material("materials/dg_tablet/ac130.png"))

                    local Predx = 150
                    local Predy = 109
                    surface.DrawTexturedRect((w - Predx) / 2, (h - Predy) / 2 , Predx, Predy)
				end,
				pos = { x = 340, y = 30},
				DoClick = function ()
					net.Start("GiveAC130")
					net.SendToServer()
				end
			},
		},
	},
}

-- Global variable to store the tablet GUI panel
DGInGame.guiTabletPanel = nil

-- Function to open the GUI when "open_tablet" is received

local scrH = ScrH()
local scrW = ScrW()

DGInGame.lastToggledButton = nil

function DGInGame.ToggleButton(button)
    if not IsValid(button) then
        return -- If the button is not valid, do nothing
    end

    if button.toggled then
        return -- If the same button is pressed again, do nothing
    end

    if DGInGame.lastToggledButton and DGInGame.lastToggledButton ~= button then
        DGInGame.lastToggledButton.toggled = false
    end

    button.toggled = true
    DGInGame.lastToggledButton = button
end


function DGInGame.OpenTabletGUI()

	if IsValid(DGInGame.guiTabletPanel) then
		-- If the GUI is already open, just make it visible again
		DGInGame.guiTabletPanel:SetVisible(true)
	else
		local frame = vgui.Create("DFrame")
		frame:SetSize(scrW / 2.59, scrH / 1.95)
		frame:SetPos(scrW / 3.54, scrH / 3.66)
		frame:SetTitle("")
		frame:ShowCloseButton(false)
		frame:SetDraggable(false)
		function frame:Paint(w, h)

			surface.SetDrawColor(Color(27, 27, 30, 0))
			surface.DrawRect(0, 0, w, h)

			surface.SetDrawColor(Color(255, 255, 255, 5))
			surface.SetMaterial(Material("materials/dg_tablet/tactical_tablet.png"))
			surface.DrawTexturedRect(0, 0, w, h)

			surface.SetDrawColor(Color(27, 27, 30))
			surface.DrawRect(0, 0, w, 80)

			surface.SetDrawColor(Color(255, 255, 255))
			surface.SetMaterial(Material("materials/dg_tablet/dgos.png"))
			surface.DrawTexturedRect(70, 15, 80, 40)

		end

		-- Add your GUI elements to the frame, e.g., buttons, labels, etc.
		-- For example:

		local closeButton = vgui.Create("DButton", frame)
		closeButton:SetFont("code_pro_40")
		closeButton:SetText("")
		closeButton:SetPos(10, 10)
		closeButton:SetSize(50, 50)
		closeButton.Paint = function (self, w, h)
			surface.SetDrawColor(Color(255, 255, 255))
			surface.SetMaterial(Material("materials/dg_tablet/power.png"))
			surface.DrawTexturedRect(5, 5, 40, 40)
			if (DGInGame.PanelHovered(self)) then
				DGInGame.drawCloselessBoxBorder(w, h, Color(130, 13, 13, 100), Color(255, 255, 255), 2, 0, 0)
			else
				DGInGame.drawCloselessBoxBorder(w, h, Color(17, 17, 30, 200), Color(255, 255, 255), 2, 0, 0)
			end
		end
		closeButton.DoClick = function ()
			DGInGame.CloseTabletGUI()
		end

		local sideBar = vgui.Create("DPanel", frame)
		sideBar:SetPos(0, 80)
		sideBar:SetSize(150, frame:GetTall() - 80)
		sideBar.Paint = function (self, w, h)
			surface.SetDrawColor(27, 27, 30)
			surface.DrawRect(0, 0, w, h)
		end

		local bx = 0
		local by = 0
		local bxr = 0

		local currentPagePanel

		for k, v in pairs(DGInGame.CategoryButtons) do
			local buttonheight = 40
			local tw, th = surface.GetTextSize("IDK big string of text")
			th = th + 45

			local button = vgui.Create("DButton", sideBar)
			button:SetPos(bx, by)
			local font = "code_pro_19"
			button:SetSize(sideBar:GetWide(), buttonheight)
			button:SetText("")

			if (v.textColor) then
				button:SetTextColor(v.textColor)
			end

			button.toggled = false -- Initialize the toggled state to false

			button.DoClick = function ()

				if IsValid(currentPagePanel) then
					currentPagePanel:Remove() -- Remove the previous page panel if it exists
				end

                DGInGame.ToggleButton(button)

				-- Create and show the new page panel
				currentPagePanel = vgui.Create("DPanel", frame)
				currentPagePanel:SetPos(150, 80)
				currentPagePanel:SetSize(frame:GetWide() - 150, frame:GetTall() - 80)
				currentPagePanel.Paint = function (self, w, h)
					v.pagePaint(w, h)
				end

				if v.buttons then
					for _, buttonData in ipairs(v.buttons) do
						local button = vgui.Create("DButton", currentPagePanel)
						button:SetSize(200, 300)
						button:SetPos(buttonData.pos.x, buttonData.pos.y)
						button:SetText("")
						button.DoClick = buttonData.DoClick
						button.Paint = buttonData.paint
					end
				end

				-- Parent the new panel to the frame
				currentPagePanel:SetParent(frame)
			end

            local arrowColor = v.textColor -- Change this to the desired color for the arrow when the button is toggled

            button.Paint = function (self, w, h)
                local color = v.textColor or Color(255, 255, 255)

                -- Check if the button is toggled and update the color accordingly
                if button.toggled then
                    DGInGame.drawCloselessBoxBorder(w, h, Color(27, 27, 30), arrowColor, 1, 0, 0)
                    draw.DrawText(tostring(v.title), font, w * 0.5, buttonheight * 0.25, color, TEXT_ALIGN_CENTER)

                    surface.SetDrawColor(arrowColor)
                    surface.SetMaterial(Material("materials/dg_tablet/arrow.png"))
                    surface.DrawTexturedRect(button:GetWide() - 20, (h - 10) * 0.5, 10, 10)
                else
                    -- Original color when not toggled
                    if not self:IsHovered() then
                        DGInGame.drawCloselessBoxBorder(w, h, Color(27, 27, 30), color, 0, 0, 0)
                        draw.DrawText(tostring(v.title), font, w * 0.5, buttonheight * 0.25, color, TEXT_ALIGN_CENTER)
                    else
                        DGInGame.drawCloselessBoxBorder(w, h, Color(27 * 1.2, 27 * 1.2, 30 * 1.2), color, 0, 0, 0)
                        draw.DrawText(tostring(v.title), font, w * 0.5, buttonheight * 0.25, color, TEXT_ALIGN_CENTER)
                    end
                end
            end
			by = by + button:GetTall()
		end

		frame.OnClose = function ()
			-- Handle the GUI close event by hiding the panel instead of removing it
			if IsValid(guiTabletPanel) then
				DGInGame.guiTabletPanel:SetVisible(false)
			end
		end

		frame:MakePopup()

		-- Store the frame in the global variable
		DGInGame.guiTabletPanel = frame
	end
end

-- close the tablet GUI
function DGInGame.CloseTabletGUI()
	if IsValid(DGInGame.guiTabletPanel) then
		DGInGame.guiTabletPanel:Close()
        DGInGame.lastToggledButton = nil -- Reset lastToggledButton to nil when closing the GUI
	end
end

net.Receive("tablet_open", DGInGame.OpenTabletGUI)
net.Receive("tablet_close", DGInGame.CloseTabletGUI)
