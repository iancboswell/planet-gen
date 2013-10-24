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
        @Perlin = new Random.Perlin 4, 4

        # Planet material allows us to change color of vertices
        planetMaterial = new Three.MeshPhongMaterial {color: 0xffffff, vertexColors: THREE.VertexColors}
        # Faces in THREE.js are indexed using letters
        faceIndices = ['a', 'b', 'c', 'd']
        DETAIL = 256
        planetGeometry = new Three.SphereGeometry 500, DETAIL, DETAIL

        OCEAN = Math.random() - .5

        for face in planetGeometry.faces
            for i in [0...3]
                vertexIndex = face[faceIndices[i]]
                vertex = planetGeometry.vertices[vertexIndex]
                color = new Three.Color 0xFFFFFF
                perlinNoise = Perlin.octaveNoise3 vertex.x / (DETAIL * (256 / DETAIL)), vertex.y / (DETAIL * (256 / DETAIL)), vertex.z / (DETAIL * (256 / DETAIL))
                R = 0
                G = 0
                B = 0
                perlinNoise += OCEAN
                if perlinNoise < 0
                    # Water
                    B = 1 + perlinNoise
                else
                    # Land
                    R = Math.pow(perlinNoise + .1, 3)
                    G = Math.sin(perlinNoise * Math.PI / 2) / 1.5 + Math.cos(perlinNoise * Math.PI / 4 + Math.PI / 4) / 2
                    B = Math.cos(perlinNoise * Math.PI / 2) / 6 #Math.pow(perlinNoise, 3)
                color.setRGB R, G, B
                face.vertexColors[i] = color

        @planet = visual.addSphere(planetGeometry, planetMaterial)

        if starfield?
            texture = Three.ImageUtils.loadTexture '../res/starfield.jpg'
            starsphereMaterial = new Three.MeshPhongMaterial {map: texture, side: Three.DoubleSide}
            visual.addSphere 3000, 100, 100, starsphereMaterial

        @light = visual.addLight(0xFFFFFF, [0, 0, 1000])

        ###for vertex in visual.meshes[0].geometry.vertices
            perlinNoise = @Perlin.octaveNoise3 vertex.x, vertex.y, vertex.z
            # This is silly, and mainly to demonstrate sphere deformation in Three.
            # TODO: properly adjust vertices
            vertex.z += perlinNoise * 15
            vertex.y += perlinNoise * 15
            vertex.x += perlinNoise * 15
        visual.meshes[0].geometry.verticesNeedUpdate = true###

        heartbeat.addSystem debugClock
        heartbeat.addSystem rotate
        heartbeat.addSystem @visual.step
    @