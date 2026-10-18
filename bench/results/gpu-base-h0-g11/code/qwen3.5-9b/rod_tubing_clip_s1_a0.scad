// Snap-on Clip for Lab Stand Rod and Tubing
// Orientation: Flat on XY plane, building upward (+Z)
// Units: Millimetres

// --- Dimensions ---
// Rod Ring
$rod_inner_d = 12.7;   // Inner diameter for 1/2" rod
$rod_wall = 3;         // Wall thickness
$rod_outer_d = $rod_inner_d + 2 * $rod_wall; // 18.7 mm
$rod_height = 10;      // Extrusion height (Z)
$rod_cut_width = 10;   // Width of opening on -X side

// Tubing Ring
$tube_inner_d = 6;     // Inner diameter
$tube_wall = 2;        // Wall thickness
$tube_outer_d = $tube_inner_d + 2 * $tube_wall; // 10 mm
$tube_x_pos = 15;      // Center X position
$tube_cut_width = 4.5; // Width of opening on +X side

// Bridge
$bridge_width_x = 4;   // Width in X (from 8 to 12)
$bridge_height_y = 6;  // Height in Y
$bridge_z = $rod_height; // Same height as extrusion

// --- Configuration ---
$fn = 128;             // High resolution for smooth curves

// --- Main Body Construction ---
difference() {
    // 1. Create the solid extrusion of the 2D profile
    union() {
        // Rod Ring
        translate([0, 0, 0]) {
            difference() {
                // Outer Ring
                cylinder(h = $rod_height, d = $rod_outer_d, center = [0, 0, $rod_height/2]);
                
                // Inner Hole (Rod passes through)
                cylinder(h = $rod_height, d = $rod_inner_d, center = [0, 0, $rod_height/2]);
                
                // Cutout on -X side (Opening)
                // Defined as a rectangular prism to cut through the ring
                translate([-($rod_outer_d/2) + ($rod_cut_width/2), 0, 0]) {
                    cube([
                        $rod_cut_width, 
                        $rod_outer_d, 
                        $rod_height + 0.1
                    ]);
                }
            }
        }
        
        // Tubing Ring
        translate([$tube_x_pos, 0, 0]) {
            difference() {
                // Outer Ring
                cylinder(h = $rod_height, d = $tube_outer_d, center = [0, 0, $rod_height/2]);
                
                // Inner Hole (Tubing passes through)
                cylinder(h = $rod_height, d = $tube_inner_d, center = [0, 0, $rod_height/2]);
                
                // Cutout on +X side (Opening)
                translate([$tube_cut_width/2, 0, 0]) {
                    cube([
                        $tube_cut_width, 
                        $tube_outer_d, 
                        $rod_height + 0.1
                    ]);
                }
            }
        }
        
        // Solid Bridge
        translate([$bridge_width_x/2, 0, 0]) {
            cube([
                $bridge_width_x, 
                $bridge_height_y, 
                $rod_height
            ]);
        }
    }
    
    // 2. Cutouts to ensure clean separation and fit (Offset by 0.1mm)
    
    // Cutout for Rod Ring Opening
    translate([-($rod_outer_d/2) + ($rod_cut_width/2), 0, 0]) {
        cube([
            $rod_cut_width + 0.1, 
            $rod_outer_d + 0.1, 
            $rod_height + 0.1
        ]);
    }
    
    // Cutout for Tubing Ring Opening
    translate([$tube_x_pos + $tube_cut_width/2, 0, 0]) {
        cube([
            $tube_cut_width + 0.1, 
            $tube_outer_d + 0.1, 
            $rod_height + 0.1
        ]);
    }
    
    // Cutout for Rod Inner Hole
    translate([0, 0, 0]) {
        cylinder(h = $rod_height + 0.1, d = $rod_inner_d + 0.1, center = [0, 0, $rod_height/2]);
    }
    
    // Cutout for Tubing Inner Hole
    translate([$tube_x_pos, 0, 0]) {
        cylinder(h = $rod_height + 0.1, d = $tube_inner_d + 0.1, center = [0, 0, $rod_height/2]);
    }
}