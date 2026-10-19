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
// The entire assembly is translated so that the base sits at Z = 0.
// Since we use center=true for cylinders, we must offset by extrusion_height/2.
translate([0, 0, extrusion_height/2]) {
    difference() {
        // Main Body: Union of the two rings and the bridge
        union() {
            // 1. Rod Ring
            difference() {
                cylinder(d = rod_outer_dia, h = extrusion_height, center = true);
                // Subtract inner hole (extended to ensure clean cut)
                cylinder(d = rod_inner_dia, h = extrusion_height + 2, center = true);
            }

            // 2. Tubing Ring
            difference() {
                cylinder(d = tube_outer_dia, h = extrusion_height, center = true);
                // Subtract inner hole (extended to ensure clean cut)
                cylinder(d = tube_inner_dia, h = extrusion_height + 2, center = true);
            }

            // 3. Solid Bridge
            // Defined as a block between x=8 and x=12, with Y width of 6mm
            translate([(bridge_x_start + bridge_x_end)/2, 0, 0])
                cube([bridge_x_end - bridge_x_start, bridge_width_y, extrusion_height], center = true);
        }

        // --- Subtractions (Openings) ---

        // Rod Ring Opening: x < 0 and -5 < y < 5
        // To ensure it cuts the ring, we make the cube large enough to cover the -X side.
        // The ring's outer radius is 9.35. We cut from x = -10 to x = 0.
        translate([-10, 0, 0])
            cube([10, rod_opening_h, extrusion_height + 2], center = true);

        // Tubing Ring Opening: x > 15 and -2.25 < y < 2.25
        // The tube center is at 15. We cut from x = 15 to x = 20.
        translate([17.5, 0, 0])
            cube([10, tube_opening_h, extrusion_height + 2], center = true);
    }
}

// Note on Geometry:
// The rod ring is centered at (0,0).
// The tubing ring is centered at (15,0).
// The bridge is a solid block between x=8 and x=12.
// The rod ring opening is on the -X side (x < 0).
// The tubing ring opening is on the +X side (x > 15).
// The part is printed flat on the XY plane (Z=0 to Z=10).