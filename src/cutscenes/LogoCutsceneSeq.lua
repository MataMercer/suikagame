--elem return true if its a waiting.
LogoCutsceneSeq = {
    function()
        backgroundCentered = true
        backgroundScale = 4
        background = sprites.logo
    end,
    function()
        Cutscene:wait(1, true)
        return true
    end,
    function()
        backgroundCentered = false
        backgroundScale = nil
        background = sprites.background
        initMainMenu()
    end
}
