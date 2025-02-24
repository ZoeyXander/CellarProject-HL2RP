-- Only for use with GMod's language library, hence it is only clientside
-- When translating, only change the strings on the right!

ArcCW.PhraseTable = {
    ["en"] = {
        -- Generic
        ["arccw.adminonly"]                      = "These options require admin privileges to change. They can only be changed using this menu in Listen (P2P) servers, but you can use this as reference.",
        ["arccw.clientcfg"]                      = "All options in this menu can be customized by players, and do not need admin privileges.",
        -- Menus
        ["arccw.menus.hud"]                      = "HUD",
        ["arccw.menus.client"]                   = "Client",
        ["arccw.menus.vmodel"]                   = "Viewmodel",
        ["arccw.menus.perf"]                     = "Perfomance",
        ["arccw.menus.server"]                   = "Server",
        ["arccw.menus.mults"]                    = "Multipliers",
        ["arccw.menus.npcs"]                     = "NPCs",
        ["arccw.menus.atts"]                     = "Attachments",
        ["arccw.menus.ammo"]                     = "Ammo",
        ["arccw.menus.xhair"]                    = "Crosshair",
        ["arccw.menus.bullet"]                   = "Bullet Physics",
        -- ArcCW_Options_Ammo
        ["arccw.cvar.ammo_detonationmode"]       = "Ammo Detonation Mode",
        ["arccw.cvar.ammo_detonationmode.desc"]  = "-1 - don't explode\n 0 - simple explosion\n 1 - fragmentation\n 2 - frag + burning",
        ["arccw.cvar.ammo_autopickup"]           = "Auto Pickup",
        ["arccw.cvar.ammo_largetrigger"]         = "Large Pickup Trigger",
        ["arccw.cvar.ammo_rareskin"]             = "Rare Skin Chance",
        ["arccw.cvar.ammo_chaindet"]             = "Chain Detonation",
        ["arccw.cvar.mult_ammohealth"]           = "Ammo Health (-1 for indestructible)",
        ["arccw.cvar.mult_ammoamount"]           = "Ammo Amount",
        -- ArcCW_Options_HUD
        ["arccw.cvar.hud_showhealth"]            = "Show Health",
        ["arccw.cvar.hud_showammo"]              = "Show Ammo",
        ["arccw.cvar.hud_3dfun"]                 = "Alternative 3D2D Ammo HUD",
        ["arccw.cvar.hud_forceshow"]             = "Force HUD On (Useful w/ Custom HUDs)",
        ["arccw.cvar.hudpos_deadzone_x"]         = "Deadzone X",
        ["arccw.cvar.hudpos_deadzone_y"]         = "Deadzone Y",
        -- ArcCW_Options_Bullet
        ["arccw.cvar.bullet_enable"]             = "Physical Bullets",
        ["arccw.cvar.bullet_gravity"]            = "Gravity",
        ["arccw.cvar.bullet_drag"]               = "Drag",
        ["arccw.cvar.bullet_lifetime"]           = "Despawn Time",
        ["arccw.cvar.bullet_velocity"]           = "Multiply Velocity",
        ["arccw.cvar.bullet_imaginary"]          = "Imaginary Bullets",
        ["arccw.cvar.bullet_imaginary.desc"]     = "Bullets will appear to continue to travel through the 3D skybox.",
        -- ArcCW_Options_Client
        ["arccw.cvar.toggleads"]                 = "Toggle Aim",
        ["arccw.cvar.altfcgkey"]                 = "E+R To Toggle Firemode (Disables +ZOOM)",
        ["arccw.cvar.altubglkey"]                = "E+RMB To Toggle UBGL (Disables 2x +ZOOM)",
        ["arccw.cvar.altsafety"]                 = "Hold Walk to Toggle Safety",
        ["arccw.cvar.altlaserkey"]               = "E+WALK To Toggle Laser (Default WALK+E)",
        ["arccw.cvar.autosave"]                  = "Autosave Attachments",
        ["arccw.cvar.autosave.desc"]             = "Attempt to re-equip the last equipped set of attachments on weapon pickup.",
        ["arccw.cvar.embracetradition"]          = "Classic Customization HUD",
        ["arccw.cvar.embracetradition.desc"]     = "Use the classic bulky customization HUD. Embrace tradition. Good on 4:3.",
        ["arccw.cvar.glare"]                     = "Scope Glare",
        ["arccw.cvar.glare.desc"]                = "Glare visible on your scope lens when aiming.",
        ["arccw.cvar.shake"]                     = "Screen Shake",
        ["arccw.cvar.shake_info"]                = "Aggressive snap when you shoot a weapon.",
        ["arccw.cvar.2d3d"]                      = "Floating Help Text",
        ["arccw.cvar.2d3d_info"]                 = "Text that floats over dropped weapons.",
        ["arccw.cvar.attinv_hideunowned"]        = "Hide Unowned Attachments",
        ["arccw.cvar.attinv_darkunowned"]        = "Grey Out Unowned Attachments",
        ["arccw.cvar.attinv_onlyinspect"]        = "Hide Customization UI",
        ["arccw.cvar.attinv_simpleproscons"]     = "Simple Pros And Cons",
        ["arccw.cvar.attinv_closeonhurt"]        = "Close menu on damage taken",
        -- ArcCW_Options_Perf
        ["arccw.performance"]                    = "The options below may change performance.",
        ["arccw.cvar.cheapscopes"]               = "Cheap Scopes",
        ["arccw.cvar.cheapscopes.desc"]          = "A cheaper PIP scope implementation that is very low quality but saves a significant amount of performance. Scoped weapons will appear to clip into surfaces.\nWill reduce scope quality!",
        ["arccw.cvar.flatscopes"]                = "Flat Scopes",
        ["arccw.cvar.flatscopes.desc"]           = "For the ultimate performance gain.\nUse a traditional-style scope implementation that's not very impressive, but actually saves performance relative to even not being scoped in.",
        ["arccw.cvar.muzzleeffects"]             = "Enable World Muzzle Effects",
        ["arccw.cvar.fastmuzzles"]               = "Low Performance Muzzle Effects",
        ["arccw.cvar.shelleffects"]              = "Enable World Case Effects",
        ["arccw.cvar.att_showothers"]            = "Show World Attachments",
        ["arccw.cvar.shelltime"]                 = "Case Lifetime",
        ["arccw.cvar.blur"]                      = "Customization Blur",
        ["arccw.cvar.blur_toytown"]              = "Aim Blur",
        ["arccw.cvar.visibility"]                = "Worldmodel Visibility",
        ["arccw.cvar.visibility.desc"]           = "Attachments will not render past this distance. -1 for always render.",
        -- ArcCW_Options_Viewmodel
        ["arccw.cvar.vm_coolsway"]               = "Custom Swaying",
        ["arccw.cvar.vm_coolview"]               = "Custom Camera Movement",
        ["arccw.cvar.vm_right"]                  = "Viewmodel Right",
        ["arccw.cvar.vm_forward"]                = "Viewmodel Forward",
        ["arccw.cvar.vm_up"]                     = "Viewmodel Up",
        ["arccw.cvar.vm_offsetwarn"]             = "Warning! Viewmodel offset settings may cause clipping or other undesired effects!",
        ["arccw.cvar.vm_sway_sprint"]            = "Sprint Bob", -- This is intentionally flipped
        ["arccw.cvar.vm_bob_sprint"]             = "Sprint Sway", -- Ditto
        ["arccw.cvar.vm_swaywarn"]               = "The following only applies when Custom Swaying is enabled",
        ["arccw.cvar.vm_lookymult"]              = "Horizontal Look Sway",
        ["arccw.cvar.vm_lookxmult"]              = "Vertical Look Sway",
        ["arccw.cvar.vm_swayxmult"]              = "Bob Right Multiplier",
        ["arccw.cvar.vm_swayymult"]              = "Bob Forward Multiplier",
        ["arccw.cvar.vm_swayzmult"]              = "Bob Up Multiplier",
        ["arccw.cvar.vm_accelmult"]              = "Sway Tightness",
        ["arccw.cvar.vm_viewwarn"]               = "The following only applies when Custom Camera Movement is enabled",
        ["arccw.cvar.vm_coolviewmult"]           = "View Move Multiplier",
        -- ArcCW_Options_Crosshair
        ["arccw.crosshair.tfa"]                  = "TFA",
        ["arccw.crosshair.cw2"]                  = "CW 2.0",
        ["arccw.crosshair.cs"]                   = "Counter-Strike",
        ["arccw.crosshair.light"]                = "Lightweight",
        ["arccw.cvar.crosshair"]                 = "Enable Crosshair",
        ["arccw.cvar.crosshair_length"]          = "Crosshair Length",
        ["arccw.cvar.crosshair_thickness"]       = "Crosshair Thickness",
        ["arccw.cvar.crosshair_gap"]             = "Crosshair Gap Scale",
        ["arccw.cvar.crosshair_dot"]             = "Show Center Dot",
        ["arccw.cvar.crosshair_shotgun"]         = "Use Shotgun Prongs",
        ["arccw.cvar.crosshair_equip"]           = "Use Equipment Prongs",
        ["arccw.cvar.crosshair_static"]          = "Static Crosshair",
        ["arccw.cvar.crosshair_clump"]           = "Use CW2-Style Clump Circle",
        ["arccw.cvar.crosshair_clump_outline"]   = "Clump Circle Outline",
        ["arccw.cvar.crosshair_clump_always"]    = "Clump Circle Always On",
        ["arccw.cvar.crosshair_clr"]             = "Crosshair Color",
        ["arccw.cvar.crosshair_outline"]         = "Outline Size",
        ["arccw.cvar.crosshair_outline_clr"]     = "Outline Color",
        ["arccw.cvar.scope_clr"]                 = "Sight Color",
        -- ArcCW_Options_Mults
        ["arccw.cvar.mult_damage"]               = "Damage",
        ["arccw.cvar.mult_npcdamage"]            = "NPC Damage",
        ["arccw.cvar.mult_range"]                = "Range",
        ["arccw.cvar.mult_recoil"]               = "Recoil",
        ["arccw.cvar.mult_penetration"]          = "Penetration",
        ["arccw.cvar.mult_hipfire"]              = "Hip Dispersion",
        ["arccw.cvar.mult_movedisp"]             = "Move Dispersion",
        ["arccw.cvar.mult_reloadtime"]           = "Reload Time",
        ["arccw.cvar.mult_sighttime"]            = "ADS Time",
        ["arccw.cvar.mult_defaultclip"]          = "Default Clip",
        ["arccw.cvar.mult_attchance"]            = "Random Att. Chance",
        ["arccw.cvar.mult_damage"]               = "Damage",
        ["arccw.cvar.mult_npcdamage"]            = "NPC Damage",
        ["arccw.cvar.mult_range"]                = "Range",
        ["arccw.cvar.mult_recoil"]               = "Recoil",
        ["arccw.cvar.mult_penetration"]          = "Penetration",
        ["arccw.cvar.mult_hipfire"]              = "Hip Dispersion",
        ["arccw.cvar.mult_movedisp"]             = "Move Dispersion",
        ["arccw.cvar.mult_reloadtime"]           = "Reload Time",
        ["arccw.cvar.mult_sighttime"]            = "ADS Time",
        ["arccw.cvar.mult_defaultclip"]          = "Default Clip",
        ["arccw.cvar.mult_attchance"]            = "Random Att. Chance",
        -- ArcCW_Options_Atts
        ["arccw.attdesc1"]                       = "ArcCW supports attachment inventory style behaviour (Like ACT3) as well as attachment locking style behaviour (Like CW2.0) as well as giving everyone all attachments for free (Like TFA Base).",
        ["arccw.attdesc2"]                       = "Leave all options off for ACT3 style attachment inventory behaviour.",
        ["arccw.cvar.attinv_free"]               = "Free Attachments",
        ["arccw.cvar.attinv_lockmode"]           = "Attachment Locking",
        ["arccw.cvar.attinv_loseondie.desc"]     = "Lose Attachments Modes:\n0 - Disable\n1 = Removed on death\n2 = Drop Attachment Box on death",
        ["arccw.cvar.attinv_loseondie"]          = "Lose Attachments Mode",
        ["arccw.cvar.atts_pickx.desc"]           = "Pick X behaviour allows you to set a limit on attachments that can be placed on any weapon.\n0 = unlimited.",
        ["arccw.cvar.atts_pickx"]                = "Pick X",
        ["arccw.cvar.enable_dropping"]           = "Attachment Dropping",
        ["arccw.cvar.atts_spawnrand"]            = "Random Attachments on Spawn",
        ["arccw.cvar.atts_ubglautoload"]         = "Underbarrel Weapons Automatically Loaded",
        ["arccw.blacklist"]                      = "Blacklist Menu",
        -- ArcCW_Options_Server
        ["arccw.cvar.enable_penetration"]        = "Enable Penetration",
        ["arccw.cvar.enable_customization"]      = "Enable Customization",
        ["arccw.cvar.truenames"]                 = "True Names (Requires Restart)",
        ["arccw.cvar.equipmentammo.desc"]        = "There is a limit of 127 ammo types, and enabling this option can cause problems related to this. Requires restart.",
        ["arccw.cvar.equipmentammo"]             = "Equipment Unique Ammo Types",
        ["arccw.cvar.equipmentsingleton.desc"]   = "Singletons can be used once and then remove themselves from your inventory. Requires restart.",
        ["arccw.cvar.equipmentsingleton"]        = "Grenade/Equipment Singleton",
        ["arccw.cvar.equipmenttime"]             = "Equipment Self-Destruct Time",
        ["arccw.cvar.throwinertia"]              = "Grenade Inherit Velocity",
        ["arccw.cvar.limityear_enable"]          = "Enable Year Limit",
        ["arccw.cvar.limityear"]                 = "Year Limit",
        ["arccw.cvar.override_crosshair_off"]    = "Force Disable Crosshair",
        ["arccw.cvar.override_deploychambered"]  = "Deploy with Rounds Chambered",
        ["arccw.cvar.override_barrellength"]     = "Enable Near-Walling",
        ["arccw.cvar.doorbust"]                  = "Enable Door-Busting",
        -- TTT Menus
        ["arccw.cvar.attinv_loseondie.help"]     = "If enabled, players lose attachment on death and round end.",
        ["arccw.cvar.ammo_detonationmode.help"]  = "Determines what happens if ammo boxes are destroyed.",
        ["arccw.cvar.equipmenttime.help"]        = "Applies to deployable equipment like Claymores, in seconds.",
        ["arccw.cvar.ttt_bodyattinfo"]           = "Body Attachment Info",
        ["arccw.cvar.ttt_bodyattinfo.help"]      = "If enabled, searching a body will reveal the attachments on the weapon used to kill someone.",
        ["arccw.cvar.ttt_bodyattinfo.desc"]      = "0 - Off; 1 - Detectives can see; 2 - Everyone can see",
        ["arccw.cvar.attinv_free.help"]          = "If enabled, players have access to all attachments.\nCustomization mode may still restrict them from using them.",
        ["arccw.cvar.attinv_lockmode.help"]      = "If enabled, picking up one attachment unlocks it for every weapon, a-la CW2.",
        ["arccw.cvar.ttt_weakensounds"]          = "Weaken Sounds",
        ["arccw.cvar.ttt_weakensounds.help"]     = "Reduces all firearm volume by 20dB, making shots easier to hide.",
        ["arccw.cvar.enable_customization.help"] = "If disabled, nobody can customize. This overrides Customization Mode.",
        ["arccw.cvar.ttt_replace"]               = "Auto-replace Weapons",
        ["arccw.cvar.ttt_replaceammo"]           = "Auto-replace Ammo",
        ["arccw.cvar.ttt_atts"]                  = "Randomize Attachments",
        ["arccw.cvar.ttt_customizemode"]         = "Customization Mode",
        ["arccw.cvar.ttt_customizemode.desc"]    = "0 - No restrictions; 1 - Restricted; 2 - Pregame only; 3 - Traitor/Detective only",
        ["arccw.cvar.ttt_rolecrosshair"]         = "Enable role-based crosshair color",
        ["arccw.cvar.ttt_inforoundstart"]        = "Enable round startup info",
    },
}

local lang = string.lower(GetConVar("gmod_language"):GetString())

if not ArcCW.PhraseTable[lang] then lang = "en" end

for key, value in pairs(ArcCW.PhraseTable[lang]) do
    if key ~= "" and (value and value ~= "") then language.Add(key, value) end
end