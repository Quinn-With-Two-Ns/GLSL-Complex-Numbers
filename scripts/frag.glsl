precision highp float;
uniform vec2 resolution;

uniform mat4 viewMatrix;
uniform vec3 cameraPosition;

uniform mat4 cameraWorldMatrix;
uniform mat4 cameraProjectionMatrixInverse;

vec2 cmpxcjg(in vec2 c) {
    return vec2(c.x, -c.y);
}

vec2 cmpxmul(in vec2 a, in vec2 b) {
    return vec2(a.x * b.x - a.y * b.y, a.y * b.x + a.x * b.y);
}

vec2 cmpxpow(in vec2 c, int p) {
    for (int i = 0; i < p; ++i) {
        c = cmpxmul(c, c);
    }
    return c;
}

vec2 cmpxdiv(in vec2 a, in vec2 b) {
    return cmpxmul(a, cmpxcjg(b));
}

float cmpxmag(in vec2 c) {
    return sqrt(c.x * c.x + c.y * c.y);
}

float cmpxarg(in vec2 z){
    return atan(z.y,z.x);
}

vec2 cmpxexp(in vec2 z){
    
    vec2 w = vec2( cos(z.y), sin(z.y));
    w *= exp(z.x);
    return w;
}

vec3 cmp2hsv(in vec2 z){
    return vec3(cmpxarg(z), 1-pow(2,-cmpxmag(z)), 1.0);
}

vec3 hsl2rgb(vec3 hsl) {
    vec3 rgb;
    
    if (hsl.y == 0.0) {
        rgb = vec3(hsl.z); // Luminance
    } else {
        float f2;
        
        if (hsl.z < 0.5)
            f2 = hsl.z * (1.0 + hsl.y);
        else
            f2 = hsl.z + hsl.y - hsl.y * hsl.z;
            
        float f1 = 2.0 * hsl.z - f2;
        
        rgb.r = hue2rgb(f1, f2, hsl.x + (1.0/3.0));
        rgb.g = hue2rgb(f1, f2, hsl.x);
        rgb.b = hue2rgb(f1, f2, hsl.x - (1.0/3.0));
    }   
    return rgb;
}


void main(void) {
    // screen position
    vec2 screenPos = ( gl_FragCoord.xy * 2.0 - resolution ) / resolution;
    gl_FragColor = vec4( hsl2rgb(cmp2hsv(screenPos)), 1.0 );
}