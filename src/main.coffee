define ['cs!src/heartbeat'], (Heartbeat) ->
    last_t = 0
    debugClock = (time) =>
        if time - last_t > 8000
            last_t = time
            console.debug "Eight seconds have passed."

    @run = ->
        window.heartbeat = new Heartbeat true
        window.heartbeat.addSystem debugClock
    @