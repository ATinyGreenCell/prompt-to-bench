// Lab funnel - printed upright, wide opening at top
// Units: mm

$fn = 64;

// --- Dimensions ---
spout_od      = 10;   // spout outer diameter
spout_h       = 20;   // spout height (z = 0 to 20)
spout_bore    = 6.8;  // spout bore (od 10, wall 1.6)

cone_od_bottom = 10;  // cone outer diameter at z = 20
cone_od_top    = 60;  // cone outer diameter at rim (z = 50)
cone_h        = 30;   // cone height (z = 20 to 50)

wall          = 1.6;  // wall thickness everywhere

// --- Derived ---
spout_r_out   = spout_od / 2;
spout_r_in    = spout_bore / 2;
cone_r_bottom = cone_od_bottom / 2;
cone_r_top    = cone_od_top / 2;

// --- Model ---
difference() {
    union() {
        // Spout
        cylinder(h = spout_h, r = spout_r_out);

        // Cone (slightly overlapping spout for a clean union)
        translate([0, 0, spout_h - 0.01])
            linear_extrude(height = cone_h + 0.01)
                circle(r = cone_r_bottom);

        // Rim
        translate([0, 0, spout_h + cone_h])
            circle(r = cone_r_top);
    }

    // Through-bore from bottom up to rim height
    translate([0, 0, -1])
        cylinder(h = spout_h + cone_h + 2, r = spout_r_in);
}