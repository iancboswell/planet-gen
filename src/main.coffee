define ['cs!src/heartbeat', 'cs!src/visual'], (Heartbeat, Visual) ->
    last_t = 0
    debugClock = (time) =>
        if time - last_t > 8000
            last_t = time
            console.debug "Eight seconds have passed."

    @run = ->
        window.heartbeat = new Heartbeat true
        window.visual = new Visual document.getElementById("renderBox")
        window.heartbeat.addSystem debugClock
        window.heartbeat.addSystem window.visual.step
    @