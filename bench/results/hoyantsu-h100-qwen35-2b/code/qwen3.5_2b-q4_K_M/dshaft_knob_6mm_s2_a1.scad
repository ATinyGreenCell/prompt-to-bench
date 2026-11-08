// Design a replacement knob for a hotplate stirrer with a 6 mm D-shaft.

// Dimensions in millimeters (measured with calipers)
const float d_shaft = 6.0;    // Diameter of the shaft hole
const float knob_diameter = 30.0; // Outer diameter of the knob
const float knob_height = 15.0; // Total height of the knob
const int groove_count = 18;   // Number of grip grooves
const float groove_radius = 2.0; // Radius of each groove (diameter / 2)
const float flat_to_opposite = 4.7; // Distance from flat to opposite side of D-shape
const float pointer_width = 1.5; // Width of the top pointer groove

// Create a helper function to generate a polygon with evenly spaced vertices
make_polygon(n_vertices, radius) {
    var v = n_vertices * 0.999999; 
    var p = [v, v + 2*radius]; 
    for (i = 1; i < n_vertices; i++) {
        p[i] = p[0] + radius * cos(2.0 * PI / n_vertices * i);
    }
    return [p[0], p[n_vertices]]; 
}

// Create a helper function to generate a polygon with evenly spaced vertices, centered at origin
make_polygon_centered(n_vertices) {
    var v = n_vertices * 0.999999;
    var p = [v, -v]; // Start and end points of the arc (symmetric around Y axis)
    for (i = 1; i < n_vertices; i++) {
        p[i] = p[0] + radius * cos(2.0 * PI / n_vertices * i);
    }
    return [p[0], p[n_vertices]]; // Close the loop
}

// Create a helper function to generate a polygon with evenly spaced vertices, centered at origin and rotated by angle
make_polygon_centered_rotated(angle) {
    var v = n_vertices * 0.999999;
    var p = [v * cos(angle), -v]; // Start point: (radius*cos(angle), -radius*sin(angle))
    for (i = 1; i < n_vertices; i++) {
        p[i] = p[0] + radius * cos(2.0 * PI / n_vertices * i);
    }
    return [p[0], p[n_vertices]]; // Close the loop
}

// Create a helper function to generate a polygon with evenly spaced vertices, centered at origin and rotated by angle, then flipped
make_polygon_centered_rotated_flipped(angle) {
    var v = n_vertices * 0.999999;
    var p = [v * cos(angle), -v]; 
    for (i = 1; i < n_vertices; i++) {
        p[i] = p[0] + radius * cos(2.0 * PI / n_vertices * i);
    }
    return [p[0], p[n_vertices]]; // Close the loop, but flipped around Y axis to ensure symmetry for holes/grooves
}

// Create a helper function to generate a polygon with evenly spaced vertices, centered at origin and rotated by angle, then flipped again (for D-shape)
make_polygon_centered_rotated_flipped_twice(angle) {
    var v = n_vertices * 0.999999;
    var p = [v * cos(angle), -v]; 
    for (i = 1; i < n_vertices; i++) {
        p[i] = p[0] + radius * cos(2.0 * PI / n_vertices * i);
    }
    return [p[0], p[n_vertices]]; // Close the loop, flipped twice to restore orientation for D-shape
}

// Create a helper function to generate a polygon with evenly spaced vertices, centered at origin and rotated by angle, then flipped again (for pointer groove)
make_polygon_centered_rotated_flipped_thrice(angle) {
    var v = n_vertices * 0.999999;
    var p = [v * cos(angle), -v]; 
    for (i = 1; i < n_vertices; i++) {
        p[i] = p[0] + radius * cos(