// Buffer tank for mini horizontal gel-electrophoresis box
// Corrected: Rests on Z=0, holes correctly pass through X-axis.

// --- Dimensions ---
length_outer = 120.0;    // X dimension
width_outer  = 70.0;     // Y dimension
height_outer = 40.0;     // Z dimension
wall_thick   = 3.0;      // Wall thickness
floor_thick  = 3.0;      // Floor thickness
platform_len = 60.0;      // Length of the central platform in X
platform_h_top = 13.0;   // Height of platform top from the absolute bottom (z=13)
hole_dia     = 2.0;      // Diameter of electrode wire holes
hole_y       = 0.0;      // Y position of holes (centered on Y axis)
hole_z       = 30.0;     // Z position of holes (from absolute bottom)

$fn = 64;

// --- Calculations ---
inner_x = length_outer - 2 * wall_thick;
inner_y = width_outer - 2 * wall_thick;

// We build the part starting at Z=0.
// To center on XY, we translate the final result.

module tank_geometry() {
    difference() {
        // 1. The main outer block
        cube([length_outer, width_outer, height_outer]);

        // 2. Subtract the inner void
        translate([wall_thick, wall_thick, floor_thick])
            cube([inner_x, inner_y, height_outer]);

        // 3. Subtract the electrode holes
        // The holes are horizontal along X, passing through the center of Y and Z.
        // We use a long cylinder to ensure it cuts through both end walls.
        translate([-1, hole_y, hole_z])
            rotate([0, 90, 0])
                cylinder(h = length_outer + 2, d = hole_dia);
    }

    // 4. Add the platform (Unioned with the tank body)
    // The platform is inside the tank.
    // Top is at Z=13, Bottom is at Z=3 (floor top).
    translate([
        (length_outer - platform_len) / 2, 
        wall_thick, 
        floor_thick
    ])
    cube([platform_len, inner_y, platform_h_top - floor_thick]);
}

// Final Assembly:
// The geometry is built from [0,0,0] to [120,70,40].
// We translate it so it is centered on the XY plane.
translate([-length_outer/2, -width_outer/2, 0])
    tank_geometry();