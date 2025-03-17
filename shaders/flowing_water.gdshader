shader_type canvas_item;

uniform float flow_speed = 0.5;  // Speed of water flow
uniform vec4 water_color = vec4(0.0, 0.5, 1.0, 0.6);  // Base water color
uniform float color_variation_intensity = 0.1;  // How strong the color shifts are

// Simple pseudo-random function for color variation
float random(vec2 uv) {
    return fract(sin(dot(uv, vec2(12.9898, 78.233))) * 43758.5453);
}

void fragment() {
    vec2 uv = UV;

    // Scroll the UVs **leftward** for correct motion
    uv.x += TIME * flow_speed * 0.1;  // Changed from `-=` to `+=` to flow right to left

    // Generate subtle color variation using random noise
    float variation = random(floor(uv * 50.0));  // Adjust scale for different-sized streaks
    variation = mix(-color_variation_intensity, color_variation_intensity, variation);

    // Apply variation to the water color
    vec4 final_color = water_color + vec4(variation, variation * 0.5, variation * 0.8, 0.0);  // Subtle shifting blues

    COLOR = final_color;
}
