Medals = Class{}

function Medals:init()
    -- initialize medals
    self.medals = {
        'bronzemedal.png',
        'silvermedal.png',
        'goldmedal.png'
    }
    self.number_medals = #(self.medals)

    self.medal = love.graphics.newArrayImage(self.medals)

end


function Medals:update()
end

function Medals:render(n)
    love.graphics.drawLayer(self.medal, n, 8, 50)
end