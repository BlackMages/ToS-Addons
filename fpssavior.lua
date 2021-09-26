local addonName = "FPSSAVIOR"
local author = "JABBERWOCK"

_G["ADDONS"] = _G["ADDONS"] or {}
_G["ADDONS"][author] = _G["ADDONS"][author] or {}
_G["ADDONS"][author][addonName] = _G["ADDONS"][author][addonName] or {}
local g = _G["ADDONS"][author][addonName];
g.saviormode = {"{#2D9B27}{ol}HIGH","{#F2F407}{ol}MEDIUM","{#284B7E}{ol}LOW","{#532881}{ol}UltraLOW","{#532881}{ol}ULow2"};

local acutil = require("acutil");
CHAT_SYSTEM("FPS Savior loaded! Help: /fpssavior help");

function FPSSAVIOR_ON_INIT(addon, frame)
	frame:ShowWindow(1);
	acutil.slashCommand("/fpssavior",FPSSAVIOR_CMD);
	acutil.slashCommand("/fs_ex",FPSSAVIOR_EX_CMD);
	acutil.slashCommand("/fs_del",FPSSAVIOR_DEL_CMD);
	acutil.slashCommand("/fs_draw_pl", FPSSAVIOR_MAXPL_CMD);
	acutil.slashCommand("/fs_draw_mon", FPSSAVIOR_MAXMON_CMD);
	addon:RegisterMsg("GAME_START", "FPSSAVIOR_START");
	addon:RegisterMsg("FPS_UPDATE", "FPSSAVIOR_SHOWORHIDE_OBJ");
	
	FPSSAVIOR_LOADSETTINGS();
end

function FPSSAVIOR_LOADSETTINGS()
	local settings, error = acutil.loadJSON("../addons/fpssavior/settings.json");
	if error then
		FPSSAVIOR_SAVESETTINGS();
		return
	end
	if settings.allplayers == nil then
		settings.allplayers = 0;
		settings.shops = 0;
		settings.noguild = 0;
		settings.onlypt = 0;
		settings.allsum = 0;
		settings.onlymy = 0;
		settings.exception = {};
		settings.deletion = {};
		settings.drawplayer = 100;
		settings.drawmonster = 100;
	end
		g.settings = settings;
end

function FPSSAVIOR_SAVESETTINGS()
	if g.settings == nil then
		g.settings = {
			saviorToggle = 2,
			displayX = 510,
			displayY = 920,
			lock = 1,
			allplayers = 0,
			shops = 0,
			noguild = 0,
			onlypt = 0,
			allsum = 0,
			onlymy = 0,
			exception = {},
			deletion = {},
			drawplayer = 100,
			drawmonster = 100
		};
	end
	acutil.saveJSON("../addons/fpssavior/settings.json", g.settings);
end

function FPSSAVIOR_START_DRAG()
	saviorFrame.isDragging = true;
end

function FPSSAVIOR_END_DRAG()
	g.settings.displayX = saviorFrame:GetX();
	g.settings.displayY = saviorFrame:GetY();
	FPSSAVIOR_SAVESETTINGS();
	saviorFrame.isDragging = false;
end

