mat2 rot2(float angle) {
    return mat2(cos(angle),sin(angle),-sin(angle),cos(angle));
}

vec4 _texture(vec2 uv) {
    return texture(Sampler0, mix(textureBounds.xy, textureBounds.zw, fract(uv)));
}

vec4 drawStar(vec3 ro, vec3 rd, float r, vec3 starColor, vec3 starGlow, out float _t) {
    float time = GameTime * 24.0;
    float a = dot(ro, rd)/dot(rd, rd);
    float b = (dot(ro, ro) - r*r)/dot(rd, rd);
    float D = max(0., a*a - b);
    float t = -a - sqrt(D);
    t = max(0., t);
    vec3 p = ro + t * rd;
    
    float hitSun = smoothstep(0.15 * r * r, 0., dot(p, p) - r*r);
    
    float corona = smoothstep(1. * r * r, 0., dot(p, p) - r*r);
    
    _t = mix(length(center - vNearPos.xyz / vNearPos.w), t, hitSun);
    
    vec3 w = abs(p);
    w /= dot(w, vec3(1));
    float z = dot(p, -normalize(ro)) / r;
    vec3 planar = p/r + z * normalize(ro);
    float shine = (1.+z)/dot(planar, planar);
    float glow = clamp(1./length(ro)-0.1*length(planar), 0., 1.);
    vec3 sunColor = vec3(0);
    if (corona >= 0.0)
        sunColor = starColor + (
          _texture(p.yz/r + vec2(0.25,-1) * time * sign(p.x)).rgb * w.x +
          _texture(p.xz/r * rot2(2.*time) * sign(p.y)).rgb * w.y +
          _texture(p.xy/r + vec2(1,-0.25) * time * sign(p.z)).rgb * w.z
        );
  vec3 col = 0.8*shine*starColor + (0.7*hitSun + 0.1*corona)*sunColor + glow*starGlow;
  return vec4(max(vec3(0), col), hitSun);
}