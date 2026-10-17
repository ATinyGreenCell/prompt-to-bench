// Snap-on Clip for Lab Stand Rod and Tubing
// Orientation: Flat on XY plane, building upward (+Z)
// Units: Millimetres

// --- Dimensions ---
// Rod Ring
$rod_id = 12.7;      // Inner diameter of rod ring
$rod_wall = 3.0;     // Wall thickness of rod ring
$rod_od = $rod_id + 2 * $rod_wall; // Outer diameter (18.7 mm)
$rod_center = [0, 0, 0];

// Tubing Ring
$tube_id = 6.0;      // Inner diameter of tubing ring
$tube_wall = 2.0;    // Wall thickness of tubing ring
$tube_od = $tube_id + 2 * $tube_wall; // Outer diameter (10 mm)
$tube_center = [15, 0, 0];

// Bridge
$bridge_width_x = 4; // Width in X (from 8 to 12)
$bridge_height_y = 6; // Height in Y
$bridge_z = 10;      // Height of extrusion

// Cutout Dimensions
$cutout_rod_width = 10; // Width of opening on rod ring (-X side)
$cutout_rod_height = 10; // Height of opening on rod ring (-5 < y < 5)

$cutout_tube_width = 4.5; // Width of opening on tubing ring (+X side)
$cutout_tube_height = 4.5; // Height of opening on tubing ring (-2.25 < y < 2.25)

// Extrusion Height
$height = 10;

// Resolution for curves
$fn = 64;

// --- Main Module ---
clip() {
    difference() {
        // 1. Create the solid base profile extruded in Z
        union() {
            // Rod Ring
            difference() {
                cylinder(
                    h = $height,
                    d = $rod_od,
                    center = $rod_center
                );
                // Cutout on -X side for rod snap
                translate([-($cutout_rod_width/2), 0, 0]) {
                    cube([
                        $cutout_rod_width, 
                        $cutout_rod_height, 
                        $height + 0.1
                    ]);
                }
            }
            
            // Tubing Ring
            difference() {
                translate($tube_center) {
                    cylinder(
                        h = $height,
                        d = $tube_od,
                        center = [0, 0, 0]
                    );
                }
                // Cutout on +X side for tubing snap
                translate([($cutout_tube_width/2), 0, 0]) {
                    translate($tube_center) {
                        cube([
                            $cutout_tube_width, 
                            $cutout_tube_height, 
                            $height + 0.1
                        ]);
                    }
                }
            }
            
            // Solid Bridge
            // Positioned between x=8 and x=12, centered at y=0
            translate([8, 0, 0]) {
                cube([
                    $bridge_width_x, 
                    $bridge_height_y, 
                    $height + 0.1
                ]);
            }
        }
        
        // 2. Cutouts to ensure clean separation and proper fit
        // Extend cuts slightly past the faces (Z direction) to ensure no coplanar faces
        
        // Cutout Rod Ring (-X side)
        translate([-($cutout_rod_width/2), 0, 0]) {
            cube([
                $cutout_rod_width + 0.1, 
                $cutout_rod_height + 0.1, 
                $height + 0.1
            ]);
        }
        
        // Cutout Tubing Ring (+X side)
        translate([($cutout_tube_width/2), 0, 0]) {
            translate($tube_center) {
                cube([
                    $cutout_tube_width + 0.1, 
                    $cutout_tube_height + 0.1, 
                    $height + 0.1
                ]);
            }
        }
        
        // Optional: Small clearance cutouts on the inner faces of the rings 
        // to ensure the rod and tube slide in easily without friction from the print surface
        // Rod Inner Face Cutout
        translate([-($rod_id/2) + 0.1, 0, 0]) {
            cube([
                $rod_id - 0.2, 
                $height + 0.1, 
                $height + 0.1
            ]);
        }
        
        // Tubing Inner Face Cutout
        translate($tube_center) {
            translate([($tube_id/2) - 0.1, 0, 0]) {
                cube([
                    $tube_id - 0.2, 
                    $height + 0.1, 
                    $height + 0.1
                ]);
            }
        }
    }
}