function FPSSAVIOR_START()
	saviorFrame = ui.GetFrame("fpssaviorframe");
	if saviorFrame == nil then
		saviorFrame = ui.CreateNewFrame("fpssavior","fpssaviorframe");
		saviorFrame:SetBorder(0, 0, 0, 0);
		saviorFrame:Resize(125,60)
		saviorFrame:SetOffset(g.settings.displayX, g.settings.displayY);
		saviorFrame:ShowWindow(1);
		saviorFrame:SetLayerLevel(61);
		saviorFrame.isDragging = false;
		saviorFrame:SetEventScript(ui.LBUTTONDOWN, "FPSSAVIOR_START_DRAG");
		saviorFrame:SetEventScript(ui.LBUTTONUP, "FPSSAVIOR_END_DRAG");
		saviorFrame:EnableMove(0);
		g.settings.lock = 1;
		FPSSAVIOR_SAVESETTINGS();
		
		saviorText = saviorFrame:CreateOrGetControl("richtext","saviortext",0,0,0,0);
		saviorText = tolua.cast(saviorText,"ui::CRichText");
		saviorText:SetGravity(ui.LEFT,ui.CENTER_VERT);
		saviorText:SetText("{s18}".. g.saviormode[g.settings.saviorToggle]);
		
		btnsaviorC = saviorFrame:CreateOrGetControl('button', 'btnc', 0, 0, 16, 16); 
		btnsaviorC:SetOffset(84, 20);
		btnsaviorC:SetText(string.format("{img chat_option2_btn %d %d}", 16, 16));
		btnsaviorC:SetEventScript(ui.LBUTTONDOWN, 'FPSSAVIOR_OPENCONFIG');
		
		btnsaviorH = saviorFrame:CreateOrGetControl('button', 'btnh', 0, 0, 25, 20); 
		btnsaviorH:SetOffset(0, 40); 
		btnsaviorH:SetText("{s16}{#2D9B27}{ol}H");
		btnsaviorH:SetEventScript(ui.LBUTTONDOWN, 'FPSSAVIOR_HIGH');
		
		btnsaviorM = saviorFrame:CreateOrGetControl('button', 'btnm', 0, 0, 25, 20); 
		btnsaviorM:SetOffset(25, 40); 
		btnsaviorM:SetText("{s16}{#F2F407}{ol}M");
		btnsaviorM:SetEventScript(ui.LBUTTONDOWN, 'FPSSAVIOR_MEDIUM');
		
		btnsaviorL = saviorFrame:CreateOrGetControl('button', 'btnl', 0, 0, 25, 20); 
		btnsaviorL:SetOffset(50, 40); 
		btnsaviorL:SetText("{s16}{#284B7E}{ol}L");
		btnsaviorL:SetEventScript(ui.LBUTTONDOWN, 'FPSSAVIOR_LOW');

		btnsaviorUlow = saviorFrame:CreateOrGetControl('button', 'btnul', 0, 0, 25, 20); 
		btnsaviorUlow:SetOffset(75, 40); 
		btnsaviorUlow:SetText("{s16}{#532881}{ol}U1");
		btnsaviorUlow:SetEventScript(ui.LBUTTONDOWN, 'FPSSAVIOR_ULOW');
		
		btnsaviorEX = saviorFrame:CreateOrGetControl('button', 'btnex', 0, 0, 25, 20); 
		btnsaviorEX:SetOffset(100, 40); 
		btnsaviorEX:SetText("{s16}{#532881}{ol}U2");
		--EE0000
		btnsaviorEX:SetEventScript(ui.LBUTTONDOWN, 'FPSSAVIOR_EX');
	end
	if not saviorFrame.isDragging then
		saviorFrame:SetOffset(g.settings.displayX, g.settings.displayY);
	end
	if g.settings.saviorToggle == 1 then
		FPSSAVIOR_HIGH();
	elseif g.settings.saviorToggle == 2 then
		FPSSAVIOR_MEDIUM();
	elseif g.settings.saviorToggle == 3 then
		FPSSAVIOR_LOW();
	elseif g.settings.saviorToggle == 4 then
		FPSSAVIOR_ULOW();
	else
		FPSSAVIOR_EX();
	end
end

function FPSSAVIOR_OPENCONFIG()
	local configframe = ui.GetFrame('fpssaviorconfig');
	if  configframe ~= nil and configframe:IsVisible() == 1  then
		configframe:ShowWindow(0);
	else
		FPSSAVIOR_CONFIGFRAME();
	end
end

