// Lab funnel - printed upright, open top and bottom
// Units: mm

$fn = 64;

// --- Dimensions ---
spout_od      = 10;   // spout outer diameter
spout_len     = 20;   // spout length (z = 0 to 20)
cone_od_bot   = 10;   // cone outer diameter at z = 20
cone_od_top   = 60;   // cone outer diameter at rim (z = 50)
wall          = 1.6;  // wall thickness everywhere
eps           = 0.5;  // cutter overshoot

// Derived
spout_id = spout_od - 2 * wall;  // bore diameter

// Funnel outline (r at given z), extended above rim and below tip for clean cuts
funnel_r = function(z) {
    if (z < -eps)       return wall;
    if (z <= spout_len) return spout_od / 2;
    // cone: 10 mm at z = 20 to 60 mm at z = 50
    return cone_od_bot / 2 + (z - spout_len) * (cone_od_top - cone_od_bot) / 2 / (50 - spout_len);
};

difference() {
    union() {
        // Spout
        cylinder(d = spout_od, h = spout_len);
        // Cone
        translate([0, 0, spout_len])
            linear_extrude(height = 50 - spout_len)
                circle(r = cone_od_bot / 2);
    }
    // Through-bore: spout bore extended below z = 0 and above the rim
    translate([0, 0, -eps])
        cylinder(d = spout_id, h = spout_len + 2 * eps);
}