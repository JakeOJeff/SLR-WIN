// variables provided by g3d's vertex shader
varying vec4 worldPosition; // fragpos
varying vec3 vertexNormal;  // normal

// the model matrix comes from the camera automatically
uniform mat4 modelMatrix;

extern vec3 lightPosition;
extern float ambient = 0.7; // ambient strength, set externally, based on position
float distanceFog = 0.9; // ambient strength, set externally, based on position
extern vec3 ambientLightColor; // ambient light color, set externally
extern vec3 lightColor; // light source color, set externally, based on position
extern vec3 viewPos;
float shininess = 16.0f;
float gamma = 2.2;

vec4 effect(vec4 color, Image tex, vec2 texcoord, vec2 pixcoord) {
	
	
	vec3 xTangent = dFdx( viewPos.xyz );
    vec3 yTangent = dFdy( viewPos.xyz );
    vec3 faceNormal = normalize( cross( xTangent, yTangent ) );
	
	// diffuse lighting
    vec3 norm = normalize(mat3(modelMatrix) * vertexNormal);
	
	vec3 lightDir = normalize(lightPosition.xyz - worldPosition.xyz);
	vec3 viewDir = normalize(viewPos.xyz - worldPosition.xyz);
	vec3 halfwayDir = normalize(lightDir + viewDir);
	
	// specular color
	float spec = pow(max(dot(norm, halfwayDir), 0.0), shininess);
	vec3 specular = lightColor * spec;
	
	
	float diff = max(dot(norm, halfwayDir), 0.0);
	vec3 diffuse = diff* lightColor;
	
	//if (diff== 0.0)
    //		spec = 0.0;
	
	// ambient lighting
	// calculate true value of ambient color, based on strength and light source color
	vec3 ambientcolor = ambient * ambientLightColor;    
    // get color from the texture, referred as "objectColor" in the tutorial
    vec4 objectColor = Texel(tex, texcoord);
    // if this pixel is invisible, get rid of it
    if (objectColor.a == 0.0) { discard; }

    float distance = length(lightPosition.xyz - worldPosition.xyz); //LightPos - Object Pos
	float attenuation = 2.0;//1.0 / (1 * distance);

    // in LOVE objectColor is vec4
    vec3 result = (ambientcolor + diffuse+spec) * vec3(objectColor) * attenuation;
	
	// gamma correction ;p
	//result.rgb = pow(result.rgb, vec3(1.0/gamma));
    return vec4(result, 1.0);
}