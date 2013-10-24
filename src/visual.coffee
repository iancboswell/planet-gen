define ['three'], (Three) ->

    class Visual
        constructor: (domContainer, @aspectRatio=16/9) ->
            @camera = new Three.PerspectiveCamera 75, @aspectRatio, 0.01, 10000
            @camera.position.z = 1000

            @scene = new Three.Scene()
            @meshes = []
            @lights = []

            @renderer = new Three.WebGLRenderer()
            @renderer.setSize window.innerWidth - 16, (window.innerWidth - 16) * 1 / @aspectRatio

            domContainer.appendChild @renderer.domElement

        addLight: (color=0xFFFFFF, pos=[0, 0, 0]) ->
            light = new Three.PointLight color
            light.position.set pos[0], pos[1], pos[2]
            @scene.add light
            @lights.push light
            light

        addCube: (geometry, material) ->
            if not geometry?
                geometry = new Three.CubeGeometry 200, 200, 200
            if geometry[0]?
                geometry = new Three.CubeGeometry geometry[0], geometry[1], geometry[2]
            if not material?
                material = new Three.MeshBasicMaterial {color: 0xff0000, wireframe: true}
            mesh = new Three.Mesh geometry, material
            @meshes.push mesh
            @scene.add mesh
            mesh

        addSphere: (geometry, material) ->
            if not geometry?
                # radius, segments, rings
                geometry = new Three.SphereGeometry 500, 16, 16
            if geometry[0]?
                geometry = new Three.SphereGeometry geometry[0], geometry[1], geometry[2]
            if not material?
                material = new Three.MeshBasicMaterial {color: 0x00ff00, wireframe: true}
            sphere = new Three.Mesh geometry,
                                    material
            @meshes.push sphere
            @scene.add sphere
            sphere

        step: =>
            @renderer.render @scene, @camera

    return Visual