// Dimensions
rod_id = 12.7;          // Inner diameter of the rod ring
rod_wall = 3;           // Wall thickness of the rod ring
rod_od = rod_id + 2 * rod_wall; // Outer diameter of the rod ring

tube_id = 6.0;          // Inner diameter of the tubing ring
tube_wall = 2.0;        // Wall thickness of the tubing ring
tube_od = tube_id + 2 * tube_wall; // Outer diameter of the tubing ring

rod_center_x = 0;       // X position of the rod ring center
rod_center_y = 0;       // Y position of the rod ring center

tube_center_x = 15;     // X position of the tubing ring center
tube_center_y = 0;      // Y position of the tubing ring center

bridge_start_x = 8;     // Start X of the solid bridge
bridge_end_x = 12;      // End X of the solid bridge
bridge_width = 6;       // Width (Y) of the solid bridge

print_height = 10;      // Extrusion height (Z)

// Calculated parameters for boolean operations
rod_inner_r = rod_id / 2;
rod_outer_r = rod_od / 2;
tube_inner_r = tube_id / 2;
tube_outer_r = tube_od / 2;

// Opening dimensions
// Rod ring: 10 mm wide opening on -X side.
// The cut removes everything with x < 0 and -5 < y < 5.
// To ensure clean boolean subtraction, we make the cutter slightly larger.
rod_cut_width = 10.02;  // Slightly wider than 10 to ensure full cut
rod_cut_height = 10.02; // Slightly taller than 10 to ensure full cut (covers -5 to 5)
rod_cut_depth = 20;     // Depth to ensure it cuts through the ring thickness

// Tubing ring: 4.5 mm wide opening on +X side.
// The cut removes everything with x > 15 and -2.25 < y < 2.25.
// Center of the cut in local coordinates of the tube ring:
// The cut is on the +X side. The center of the ring is at (15,0).
// The cut is defined in global coordinates: x > 15.
// Let's define the cutter in global coordinates to be precise.
tube_cut_x_start = 15.01; // Start just past 15
tube_cut_x_end = tube_center_x + tube_outer_r + 1; // Extend past the outer edge
tube_cut_y_start = -2.26; // Slightly wider than 2.25
tube_cut_y_end = 2.26;
tube_cut_z_depth = 20;

// Bridge dimensions
// Solid bridge between x=8 and x=12, width 6mm (Y).
// It joins the two rings.
// We need to ensure it doesn't block the holes.
// The rod ring hole is radius 6.35. At x=8, y=0, the rod ring material exists.
// The tubing ring hole is radius 3. At x=15, y=0, the tubing ring material exists.
// The bridge is solid. We must subtract the inner holes of the rings from the bridge area if it overlaps,
// but the problem states "without blocking either ring's hole".
// Since the bridge is between x=8 and x=12, it does not overlap the rod ring hole (radius 6.35, ends at x=6.35)
// nor the tubing ring hole (radius 3, center 15, starts at x=12).
// Wait, the tubing ring hole is at x=15, radius 3. So the hole extends from x=12 to x=18.
// The bridge ends at x=12. So the bridge touches the edge of the tubing ring hole.
// The rod ring hole is at x=0, radius 6.35. The bridge starts at x=8. So the bridge is outside the rod ring hole.
// So the bridge itself is solid and does not intersect the holes.
// However, we need to subtract the bridge from the rings to merge them?
// No, the bridge is a solid part joining them. We can model the rings and the bridge as separate solids and union them,
// then subtract the openings.

// Let's build the base profile in XY plane, then extrude.

module rod_ring() {
    // Create a torus-like shape using difference of two cylinders
    // Outer cylinder
    difference() {
        cylinder(r = rod_outer_r, h = 1, center = true);
        // Inner hole
        cylinder(r = rod_inner_r, h = 1.02, center = true);
    }
}

module tube_ring() {
    difference() {
        cylinder(r = tube_outer_r, h = 1, center = true);
        // Inner hole
        cylinder(r = tube_inner_r, h = 1.02, center = true);
    }
}

module bridge() {
    // Solid bridge between x=8 and x=12, width 6mm (Y from -3 to 3)
    // Height 1 for profile
    translate([ (bridge_start_x + bridge_end_x)/2, 0, 0 ]) {
        cube([bridge_end_x - bridge_start_x, bridge_width, 1], center = true);
    }
}

// Main profile
module profile() {
    union() {
        // Rod ring
        translate([rod_center_x, rod_center_y, 0]) {
            rod_ring();
        }
        
        // Tubing ring
        translate([tube_center_x, tube_center_y, 0]) {
            tube_ring();
        }
        
        // Bridge
        bridge();
    }
}

// Final part
module snap_clip() {
    // Create the base profile
    base = profile();
    
    // Subtract rod ring opening
    // Cut: x < 0, -5 < y < 5
    // We use a cube cutter
    rod_cut = cube([rod_cut_width, rod_cut_height, rod_cut_depth], center = true);
    // Position the cut: x < 0, -5 < y < 5
    // The cube is centered at (0,0). Its x range is [-5.01, 5.01].
    // We want to remove x < 0. So we should shift the cube to the left?
    // No, the cut is "everything with x < 0 and -5 < y < 5".
    // A cube centered at (0,0) covers x from -5.01 to 5.01.
    // If we subtract this cube, we remove x from -5.01 to 5.01.
    // We only want to remove x < 0.
    // So we need a cutter that covers x < 0 and -5 < y < 5.
    // Let's make a cube that covers x from -10 to 0, and y from -5 to 5.
    // To make it easy, let's use a cube centered at (-5, 0) with width 10.02 and height 10.02.
    // This covers x from -10.01 to 0.01, y from -5.01 to 5.01.
    // This effectively removes everything with x < 0 (and a bit more) and -5 < y < 5.
    
    rod_opening_cut = translate([-rod_cut_width/2, 0, 0]) {
        cube([rod_cut_width, rod_cut_height, rod_cut_depth], center = true);
    };
    
    // Subtract rod opening
    base_with_rod_cut = difference() {
        base;
        rod_opening_cut;
    };
    
    // Subtract tubing ring opening
    // Cut: x > 15, -2.25 < y < 2.25
    // We use a cube cutter.
    // Let's make a cube that covers x from 15 to 25, and y from -2.25 to 2.25.
    // Center at (20, 0). Width 10.02, Height 4.52.
    // This covers x from 15.01 to 25.01, y from -2.26 to 2.26.
    // This effectively removes everything with x > 15 (and a bit more) and -2.25 < y < 2.25.
    
    tube_opening_cut = translate([tube_center_x + (tube_cut_x_end - tube_cut_x_start)/2, 0, 0]) {
        cube([tube_cut_x_end - tube_cut_x_start, tube_cut_y_end - tube_cut_y_start, tube_cut_z_depth], center = true);
    };
    
    // Calculate cutter dimensions