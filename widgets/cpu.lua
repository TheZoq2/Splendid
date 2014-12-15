CPUMonitor = {}

CPUMonitor.__index = CPUMonitor

function CPUMonitor.create(widget)
    local monitor = {}
    
    setmetatable(monitor, CPUMonitor)
    monitor.widget = widget

    return monitor
end

function CPUMonitor:update()
    --Fetching CPU info from /proc/stat
    procFile = io.open("/proc/stat/")

    --If the stat file doesn't exist, we don't want to spam the notifications
    if(procFile == nil) then 
        return 
    end
    
    --Read the first line
    cpuLine = procFile:lines()[1]

    splitLine = string.gmatch(cpuLine, "%S+")

    --The time spent idle is the fifth column in the file
    idleTime = splitLine[5]


end
