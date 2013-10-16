define ['three'], (Three) ->
    class Visual
        constructor: (domContainer, @aspectRatio=16/9) ->
            @camera = new Three.PerspectiveCamera 75, @aspectRatio, 0.01, 10000
            @camera.position.z = 1000

            @scene = new Three.Scene()
            @meshes = []

            # Debug cube
            geometry = new Three.CubeGeometry 200, 200, 200
            material = new Three.MeshBasicMaterial {color: 0xff0000, wireframe: true}
            mesh = new Three.Mesh geometry, material
            @meshes.push mesh
            @scene.add mesh

            @renderer = new Three.WebGLRenderer()
            @renderer.setSize window.innerWidth, window.innerHeight

            domContainer.appendChild @renderer.domElement

        step: =>
            for mesh in @meshes
                mesh.rotation.x += 0.01
                mesh.rotation.y += 0.02

                @renderer.render @scene, @camera

    return Visual