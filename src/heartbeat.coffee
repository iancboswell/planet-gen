define [], () ->

    class Heartbeat
        constructor: ->
            # Cross-browser/backwards-compatible support
            requestAnimFrame = window.requestAnimationFrame       ||
                               window.webkitRequestAnimationFrame ||
                               window.mozRequestAnimationFrame
            window.requestAnimationFrame = requestAnimFrame

            window.requestAnimationFrame(@beat)

        beat: (time) =>
            console.log time
            window.requestAnimationFrame(@beat)

    return Heartbeat