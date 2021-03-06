if ( ! Detector.webgl ) Detector.addGetWebGLMessage();


var scene, camera, renderer;
var material;
var config = {
    resolution: '1024'
};
var clk = new THREE.Clock()
init();
render();

function init() {

    scene = new THREE.Scene();
    camera = new THREE.PerspectiveCamera( 75, window.innerWidth/window.innerHeight, 0.1, 1000 );

    renderer = new THREE.WebGLRenderer( { canvas: canvas } );
    renderer.setPixelRatio( window.devicePixelRatio );
    renderer.setSize( config.resolution, config.resolution );

    var texture = new THREE.TextureLoader().load( "images/pal.png" );
    texture.magFilter = THREE.NearestFilter;
    
    var geometry = new THREE.PlaneBufferGeometry( 2.0, 2.0 );;
    material = new THREE.RawShaderMaterial( {
        uniforms: {
            tex : {value: texture },
            time : { value: 0.0 },
            delta : { value: 0.0 },
            resolution: { value: new THREE.Vector2( canvas.width, canvas.height ) },
            cameraWorldMatrix: { value: camera.matrixWorld },
            cameraProjectionMatrixInverse: { value: new THREE.Matrix4().getInverse( camera.projectionMatrix ) }
        },
        vertexShader: document.getElementById( 'vertex_shader' ).textContent,
        fragmentShader: document.getElementById( 'fragment_shader' ).textContent
    } );
    var mesh = new THREE.Mesh( geometry, material );
    mesh.frustumCulled = false;
    scene.add( mesh );

    camera.position.z = 5;
}

function onWindowResize() {
    if ( config.resolution === 'full' ) {
        renderer.setSize( window.innerWidth, window.innerHeight );
    } else {
        renderer.setSize( config.resolution, config.resolution );
    }
    camera.aspect = canvas.width / canvas.height;
    camera.updateProjectionMatrix();

    material.uniforms.resolution.value.set( canvas.width, canvas.height );
    material.uniforms.cameraProjectionMatrixInverse.value.getInverse( camera.projectionMatrix );
}

function render( time ) {
    renderer.render( scene, camera );
    material.uniforms.time.value =  clk.getElapsedTime();
    material.uniforms.time.needsUpdate = true;
    material.uniforms.delta.value = clk.getDelta();
    material.uniforms.delta.needsUpdate = true;
    requestAnimationFrame( render );
}