float hash12(vec2 p, float scale, float SEED) {
    p = mod(p, scale);
    p.y += SEED;
    return fract(sin(dot(p, vec2(12.9898, 4.1414))) * 43758.5453);
}

float noise(vec2 p, float scale, float SEED) {
    p *= scale;
    vec2 f = fract(p);
    p = floor(p);
    return mix(mix(hash12(p, scale, SEED), hash12(p + vec2(1.0, 0.0), scale, SEED), f.x), mix(hash12(p + vec2(0.0, 1.0), scale, SEED), hash12(p + vec2(1.0, 1.0), scale, SEED), f.x), f.y);
}

float fbm(vec2 p, float scale, int octaves, float SEED) {
    float s = 0.0, m = 0.0, a = 1.0;
    for(int i = 0; i < octaves; i++) {
        s += a * noise(p, scale, SEED);
        m += a;
        a *= 0.6;
        scale *= 2.0;
    }
    return s / m;
}

float swirly_fbm(vec2 p, float scale, int octaves, float SEED) {
    p -= GameTime * 0.004;
    float s = 0.0, m = 0.0, a = 1.0;
    for(int i = 0; i < octaves; i++) {
        s += a * noise(p + GameTime * 0.004 * a, scale, SEED);
        m += a;
        a *= 0.6;
        scale *= 2.0;
        p += vec2(cos(s * TAU), sin(s * TAU)) / scale * 0.4;
    }
    return s / m;
}

vec3 lookat(vec3 v, vec3 CAMERA) {
    vec3 f = normalize(CAMERA);
    vec3 s = normalize(vec3(-f.z, 0.0, f.x));
    return v * mat3(s, cross(s, f), -f);
}

vec3 rot_axis(vec3 v, vec3 axis, float angle) {
    vec4 q = vec4(cos(angle * 0.5), axis * sin(angle * 0.5));
    return v + 2.0 * cross(q.xyz, cross(q.xyz, v) + q.w * v);
}

vec2 mercator(vec3 n) {
    return vec2(atan(n.z, n.x) * 0.5, acos(-n.y)) / PI;
}

