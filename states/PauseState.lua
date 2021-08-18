PauseState = Class{__includes = BaseState}

function PauseState:enter(params)
    self.score = params.score
    self.bird = params.bird
    self.pipePairs = params.pipePairs
    self.medals = params.medals
end

function PauseState:update(dt)
    -- resume game if p key is pressed
    if love.keyboard.wasPressed('p') then
        gStateMachine:change('resume', {
            score = self.score,
            bird = self.bird,
            pipePairs = self.pipePairs,
            medals = self.medals
        })
    end
end

function PauseState:render()
    
    -- draw current pipes
    for k, pipe in pairs(self.pipePairs) do
        pipe:render()
    end
    
    -- draw bird
    self.bird:render()

    -- display current score
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

    -- display pause message
    love.graphics.setFont(flappyFont)
    love.graphics.printf('Game Paused', 0, 64, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(mediumFont)
    love.graphics.printf('Press P to Resume', 0, 160, VIRTUAL_WIDTH, 'center')
    
    
end
