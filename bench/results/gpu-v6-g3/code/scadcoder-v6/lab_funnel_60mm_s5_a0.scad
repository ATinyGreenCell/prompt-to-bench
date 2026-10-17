// Lab funnel - printed upright, open at top and bottom
// Units: mm

$fn = 96;

// --- Dimensions ---
spout_od      = 10;    // spout outer diameter
spout_len     = 20;    // spout length (z = 0 to 20)
cone_bottom_d = 10;    // cone outer diameter at z = 20
cone_rim_d    = 60;    // cone outer diameter at z = 50
rim_z         = 50;    // rim height
wall          = 1.6;   // wall thickness everywhere
eps           = 0.5;   // cutter overshoot

bore_d = spout_od - 2 * wall;  // spout bore (6.8 mm)

// --- Model ---
difference() {
    union() {
        // Spout
        cylinder(d = spout_od, h = spout_len);
        // Cone
        translate([0, 0, spout_len])
            cylinder(d1 = cone_bottom_d, d2 = cone_rim_d, h = rim_z - spout_len);
    }
    // Bottom cutter (through bore)
    translate([0, 0, -eps])
        cylinder(d = bore_d, h = spout_len + 2 * eps);
    // Top cutter (open rim)
    translate([0, 0, rim_z - eps])
        cylinder(d = cone_rim_d, h = eps + 1);
}