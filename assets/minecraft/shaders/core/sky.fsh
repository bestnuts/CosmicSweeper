#version 330

#moj_import <minecraft:fog.glsl>
#moj_import <minecraft:globals.glsl>
#moj_import <minecraft:dynamictransforms.glsl>
#moj_import <minecraft:projection.glsl>

in float sphericalVertexDistance;
in float cylindricalVertexDistance;

out vec4 fragColor;

float random3D(vec3 p, float seed) {
    return fract(sin(dot(p + seed, vec3(127.1, 311.7, 74.7))) * 43758.5453123);
}

vec4 generateNoise3D(vec3 p) {
    float r = random3D(p, 0.0);
    float g = random3D(p, 1.0);
    float b = random3D(p, 2.0);
    float a = random3D(p, 3.0);
    return vec4(r, g, b, a);
}

float noise3D(in vec3 x) {
    vec3 p = floor(x);
    vec3 f = fract(x);
    f = f * f * (3.0 - 2.0 * f);

    float r000 = generateNoise3D(p + vec3(0,0,0)).x;
    float r100 = generateNoise3D(p + vec3(1,0,0)).x;
    float r010 = generateNoise3D(p + vec3(0,1,0)).x;
    float r110 = generateNoise3D(p + vec3(1,1,0)).x;
    float r001 = generateNoise3D(p + vec3(0,0,1)).x;
    float r101 = generateNoise3D(p + vec3(1,0,1)).x;
    float r011 = generateNoise3D(p + vec3(0,1,1)).x;
    float r111 = generateNoise3D(p + vec3(1,1,1)).x;

    return mix(
        mix(mix(r000, r100, f.x), mix(r010, r110, f.x), f.y),
        mix(mix(r001, r101, f.x), mix(r011, r111, f.x), f.y), f.z
    );
}

float palette(in float a, in float b, in float c, in float d, in float x) {
    return a + b * cos(6.28318 * (c * x + d));
}

float computeFBM3D(in vec3 pos) {
    float amplitude = 0.75;
    float sum = 0.0;
    float maxAmp = 0.0;
    for(int i = 0; i < 6; ++i) {
        sum += noise3D(pos) * amplitude;
        maxAmp += amplitude;
        amplitude *= 0.5;
        pos *= 2.2;
    }
    return sum / maxAmp;
}

float computeFBMStars3D(in vec3 pos) {
    float amplitude = 0.75;
    float sum = 0.0;
    float maxAmp = 0.0;
    for(int i = 0; i < 5; ++i) {
        sum += noise3D(pos) * amplitude;
        maxAmp += amplitude;
        amplitude *= 0.5;
        pos *= 2.0;
    }
    return sum / maxAmp * 1.15;
}

vec3 backgroundColor3D(in vec3 rd) {
    float noise1 = computeFBMStars3D(rd * 15.0);
    float noise2 = computeFBMStars3D(rd * vec3(35.0, 55.0, 45.0));
    float noise3 = computeFBMStars3D((rd + vec3(0.5, 0.1, 0.2)) * 12.0 + GameTime * 0.35);
    float starShape = noise1 * noise2 * noise3;
    
    float falloffRadius = 0.2;
    float baseThreshold = 0.6; 
    
    starShape = clamp(starShape - baseThreshold + falloffRadius, 0.0, 1.0);
    
    float weight = starShape / (2.0 * falloffRadius);
    return weight * vec3(noise1 * 0.55, noise2 * 0.4, noise3 * 1.0) * 6.0; 
}

vec3 renderSky(in vec3 ro, in vec3 rd) {
    vec3 localRd = normalize(rd);

    float angle = 0.3; 
    float s = sin(angle);
    float c = cos(angle);
    mat3 rotX = mat3(1.0, 0.0, 0.0, 0.0, c, -s, 0.0, s, c);
    vec3 rotatedRd = localRd * rotX;

    float noiseVal = computeFBM3D(rotatedRd * 4.0 + 50.0 + GameTime * 0.0234);
    vec3 distortedRd = rotatedRd + vec3(noiseVal) * 0.15;

    float centralFalloff = clamp(1.0 - abs(rotatedRd.y), 0.0, 1.0);
    float centralFalloffRot = clamp(1.0 - abs(distortedRd.y), 0.0, 1.0);
    
    float xDirFalloff = cos(atan(rotatedRd.z, rotatedRd.x) * 1.0) * 0.5 + 0.5;
    float xDirFalloffRot = cos(atan(distortedRd.z, distortedRd.x) * 1.0) * 0.5 + 0.5;

    float lowFreqNoiseForFalloff = computeFBM3D(distortedRd * 2.5 - GameTime * 0.0234);
    float milkywayShape = clamp(pow(centralFalloffRot, 3.0) - lowFreqNoiseForFalloff * 0.5, 0.0, 1.0) * xDirFalloffRot;
    
    vec3 color;
    color.r = palette(0.5, -1.081592653589793, 0.798407346410207, 0.0, pow(milkywayShape, 1.0));
    color.g = palette(0.5, 0.658407346410207, 0.908407346410207, 0.268407346410207, pow(milkywayShape, 1.0));
    color.b = palette(0.5, -0.201592653589793, 0.318407346410207, -0.001592653589793, pow(milkywayShape, 1.0));
    
    float removeColor = (pow(milkywayShape, 10.0) + lowFreqNoiseForFalloff * 0.1) * 5.0;
    color -= vec3(removeColor);
    
    vec3 backgroundCol = backgroundColor3D(localRd) * pow(centralFalloff, 0.5) * pow(xDirFalloff, 0.5);
    vec3 blueish = vec3(0.2, 0.2, 0.4);
    backgroundCol += blueish * (5.0 - milkywayShape) * pow(centralFalloffRot, 2.0) * lowFreqNoiseForFalloff * pow(xDirFalloff, 0.75);
    
    vec3 whiteish = vec3(0.5, 1.0, 0.85);
    backgroundCol += whiteish * 0.95 * pow(centralFalloff, 1.5) * lowFreqNoiseForFalloff * pow(xDirFalloff, 2.0);
    
    return mix(backgroundCol, color, milkywayShape);
}

vec3 rayDirection() { 
    vec2 screenUV = gl_FragCoord.xy / ScreenSize.xy;
    screenUV -= vec2(0.5, 0.5);
    screenUV *= 2.0;

    vec4 rayClip = vec4(screenUV, 1.0, 1.0);
    rayClip = inverse(ProjMat) * rayClip;
    rayClip /= rayClip.w;
    return normalize(rayClip.xyz * mat3(ModelViewMat));
}

void main() {
    vec3 ro = vec3(0.0, 0.0, 0.0);
    vec3 rd = rayDirection();

    vec3 sceneColor = renderSky(ro, rd);

    fragColor = vec4(sceneColor, 1.0);
}