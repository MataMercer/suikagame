sprites = {}

--Misc
sprites.playerSheet = love.graphics.newImage('sprites/playersheet.png')
sprites.background = love.graphics.newImage('sprites/background.png')
sprites.title = love.graphics.newImage('sprites/title.png')
sprites.logo = love.graphics.newImage('sprites/logo.png')
sprites.mergeParticle = love.graphics.newImage('sprites/mergeParticles.png')
sprites.comboEffect = love.graphics.newImage('sprites/combo-sheet.png')
--ui
sprites.bgButton = love.graphics.newImage('sprites/BgButton.png')

--Fruit Sprites
sprites.cherrySheet = love.graphics.newImage('sprites/cherry-Sheet.png')
sprites.grapeSheet = love.graphics.newImage('sprites/grape-Sheet.png')
sprites.dekoponSheet = love.graphics.newImage('sprites/dekopon-Sheet.png')
sprites.bananaSheet = love.graphics.newImage('sprites/banana-Sheet.png')
sprites.strawberrySheet = love.graphics.newImage('sprites/strawberry-Sheet.png')
sprites.appleSheet = love.graphics.newImage('sprites/apple-Sheet.png')
sprites.orangeSheet = love.graphics.newImage('sprites/orange-Sheet.png')
sprites.pearSheet = love.graphics.newImage('sprites/pear-Sheet.png')
sprites.peachSheet = love.graphics.newImage('sprites/peach-Sheet.png')
sprites.pineappleSheet = love.graphics.newImage('sprites/pineapple-Sheet.png')
sprites.melonSheet = love.graphics.newImage('sprites/melon-Sheet.png')
sprites.watermelonSheet = love.graphics.newImage('sprites/watermelon-Sheet.png')

for k, v in pairs(sprites) do
    v:setFilter("nearest", "nearest")
end

animations = {}

function initFonts()
    fonts = {}
    fonts.default = love.graphics.newFont(30)
end

initFonts()

sounds = {}
-- sounds.jump = love.audio.newSource("audio/jump.wav", "static")
-- sounds.merge = love.audio.newSource("audio/merge.wav", "static")
sounds.merge = love.sound.newSoundData("audio/merge.wav")
sounds.click = love.sound.newSoundData("audio/click.wav")
-- sounds.hit = love.audio.newSource("audio/hit.wav", "static")
-- sounds.hit:setVolume(0.25)
-- sounds.music = love.audio.newSource("audio/music.mp3", "stream")
-- sounds.music:setLooping(true)
-- sounds.music:setVolume(0.5)
