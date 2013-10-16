define ['cs!src/heartbeat'], (Heartbeat) ->
    @run = ->
        window.heartbeat = new Heartbeat
        console.debug "Executing"
    @