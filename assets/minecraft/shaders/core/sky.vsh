#version 330

#moj_import <minecraft:fog.glsl>
#moj_import <minecraft:dynamictransforms.glsl>
#moj_import <minecraft:projection.glsl>
#moj_import <minecraft:globals.glsl>

in vec3 Position;

out float sphericalVertexDistance;
out float cylindricalVertexDistance;

void main() {
    vec3 worldDir = normalize(Position);
    worldDir.y = worldDir.y * ScreenSize.x - (ScreenSize.x - 0.1);
    vec3 viewDir = mat3(ModelViewMat) * worldDir;

    mat4 projMat = ProjMat;
    projMat[3].xy = vec2(0.0);

    vec4 pos = projMat * vec4(viewDir, 1.0);
    pos.z = pos.w;
    gl_Position = pos;

    sphericalVertexDistance = fog_spherical_distance(Position);
    cylindricalVertexDistance = fog_cylindrical_distance(Position);
}