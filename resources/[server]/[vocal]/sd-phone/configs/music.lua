-- Which links the Music app will accept. Anything not matched here is refused.
--
-- By default it accepts the two Creative Commons songs below and nothing else. That is
-- deliberate: Rockstar's Creator PLA (2.4) forbids sharing music licensed by someone
-- else, and that is about the song, not the link, so a .mp3 of a chart track is no
-- different to a YouTube link to it. Opening anything up is your call, and your risk.
return {
    -- Any YouTube video, from any player.
    AllowYouTube = false,

    -- Any direct audio file, from any host.
    AllowAnyAudioLink = false,

    -- Hosts you trust. Every file on them is allowed, so prefer a host you control.
    -- A leading dot covers subdomains: '.myserver.com' matches 'cdn.myserver.com'.
    AllowedHosts = {
        -- 'cdn.myserver.com',
    },

    -- Named songs, listed one by one. Players pick these from "Add from allowlist"
    -- instead of typing a URL, and a listed link always plays whatever AllowedHosts says.
    -- The two below are real, working examples: Kevin MacLeod tracks on Wikimedia Commons
    -- under CC BY 3.0, which allows playing them as long as he is credited. Delete them
    -- if you want to ship nothing, or copy the shape for your own songs.
    AllowedTracks = {
        -- 'https://cdn.myserver.com/song.mp3',
        { url = 'https://upload.wikimedia.org/wikipedia/commons/4/47/Kevin_MacLeod_~_Monkeys_Spinning_Monkeys.ogg',
          title = 'Monkeys Spinning Monkeys', artist = 'Kevin MacLeod (CC BY 3.0)' },
        { url = 'https://upload.wikimedia.org/wikipedia/commons/7/7a/Kevin_MacLeod_-_Gustav_Holst_Thaxted.oga',
          title = 'Thaxted', artist = 'Kevin MacLeod (CC BY 3.0)' },
    },

    -- Specific YouTube videos, allowed even while AllowYouTube is false. Good for music
    -- your own community made. URLs or bare video ids both work. Check the licence is
    -- real: "no copyright music" on a re-upload channel usually means nothing.
    AllowedVideos = {
        -- 'https://www.youtube.com/watch?v=SOME_VIDEO_ID',
    },
}
