// Snap-on Clip for Lab Stand Rod and Tubing
// Orientation: Flat on XY plane, building up in +Z.
// Units: Millimetres.

// --- Dimensions ---
// Rod Ring
$rod_id = 12.7;      // Inner diameter of rod ring (mm)
$rod_wall = 3.0;     // Wall thickness of rod ring (mm)
$rod_od = $rod_id + 2 * $rod_wall; // Outer diameter (18.7 mm)
$rod_center_x = 0;   // Center X of rod ring
$rod_center_y = 0;   // Center Y of rod ring
$rod_height = 10.0;  // Height of extrusion (mm)

// Tubing Ring
$tube_id = 6.0;      // Inner diameter of tubing ring (mm)
$tube_wall = 2.0;    // Wall thickness of tubing ring (mm)
$tube_od = $tube_id + 2 * $tube_wall; // Outer diameter (10.0 mm)
$tube_center_x = 15; // Center X of tubing ring
$tube_center_y = 0;  // Center Y of tubing ring

// Bridge / Cutout Parameters
$bridge_x_start = 8;
$bridge_x_end = 12;
$bridge_width_y = 6.0; // Width in Y (from -3 to 3)

$rod_cut_width = 10.0; // Width of opening on -X side
$rod_cut_half_y = $rod_cut_width / 2; // +/- 5 mm

$tube_cut_width = 4.5; // Width of opening on +X side
$tube_cut_half_y = $tube_cut_width / 2; // +/- 2.25 mm

// --- Configuration ---
$fn = 128; // High resolution for smooth curves

// --- Main Body Construction ---

difference() {
    // 1. The Base Profile Extrusion
    // Bounding box must cover the entire part.
    // Max X: Tube outer edge = 15 + 5 = 20.
    // Min X: Rod outer edge = -9.35.
    // Max Y: Rod outer edge = 9.35.
    // We use a safe margin.
    $max_x = 22;
    $max_y = 10;
    
    translate([0, 0, 0]) {
        cube([
            $max_x * 2, 
            $max_y * 2, 
            $rod_height
        ]);
    }
    
    // 2. Cut Rod Ring Hole (Inner)
    // Cylinder centered at origin, radius = rod_id/2
    translate([0, 0, 0]) {
        cylinder(
            h = $rod_height + 0.1, // Extend slightly past Z to ensure clean cut
            r = $rod_id / 2,
            $fn = $fn
        );
    }
    
    // 3. Cut Tubing Ring Hole (Inner)
    // Cylinder centered at (15, 0), radius = tube_id/2
    translate([tube_center_x, tube_center_y, 0]) {
        cylinder(
            h = $rod_height + 0.1,
            r = $tube_id / 2,
            $fn = $fn
        );
    }
    
    // 4. Cut Rod Ring Opening (Slot on -X side)
    // Region: x < 0, -5 < y < 5
    // We cut a rectangle extending from x = -infinity to x = 0
    translate([-100, -rod_cut_half_y, 0]) {
        cube([
            100, // Extend far enough to left
            rod_cut_width,
            $rod_height + 0.1
        ]);
    }
    
    // 5. Cut Tubing Ring Opening (Slot on +X side)
    // Region: x > 15, -2.25 < y < 2.25
    // We cut a rectangle extending from x = 15 to x = +infinity
    translate([tube_center_x, -tube_cut_half_y, 0]) {
        cube([
            100, // Extend far enough to right
            tube_cut_width,
            $rod_height + 0.1
        ]);
    }
}