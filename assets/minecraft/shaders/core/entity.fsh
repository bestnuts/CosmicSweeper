#version 330

#moj_import <minecraft:fog.glsl>
#moj_import <minecraft:dynamictransforms.glsl>

uniform sampler2D Sampler0;

#ifdef DISSOLVE
uniform sampler2D DissolveMaskSampler;
#endif

in float sphericalVertexDistance;
in float cylindricalVertexDistance;
#ifdef PER_FACE_LIGHTING
in vec4 vertexPerFaceColorBack;
in vec4 vertexPerFaceColorFront;
#else
in vec4 vertexColor;
#endif

#ifndef EMISSIVE
in vec4 lightMapColor;
#endif

#ifndef NO_OVERLAY
in vec4 overlayColor;
#endif

in vec2 texCoord0;
in vec2 texCoord1;
in vec4 corner0;
in vec4 corner1;

out vec4 fragColor;

const vec3 HAND_MODEL_SCALE = vec3(0.471, 0.515, 1.515);

const vec3 modelScaleF = 0.5 * HAND_MODEL_SCALE;
const vec3 modelScaleS = modelScaleF + (0.25 / 8.0) * HAND_MODEL_SCALE;
const vec3 hRefF = vec3(length(modelScaleF.xz), length(modelScaleF.yz), length(modelScaleF.xy));
const vec3 hRefS = vec3(length(modelScaleS.xz), length(modelScaleS.yz), length(modelScaleS.xy));

bool testDim(float h, float hRef) {
    return abs(h - hRef) < 0.001;
}
bool testDims(float h, vec3 hRef) {
    return testDim(h, hRef.x) || testDim(h, hRef.y) || testDim(h, hRef.z);
}

void main() {
    vec2 texCoord = texCoord0;

    if (corner0.w != 0.0 && corner1.w != 0.0) {
        float h = length(corner0.xyz / corner0.w - corner1.xyz / corner1.w);
        if (testDims(h, hRefF) || testDims(h, hRefS)) {
            texCoord = texCoord1;
        }
    }

    vec4 color = texture(Sampler0, texCoord);
    
#ifdef ALPHA_CUTOUT
    if (color.a < ALPHA_CUTOUT) {
        discard;
    }
#endif

#ifdef PER_FACE_LIGHTING
    vec4 faceVertexColor = gl_FrontFacing ? vertexPerFaceColorFront : vertexPerFaceColorBack;
#else
    vec4 faceVertexColor = vertexColor;
#endif

#ifdef DISSOLVE
    if (faceVertexColor.a < texture(DissolveMaskSampler, texCoord0).a) {
        discard;
    }
    // The dissolve effect entirely replaces translucency
    faceVertexColor.a = 1.0;
#endif

    color *= faceVertexColor * ColorModulator;
#ifndef NO_OVERLAY
    color.rgb = mix(overlayColor.rgb, color.rgb, overlayColor.a);
#endif
#ifndef EMISSIVE
    color *= lightMapColor;
#endif
    
    fragColor = apply_fog(color, sphericalVertexDistance, cylindricalVertexDistance, FogEnvironmentalStart, FogEnvironmentalEnd, FogRenderDistanceStart, FogRenderDistanceEnd, FogColor);
}