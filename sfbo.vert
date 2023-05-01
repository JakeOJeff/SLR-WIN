uniform mat4 projectionMatrix; // handled by the camera
uniform mat4 viewMatrix;       // handled by the camera
uniform mat4 modelMatrix;      // models send their own model matrices when drawn
uniform bool isCanvasEnabled;  // detect when this model is being rendered to a canvas


varying vec4 worldPosition;
varying vec4 viewPosition;
varying vec4 screenPosition;
varying vec3 vertexNormal;
varying vec4 vertexColor;

vec4 position(mat4 transformProjection, vec4 vertexPosition) {
    worldPosition = modelMatrix * vertexPosition;
    viewPosition = viewMatrix * worldPosition;
	screenPosition = projectionMatrix * viewPosition;
	
	
    return screenPosition;
}  
