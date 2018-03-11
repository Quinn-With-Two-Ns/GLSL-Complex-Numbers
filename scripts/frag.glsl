precision highp float;
uniform vec2 resolution;

uniform mat4 viewMatrix;
uniform vec3 cameraPosition;

uniform mat4 cameraWorldMatrix;
uniform mat4 cameraProjectionMatrixInverse;

void main(void) {
    // screen position
    vec2 screenPos = ( gl_FragCoord.xy * 2.0 - resolution ) / resolution;
    
    gl_FragColor = vec4( screenPos, 0.0, 1.0 );
}