function FPSSAVIOR_CONFIGFRAME()
	local configframe = ui.GetFrame('fpssaviorconfig');
	if configframe == nil then
		configframe = ui.CreateNewFrame("fpssavior","fpssaviorconfig");
		configframe:SetSkinName("pip_simple_frame");
		configframe:Resize(170,190);
		configframe:SetLayerLevel(62);
	end
	configframe:ShowWindow(1);
	local mainX = ui.GetFrame("fpssaviorframe"):GetX();
	local mainY = ui.GetFrame("fpssaviorframe"):GetY();
	if mainY < 210 then
		configframe:SetOffset(mainX,mainY+60);
	else
		configframe:SetOffset(mainX,mainY-172);
	end
	
	local playerText = configframe:CreateOrGetControl("richtext","playertext",5,10,0,0);
	playerText:SetText("{ol}Players:");
	
	local playerBox = configframe:CreateOrGetControl('checkbox', 'allplayersbox', 5, 32, 100, 20)
	playerBox:SetText("{ol}Hide all");	
	playerBox:SetEventScript(ui.LBUTTONUP,"FPSSAVIOR_SAVECONFIGFRAME1");
	local playerBoxchild = GET_CHILD(configframe, "allplayersbox");
	playerBoxchild:SetCheck(g.settings.allplayers);
	
	playerBox = configframe:CreateOrGetControl('checkbox', 'onlyptbox', 5, 54, 100, 20)
	playerBox:SetText("{ol}Show pt/guild only");
	playerBox:SetEventScript(ui.LBUTTONUP,"FPSSAVIOR_SAVECONFIGFRAME2");
	playerBoxchild = GET_CHILD(configframe, "onlyptbox");
	playerBoxchild:SetCheck(g.settings.onlypt);
	
	playerBox = configframe:CreateOrGetControl('checkbox', 'noguildbox', 5, 76, 100, 20)
	playerBox:SetText("{ol}Show pt only");
	playerBox:SetEventScript(ui.LBUTTONUP,"FPSSAVIOR_SAVECONFIGFRAME5");
	playerBoxchild = GET_CHILD(configframe, "noguildbox");
	playerBoxchild:SetCheck(g.settings.noguild);

	playerBox = configframe:CreateOrGetControl('checkbox', 'shopsbox', 5, 98, 100, 20)
	playerBox:SetText("{ol}Hide player shops");
	playerBox:SetEventScript(ui.LBUTTONUP,"FPSSAVIOR_SAVECONFIGFRAME6");
	playerBoxchild = GET_CHILD(configframe, "shopsbox");
	playerBoxchild:SetCheck(g.settings.shops);
		
	local summonText = configframe:CreateOrGetControl("richtext","summontext",5,118,0,0);
	summonText:SetText("{ol}Summons:");
	local summonBox = configframe:CreateOrGetControl('checkbox', 'allsumbox', 5, 140, 100, 20)
	summonBox:SetText("{ol}Hide all");
	summonBox:SetEventScript(ui.LBUTTONUP,"FPSSAVIOR_SAVECONFIGFRAME3");
	--summonBox:SetEventScriptArgString(ui.LBUTTONUP, "allsum");
	local summonBoxchild = GET_CHILD(configframe, "allsumbox");
	summonBoxchild:SetCheck(g.settings.allsum);
	summonBox = configframe:CreateOrGetControl('checkbox', 'onlymybox', 5, 162, 100, 20)
	summonBox:SetText("{ol}Show mine only");
	summonBox:SetEventScript(ui.LBUTTONUP,"FPSSAVIOR_SAVECONFIGFRAME4");
	--summonBox:SetEventScriptArgString(ui.LBUTTONUP, "onlymy");
	summonBoxchild = GET_CHILD(configframe, "onlymybox");
	summonBoxchild:SetCheck(g.settings.onlymy);	
end

function FPSSAVIOR_SAVECONFIGFRAME1()
	local configframe = ui.GetFrame('fpssaviorconfig');
	local playerBoxchild = GET_CHILD(configframe, "allplayersbox");
	if playerBoxchild:IsChecked() == 1 then
			g.settings.allplayers = 1;
			g.settings.onlypt = 0;
			g.settings.noguild = 0;
			playerBoxchild = GET_CHILD(configframe, "onlyptbox");
			playerBoxchild:SetCheck(g.settings.onlypt);
			playerBoxchild = GET_CHILD(configframe, "noguildbox");
			playerBoxchild:SetCheck(g.settings.noguild);
	else
			g.settings.allplayers = 0;
	end
	acutil.saveJSON("../addons/fpssavior/settings.json", g.settings);
	--FPSSAVIOR_CONFIGFRAME()
end
function FPSSAVIOR_SAVECONFIGFRAME2()
	local configframe = ui.GetFrame('fpssaviorconfig');
	local playerBoxchild = GET_CHILD(configframe, "onlyptbox");
	if playerBoxchild:IsChecked() == 1 then
			g.settings.allplayers = 0;
			g.settings.onlypt = 1;
			g.settings.noguild = 0;
			playerBoxchild = GET_CHILD(configframe, "allplayersbox");
			playerBoxchild:SetCheck(g.settings.allplayers);
			playerBoxchild = GET_CHILD(configframe, "noguildbox");
			playerBoxchild:SetCheck(g.settings.noguild);
	else
			g.settings.onlypt = 0;
	end
	acutil.saveJSON("../addons/fpssavior/settings.json", g.settings);
	--FPSSAVIOR_CONFIGFRAME()
end
function FPSSAVIOR_SAVECONFIGFRAME5()
	local configframe = ui.GetFrame('fpssaviorconfig');
	local playerBoxchild = GET_CHILD(configframe, "noguildbox");
	if playerBoxchild:IsChecked() == 1 then
			g.settings.allplayers = 0;
			g.settings.onlypt = 0;
			g.settings.noguild = 1;
			playerBoxchild = GET_CHILD(configframe, "allplayersbox");
			playerBoxchild:SetCheck(g.settings.allplayers);
			playerBoxchild = GET_CHILD(configframe, "onlyptbox");
			playerBoxchild:SetCheck(g.settings.onlypt);
	else
			g.settings.noguild = 0;
	end
	acutil.saveJSON("../addons/fpssavior/settings.json", g.settings);
	--FPSSAVIOR_CONFIGFRAME()
