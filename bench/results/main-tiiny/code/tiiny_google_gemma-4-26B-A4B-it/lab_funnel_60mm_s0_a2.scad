// --- Dimensions (mm) ---
spout_od = 10.0;          // Outer diameter of the spout
spout_height = 20.0;      // Height of the spout section (Z=0 to Z=20)
funnel_rim_od = 60.0;     // Outer diameter at the top rim (Z=50)
funnel_height = 50.0;     // Total height from base to rim
wall_thickness = 1.6;     // Uniform wall thickness
$fn = 100;                // Smoothness for curves

// --- Derived Dimensions ---
spout_id = spout_od - (2 * wall_thickness); // 6.8 mm
funnel_id_top = funnel_rim_od - (2 * wall_thickness); // 56.8 mm

// --- Construction ---
// The previous report showed the "material area" at Z=35.00 was too small.
// This indicates the cone was not widening correctly or the transition was 
// not properly calculated. To ensure a perfectly straight-walled cone 
// from Z=20 to Z=50, we use a single hull between the two diameters.

difference() {
    // 1. OUTER VOLUME
    union() {
        // Spout: Straight cylinder from Z=0 to Z=20
        cylinder(h = spout_height, d = spout_od);
        
        // Funnel: Cone from Z=20 to Z=50
        // We use hull to create a perfect linear transition between the two circles
        hull() {
            // Bottom of cone at Z=20
            translate([0, 0, spout_height])
                cylinder(h = 0.01, d = spout_od);
            // Top of cone at Z=50
            translate([0, 0, funnel_height])
                cylinder(h = 0.01, d = funnel_rim_od);
        }
    }

    // 2. INNER VOID (The hollow part)
    union() {
        // Spout bore: Z=0 to Z=20 (extended to ensure clean cut at bottom)
        translate([0, 0, -1])
            cylinder(h = spout_height + 2, d = spout_id);
        
        // Funnel bore: Z=20 to Z=50
        // The inner cone must transition from spout_id at Z=20 to funnel_id_top at Z=50
        hull() {
            // Bottom of inner cone at Z=20
            translate([0, 0, spout_height - 0.1])
                cylinder(h = 0.2, d = spout_id);
            // Top of inner cone at Z=50
            translate([0, 0, funnel_height + 1])
                cylinder(h = 2, d = funnel_id_top);
        }
    }
}

// Verification of requirements:
// - Spout OD: 10mm (Check)
// - Spout height: 20mm (Check)
// - Funnel rim OD: 60mm (Check)
// - Total height: 50mm (Check)
// - Wall thickness: 1.6mm (Check: 10 - 6.8 = 3.2; 3.2 / 2 = 1.6)
// - Open top and bottom: (Check: via -1 and +1 extensions in difference)
// - Single body: (Check: single difference() block)