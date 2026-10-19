// Snap-on clip for 12.7mm rod and 6mm tubing
// Designed for FDM printing: printed flat on the XY plane.

// --- Dimensions ---
rod_id       = 12.7;    // Inner diameter of the rod ring
rod_wall     = 3.0;     // Wall thickness of the rod ring
rod_od       = rod_id + 2 * rod_wall; // Outer diameter of the rod ring
rod_gap_w    = 10.0;    // Width of the gap in the rod ring
rod_gap_h    = 10.0;    // Height of the gap in the rod ring (total span)

tube_id      = 6.0;     // Inner diameter of the tubing ring
tube_wall    = 2.0;     // Wall thickness of the tubing ring
tube_od      = tube_id + 2 * tube_wall; // Outer diameter of the tubing ring
tube_gap_w   = 4.5;     // Width of the gap in the tubing ring
tube_gap_h   = 4.5;     // Height of the gap in the tubing ring (total span)

tube_offset_x = 15.0;   // X-coordinate of the tubing ring center
bridge_w_y    = 6.0;    // Width of the bridge in the Y direction
bridge_x_start = 8.0;   // Start of the bridge in X
bridge_x_end   = 12.0;  // End of the bridge in X

extrusion_z   = 10.0;   // Height of the part (Z)

$fn = 64;

// --- Geometry Construction ---

// 1. The Rod Ring Profile (2D)
// Centered at (0,0). We create a circle and subtract the gap.
module rod_ring_profile() {
    difference() {
        circle(d = rod_od);
        // The gap is on the -X side. 
        // Everything with x < 0 and -5 < y < 5 is removed.
        // We use a rectangle to define the cutout.
        // To ensure a clean cut, we make the rectangle slightly larger.
        translate([-rod_od, -rod_gap_h/2 - 0.1]) 
            square([rod_od + 1, rod_gap_h]);
    }
}

// 2. The Tubing Ring Profile (2D)
// Centered at (15, 0). Gap is on the +X side.
module tubing_ring_profile() {
    translate([tube_offset_x, 0]) {
        difference() {
            circle(d = tube_od);
            // The gap is on the +X side.
            // Everything with x > 15 and -2.25 < y < 2.25 is removed.
            // Relative to the center (15,0), this is x > 0 and -2.25 < y < 2.25.
            translate([0, -tube_gap_h/2 - 0.1]) 
                square([tube_od + 1, tube_gap_h]);
        }
    }
}

// 3. The Bridge Profile (2D)
// A solid rectangle between x=8 and x=12, with width 6mm in Y.
module bridge_profile() {
    translate([bridge_x_start, -bridge_w_y/2])
        square([bridge_x_end - bridge_x_start, bridge_w_y]);
}

// --- Final Assembly ---

// We union the 2D profiles and then extrude them to Z height.
// We use a difference to ensure the internal holes are actually holes.
// However, the prompt asks for a "solid bridge" and "rings".
// The most robust way is to union the ring outlines and the bridge, 
// then subtract the inner diameters.

difference() {
    // The outer boundary of the whole part
    linear_extrude(height = extrusion_z) {
        union() {
            // Rod ring outer boundary
            difference() {
                circle(d = rod_od);
                // Subtract the gap from the rod ring
                translate([-rod_od, -rod_gap_h/2 - 0.1]) 
                    square([rod_od + 1, rod_gap_h]);
            }
            
            // Tubing ring outer boundary
            translate([tube_offset_x, 0]) {
                difference() {
                    circle(d = tube_od);
                    // Subtract the gap from the tubing ring
                    translate([0, -tube_gap_h/2 - 0.1]) 
                        square([tube_od + 1, tube_gap_h]);
                }
            }
            
            // The bridge
            bridge_profile();
        }
    }

    // Subtract the inner holes to make them actual holes
    // Rod hole
    translate([0, 0, -0.1])
        cylinder(h = extrusion_z + 0.2, d = rod_id);
    
    // Tubing hole
    translate([tube_offset_x, 0, -0.1])
        cylinder(h = extrusion_z + 0.2, d = tube_id);
}