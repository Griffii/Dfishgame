shader_type canvas_item;

// Screen texture sampling
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

// Water effect textures (Remove invalid hints)
uniform sampler2D refraction_map;
uniform sampler2D water_mask;

// Scaling and distortion factors
uniform vec2 scale = vec2(1.0); // Scale for UV mapping
uniform float zoom = 1.0; // Zoom factor for refraction distortion

// Stretch factors for different elements
uniform vec2 gap_stretch = vec2(0.8, 0.05);
uniform vec2 refraction_stretch = vec2(2.0, 0.8);

// Water refraction strength
uniform float refraction_strength : hint_range(0.0, 0.1) = 0.02;

// Water color properties
uniform vec4 water_tint = vec4(0.2, 0.6, 1.0, 0.1);
uniform vec4 water_highlight = vec4(1.0, 1.0, 1.0, 0.3);

// Flowing water properties
uniform float speed = 1.0;
uniform float flow_gaps : hint_range(0.0, 1.0) = 0.33;
uniform float highlight_width : hint_range(0.0, 0.3) = 0.02;

void fragment() {
    vec2 uv = UV * scale;

    // Apply animated offsets to textures
    vec2 refraction_offset = texture(refraction_map, vec2(uv.x, uv.y - TIME * speed * 0.5) * refraction_stretch).xy;
    vec2 gap_mask = texture(water_mask, vec2(uv.x, uv.y - TIME * speed) * gap_stretch).xy;

    // Normalize refraction offset (set between -0.5 and 0.5)
    refraction_offset -= 0.5;

    // Sample the screen texture and apply refraction
    vec4 refraction = texture(SCREEN_TEXTURE, SCREEN_UV - refraction_offset * refraction_strength * zoom);

    // Create water surface with highlights and gaps
    vec4 color = vec4(1.0);
    float inner_edge = flow_gaps + highlight_width;

    if (gap_mask.x < inner_edge) {
        color.rgb = mix(refraction.rgb, water_highlight.rgb, water_highlight.a);
    } else {
        color.rgb = mix(refraction.rgb, water_tint.rgb, water_tint.a);
    }

    // Create transparent flow gaps
    if (gap_mask.x < flow_gaps) {
        color.a = 0.0;
    }

    // Generate edge wobble effect
    vec2 water_edge = texture(water_mask, vec2(uv.x, uv.y - TIME * 0.1) * vec2(0.15, 0.6)).xy;
    water_edge -= 0.5;

    vec2 vertical_edge_mask = gap_mask - 0.5;

    // Apply alpha masking for edges
    color.a = mix(0.0, color.a, step(uv.x + vertical_edge_mask.x * 0.2, 0.92)); // Right edge
    color.a = mix(color.a, 0.0, step(uv.x - vertical_edge_mask.x * 0.2, 0.08)); // Left edge
    color.a = mix(0.0, color.a, step(uv.y + water_edge.y * 0.1, 0.95));  // Bottom edge
    color.a = mix(color.a, 0.0, step(uv.y - water_edge.y * 0.05, 0.05)); // Top edge

    COLOR = color;
}
