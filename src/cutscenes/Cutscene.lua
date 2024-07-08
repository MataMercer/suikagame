Cutscene = {}


function Cutscene:resetCutscene()
    Cutscene.timeElapsed = 0
    Cutscene.sequenceStep = 1
    Cutscene.isInitialized = true
end

function Cutscene:startCutscene(cutsceneSequence, callback)
    self:resetCutscene()
    table.insert(cutsceneSequence, callback)
    Cutscene.sequence = cutsceneSequence
end

function Cutscene:wait(waitTime, skippable)
    if waitTime == nil then
        waitTime = 2
    end
    if self.timeElapsed >= waitTime then
        Cutscene.sequenceStep = Cutscene.sequenceStep + 1
        self.timeElapsed = 0
    end
end

function Cutscene:update(dt)
    if Cutscene.isInitialized then
        Cutscene.timeElapsed = Cutscene.timeElapsed + dt

        -- print(self.timeElapsed)
        if Cutscene.sequenceStep <= #Cutscene.sequence then
            local isWait = Cutscene.sequence[Cutscene.sequenceStep]()
            if isWait == nil then
                Cutscene.sequenceStep = Cutscene.sequenceStep + 1
            end
        end
    end
end

function Cutscene:draw()

end
