PlayState = Class{__includes = BaseState}

-- height and witdh of the pipe image, globally accessible
PIPE_HEIGHT = 288
PIPE_WIDTH = 70
PIPE_SPEED = 60


function PlayState:init()
    -- bird sprite
    self.bird = Bird{}

    -- medals sprites
    self.medals = Medals{}

    -- keep track of spawn pipePairs
    self.pipePairs = {}
    
    -- pipe spawning interval
    self.timer = 0

    -- keep track of score
    self.score = 0 

    -- store the y values of the last spawn pipe (so gaps are not totally random but there is a smooth transition gap)
    self.lastY = -PIPE_HEIGHT + math.random(80) + 20
end

function PlayState:update(dt)

    -- pause the game if p key is pressed
    if love.keyboard.wasPressed('p') then
        gStateMachine:change('pause', {
            score = self.score,
            bird = self.bird,
            pipePairs = self.pipePairs,
            medals = self.medals
        })
    end
   
    -- update timer for pipe spawning 
    self.timer = self.timer + dt

    -- spawn a new pair of pipes every sec. and a half
    if self.timer > math.random(2,100) then
        local y = math.max(
            -PIPE_HEIGHT + 10, 
            math.min(self.lastY + math.random(-20, 20), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))

        self.lastY = y 

        table.insert(self.pipePairs, PipePair(y))
        self.timer = 0
    end

    for k, pair in pairs(self.pipePairs) do
        -- scoring: bird passed the right side of a pipe pair
        if not pair.scored then
            if pair.x + PIPE_WIDTH < self.bird.x then
                sounds['score']:play()
                self.score = self.score + 1
                pair.scored = true
            end
        end

        -- update position of pairs
        pair:update(dt)
    end

    -- collision detection bird - pipes
    for k, pair in pairs(self.pipePairs) do
        for l, pipe in pairs(pair.pipes) do
            if self.bird:collides(pipe) then
                sounds['explosion']:play()
                sounds['hurt']:play()
                -- end the game and display score
                gStateMachine:change('score', {
                    score = self.score 
                })
            end
        end
    end


    -- removes a pipe pair once they are pass the left side of the screen
    for k, pair in pairs(self.pipePairs) do
        if pair.remove then
            table.remove(self.pipePairs, k)
        end
    end


    -- get bird to fall (gravity simmulation)
    self.bird:update(dt)


    -- end the game if bird touches the ground
    if self.bird.y > VIRTUAL_HEIGHT - 15 then
        sounds['explosion']:play()
        sounds['hurt']:play()
        gStateMachine:change('score', {
            score = self.score
        })
    end
    
end

function PlayState:render()
    -- draw pipes
    for k, pipe in pairs(self.pipePairs) do
        pipe:render()
    end

    -- display score
    love.graphics.setFont(flappyFont)
    love.graphics.print('Score: ' .. tostring(self.score), 8, 8)

    if self.score == 1 then
        -- display bronze medal
        self.medals:render(1)
    elseif self.score == 2 then
        -- remove previous medal
        -- display silver medal
        self.medals:render(2)
    elseif self.score >= 3 then
        -- remove previous medal
        -- display gold medal
        self.medals:render(3)
    end

    -- draw bird
    self.bird:render()
end


function PlayState:enter()
    --restart the game 
    scrolling = true
end


function PlayState:exit()
    -- stop scrolling when game over
    scrolling = false
end


