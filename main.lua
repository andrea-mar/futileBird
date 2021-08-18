push = require 'push'
Class = require 'class'

require 'StateMachine'

require 'states/BaseState'
require 'states/TitleScreenState'
require 'states/PlayState'
require 'states/ScoreState'

require 'Bird'
require 'Pipe'
require 'PipePair'
require 'Medals'


WINDOW_WITDH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

local background = love.graphics.newImage('background.png')
local background_scroll = 0
local ground = love.graphics.newImage('ground.png')
local ground_scroll = 0  

local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60

local BACKGROUND_LOOPING_PONIT = 413


-- let s us pause the game when the bird collides with a pipe
local scrolling = true

function love.load()
    math.randomseed(os.time())

    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('FutileFlappybird')

    -- initialize retro fonts
    smallFont = love.graphics.newFont('font.ttf', 8)
    mediumFont = love.graphics.newFont('font.ttf', 14)
    flappyFont = love.graphics.newFont('flappy.ttf', 28)
    hugeFont = love.graphics.newFont('font.ttf', 56)
    love.graphics.setFont(flappyFont)

    -- initialize sound effects
    sounds = {
        ['explosion'] = love.audio.newSource('explosion.wav', 'static'),
        ['hurt'] = love.audio.newSource('hurt.wav', 'static'),
        ['jump'] = love.audio.newSource('jump.wav', 'static'),
        ['score'] = love.audio.newSource('score.wav', 'static'),

        ['music'] = love.audio.newSource('marios_way.mp3', 'static')
    }
    -- set loop for background music
    sounds['music']:setLooping(true)
    sounds['music']:play()

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WITDH, WINDOW_HEIGHT, {
        vsync = true, 
        fullscreen = false,
        resizable = true
    })

    gStateMachine = StateMachine {
        ['title'] = function() return TitleScreenState() end,
        ['score'] = function() return ScoreState end,
        ['play'] = function() return PlayState() end
    }

    gStateMachine:change('title')

    love.keyboard.keysPressed = {}
end


function love.resize(w, h)
    push:resize(w, h)
end


function love.keypressed(key)
    -- add the key the user pressed to the keysPressed table
    love.keyboard.keysPressed[key] = true

    if key == 'escape' then
        love.event.quit()
    end
end


-- check to see if a key was pressed (this function can be accessed from any file in the project)
function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end


function love.update(dt)
    -- make the background move forver
    background_scroll = (background_scroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_PONIT
    ground_scroll = (ground_scroll + GROUND_SCROLL_SPEED * dt) % VIRTUAL_WIDTH

    -- update game play according to the current state
    gStateMachine:update(dt)

    -- reset the keys pressed table every frame
    love.keyboard.keysPressed = {}
    
end


function love.draw()
    push:start()
    

    -- draw backdround
    love.graphics.draw(background, -background_scroll, 0)  

    -- draw ground
    love.graphics.draw(ground, -ground_scroll, VIRTUAL_HEIGHT - 16)

    -- draw text, bird and pipes depending on the state
    gStateMachine:render()
    push:finish()
end