end

function FPSSAVIOR_SAVECONFIGFRAME6()
	local configframe = ui.GetFrame('fpssaviorconfig');
	local playerBoxchild = GET_CHILD(configframe, "shopsbox");
	if playerBoxchild:IsChecked() == 1 then
		g.settings.shops = 1;
	else
		g.settings.shops = 0;
	end
	acutil.saveJSON("../addons/fpssavior/settings.json", g.settings);
	--FPSSAVIOR_CONFIGFRAME()
end

function FPSSAVIOR_SAVECONFIGFRAME3()
	local configframe = ui.GetFrame('fpssaviorconfig');
	local summonBoxchild = GET_CHILD(configframe, "allsumbox");
	if summonBoxchild:IsChecked() == 1 then
			g.settings.allsum = 1;
			g.settings.onlymy = 0;
			summonBoxchild = GET_CHILD(configframe, "onlymybox");
			summonBoxchild:SetCheck(g.settings.onlymy);
	else
			g.settings.allsum = 0;
	end
	acutil.saveJSON("../addons/fpssavior/settings.json", g.settings);
	--FPSSAVIOR_CONFIGFRAME()
end
function FPSSAVIOR_SAVECONFIGFRAME4()
	local configframe = ui.GetFrame('fpssaviorconfig');
	local summonBoxchild = GET_CHILD(configframe, "onlymybox");
	if summonBoxchild:IsChecked() == 1 then
			g.settings.allsum = 0;
			g.settings.onlymy = 1;
			summonBoxchild = GET_CHILD(configframe, "allsumbox");
			summonBoxchild:SetCheck(g.settings.allsum);
	else
			g.settings.onlymy = 0;
	end
	acutil.saveJSON("../addons/fpssavior/settings.json", g.settings);
	--FPSSAVIOR_CONFIGFRAME()
end

function FPSSAVIOR_EX_CMD(command)
	local cmd = "";
	if #command > 1 then
		cmd = table.remove(command, 1);
		team_name = table.remove(command, 1);
	else
		if #command > 0 then
			cmd = table.remove(command, 1);
		else
			CHAT_SYSTEM("FPS Savior Exception Help:{nl}'/fs_ex list' to print all team names inside the exception list.{nl}'/fs_ex add team_name' to put player with that team name inside the exception list.{nl}'/fs_ex remove team_name' to remove player with that team name from the exception list.");
			return;
		end
	end
	if cmd == "add" then
		if g.settings.exception == nil then
			g.settings.exception = {}
		end
		g.settings.exception[team_name] = true;
		CHAT_SYSTEM(team_name .. " is added to exception list.");
		FPSSAVIOR_SAVESETTINGS();
		return;
	end
	if cmd == "remove" then
		if g.settings.exception == nil then
			g.settings.exception = {}
		end
		g.settings.exception[team_name] = false;
		CHAT_SYSTEM(team_name .. " is removed from exception list.");
		FPSSAVIOR_SAVESETTINGS();
		return;
	end
	if cmd == "list" then
		CHAT_SYSTEM("The following player are inside the exception list:");
		list = g.settings.exception;
		for key,value in pairs(list) do
			if list[key] then
				CHAT_SYSTEM(key);
			end
		end
		return;
	end
	CHAT_SYSTEM("Invalid command. Available commands:{nl}/fs_ex{nl}/fs_ex add team_name{nl}/fs_ex remove team_name{nl}/fs_ex list");
	return;	
end

