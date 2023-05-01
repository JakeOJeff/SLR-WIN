extern Image depthMap;

vec4 effect(vec4 color, Image tex, vec2 texcoord, vec2 pixcoord) {
	
    float depthValue = Texel(depthMap, texcoord).r;
    vec4 result  = vec4(vec3(depthValue), 2.0);
	
    return result;
}