#version 330

#moj_import <minecraft:fog.glsl>
#moj_import <minecraft:dynamictransforms.glsl>
#moj_import <minecraft:projection.glsl>

in vec3 Position;

out float sphericalVertexDistance;
out float cylindricalVertexDistance;

void main() {
    vec4 pos = vec4(Position, 1.0);
	if (ProjMat[3][2] != -2.0) {
		pos = ProjMat * vec4(Position, 1.0);
		pos.y = -pos.z;
	} else {
		pos = ProjMat * ModelViewMat * vec4(Position, 1.0);
	}
	
	gl_Position = pos;

    sphericalVertexDistance = fog_spherical_distance(Position);
    cylindricalVertexDistance = fog_cylindrical_distance(Position);
}