function FPSSAVIOR_DEL_CMD(command)
	local cmd = "";
	if #command > 1 then
		cmd = table.remove(command, 1);
		team_name = table.remove(command, 1);
	else
		if #command > 0 then
			cmd = table.remove(command, 1);
		else
			CHAT_SYSTEM("FPS Savior Delete Help:{nl}'/fs_del list' to print all team names inside the delete list.{nl}'/fs_del add team_name' to put player with that team name inside the delete list.{nl}'/fs_del remove team_name' to remove player with that team name from the delete list.");
			return;
		end
	end
	if cmd == "add" then
		if g.settings.deletion == nil then
			g.settings.deletion = {}
		end
		g.settings.deletion[team_name] = true;
		CHAT_SYSTEM(team_name .. " is added to delete list.");
		FPSSAVIOR_SAVESETTINGS();
		return;
	end
	if cmd == "remove" then
		if g.settings.deletion == nil then
			g.settings.deletion = {}
		end
		g.settings.deletion[team_name] = false;
		CHAT_SYSTEM(team_name .. " is removed from delete list.");
		FPSSAVIOR_SAVESETTINGS();
		return;
	end
	if cmd == "list" then
		CHAT_SYSTEM("The following player are inside the delete list:");
		list = g.settings.deletion;
		for key,value in pairs(list) do
			if list[key] then
				CHAT_SYSTEM(key);
			end
		end
		return;
	end
	CHAT_SYSTEM("Invalid command. Available commands:{nl}/fs_del{nl}/fs_del add team_name{nl}/fs_del remove team_name{nl}/fs_del list");
	return;	
end

function FPSSAVIOR_MAXPL_CMD(command)
	local cmd = "";
	if #command > 0 then
		cmd = table.remove(command, 1);
		g.settings.drawplayer = tonumber(cmd);
		FPSSAVIOR_SAVESETTINGS();
		return;
	end
	CHAT_SYSTEM("Invalid command. Available commands:{nl}/fs_draw_pl integer");
	return;
end

function FPSSAVIOR_MAXMON_CMD(command)
	local cmd = "";
	if #command > 0 then
		cmd = table.remove(command, 1);
		g.settings.drawmonster = tonumber(cmd);
		FPSSAVIOR_SAVESETTINGS();
		return;
	end
	CHAT_SYSTEM("Invalid command. Available commands:{nl}/fs_draw_mon integer");
	return;
end


function FPSSAVIOR_CMD(command)
	local cmd = "";
	if #command > 0 then
		cmd = table.remove(command, 1);
	else
		FPSSAVIOR_TOGGLE();
		return;
	end
	if cmd == "help" then
		CHAT_SYSTEM("FPS Savior Help:{nl}'/fpssavior' to toggle between 3 predefined settings High, Low, and Ultra Low.{nl}'/fpssavior lock' to unlock/lock the settings display in order to move it around.{nl}'/fpssavior default' to restore the settings display to its default location.{nl}'/fs_ex' and '/fs_del' for help about exception list and deletion list, respectively.{nl}'/fs_draw_pl' and '/fs_draw_mon' to set the maximum player and monster shown on the map, respectively.");
		return;
	end
	if cmd == "lock" then
		if g.settings.lock == 1 then
			g.settings.lock = 0;
			saviorFrame:EnableHitTest(1);
			saviorText:EnableHitTest(0);
			saviorFrame:EnableMove(1);
			saviorFrame.EnableHittestFrame(saviorFrame, 1);
			CHAT_SYSTEM("Settings display unlocked.");
			FPSSAVIOR_SAVESETTINGS();
		else
			g.settings.lock = 1;
			saviorFrame:EnableHitTest(1);
			saviorFrame:EnableMove(0);
			saviorFrame.EnableHittestFrame(saviorFrame, 1);
			CHAT_SYSTEM("Settings display locked.");
			FPSSAVIOR_SAVESETTINGS();
		end
		return;
	end
	if cmd == "default" then
		g.settings.displayX = 510;
		g.settings.displayY = 920;
		g.settings.lock = 1;
		saviorFrame:SetOffset(g.settings.displayX, g.settings.displayY);
		saviorFrame:EnableHitTest(1);
		saviorFrame:EnableMove(0);
		saviorFrame.EnableHittestFrame(saviorFrame, 1);
		FPSSAVIOR_SAVESETTINGS();
		return;
	end
	CHAT_SYSTEM("Invalid command. Available commands:{nl}/fpssavior{nl}/fpssavior lock{nl}/fpssavior default");
	return;
end

function FPSSAVIOR_SETTEXT()
	if saviorFrame ~= nil then
		saviorText:SetText("{s18}".. g.saviormode[g.settings.saviorToggle]);
	end
end


