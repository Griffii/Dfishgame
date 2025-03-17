shader_type canvas_item;

uniform vec4 water_color = vec4(0.0, 0.5, 1.0, 0.6); // Base water color (deep blue)
uniform vec4 highlight_color = vec4(0.7, 0.9, 1.0, 0.4); // Soft white-blue highlight
uniform float flow_speed = 0.4; // Speed of downward flow
uniform float strip_spacing = 0.4; // Controls spacing of strips
uniform float highlight_ratio = 0.3; // Smaller highlight strips
uniform float wave_amplitude = 0.12; // **Increased wave size for testing**
uniform float wave_frequency = 8.0; // Slower but larger waves
uniform float edge_width = 0.25; // Affects 25% of the left/right edges

void fragment() {
    vec2 uv = UV;

    // Determine how close we are to the left or right edge
    float edge_factor = smoothstep(edge_width, 0.0, min(uv.x, 1.0 - uv.x)); // **Make edge waves strong**

    // **Massive sine wave distortion to make it obvious**
    float side_wave = sin((uv.y * wave_frequency) + (TIME * flow_speed * 10.0)) * wave_amplitude;
    uv.x += side_wave * edge_factor; // Only affects the edges

    // Animate downward movement for cascading strips
    uv.y -= TIME * flow_speed;

    // Create cascading strips (more blue, less highlight)
    float strip_position = mod(uv.y / strip_spacing, 1.0);
    float stripe = step(highlight_ratio, strip_position);

    // Blend colors for alternating horizontal strips
    vec4 final_color = mix(highlight_color, water_color, stripe);

    COLOR = final_color;
}
