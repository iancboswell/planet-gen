define [], () ->

    class Heartbeat
        constructor: () ->
            # Cross-browser/backwards-compatible support
            requestAnimFrame = window.requestAnimationFrame       ||
                               window.webkitRequestAnimationFrame ||
                               window.mozRequestAnimationFrame    ||
                               (callback) ->
                                   window.setTimeout callback, 1000 / 60
            window.requestAnimationFrame = requestAnimFrame

            @systems = []

            window.requestAnimationFrame(@beat)

        addSystem: (system) ->
            @systems.push system

        removeSystem: (systemToNix) ->
            for system, i in @systems when system is systemToNix
                @systems.splice i, 1

        beat: (time) =>
            system(time) for system in @systems
            window.requestAnimationFrame(@beat)

    return Heartbeat