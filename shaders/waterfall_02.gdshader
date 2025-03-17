shader_type canvas_item;

uniform float time_scale = 3.0;  // Speed of wave motion
uniform float wave_amplitude = 10.0;  // Fixed wave height in pixels
uniform float wave_frequency = 75.0;  // Number of waves across the screen
uniform vec4 water_color = vec4(0.0, 0.4, 0.8, 0.5);  // Base water color (mostly blue)
uniform vec4 highlight_color = vec4(0.7, 0.9, 1.0, 0.5);  // Soft white-blue highlight
uniform float wave_height_pixels = 20.0;  // Fixed height for the wave effect in pixels
uniform float flow_speed = 0.5; // Speed of right-to-left movement
uniform float stripe_spacing = 0.3; // Width of each stripe
uniform float highlight_ratio = 0.2; // Smaller highlight sections
uniform float gradient_blend = 0.15; // Controls smooth transition in & out of highlight

void fragment() {
    vec2 uv = UV;

    // Create a smoothly blended highlight stripe pattern
    float stripe_position = mod(uv.x / stripe_spacing + TIME * flow_speed, 1.0);
    
    // Make the highlight smaller and blend on both sides
    float highlight_start = highlight_ratio - gradient_blend;
    float highlight_end = highlight_ratio + gradient_blend;
    
    // Use smoothstep to blend the highlight smoothly in & out
    float stripe_gradient = smoothstep(highlight_start, highlight_ratio, stripe_position) * 
                            (1.0 - smoothstep(highlight_ratio, highlight_end, stripe_position));

    // Blend mostly blue water with small white-blue highlights
    vec4 base_color = mix(water_color, highlight_color, stripe_gradient);

    // Convert UV to screen space to keep wave size consistent
    float screen_wave = sin(SCREEN_UV.x * wave_frequency + TIME * time_scale) * (wave_amplitude * SCREEN_PIXEL_SIZE.y);

    // Convert the fixed pixel height to UV space
    float fixed_wave_height = wave_height_pixels * SCREEN_PIXEL_SIZE.y;

    // Apply wave effect only to the top fixed number of pixels, blending with stripes
    if (uv.y < fixed_wave_height) {
        uv.y += screen_wave;  // Apply wave distortion
        float alpha_fade = smoothstep(0.0, fixed_wave_height, uv.y);
        base_color.a *= alpha_fade;
    }

    COLOR = base_color;
}
