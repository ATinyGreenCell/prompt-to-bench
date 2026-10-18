// Snap-on Clip for Lab Stand Rod and Tubing
// Orientation: Flat on XY plane, building up in +Z.
// Units: Millimetres.

// --- Dimensions ---
// Rod Ring
$rod_id = 12.7;      // Inner diameter (mm)
$rod_wall = 3.0;     // Wall thickness (mm)
$rod_od = $rod_id + 2 * $rod_wall; // Outer diameter (mm)
$rod_z = 10.0;       // Height of extrusion (mm)

// Tubing Ring
$tube_id = 6.0;      // Inner diameter (mm)
$tube_wall = 2.0;    // Wall thickness (mm)
$tube_od = $tube_id + 2 * $tube_wall; // Outer diameter (mm)
$tube_x_center = 15.0; // Center X position (mm)

// Bridge
$bridge_x_start = 8.0; // Start X (mm)
$bridge_x_end = 12.0;  // End X (mm)
$bridge_y_half = 3.0;  // Half width in Y (mm) -> Total 6mm

// Cutouts (Openings)
// Rod Ring Cutout: -X side relative to ring center, width 10mm
$rod_cut_width = 10.0;
$rod_cut_y_half = $rod_cut_width / 2;

// Tubing Ring Cutout: +X side relative to ring center, width 4.5mm
$tube_cut_width = 4.5;
$tube_cut_y_half = $tube_cut_width / 2;

// --- Geometry Construction ---

module rod_ring() {
    // Main ring body centered at (0,0)
    cylinder(h = $rod_z, d = $rod_od, $fn = 64);
    // Inner hole
    cylinder(h = $rod_z + 0.1, d = $rod_id, $fn = 64);
}

module tube_ring() {
    // Main ring body centered at (tube_x_center, 0)
    translate([$tube_x_center, 0, 0])
        cylinder(h = $rod_z, d = $tube_od, $fn = 64);
    // Inner hole
    translate([$tube_x_center, 0, 0])
        cylinder(h = $rod_z + 0.1, d = $tube_id, $fn = 64);
}

module bridge() {
    // Solid bridge connecting the two rings
    // Spans from x=8 to x=12, width 6mm in Y
    translate([$bridge_x_start, -$bridge_y_half, 0])
        cube([
            $bridge_x_end - $bridge_x_start, // Width in X
            $bridge_y_half * 2,              // Width in Y (6mm)
            $rod_z + 0.1                     // Height
        ]);
}

// --- Final Assembly ---

difference() {
    union() {
        // 1. Rod Ring (Centered at origin)
        translate([0, 0, 0])
            rod_ring();
        
        // 2. Tubing Ring (Centered at x=15)
        translate([$tube_x_center, 0, 0])
            tube_ring();
        
        // 3. Bridge
        translate([$bridge_x_start, 0, 0])
            bridge();
    }
    
    // --- Cutouts (Applied to the whole assembly) ---
    
    // Rod Ring Cutout: -X side relative to ring center (0,0)
    // Remove area where x < 0 (relative to ring) and -5 < y < 5
    translate([-0.05, -$rod_cut_y_half, 0])
        cube([
            $rod_cut_width + 0.1, // Width in X
            $rod_cut_width,       // Width in Y
            $rod_z + 0.1          // Height
        ]);
    
    // Tubing Ring Cutout: +X side relative to ring center (15,0)
    // Remove area where x > 0 (relative to ring) and -2.25 < y < 2.25
    translate([$tube_x_center + 0.05, -$tube_cut_y_half, 0])
        cube([
            $tube_cut_width + 0.1, // Width in X
            $tube_cut_width,       // Width in Y
            $rod_z + 0.1           // Height
        ]);
}