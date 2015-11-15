function invis( event )
    local caster = event.caster
    MakeMod(caster,caster,"modifier_riki_permanent_invisibility",{duration=4})
end