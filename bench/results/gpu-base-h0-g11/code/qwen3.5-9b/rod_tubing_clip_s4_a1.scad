// Snap-on Clip for Lab Stand and Tubing
// Orientation: Flat on XY plane, building up in +Z.
// Units: Millimetres.

// --- Dimensions ---
// Rod Stand Dimensions
$rod_diameter = 12.7;      // Inner diameter of rod ring
$rod_wall = 3;             // Wall thickness of rod ring
$rod_outer = $rod_diameter + 2 * $rod_wall; // 18.7 mm
$rod_center_x = 0;         // Center of rod ring
$rod_center_y = 0;         // Center of rod ring

// Tubing Dimensions
$tube_diameter = 6;        // Inner diameter of tubing ring
$tube_wall = 2;            // Wall thickness of tubing ring
$tube_outer = $tube_diameter + 2 * $tube_wall; // 10 mm
$tube_center_x = 15;       // Center of tubing ring
$tube_center_y = 0;        // Center of tubing ring

// Opening Dimensions
$rod_cut_width = 10;       // Width of opening on -X side
$rod_cut_half_y = $rod_cut_width / 2; // 5 mm

$tube_cut_width = 4.5;     // Width of opening on +X side
$tube_cut_half_y = $tube_cut_width / 2; // 2.25 mm

// Bridge Dimensions
$bridge_width_x = 4;       // Width of bridge (12 - 8)
$bridge_height_y = 6;      // Height of bridge in Y
$bridge_start_x = 8;       // Start X of bridge
$bridge_end_x = 12;        // End X of bridge

// Extrusion Height
$height = 10;              // Z height

// Resolution
$fn = 64;

// --- Main Generation ---
difference() {
    // 1. Create the solid extrusion from the 2D profile
    union() {
        // Rod Ring Outer Boundary
        translate([0, 0, 0])
            cylinder(h = $height, r = $rod_outer / 2, center = true);
        
        // Tubing Ring Outer Boundary
        translate([tube_center_x, tube_center_y, 0])
            cylinder(h = $height, r = $tube_outer / 2, center = true);
        
        // Solid Bridge
        translate([bridge_start_x, -bridge_height_y/2, 0])
            cube([bridge_width_x, bridge_height_y, $height]);
    }

    // 2. Cut out the Rod Ring Opening (-X side)
    // Cut region: x < 0, -5 < y < 5
    translate([0, -rod_cut_half_y, 0])
        cube([rod_cut_width, rod_cut_width, $height + 0.1]);

    // 3. Cut out the Tubing Ring Opening (+X side)
    // Cut region: x > 15, -2.25 < y < 2.25
    translate([tube_center_x, -tube_cut_half_y, 0])
        cube([tube_cut_width, tube_cut_width, $height + 0.1]);

    // 4. Cut out the Rod Ring Inner Hole (to let the rod through)
    // Inner diameter 12.7mm, centered at 0,0
    translate([0, 0, 0])
        cylinder(h = $height + 0.1, r = $rod_diameter / 2, center = true);

    // 5. Cut out the Tubing Ring Inner Hole (to let the tube through)
    // Inner diameter 6mm, centered at 15,0
    translate([tube_center_x, tube_center_y, 0])
        cylinder(h = $height + 0.1, r = $tube_diameter / 2, center = true);
}