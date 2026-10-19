// --- Parameters ---
// Rod Ring Dimensions
rod_inner_dia = 12.7;      // Inner diameter of the rod ring (mm)
rod_wall_thick = 3.0;      // Wall thickness of the rod ring (mm)
rod_opening_w = 10.0;      // Width of the gap in the rod ring (mm)
rod_opening_h = 10.0;      // Height of the gap in the rod ring (mm)

// Tubing Ring Dimensions
tube_inner_dia = 6.0;       // Inner diameter of the tubing ring (mm)
tube_wall_thick = 2.0;      // Wall thickness of the tubing ring (mm)
tube_opening_w = 4.5;       // Width of the gap in the tubing ring (mm)
tube_opening_h = 10.0;      // Height of the gap in the tubing ring (mm)

// Bridge Dimensions
bridge_width_y = 6.0;       // Width of the bridge along the Y axis (mm)
bridge_x_start = 8.0;       // Start position of bridge along X axis (mm)
bridge_x_end = 12.0;        // End position of bridge along X axis (mm)

// Extrusion Height
extrusion_z = 10.0;         // Total height of the part (mm)

// Resolution
fn_val = 64;                // Smoothness for circular features

// --- Calculations ---
rod_outer_dia = rod_inner_dia + (2 * rod_wall_thick);
tube_outer_dia = tube_inner_dia + (2 * tube_wall_thick);

// Offsets for clean manifold geometry (preventing coplanar faces)
offset = 0.1;

// --- Main Model ---
// The part is built upward from Z=0 as requested.
// We use a union of the positive features and then subtract the holes.
// To ensure the part starts at Z=0, we do not use center=true for the main extrusion.

module part_profile() {
    union() {
        // 1. Rod Ring (centered at origin)
        cylinder(d = rod_outer_dia, h = extrusion_z, $fn = fn_val);
        
        // 2. Tubing Ring (centered at x=15, y=0)
        translate([15, 0, 0])
            cylinder(d = tube_outer_dia, h = extrusion_z, $fn = fn_val);
        
        // 3. Solid Bridge (between x=8 and x=12, width 6 in Y)
        // Centered on Y: Y range is -3 to +3
        translate([bridge_x_start, -bridge_width_y/2, 0])
            cube([bridge_x_end - bridge_x_start, bridge_width_y, extrusion_z]);
    }
}

difference() {
    // The base profile
    part_profile();

    // --- Subtraction Operations ---

    // A. Rod Inner Hole (centered at origin)
    // We extend the height to ensure it cuts through the top and bottom
    translate([0, 0, -offset])
        cylinder(d = rod_inner_dia, h = extrusion_z + 2*offset, $fn = fn_val);

    // B. Rod Ring Opening (Snap-on gap)
    // "everything with x < 0 and -5 < y < 5 is removed"
    // We use a large cube to ensure it cuts through the ring completely.
    translate([-rod_outer_dia - offset, -5.0 - offset, -offset])
        cube([rod_outer_dia + 2*offset, 10.0, extrusion_z + 2*offset]);

    // C. Tubing Inner Hole (centered at x=15, y=0)
    translate([15, 0, -offset])
        cylinder(d = tube_inner_dia, h = extrusion_z + 2*offset, $fn = fn_val);

    // D. Tubing Ring Opening (Snap-on gap)
    // "x > 15 and -2.25 < y < 2.25 is removed"
    // We use a large cube to ensure it cuts through the ring completely.
    translate([15, -2.25 - offset, -offset])
        cube([tube_outer_dia, 4.5 + 2*offset, extrusion_z + 2*offset]);
}

// Final check: The part is built from Z=0 to Z=10.
// The cylinders are not centered on Z, so the base is at Z=0.