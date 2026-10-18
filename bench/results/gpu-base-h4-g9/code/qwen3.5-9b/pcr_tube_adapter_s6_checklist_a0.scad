// Adapter sleeve for 0.2 mL PCR tube in 1.5 mL rack.
// Prints upside down: collar on bed (z=0 to 1.5), body rises to z=21.5.

// Dimensions
collar_od = 13;
collar_t  = 1.5;
body_od   = 10.8;
body_h    = 21.5;
bore_d    = 6.2;

$fn = 64;

// Build the part in the requested orientation:
// 1. Collar sits on XY plane (z=0 to z=1.5).
// 2. Body rises from the top of the collar (z=1.5) to z=21.5.
// 3. Bore runs through the full height.

difference() {
    union() {
        // --- Collar (on the bed) ---
        // Outer cylinder: 13mm diameter, 1.5mm height, centered on origin.
        translate([0, 0, 0]) 
            cylinder(h = collar_t, d = collar_od);
        
        // --- Body (rising from collar) ---
        // Outer cylinder: 10.8mm diameter, height from 1.5 to 21.5 (total 20mm).
        // Positioned so bottom is at z=1.5.
        translate([0, 0, collar_t]) 
            cylinder(h = body_h - collar_t, d = body_od);
    }
    
    // --- Bore ---
    // Hole running through the full height (0 to 21.5).
    // Extend slightly past the top to ensure clean cut.
    translate([0, 0, -1]) 
        cylinder(h = body_h + collar_t + 2, d = bore_d);
}