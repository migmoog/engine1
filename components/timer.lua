function makeTimer(seconds, callback, context)
    return {
        wait = seconds,
        time_left = -1,
        callback = callback,
        update = function(self, dt) -- you *could* try using love.thread but that's a little advanced
            if self.time_left > 0 then
                self.time_left = self.time_left - dt
            elseif self.time_left ~= -1 then
                self.time_left = -1
                self.callback(context)
            end
        end,

        -- begins the timer
        start = function(self, wait)
            if wait then
                self.wait = wait
            end
            self.time_left = self.wait
        end
    }
end
