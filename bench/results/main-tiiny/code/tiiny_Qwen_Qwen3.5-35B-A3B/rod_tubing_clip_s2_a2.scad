// Dimensions for the snap-on clip
// Lab stand rod diameter
rod_diameter = 12.7;
// Lab stand rod radius
rod_radius = rod_diameter / 2;
// Rod ring wall thickness
rod_wall = 3;
// Rod ring outer diameter
rod_outer = rod_diameter + 2 * rod_wall;
// Rod ring outer radius
rod_outer_radius = rod_outer / 2;
// Rod ring opening width (X-direction)
rod_opening_width = 10;
// Rod ring opening half-width
rod_opening_half = rod_opening_width / 2;
// Rod ring opening Y-range half-width
rod_opening_y_half = 5;

// Tubing diameter
tubing_diameter = 6;
// Tubing radius
tubing_radius = tubing_diameter / 2;
// Tubing wall thickness
tubing_wall = 2;
// Tubing ring outer diameter
tubing_outer = tubing_diameter + 2 * tubing_wall;
// Tubing ring outer radius
tubing_outer_radius = tubing_outer / 2;
// Tubing ring center X position
tubing_center_x = 15;
// Tubing ring opening width (X-direction)
tubing_opening_width = 4.5;
// Tubing ring opening half-width
tubing_opening_half = tubing_opening_width / 2;
// Tubing ring opening Y-range half-width
tubing_opening_y_half = 2.25;

// Bridge dimensions
bridge_width = 6;
bridge_start_x = 8;
bridge_end_x = 12;

// Extrusion height
extrusion_height = 10;

// Safety offset for cutting shapes to avoid coplanar faces
safety_offset = 0.01;

// Define the 2D profile in the XY plane
module profile() {
    // 1. Rod Ring (Centered at origin)
    // We create a circle, subtract the inner hole, then subtract the opening cut.
    rod_ring_2d = difference() {
        // Main ring body (outer circle)
        circle(r = rod_outer_radius, $fn = 64);
        // Inner hole for the rod
        circle(r = rod_radius, $fn = 64);
        // Opening cut (remove x < 0 and -5 < y < 5)
        // We use a rectangle that covers the area to be removed.
        // The cut is on the -X side.
        // Rectangle center: x = -rod_opening_half, y = 0
        // Width: rod_opening_width + 2*safety_offset (to ensure it cuts through)
        // Height: rod_opening_y_half * 2 + 2*safety_offset
        translate([-rod_opening_half, 0])
            cube([rod_opening_width + 2 * safety_offset, rod_opening_y_half * 2 + 2 * safety_offset], center = true);
    };

    // 2. Tubing Ring (Centered at x=15, y=0)
    tubing_ring_2d = difference() {
        // Main ring body (outer circle)
        translate([tubing_center_x, 0])
            circle(r = tubing_outer_radius, $fn = 64);
        // Inner hole for the tubing
        translate([tubing_center_x, 0])
            circle(r = tubing_radius, $fn = 64);
        // Opening cut (remove x > 15 and -2.25 < y < 2.25)
        // Rectangle center: x = tubing_center_x + tubing_opening_half
        // Width: tubing_opening_width + 2*safety_offset
        // Height: tubing_opening_y_half * 2 + 2*safety_offset
        translate([tubing_center_x + tubing_opening_half, 0])
            cube([tubing_opening_width + 2 * safety_offset, tubing_opening_y_half * 2 + 2 * safety_offset], center = true);
    };

    // 3. Bridge (Solid rectangle between x=8 and x=12, width 6mm)
    bridge_2d = translate([(bridge_start_x + bridge_end_x) / 2, 0])
        cube([bridge_end_x - bridge_start_x, bridge_width, 0], center = true);

    // Combine all parts
    union() {
        rod_ring_2d;
        tubing_ring_2d;
        bridge_2d;
    }
}

// Extrude the 2D profile to create the 3D part
linear_extrude(height = extrusion_height)
    profile();