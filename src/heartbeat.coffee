define [], () ->

    class Heartbeat
        constructor: ->
            # requestAnimationFrame polyfill, courtesy of Paul Irish
            window.requestAnimFrame = ->
                return window.requestAnimationFrame       ||
                       window.webkitRequestAnimationFrame ||
                       window.mozRequestAnimationFrame    ||
                       (callback) ->
                           window.setTimeout(callback, 1000 / 60)

        tick: ->
            requestAnimFrame(tick)
            # render

    return Heartbeat