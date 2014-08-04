script PlayerStatus
    
    property isPlaying : false
    property currentSong : ""
    property currentArtist : ""
    property currentPos : 0
    property currentLength : 1
    
    -- reset object - subclasses should fetch data and call setStatus
    on updateStatus()
        setStatus({false, "", "", 0, 1})
    end updateStatus
    
    -- set script object (playing, song, artist, pos, len)
    on setStatus(results)
        set my isPlaying to item 1 of results
        set my currentSong to item 2 of results
        set my currentArtist to item 3 of results
        set my currentPos to item 4 of results as number
        set my currentLength to item 5 of results as number
    end setStatus
    
    -- Test if appName is running
    on isRunning(appName)
        tell application "System Events"
            if (name of every process) contains appName then return true
        end tell
        -- if application appName is running then return true
        return false
    end isRunning
    
    -- Get current track progress in %
    on getProgress()
        if not isPlaying then return 0
        -- else
        return (round ((my currentPos) / (my currentLength)) * 100)
    end getProgress
    
    -- return player info as string: "<artist>|<song>|<perentage>"
    on getSerialized()
        if not isPlaying then return ""
        return my currentArtist & "|" & my currentSong & "|" & getProgress()
    end getSerialized
    
end script

script iTunesStatus
    
    property parent : PlayerStatus
    
    -- update and return player state
    on updateStatus()
        if isRunning("iTunes") then
            tell application "iTunes"
                if player state is playing then
                    continue setStatus({true, get name of current track, get artist of current track, get player position, get duration of current track})
                else
                    set my isPlaying to false
                end if
            end tell
        else
            continue updateStatus()
        end if
    end updateStatus
    
end script

script SpotifyStatus
    
    property parent : PlayerStatus
    
    -- update and return player state
    on updateStatus()
        if isRunning("Spotify") then
            tell application "Spotify"
                if player state is playing then
                    continue setStatus({true, get name of current track, get artist of current track, get player position, get duration of current track})
                else
                    set my isPlaying to false
                end if
            end tell
        else
            continue updateStatus()
        end if
    end updateStatus
    
end script

set output to ""

repeat with status in {iTunesStatus, SpotifyStatus}
    tell status to updateStatus()
    if isPlaying of status then return getSerialized() of status as string
end repeat

return ""
