ResumeState = Class{__includes = PlayState}

function ResumeState:enter(params)
    self.score = params.score
    self.bird = params.bird
    self.pipePairs = params.pipePairs
    self.medals = params.medals
end
