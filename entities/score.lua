-- handles calculating and displaying the score
local textColor = { 1.0, 0.8627, 0.0, 1 }
score = {
    score = 0,
    highscore = 0,
    streak = 0,
}

function score:reset()
    local old = self.score
    self.score = 0
    self.highscore = math.max(self.highscore, old)
    self.streak = 0
end

function score:addMatches(matchCount)
    self.streak = self.streak + 1
    local points = self.streak * matchCount * (matchCount + 1) / 2
    self.score = self.score + points

    self.highscore = math.max(self.highscore, self.score)
end

function score:draw()
    love.graphics.print({
            textColor,
            "Score: " .. self.score .. " | Streak: " .. self.streak .. " | Hi: " .. self.highscore,
        },
        -- align to bottom of screen
        0, love.graphics.getHeight() - 50, 0,
        2.5, 2)
end
