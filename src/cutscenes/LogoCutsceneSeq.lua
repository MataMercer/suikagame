--elem return true if its a waiting.
LogoCutsceneSeq = {
    function()
        background = sprites.logo
    end,
    function()
        Cutscene:wait(0.5, true)
        return true
    end,
    function()
        background = sprites.background
        initMainMenu()
    end
}
