function makeTimer(seconds, callback, context, dont_repeat)
    return {
        wait = seconds,
        time_left = seconds,
        update = function(self, dt) -- you *could* try using love.thread but that's a little advanced
            if self.time_left > 0 then
                self.time_left = self.time_left - dt
            else
                if dont_repeat then
                    self.time_left = self.wait
                end
                callback(context)
            end
        end
    }
end
