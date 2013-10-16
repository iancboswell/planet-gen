define ['three'], (Three) ->
    class Visual
        constructor: (domContainer, @aspectRatio=16/9) ->
            @camera = new Three.PerspectiveCamera 75, @aspectRatio, 0.01, 10000
            @camera.position.z = 1000

            @scene = new Three.Scene()
            @meshes = []

            @addSphere()

            @renderer = new Three.WebGLRenderer()
            @renderer.setSize window.innerWidth, window.innerHeight

            domContainer.appendChild @renderer.domElement

        addCube: (dim=[200, 200, 200], material) ->
            if not material?
                material = new Three.MeshBasicMaterial {color: 0xff0000, wireframe: true}
            geometry = new Three.CubeGeometry dim[0], dim[1], dim[2]
            mesh = new Three.Mesh geometry, material
            @meshes.push mesh
            @scene.add mesh

        addSphere: (radius=500, segments=16, rings=16, material) ->
            if not material?
                material = new Three.MeshBasicMaterial {color: 0x00ff00, wireframe: true}
            sphere = new Three.Mesh new Three.SphereGeometry(radius, segments, rings),
                                    material
            @meshes.push sphere
            @scene.add sphere

        step: =>
            for mesh in @meshes
                mesh.rotation.x += 0.01
                mesh.rotation.y += 0.02

                @renderer.render @scene, @camera

    return Visual