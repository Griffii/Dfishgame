shader_type canvas_item;

uniform float time_scale = 2.0; // Speed of wave motion
uniform float wave_amplitude = 10.0; // Height of waves at the top
uniform float wave_frequency = 15.0; // Spacing of waves
uniform vec4 water_color = vec4(0.0, 0.4, 0.8, 0.6); // Semi-transparent water color

void fragment() {
    vec2 uv = UV;

    // Apply sine wave distortion to the top edge of the water
    float wave = sin(uv.x * wave_frequency + TIME * time_scale) * (wave_amplitude * 0.01);

    // Modify transparency at the top to create a wavy effect
    if (uv.y < 0.1) {  // Only distort the top 10% of the water
        uv.y += wave;  // Apply wave movement

        // Create a fade-out effect for the edges
        float alpha_fade = smoothstep(0.0, 0.1, uv.y);
        COLOR = vec4(water_color.rgb, water_color.a * alpha_fade);
    } else {
        COLOR = water_color; // Normal water color below waves
    }
}
