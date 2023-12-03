sprites = {}
sprites.playerSheet = love.graphics.newImage('sprites/playersheet.png')
sprites.background = love.graphics.newImage('sprites/background.png')
-- sprites.projectile = love.graphics.newImage('sprites/projectile.png')
sprites.effects = {}
-- sprites.effects.hit = love.graphics.newImage('sprites/hitEffect-Sheet.png')
-- sprites.effects.assaulter = love.graphics.newImage('sprites/assaulter-hiteffect-Sheet.png')

animations = {}

function initFonts()
    fonts = {}
    fonts.default = love.graphics.newFont(30)
end

initFonts()

sounds = {}
-- sounds.jump = love.audio.newSource("audio/jump.wav", "static")
-- sounds.hit = love.audio.newSource("audio/hit.wav", "static")
-- sounds.hit:setVolume(0.25)
-- sounds.music = love.audio.newSource("audio/music.mp3", "stream")
-- sounds.music:setLooping(true)
-- sounds.music:setVolume(0.5)
