// Straight hose-barb reducer
// Designed for 8mm and 5mm ID tubing with a 3mm central bore.

// --- Dimensions ---
bore_d = 3.0;               // Central bore diameter
barb8_h = 10.0;            // Height of one 8mm barb segment
barb8_d_bot = 7.5;         // Bottom diameter of 8mm barb
barb8_d_top = 9.5;         // Top diameter of 8mm barb
collar_d = 12.0;           // Diameter of the middle collar
collar_h = 5.0;            // Height of the middle collar (25 - 20)
barb5_h = 8.0;             // Height of one 5mm barb segment
barb5_d_bot = 6.5;         // Bottom diameter of 5mm barb
barb5_d_top = 5.0;         // Top diameter of 5mm barb

// --- Derived Geometry ---
// Total height calculation:
// 8mm section: 2 barbs * 10mm = 20mm (z=0 to 20)
// Collar: 5mm (z=20 to 25)
// 5mm section: 2 barbs * 8mm = 16mm (z=25 to 41)
total_h = 41.0;

$fn = 64;

// --- Modules ---

// A single barb segment using a cone/cylinder approach
// type 1: grows from d_bot to d_top then steps back to d_bot
// type 2: shrinks from d_bot to d_top then steps back to d_bot
module barb_segment(h, d_start, d_end, is_growing) {
    if (is_growing) {
        // Grows from d_start to d_end
        cylinder(h = h, d1 = d_start, d2 = d_end);
        // Step back to d_start (the "sawtooth" base)
        translate([0, 0, 0]) cylinder(h = 0.01, d = d_start); 
    } else {
        // Shrinks from d_start to d_end
        cylinder(h = h, d1 = d_start, d2 = d_end);
    }
}

// Corrected Barb Segment to match "step straight back" description
module barb_profile(h, d_bot, d_top, growing) {
    // The barb is a frustum (cone)
    // "then steps straight back to [original diameter]" implies the base of the next barb
    // or the shoulder of the current one is the original diameter.
    // We model the frustum part.
    cylinder(h = h, d1 = d_bot, d2 = d_top);
}

module barb8_stack() {
    // Two identical barbs, each 10mm tall
    // Barb 1: z=0 to 10, Barb 2: z=10 to 20
    for (z_offset = [0, 10]) {
        translate([0, 0, z_offset])
        cylinder(h = 10, d1 = 7.5, d2 = 9.5);
    }
}

module barb5_stack() {
    // Two identical barbs, each 8mm tall
    // Barb 1: z=25 to 33, Barb 2: z=33 to 41
    for (z_offset = [0, 8]) {
        translate([0, 0, z_offset])
        cylinder(h = 8, d1 = 6.5, d2 = 5.0);
    }
}

// --- Main Assembly ---

difference() {
    union() {
        // 8mm Barb Section (z=0 to 20)
        barb8_stack();
        
        // Collar Section (z=20 to 25)
        translate([0, 0, 20])
        cylinder(h = 5, d = 12);
        
        // 5mm Barb Section (z=25 to 41)
        translate([0, 0, 25])
        barb5_stack();
    }
    
    // Central Bore (runs through full length)
    // We extend the cylinder slightly to ensure a clean cut
    translate([0, 0, -1])
    cylinder(h = total_h + 2, d = bore_d);
}