function FPSSAVIOR_HIGH()
	g.settings.saviorToggle = 1;

	graphic.SetDrawActor(100);
	graphic.SetDrawMonster(100);
	graphic.EnableBloom(1);
	graphic.EnableCharEdge(1);
	graphic.EnableFXAA(1);
	graphic.EnableGlow(1);
	graphic.EnableHighTexture(1);
	graphic.EnableSoftParticle(1);
	graphic.EnableWater(1);  
	imcperfOnOff.EnableIMCEffect(1);
	imcperfOnOff.EnableEffect(1);

	config.SetRenderShadow(1)
	imcperfOnOff.EnableRenderShadow(1); 
	
	imcperfOnOff.EnablePlaneLight(1);
	imcperfOnOff.EnableWater(1);
	
	imcperfOnOff.EnableDeadParts(1);
	config.EnableOtherPCEffect(1);
	--config.EnableOtherPCDamageEffect(1);
	graphic.EnableHitGlow(1);
	
	-- This turn on the "Show Boss Skill Magic Circle" options.
	config.SetEnableShowBossSkillRange(1);
	
	config.SetIsEnableSummonAlpha(1)
	
	ACTIVATE_HIDDEN();
	
	--lowmodeconfig
	--graphic.EnableLowOption(0);
	--config.SetAutoAdjustLowLevel(2);
	config.SaveConfig();
	
	FPSSAVIOR_SETTEXT();
	FPSSAVIOR_SAVESETTINGS();
end

function FPSSAVIOR_MEDIUM()
	g.settings.saviorToggle = 2;
		
	graphic.SetDrawActor(g.settings.drawplayer);
	graphic.SetDrawMonster(g.settings.drawmonster);
	graphic.EnableBloom(0);
	graphic.EnableCharEdge(1);
	graphic.EnableFXAA(1);
	graphic.EnableGlow(1);
	graphic.EnableHighTexture(1);
	graphic.EnableSoftParticle(0);
	graphic.EnableWater(1);
	imcperfOnOff.EnableIMCEffect(1);
	imcperfOnOff.EnableEffect(1);

	config.SetRenderShadow(0)
	imcperfOnOff.EnableRenderShadow(0);
	
	imcperfOnOff.EnablePlaneLight(1);
	imcperfOnOff.EnableWater(1);
	
	imcperfOnOff.EnableDeadParts(0);
	config.EnableOtherPCEffect(1);
	--.EnableOtherPCDamageEffect(0);
	graphic.EnableHitGlow(0);
	--config.SetEnableShowBossSkillRange(1);
	config.SetIsEnableSummonAlpha(1)
	
	ACTIVATE_HIDDEN();
		
	--lowmodeconfig
	--graphic.EnableLowOption(0);
	--config.SetAutoAdjustLowLevel(2);
	config.SaveConfig();
		
	FPSSAVIOR_SETTEXT();
	FPSSAVIOR_SAVESETTINGS()
end

function FPSSAVIOR_LOW()
	g.settings.saviorToggle = 3;
		
	graphic.SetDrawActor(g.settings.drawplayer);
	graphic.SetDrawMonster(g.settings.drawmonster);
	graphic.EnableBloom(0);
	graphic.EnableCharEdge(0);
	graphic.EnableFXAA(0);
	
	-- Someone call this a fog. The effect can be tested on Fedimian.
	graphic.EnableGlow(0);
	
	graphic.EnableHighTexture(0);
	graphic.EnableSoftParticle(0);
	graphic.EnableWater(0);
	
	-- This can disable the fallen leaves effect on Orsha.
	imcperfOnOff.EnableIMCEffect(1);
	imcperfOnOff.EnableEffect(1);
	
	config.SetRenderShadow(0)
	imcperfOnOff.EnableRenderShadow(0);
	
	imcperfOnOff.EnablePlaneLight(0);
	imcperfOnOff.EnableWater(0);

	imcperfOnOff.EnableDeadParts(0);
	config.EnableOtherPCEffect(1);
	config.EnableOtherPCDamageEffect(0);
	graphic.EnableHitGlow(0);
	--config.SetEnableShowBossSkillRange(0);
	config.SetIsEnableSummonAlpha(0)
	
	ACTIVATE_HIDDEN();
	
	--lowmodeconfig
	--graphic.EnableLowOption(1);
	--config.SetAutoAdjustLowLevel(0);
	config.SaveConfig();
	
	FPSSAVIOR_SETTEXT();
	FPSSAVIOR_SAVESETTINGS()
end

