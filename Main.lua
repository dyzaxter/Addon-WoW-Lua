local frame = CreateFrame("Frame")

-- Tabla con habilidades y sus sonidos posibles
local habilidades = {
    ["Tu Abrumar "] = {
        "Interface\\Addons\\WarS\\Sounds\\2h_Sword_CritHit_Shield_Wood_01.ogg",
        "Interface\\Addons\\WarS\\Sounds\\2h_Sword_CritHit_Shield_Wood_02.ogg",
        "Interface\\Addons\\WarS\\Sounds\\Sword2H_HitWood_44_02.ogg",
        "Interface\\Addons\\WarS\\Sounds\\Sword2H_HitWood_44_01.ogg",
		"Interface\\Addons\\WarS\\Sounds\\2h_Sword_CritHit_Shield_Wood_03.ogg",
		"Interface\\Addons\\WarS\\Sounds\\2h_Sword_CritHit_Shield_Wood_04.ogg",
    },
    ["Tu Ejecutar "] = {
        "Interface\\Addons\\WarS\\Sounds\\FireShield.ogg",
        "Interface\\Addons\\WarS\\Sounds\\TOD.ogg",
        "Interface\\Addons\\WarS\\Sounds\\Spell_DK_Bloodstrike_Cast01.ogg",
        "Interface\\Addons\\WarS\\Sounds\\Spell_DK_Bloodstrike_Cast02.ogg",
        "Interface\\Addons\\WarS\\Sounds\\Spell_DK_Bloodstrike_Cast03.ogg",    
        "Interface\\Addons\\WarS\\Sounds\\Spell_WR_Execute_Revamp_Cast_01.ogg",
        "Interface\\Addons\\WarS\\Sounds\\Spell_WR_Execute_Revamp_Cast_02.ogg",
        "Interface\\Addons\\WarS\\Sounds\\Spell_WR_Execute_Revamp_Cast_03.ogg",        
    },
    ["Tu Golpe Mortal"] = {
        "Interface\\Addons\\WarS\\Sounds\\SPELL_WR_MORTAL_STRIKE_44_02.ogg",
        "Interface\\Addons\\WarS\\Sounds\\SPELL_WR_MORTAL_STRIKE_44_01.ogg",
        "Interface\\Addons\\WarS\\Sounds\\SPELL_WR_MORTAL_STRIKE_44_03.ogg",
        "Interface\\Addons\\WarS\\Sounds\\SPELL_WR_MORTAL_STRIKE_44_05.ogg",
        "Interface\\Addons\\WarS\\Sounds\\SPELL_WR_MORTAL_STRIKE_44_04.ogg",        
    },
    ["Tu Corte de Tend"] = {
        "Interface\\Addons\\WarS\\Sounds\\SPELL_MK_SLICESWING_01.ogg",
    },    
    ["Tu Golpe de Pu"] = {
        "Interface\\Addons\\WarS\\Sounds\\Spell_WR_Shield_Bash_Revamp_Cast_01.ogg",
		"Interface\\Addons\\WarS\\Sounds\\SPELL_WR_ColossusSmash_Impact_01.ogg",
		"Interface\\Addons\\WarS\\Sounds\\SPELL_WR_ColossusSmash_Impact_03.ogg",
		"Interface\\Addons\\WarS\\Sounds\\SPELL_WR_ColossusSmash_Impact_04.ogg",
		"Interface\\Addons\\WarS\\Sounds\\SPELL_WR_ColossusSmash_Impact_05.ogg",
    },    
    ["Tu Golpe Heroico"] = {
        "Interface\\Addons\\WarS\\Sounds\\Spell_WR_Ravager_Cast_01.ogg",
        "Interface\\Addons\\WarS\\Sounds\\Spell_WR_Ravager_Cast_02.ogg",
        "Interface\\Addons\\WarS\\Sounds\\Spell_WR_Ravager_Cast_03.ogg",
        "Interface\\Addons\\WarS\\Sounds\\Spell_WR_Ravager_Cast_04.ogg",
    },
    ["Tu Golpe golpea"] = {
        "Interface\\Addons\\WarS\\Sounds\\Spell_WR_Slam_Revamp_Impact_01.ogg",
        "Interface\\Addons\\WarS\\Sounds\\Spell_WR_Slam_Revamp_Impact_02.ogg",
        "Interface\\Addons\\WarS\\Sounds\\Spell_WR_Slam_Revamp_Impact_03.ogg",
        "Interface\\Addons\\WarS\\Sounds\\Spell_WR_Slam_Revamp_Impact_04.ogg",
    },
    ["Tu Represalia golpea"] = {
        "Interface\\Addons\\WarS\\Sounds\\Spell_WR_Slam_Revamp_Impact_01.ogg",
        "Interface\\Addons\\WarS\\Sounds\\Spell_WR_Slam_Revamp_Impact_02.ogg",
        "Interface\\Addons\\WarS\\Sounds\\Spell_WR_Slam_Revamp_Impact_03.ogg",
        "Interface\\Addons\\WarS\\Sounds\\Spell_WR_Slam_Revamp_Impact_04.ogg",
    },    
}

-- Func manual para contar elementos de una tabla
local function contar(tabla)
    local n = 0
    for _, _ in pairs(tabla) do
        n = n + 1
    end
    return n
end

-- Palabras que indican un golpe exitoso o crtico (sonido DEBE reproducirse)
local palabrasExito = {
    "golpea", "crítico", "impacta", "daño", "por %d+", "sufre"
}

-- Palabras que indican un fallo (sonido NO debe reproducirse)
local palabrasFallo = {
    "falla", "esquiva", "resistido", "bloqueado", "parado", "inmune", "fallo", "error"
}

-- Verificar si el mensaje es un ataque exitoso
local function esAtaqueExitoso(mensaje)
    -- Primero verificamos si es un fallo
    for _, palabra in ipairs(palabrasFallo) do
        if string.find(mensaje, palabra) then
            return false
        end
    end
    
    -- Luego verificamos si es un exito
    for _, palabra in ipairs(palabrasExito) do
        if string.find(mensaje, palabra) then
            return true
        end
    end
    
    return false
end

-- Reproducir sonido aleatorio
local function ReproducirSonido(skill)
    local sonidos = habilidades[skill]
    local total = contar(sonidos)
    if sonidos and total > 0 then
        local index = math.random(1, total)
        PlaySoundFile(sonidos[index], "SFX")
    end
end

-- Captura de evento
local function OnEvent()
    local msg = arg1
    
    -- Solo proceder si es un ataque exitoso
    if esAtaqueExitoso(msg) then
        for skill, _ in pairs(habilidades) do
            if string.find(msg, skill, 1, true) then
                ReproducirSonido(skill)
                break
            end
        end
    end
end

frame:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE")
frame:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE")
frame:RegisterEvent("CHAT_MSG_SPELL_AURA_APPLIED")
frame:SetScript("OnEvent", OnEvent)