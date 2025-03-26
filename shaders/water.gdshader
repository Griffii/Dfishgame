shader_type canvas_item;

uniform float time_scale = 3.0;  // Speed of wave motion
uniform float wave_amplitude = 10.0;  // Fixed wave height in pixels
uniform float wave_frequency = 75.0;  // Number of waves across the screen
uniform vec4 water_color = vec4(0.0, 0.4, 0.8, 0.7);  // Semi-transparent water color
uniform float wave_height_pixels = 20.0;  // Fixed height for the wave effect in pixels

void fragment() {
    vec2 uv = UV;

    // Convert UV to screen space to keep wave size consistent
    float screen_wave = sin(SCREEN_UV.x * wave_frequency + TIME * time_scale) * (wave_amplitude * SCREEN_PIXEL_SIZE.y);

    // Convert the fixed pixel height to UV space
    float fixed_wave_height = wave_height_pixels * SCREEN_PIXEL_SIZE.y;

    // Apply wave effect only to the top fixed number of pixels
    if (uv.y < fixed_wave_height) {
        uv.y += screen_wave;  // Apply wave distortion

        // Create a smooth fade-out effect at the wave edges
        float alpha_fade = smoothstep(0.0, fixed_wave_height, uv.y);
        COLOR = vec4(water_color.rgb, water_color.a * alpha_fade);
    } else {
        COLOR = water_color;  // Normal water color below waves
    }
}
