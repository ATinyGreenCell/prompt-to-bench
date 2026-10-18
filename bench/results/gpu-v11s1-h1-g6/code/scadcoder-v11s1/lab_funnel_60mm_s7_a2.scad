// Small lab funnel, printed upright: spout at the bottom, wide opening at the top
// All dimensions in mm

$fn = 128;

// ---- Spout ----
spout_od      = 10;    // spout outer diameter
spout_id      = spout_od - 2 * 1.6;   // spout bore = 6.8 mm
spout_h       = 20;    // spout height (z = 0 to 20)

// ---- Cone ----
cone_od_top   = 60;    // cone outer diameter at the rim (z = 50)
cone_od_base  = spout_od;              // cone outer diameter where it meets the spout (z = 20)
cone_h        = 50 - 20;               // cone height = 30 mm

// ---- Wall ----
wall          = 1.6;   // uniform wall thickness

// ---- Model ----
difference() {
    union() {
        // Spout tube
        translate([0, 0, 0])
            cylinder(d = spout_od, h = spout_h);
        // Cone (overlaps slightly into the spout for a clean union)
        translate([0, 0, spout_h - 0.01])
            cylinder(d1 = cone_od_base, d2 = cone_od_top, h = cone_h + 0.01);
    }
    // Through-bore from the bottom up past the rim
    translate([0, 0, -1])
        cylinder(d = spout_id, h = spout_h + cone_h + 2);
}