#version 330

#moj_import <minecraft:fog.glsl>
#moj_import <minecraft:dynamictransforms.glsl>
#moj_import <minecraft:globals.glsl>

uniform sampler2D Sampler0;

in float sphericalVertexDistance;
in float cylindricalVertexDistance;
in vec4 vertexColor;
in vec2 texCoord0;

in vec3 position;
in vec4 vNearPos;
flat in vec3 center;
flat in vec3 localZ;
flat in int drawType;
flat in vec4 textureBounds;
flat in vec3 starColor1;
flat in vec3 starColor2;
flat in float starRadius;
const float near = 0.05;
flat in float far;

out vec4 fragColor;

#define PI 3.14159265
#define TAU 6.2831853

#moj_import <minecraft:lib/star.glsl>
#moj_import <minecraft:lib/planet.glsl>

vec4 raytrace(vec3 ro, vec3 rd, out float t) {
    if (drawType == 1) return drawStar(ro, rd, starRadius, starColor1, starColor2, t);
    else if (drawType == 2) return drawPlanet(ro, rd, starRadius, starColor1, starColor2, t);
    return vec4(1.0);
}

void setupRaytrace() {
    vec3 nearPos = vNearPos.xyz / vNearPos.w;
    vec3 rayDir = normalize(position - nearPos);

    float t;
    vec4 col = raytrace(nearPos - center, rayDir, t);
    float a = col.a;
    a = max(a, min(1., max(col.r,max(col.g,col.b))));
    if (a <= 0.0) discard;
    fragColor = vec4(col.rgb / a, a);

    float z = t * dot(localZ, rayDir);
    gl_FragDepth = 0.5+0.5*(2.*far*near + z*(far+near))/(z*(far-near));
}

void main() {
    gl_FragDepth = gl_FragCoord.z;
    if (drawType != 0) {
        setupRaytrace();
        return;
    }
    vec4 color = texture(Sampler0, texCoord0);

#ifdef ALPHA_CUTOUT
    if (color.a < ALPHA_CUTOUT) {
        discard;
    }
#endif
    color *= vertexColor * ColorModulator;
    fragColor = apply_fog(color, sphericalVertexDistance, cylindricalVertexDistance, FogEnvironmentalStart, FogEnvironmentalEnd, FogRenderDistanceStart, FogRenderDistanceEnd, FogColor);
}
