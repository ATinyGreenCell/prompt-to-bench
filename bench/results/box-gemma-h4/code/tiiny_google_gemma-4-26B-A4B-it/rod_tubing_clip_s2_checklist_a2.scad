// Snap-on clip for 12.7mm lab rod and 6mm tubing
// Corrected version: Uses a single 2D profile extruded to 3D to avoid mixing 2D/3D errors.
// The part is printed flat on the XY plane (Z=0 to Z=10).

// --- Dimensions ---
rod_id      = 12.7;    // Inner diameter of the rod ring
rod_wall    = 3.0;     // Wall thickness of the rod ring
rod_od      = rod_id + 2 * rod_wall; 

rod_gap_w   = 10.0;    // Width of the opening in the rod ring
rod_gap_h   = 10.0;    // Height of the opening in the rod ring

tube_id     = 6.0;     // Inner diameter of the tubing ring
tube_wall   = 2.0;     // Wall thickness of the tubing ring
tube_od     = tube_id + 2 * tube_wall; 

tube_gap_w  = 4.5;     // Width of the opening in the tubing ring
tube_gap_h  = 4.5;     // Height of the opening in the tubing ring

tube_offset_x = 15.0;  // X-coordinate of the tubing ring center
bridge_w_y    = 6.0;   // Width of the bridge in the Y direction
bridge_x_start = 8.0;   // Start of the bridge in X
bridge_x_end   = 12.0;  // End of the bridge in X

extrusion_z = 10.0;    // Total height of the part (Z)

$fn = 64;

// --- Geometry Construction ---

// We define the entire cross-section in 2D first.
// This ensures a single watertight solid and avoids "Mixing 2D and 3D" errors.
module profile_2d() {
    difference() {
        // 1. The Main Body (Union of Rod Ring, Tube Ring, and Bridge)
        union() {
            // Rod Ring Profile
            difference() {
                circle(d = rod_od);
                circle(d = rod_id);
            }
            
            // Tube Ring Profile
            translate([tube_offset_x, 0])
            difference() {
                circle(d = tube_od);
                circle(d = tube_id);
            }
            
            // Bridge Profile
            // Centered on Y, so Y goes from -3 to 3
            translate([bridge_x_start, -bridge_w_y/2])
            square([bridge_x_end - bridge_x_start, bridge_w_y]);
        }
        
        // 2. Subtractions (Gaps)
        
        // Rod gap: everything with x < 0 and -5 < y < 5 is removed
        // We extend the square slightly to ensure a clean cut through the ring
        translate([-rod_od, -5])
        square([rod_od, 10]);
        
        // Tube gap: everything with x > 15 and -2.25 < y < 2.25 is removed
        // We extend the square slightly to ensure a clean cut through the ring
        translate([tube_offset_x, -2.25])
        square([tube_gap_w + 1, 4.5]);
    }
}

// Final Render:
// Extrude the 2D profile to the required height Z.
// This results in a 3D object that sits on the XY plane at Z=0.
linear_extrude(height = extrusion_z) {
    profile_2d();
}