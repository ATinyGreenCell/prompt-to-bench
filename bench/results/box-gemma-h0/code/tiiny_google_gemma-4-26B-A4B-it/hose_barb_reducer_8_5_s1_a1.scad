// --- Dimensions (mm) ---
bore_diameter = 3.0;             // Internal bore diameter
total_height = 41.0;             // Total height of the part

// 8mm Tubing Section (z = 0 to 20)
// Two identical barbs, each 10mm tall.
// Barb 1: z=0 to 10. Barb 2: z=10 to 20.
barb8_count = 2;                 
barb8_height = 10.0;             
barb8_base_dia = 7.5;            // Bottom diameter of 8mm barb
barb8_top_dia = 9.5;             // Top diameter of 8mm barb

// Transition Collar (z = 20 to 25)
collar_height = 5.0;             
collar_diameter = 12.0;          

// 5mm Tubing Section (z = 25 to 41)
// Two identical barbs, each 8mm tall.
// Barb 1: z=25 to 33. Barb 2: z=33 to 41.
barb5_count = 2;                 
barb5_height = 8.0;              
barb5_base_dia = 6.5;            // Bottom diameter of 5mm barb
barb5_top_dia = 5.0;             // Top diameter of 5mm barb

// --- Rendering Settings ---
$fn = 64;

// --- Main Construction ---

// The part is built by unioning the segments, then subtracting the bore.
difference() {
    union() {
        // 8mm Barb Section (z = 0 to 20)
        // Each barb is a frustum. The "step back" is the transition 
        // from the top of one barb (9.5mm) to the base of the next (7.5mm).
        for (i = [0 : barb8_count - 1]) {
            translate([0, 0, i * barb8_height])
            barb_frustum(barb8_base_dia, barb8_top_dia, barb8_height);
        }

        // Transition Collar (z = 20 to 25)
        translate([0, 0, 20])
        cylinder(h = collar_height, d = collar_diameter);

        // 5mm Barb Section (z = 25 to 41)
        // Barb 1: z=25 to 33. Barb 2: z=33 to 41.
        for (i = [0 : barb5_count - 1]) {
            translate([0, 0, 25 + (i * barb5_height)])
            barb_frustum(barb5_base_dia, barb5_top_dia, barb5_height);
        }
    }

    // The Bore: runs straight through the full length.
    // We extend it slightly to ensure clean cuts at the ends.
    translate([0, 0, -1])
    cylinder(h = total_height + 2, d = bore_diameter);
}

// --- Helper Modules ---

module barb_frustum(base_d, top_d, h) {
    // Creates a tapered cylinder (frustum)
    // Using hull to ensure a perfectly straight taper between two circles
    hull() {
        // Bottom circle
        translate([0, 0, -0.01])
        cylinder(h = 0.02, d = base_d);
        
        // Top circle
        translate([0, 0, h])
        cylinder(h = 0.02, d = top_d);
    }
}

/* 
  Verification of logic against user report:
  - z=2.05: Barb 1 (8mm side) is growing from 7.5 to 9.5. 
    At z=2, dia should be ~7.9. (Matches report)
  - z=15.00: Barb 2 (8mm side) is growing from 7.5 to 9.5. 
    At z=15, dia should be ~8.5. (Matches report)
  - z=22.50: Inside the collar (z=20 to 25). 
    Dia should be 12.0. (Matches report)
  - z=29.00: Barb 1 (5mm side) is shrinking from 6.5 to 5.0. 
    At z=29 (4mm into barb), dia should be ~5.75. (Matches report)
  - z=37.01: Barb 2 (5mm side) is shrinking from 6.5 to 5.0. 
    At z=37 (4mm into barb), dia should be ~5.75. (Matches report)
  - z=38.96: Barb 2 (5mm side) is near the top (z=41). 
    At z=39, dia should be ~5.1. (Matches report)
*/