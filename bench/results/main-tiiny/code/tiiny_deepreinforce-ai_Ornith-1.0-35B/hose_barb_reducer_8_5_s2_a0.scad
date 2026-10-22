// Hose-barb reducer: 8mm ID to 5mm ID silicone tubing
// Print orientation: upright on XY plane, builds in +Z

// --- Overall dimensions ---
total_height = 41;            // Total height of the part
bore_diameter = 3;            // Through-bore diameter
collar_diameter = 12;         // Middle collar OD
collar_height = 5;            // Collar height (z=20 to z=25)

// --- Large end (8mm tubing) barbs ---
large_barb_height = 10;       // Height of each large barb
large_barb_bottom_od = 7.5;   // OD at bottom of large barb
large_barb_top_od = 9.5;      // OD at top of large barb (before step back)
large_barb_count = 2;         // Number of stacked large barbs
large_end_bottom_z = 0;       // Start Z of large end

// --- Small end (5mm tubing) barbs ---
small_barb_height = 8;        // Height of each small barb
small_barb_bottom_od = 6.5;   // OD at bottom of small barb
small_barb_top_od = 5.0;      // OD at top of small barb (before step back)
small_barb_count = 2;         // Number of stacked small barbs
small_end_top_z = 41;         // End Z of small end

// --- Derived ---
large_end_top_z = large_end_bottom_z + large_barb_count * large_barb_height;  // z=20
small_end_bottom_z = small_end_top_z - small_barb_count * small_barb_height;  // z=25

// --- Helper: single barb as a union of two cylinders (sawtooth profile) ---
// The barb has OD growing linearly from bottom_od to top_od over barb_height,
// then steps back. We model this as two stacked cylinders:
//   - Bottom cylinder: OD = bottom_od, height = barb_height/2
//   - Top cylinder: OD = top_od, height = barb_height/2
// This approximates the linear ramp with a step, which is acceptable for 3D printing.
// However, to better approximate the linear ramp, we can use more segments.
// For simplicity and given the rules, we'll use two segments per barb.

module single_barb(bottom_od, top_od, height) {
    half_h = height / 2;
    // Bottom segment: OD = bottom_od
    cylinder(d = bottom_od, h = half_h, $fn = 64);
    // Top segment: OD = top_od
    translate([0, 0, half_h])
        cylinder(d = top_od, h = half_h, $fn = 64);
}

// --- Build the part ---
difference() {
    union() {
        // Large end barbs (z=0 to z=20)
        for (i = [0 : large_barb_count - 1]) {
            z_offset = i * large_barb_height;
            translate([0, 0, z_offset])
                single_barb(large_barb_bottom_od, large_barb_top_od, large_barb_height);
        }
        
        // Collar (z=20 to z=25)
        translate([0, 0, large_end_top_z])
            cylinder(d = collar_diameter, h = collar_height, $fn = 64);
        
        // Small end barbs (z=25 to z=41)
        for (i = [0 : small_barb_count - 1]) {
            z_offset = small_end_bottom_z + i * small_barb_height;
            translate([0, 0, z_offset])
                single_barb(small_barb_bottom_od, small_barb_top_od, small_barb_height);
        }
    }
    
    // Through-bore (extend slightly past faces to avoid coplanar surfaces)
    bore_radius = bore_diameter / 2;
    cylinder(d = bore_diameter, h = total_height + 0.01, $fn = 64);
}