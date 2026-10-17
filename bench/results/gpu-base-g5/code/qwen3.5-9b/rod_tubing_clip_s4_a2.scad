// Snap-on Clip for Lab Stand and Tubing
// Orientation: Flat on XY plane, building up in +Z.
// Units: Millimetres.

// --- Dimensions ---
// Rod Stand Dimensions
$rod_diameter = 12.7;      // Inner diameter of rod ring
$rod_wall = 3;             // Wall thickness of rod ring
$rod_outer = $rod_diameter + 2 * $rod_wall; // 18.7 mm
$rod_opening_width = 10;   // Width of the cutout on the -X side
$rod_opening_y_limit = 5;  // Half-height of the cutout on the -X side

// Tubing Dimensions
$tube_diameter = 6;        // Inner diameter of tubing ring
$tube_wall = 2;            // Wall thickness of tubing ring
$tube_outer = $tube_diameter + 2 * $tube_wall; // 10 mm
$tube_center_x = 15;       // X position of tubing ring center
$tube_opening_width = 4.5; // Width of the cutout on the +X side
$tube_opening_y_limit = 2.25; // Half-height of the cutout on the +X side

// Bridge Dimensions
$bridge_width_x = 4;       // Width of bridge in X (from 8 to 12)
$bridge_height_y = 6;      // Height of bridge in Y
$bridge_z = 10;            // Height of extrusion (Target Z)

// --- Configuration ---
$fn = 100;                 // Smoothness for curved shapes

// --- Main Body ---
// We define the 2D profile in the XY plane and extrude it to Z.
// The profile is constructed using difference() to cut holes and openings.

difference() {
    // 1. Create the solid base shape (Union of Rod Ring, Tubing Ring, and Bridge)
    union() {
        // --- Rod Ring (Left) ---
        // Constructed as a single difference to ensure the slot is clean
        difference() {
            // Outer cylinder
            cylinder(
                h = $bridge_z,
                d = $rod_outer,
                center = [0, 0, $bridge_z/2]
            );
            
            // Inner hole for the rod
            cylinder(
                h = $bridge_z,
                d = $rod_diameter,
                center = [0, 0, $bridge_z/2]
            );
            
            // Cut the -X side opening (Rectangular slot)
            // Position: Centered at x=0, extending to the left.
            // Height: Must cover the full Z height of the part.
            translate([-($rod_opening_width/2), 0, $bridge_z/2]) {
                cube([
                    $rod_opening_width, 
                    $rod_opening_y_limit * 2, 
                    $bridge_z
                ]);
            }
        }
        
        // --- Tubing Ring (Right) ---
        // Outer circle centered at x = $tube_center_x
        translate([0, 0, $bridge_z/2]) {
            difference() {
                // Outer cylinder
                cylinder(
                    h = $bridge_z,
                    d = $tube_outer,
                    center = [$tube_center_x, 0, $bridge_z/2]
                );
                
                // Inner hole for the tubing
                cylinder(
                    h = $bridge_z,
                    d = $tube_diameter,
                    center = [$tube_center_x, 0, $bridge_z/2]
                );
                
                // Cut the +X side opening (Rectangular slot)
                // Position: Centered at x=15, extending to the right.
                translate([$tube_center_x + ($tube_opening_width/2), 0, $bridge_z/2]) {
                    cube([
                        $tube_opening_width, 
                        $tube_opening_y_limit * 2, 
                        $bridge_z
                    ]);
                }
            }
        }
        
        // --- Solid Bridge ---
        // Joins the two rings. 
        // Spans from x = 8 to x = 12.
        // Height in Y is 6 mm, centered at y=0.
        translate([8, -($bridge_height_y/2), $bridge_z/2]) {
            cube([
                $bridge_width_x, 
                $bridge_height_y, 
                $bridge_z
            ]);
        }
    }
}