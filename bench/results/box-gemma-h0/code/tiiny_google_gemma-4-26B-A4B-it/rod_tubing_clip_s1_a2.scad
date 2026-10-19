// --- Dimensions (mm) ---
rod_inner_dia = 12.7;      // Inner diameter of the rod ring
rod_wall = 3.0;            // Wall thickness of the rod ring
rod_opening_w = 10.0;      // Width of the gap in the rod ring (X-axis span)
rod_opening_h = 10.0;      // Height of the gap in the rod ring (Y-axis span)

tube_inner_dia = 6.0;       // Inner diameter of the tubing ring
tube_wall = 2.0;           // Wall thickness of the tubing ring
tube_opening_w = 4.5;      // Width of the gap in the tubing ring (X-axis span)
tube_opening_h = 4.5;       // Height of the gap in the tubing ring (Y-axis span)

bridge_width_y = 6.0;      // Width of the bridge in the Y direction
bridge_x_start = 8.0;      // Start of the bridge on X axis
bridge_x_end = 12.0;        // End of the bridge on X axis

extrusion_height = 10.0;   // Total Z height of the part

// --- Constants ---
$fn = 64;

// --- Calculations ---
rod_outer_dia = rod_inner_dia + (2 * rod_wall);
tube_outer_dia = tube_inner_dia + (2 * tube_wall);
tube_center_x = 15.0;
tube_center_y = 0.0;

// --- Final Assembly ---
// The part is built from Z=0 to Z=10.
// We use a top-level translate to ensure the entire object starts at Z=0.
translate([0, 0, 0]) {
    difference() {
        // Main Body: Union of the two rings and the bridge
        union() {
            // 1. Rod Ring
            // Centered at origin, height 10, base at Z=0
            difference() {
                cylinder(d = rod_outer_dia, h = extrusion_height, center = false);
                // Subtract inner hole (extended to ensure clean cut)
                translate([0, 0, -1])
                    cylinder(d = rod_inner_dia, h = extrusion_height + 2, center = false);
            }

            // 2. Tubing Ring
            // Centered at x=15, y=0, height 10, base at Z=0
            translate([tube_center_x, tube_center_y, 0])
                difference() {
                    cylinder(d = tube_outer_dia, h = extrusion_height, center = false);
                    // Subtract inner hole (extended to ensure clean cut)
                    translate([0, 0, -1])
                        cylinder(d = tube_inner_dia, h = extrusion_height + 2, center = false);
                }

            // 3. Solid Bridge
            // Solid block between x=8 and x=12, width 6 in Y, height 10 in Z
            // Centered on Y=0, so Y goes from -3 to 3.
            translate([(bridge_x_start + bridge_x_end)/2, 0, extrusion_height/2])
                cube([bridge_x_end - bridge_x_start, bridge_width_y, extrusion_height], center = true);
        }

        // --- Subtractions (Openings) ---

        // Rod Ring Opening: x < 0 and -5 < y < 5
        // The rod ring is centered at 0,0. To cut the -X side, we place a cube 
        // that covers the area from x = -rod_outer_dia to x = 0.
        // We use a large X-offset to ensure it cuts through the ring.
        translate([-rod_outer_dia - 1, 0, extrusion_height/2])
            cube([rod_outer_dia + 2, rod_opening_h, extrusion_height + 2], center = true);

        // Tubing Ring Opening: x > 15 and -2.25 < y < 2.25
        // The tube center is at 15. To cut the +X side, we place a cube
        // that covers the area from x = 15 to x = 15 + tube_outer_dia.
        translate([tube_center_x + tube_outer_dia, 0, extrusion_height/2])
            cube([tube_outer_dia + 2, tube_opening_h, extrusion_height + 2], center = true);
    }
}