define ['cs!src/heartbeat', 'cs!src/visual', 'cs!src/random', 'three'], (Heartbeat, Visual, Random, Three) ->
    last_t = 0
    debugClock = (time) =>
        if time - last_t > 8000
            last_t = time
            console.debug "Eight seconds have passed."

    rotate = (time) =>
        if planet?
            planet.rotation.y += 0.015

    @run = ->
        @heartbeat = new Heartbeat true
        @visual = new Visual document.getElementById("renderBox")
        @Perlin = new Random.Perlin 8, .3

        # Planet material allows us to change color of vertices
        # TODO: set specular map to only reflect from ocean
        planetMaterial = new Three.MeshPhongMaterial {color: 0xffffff, vertexColors: THREE.VertexColors}
        #oceanMaterial = new Three.MeshPhongMaterial {color:0x0000FF}
        # Faces in THREE.js are indexed using letters
        faceIndices = ['a', 'b', 'c', 'd']
        RADIUS = 500
        DETAIL = 256
        planetGeometry = new Three.SphereGeometry RADIUS, DETAIL, DETAIL

        OCEAN = Math.random() - .5
        #visual.addSphere [RADIUS + OCEAN, DETAIL, DETAIL], oceanMaterial

        f25 = Math.floor(planetGeometry.faces.length / 4)
        f50 = Math.floor(planetGeometry.faces.length / 2)
        f75 = Math.floor(planetGeometry.faces.length * .75)
        console.debug "Generating planet."
        for face, iFace in planetGeometry.faces
            for i in [0...3]
                vertexIndex = face[faceIndices[i]]
                vertex = planetGeometry.vertices[vertexIndex]
                color = new Three.Color 0xFFFFFF
                perlinNoise = Perlin.fBm3 vertex.x / (DETAIL * (256 / DETAIL)), vertex.y / (DETAIL * (256 / DETAIL)), vertex.z / (DETAIL * (256 / DETAIL))
                R = 0
                G = 0
                B = 0
                # Raise or lower the noise to the height of the ocean
                perlinNoise -= OCEAN
                if perlinNoise < 0
                    # Water
                    B = 1 + perlinNoise / 1.5
                else
                    # Land
                    R = Math.pow(perlinNoise + .25, 2) / 1.5
                    G = Math.sin(perlinNoise * Math.PI / 2) / 1.5 + Math.cos(perlinNoise * Math.PI / 4 + Math.PI / 4) / 2 + Math.pow(perlinNoise + .25, 2) / 4
                    B = Math.cos(perlinNoise * Math.PI / 2) / 8 + Math.pow(perlinNoise + .25, 2) / 2
                color.setRGB R, G, B
                face.vertexColors[i] = color

                # Raise/lower
                # First determine the unit-length direction vector of the vertex
                unitVector = [vertex.x / RADIUS, vertex.y / RADIUS, vertex.z / RADIUS]
                pointRadius = perlinNoise + RADIUS

                vertex.x = pointRadius * unitVector[0]
                vertex.y = pointRadius * unitVector[1]
                vertex.z = pointRadius * unitVector[2]
                #if Math.random() < .01
                #    console.log "Vertex on face #{i} of #{planetGeometry.faces.length}"
                #    console.log unitVector, perlinNoise, pointRadius
                #    console.log vertex.x, vertex.y, vertex.z
            #document.getElementById("statusbar").value = Math.floor((iFace / planetGeometry.faces.length) * 100)
            if iFace is f25
                console.debug "25% completed."
            if iFace is f50
                console.debug "50% completed."
            if iFace is f75
                console.debug "75% completed."

        #document.getElementById("statusbar").value = 100
        console.debug "Planet generated."

        # This is necessary if we want to change vertex positions after the
        # sphere has been created.
        #visual.meshes[0].geometry.verticesNeedUpdate = true


        @planet = visual.addSphere(planetGeometry, planetMaterial)

        #starfield = true

        if starfield?
            texture = Three.ImageUtils.loadTexture 'res/starfield.jpg'
            starsphereMaterial = new Three.MeshPhongMaterial {map: texture, side: Three.DoubleSide}
            visual.addSphere [3000, 100, 100], starsphereMaterial

        @light = visual.addLight(0xFFFFFF, [0, 0, 1000])

        ###for vertex in visual.meshes[0].geometry.vertices
            perlinNoise = @Perlin.octaveNoise3 vertex.x, vertex.y, vertex.z
            # This is silly, and mainly to demonstrate sphere deformation in Three.
            # TODO: properly adjust vertices
            vertex.z += perlinNoise * 15
            vertex.y += perlinNoise * 15
            vertex.x += perlinNoise * 15
        ###

        heartbeat.addSystem debugClock
        heartbeat.addSystem rotate
        heartbeat.addSystem @visual.step
    @