vec4 drawPlanet(vec3 ro, vec3 rd, float r, vec3 skyColor, vec3 atmosphereGlow, out float _t) {
    float SEED = 0.0;
    vec3 CAMERA = vec3(0.0, 0.0, -1.0);
    vec3 ROTATION_AXIS = vec3(0.3, 1.0, 0.0);
    float ROTATION_SPEED = 2;
    vec3 LAND_COLOR = vec3(0.2, 0.4, 0.0);
    vec3 JUNGLE_COLOR = vec3(0.0, 0.2, 0.0);
    vec3 DESERT_COLOR = vec3(1.0, 0.8, 0.6);
    vec3 SNOW_COLOR = vec3(0.85, 0.85, 0.9);
    float OCEAN_SIZE = 0.57;
    vec3 OCEAN_COLOR = vec3(0.1, 0.15, 0.35);
    vec3 ATMOSPHERE_COLOR = skyColor;
    vec3 CLOUD_COLOR = vec3(1.0);
    float AMBIENT_LIGHT = 0.08;

    vec3 LIGHT_DIR = normalize(vec3(1.5, 0.5, -1.0));

    float rdLen2 = dot(rd, rd);
    float rayProj = dot(ro, rd) / rdLen2;
    float rayDistSq = (dot(ro, ro) - r * r) / rdLen2;
    float discriminant = rayProj * rayProj - rayDistSq;

    float tClosest = -rayProj - sqrt(max(0.0, discriminant));
    tClosest = max(0.0, tClosest);
    vec3 hitPos = ro + tClosest * rd;

    float hitPlanet = smoothstep(0.01, 0.0, length(hitPos) - r);
    float corona = smoothstep(0.4 * r * r, 0.0, dot(hitPos, hitPos) - r * r);

    if (discriminant < 0.0 && corona <= 0.0) {
        return vec4(0.0);
    }

    _t = mix(length(-ro), tClosest, hitPlanet);

    vec3 rawNorm = normalize(hitPos);
    vec3 planetNorm = rot_axis(rawNorm, normalize(ROTATION_AXIS), GameTime * ROTATION_SPEED);
    planetNorm = lookat(planetNorm, CAMERA);
    vec2 planetMuv = mercator(planetNorm);

    float continent = fbm(planetMuv, 4.0, 7, SEED);
    float temperature = fbm(planetMuv * 3.0 + vec2(31.33), 1.0, 4, SEED);
    float humidity = fbm(planetMuv * 3.0 - vec2(54.1), 1.0, 4, SEED);

    vec3 surfaceColor = LAND_COLOR;
    surfaceColor = mix(surfaceColor, DESERT_COLOR, smoothstep(0.25, 0.1, humidity));
    surfaceColor = mix(surfaceColor, JUNGLE_COLOR, smoothstep(0.1, 0.3, humidity) * smoothstep(0.3, 0.4, temperature));
    surfaceColor = mix(surfaceColor, SNOW_COLOR, smoothstep(0.3, 0.2, temperature));
    surfaceColor *= sqrt(max(0.0, continent)) * smoothstep(0.0, 0.0, OCEAN_SIZE - continent) * 1.2 * smoothstep(1.0, 0.99, abs(planetNorm.y));
    surfaceColor += (1.0 - continent) * smoothstep(OCEAN_SIZE, OCEAN_SIZE, continent) * OCEAN_COLOR;
    surfaceColor *= sqrt(1.0 + 0.1 * cos(sqrt(max(0.0, continent)) * 512.0));

    float cloudNoise = swirly_fbm(-planetMuv, 11.0, 6, SEED) * smoothstep(1.0, 0.99, abs(planetNorm.y));
    float cloudAlpha = exp(-pow(cloudNoise, 6.0) * 32.0);

    float z = dot(hitPos, -normalize(ro)) / r;
    vec3 planar = hitPos / r + z * normalize(ro);
    float shine = (1.0 + z) / max(0.001, dot(planar, planar));
    float glow = clamp(1.0 / length(ro) - 0.1 * length(planar), 0.0, 1.0);

    float lightDot = max(0.0, dot(rawNorm, LIGHT_DIR));
    vec3 lighting = vec3(lightDot);

    surfaceColor *= lighting + vec3(AMBIENT_LIGHT);
    vec3 finalCloudColor = CLOUD_COLOR * (lighting + vec3(AMBIENT_LIGHT));

    vec4 mixedSurface = mix(vec4(surfaceColor, 1.0), vec4(finalCloudColor, cloudAlpha), cloudAlpha * hitPlanet);
    
    float viewNDot = max(0.0, dot(rawNorm, -rd));
    float frontAtmosScatter = pow(1.0 - viewNDot, 2.0) * 0.6 + pow(lightDot, 2.0) * 0.4;
    vec3 earthAtmosColor = ATMOSPHERE_COLOR * (lightDot * 1.2 + 0.2);

    mixedSurface.rgb = mix(mixedSurface.rgb, earthAtmosColor, frontAtmosScatter * hitPlanet);
    
    vec3 col = (0.05 * shine) * skyColor + vec3(0.3 * hitPlanet + 0.7 * corona) * earthAtmosColor + glow * atmosphereGlow * 0.15;

    vec4 finalPlanetColor = mix(vec4(col, corona), mixedSurface, hitPlanet);
    finalPlanetColor.rgb += atmosphereGlow * vec3(corona * (1.0 - hitPlanet) * 0.15 * max(0.0, dot(LIGHT_DIR, -rd) * 0.5 + 0.5));

    return vec4(clamp(finalPlanetColor.rgb, 0.0, 1.0), max(hitPlanet, corona));
}