function FPSSAVIOR_ULOW()
	g.settings.saviorToggle = 4;
		
	graphic.SetDrawActor(g.settings.drawplayer);
	graphic.SetDrawMonster(g.settings.drawplayer);
	graphic.EnableBloom(0);
	graphic.EnableCharEdge(0);
	graphic.EnableFXAA(0);
	graphic.EnableGlow(0);
	graphic.EnableHighTexture(0);
	graphic.EnableSoftParticle(0);
	graphic.EnableWater(0);
	
	-- These two contibutes to tornado in WBR
	imcperfOnOff.EnableIMCEffect(0);
	config.EnableOtherPCEffect(0);
	
	-- Skill effect animation. Firewall, barier, etc.
	imcperfOnOff.EnableEffect(0);

	config.SetRenderShadow(0)
	
	imcperfOnOff.EnableRenderShadow(0); 
	imcperfOnOff.EnablePlaneLight(0);
	imcperfOnOff.EnableWater(0);
	
	imcperfOnOff.EnableDeadParts(0);
	config.EnableOtherPCDamageEffect(0);
	graphic.EnableHitGlow(0);
	--config.SetEnableShowBossSkillRange(0);
	config.SetIsEnableSummonAlpha(0)
	
	ACTIVATE_HIDDEN();
	
	--lowmodeconfig
	--graphic.EnableLowOption(1);
	--config.SetAutoAdjustLowLevel(0);
	config.SaveConfig();
	
	FPSSAVIOR_SETTEXT();
	FPSSAVIOR_SAVESETTINGS()
end

function FPSSAVIOR_EX()
	g.settings.saviorToggle = 5;
		
	graphic.SetDrawActor(g.settings.drawplayer);
	graphic.SetDrawMonster(g.settings.drawplayer);
	graphic.EnableBloom(0);
	graphic.EnableCharEdge(0);
	graphic.EnableFXAA(0);
	graphic.EnableGlow(0);
	graphic.EnableHighTexture(0);
	graphic.EnableSoftParticle(0);
	graphic.EnableWater(0);
	
	imcperfOnOff.EnableIMCEffect(0);
	imcperfOnOff.EnableEffect(0);
	
	config.SetRenderShadow(0)
	imcperfOnOff.EnableRenderShadow(0); 
	
	imcperfOnOff.EnablePlaneLight(0);
	imcperfOnOff.EnableWater(0);
	
	imcperfOnOff.EnableDeadParts(0);
	config.EnableOtherPCEffect(0);
	config.EnableOtherPCDamageEffect(0);
	graphic.EnableHitGlow(0);
	--config.SetEnableShowBossSkillRange(0);
	config.SetIsEnableSummonAlpha(0)
	
	imcperfOnOff.EnableFog(0);
	imcperfOnOff.EnableGrass(0);
	imcperfOnOff.EnableLight(0);
	imcperfOnOff.EnableParticleEffectModel(0);
	imcperfOnOff.EnableParticleInstancing(0);
	imcperfOnOff.EnableParticleInstancing2(0);
	imcperfOnOff.EnableParticleModel(0);
	imcperfOnOff.EnableParticlePoint(0);
	imcperfOnOff.EnableParticleScreen(0);
	imcperfOnOff.EnableParticleVertex(0);
	imcperfOnOff.EnableSky(0);
	imcperfOnOff.EnableMud(0);
	imcperfOnOff.EnableMudBlending1(0);
	imcperfOnOff.EnableMudBlending2(0);
	imcperfOnOff.EnableMudBlending3(0);
	imcperfOnOff.EnableMudBlending4(0);
	imcperfOnOff.EnableMudBlending5(0);
	imcperfOnOff.EnableMudBlending6(0);
	imcperfOnOff.EnableMudBlending7(0);
	imcperfOnOff.EnableBloomObject(0);
	imcperfOnOff.EnableDepth(0);
	imcperfOnOff.EnableDynamicTree(0);
	imcperfOnOff.EnableFork(0);
	
	--lowmodeconfig
	--graphic.EnableLowOption(1);
	--config.SetAutoAdjustLowLevel(0);
	config.SaveConfig();
	
	FPSSAVIOR_SETTEXT();
	FPSSAVIOR_SAVESETTINGS()
end

function ACTIVATE_HIDDEN()
	imcperfOnOff.EnableFog(1);
	imcperfOnOff.EnableGrass(1);
	imcperfOnOff.EnableLight(1);
	imcperfOnOff.EnableParticleEffectModel(1);
	imcperfOnOff.EnableParticleInstancing(1);
	imcperfOnOff.EnableParticleInstancing2(1);
	imcperfOnOff.EnableParticleModel(1);
	imcperfOnOff.EnableParticlePoint(1);
	imcperfOnOff.EnableParticleScreen(1);
	imcperfOnOff.EnableParticleVertex(1);
	imcperfOnOff.EnableSky(1);
	imcperfOnOff.EnableMud(1);
	imcperfOnOff.EnableMudBlending1(1);
	imcperfOnOff.EnableMudBlending2(1);
	imcperfOnOff.EnableMudBlending3(1);
	imcperfOnOff.EnableMudBlending4(1);
	imcperfOnOff.EnableMudBlending5(1);
	imcperfOnOff.EnableMudBlending6(1);
	imcperfOnOff.EnableMudBlending7(1);
	imcperfOnOff.EnableBloomObject(1);
	imcperfOnOff.EnableDepth(1);
	imcperfOnOff.EnableDynamicTree(1);
	imcperfOnOff.EnableFork(1);
end

function FPSSAVIOR_TOGGLE()
	if g.settings.saviorToggle == 1 then
		FPSSAVIOR_MEDIUM();
	elseif g.settings.saviorToggle == 2 then
		FPSSAVIOR_LOW();
	elseif g.settings.saviorToggle == 3 then
		FPSSAVIOR_ULOW();
	elseif g.settings.saviorToggle == 4 then
		FPSSAVIOR_EX();
	else
		FPSSAVIOR_HIGH();
	end
end

function FPSSAVIOR_SHOWORHIDE_OBJ()
	-- Check if any setting is on.
	if (g.settings.allplayers + g.settings.onlypt + g.settings.noguild + g.settings.allsum + g.settings.onlymy + g.settings.shops) > 0 then
		local list, cnt = SelectObject(GetMyPCObject(), 650, "ALL");
		local musuh = {};
		local elist, ecnt = SelectObject(GetMyPCObject(), 650, "ENEMY");
		for i = 1, ecnt do
			musuh[GetHandle(elist[i])] = true
		end			
		local b_list = g.settings.exception	
		for i = 1, cnt do
			local ObHandle = GetHandle(list[i]);
			local OwHandle = info.GetOwner(ObHandle);
			
			-- Check if object is character and inside the exception list.
			if info.IsPC(ObHandle) == 1 and b_list[info.GetFamilyName(ObHandle)] == true then

			-- Check if object is character and inside the delete list.
			elseif info.IsPC(ObHandle) == 1 and g.settings.deletion[info.GetFamilyName(ObHandle)] == true then
				world.Leave(ObHandle, 0.0 );
				
			-- Check if the object is character and any of the settings is on.
			elseif (g.settings.allplayers + g.settings.onlypt + g.settings.noguild + g.settings.shops) > 0 and info.IsPC(ObHandle) == 1 then
					
				-- Check if the object is an enemy.
				if musuh[ObHandle] then
					local placeholder = true;
					
				-- Check if the object is a shops.
				elseif (info.GetTargetInfo(ObHandle).IsDummyPC == 1) then
				
					-- Check if the hide shop setting is on.
					if (g.settings.shops == 1) then
						world.Leave(ObHandle, 0.0 );
					end
								
				-- Check if all character should be deleted setting is on.
				elseif g.settings.allplayers == 1 then
					world.Leave(ObHandle, 0.0 );
							
				-- Check if only party member shown setting is on and the object is not in the party.
				elseif g.settings.noguild == 1 and session.party.GetPartyMemberInfoByName(PARTY_NORMAL, info.GetFamilyName(ObHandle)) == nil then
					world.Leave(ObHandle, 0.0 );
						
				-- Check if the object is not in the party and not in the guild.
				elseif session.party.GetPartyMemberInfoByName(PARTY_NORMAL, info.GetFamilyName(ObHandle)) == nil and session.party.GetPartyMemberInfoByName(PARTY_GUILD, info.GetFamilyName(ObHandle)) == nil then
					world.Leave(ObHandle, 0.0 );					
				end

			-- Check if any of the summon setting is on and the object has owner, which indicate that it's a summon.
			elseif (g.settings.allsum + g.settings.onlymy) > 0 and OwHandle ~= 0 then
			
				-- Check if delete all summon setting is on.
				if g.settings.allsum == 1 then
					world.Leave(ObHandle, 0.0 );
				
				-- Check if the summon owner is not the player.
				elseif OwHandle ~= session.GetMyHandle() then
					world.Leave(ObHandle, 0.0 );
				end
				
			end
        end
	
	-- Player inside the delete list will always get deleted even if none of the setting is on.
	elseif g.settings.deletion ~= {} then
		if g.settings.deletion == nil then
			g.settings.deletion = {}
		end
		local list, cnt = SelectObject(GetMyPCObject(), 650, "ALL");
		for i = 1, cnt do
			local ObHandle = GetHandle(list[i]);
			local OwHandle = info.GetOwner(ObHandle);
			if info.IsPC(ObHandle) == 1 and g.settings.deletion[info.GetFamilyName(ObHandle)] == true then
				world.Leave(ObHandle, 0.0 );
			end
		end
	end	
end