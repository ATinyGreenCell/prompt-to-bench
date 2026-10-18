// Small lab funnel, printed upright with the wide opening at the top
// Units: mm

$fn = 96;

// ---- Spout ----
spout_od      = 10;    // outer diameter of straight spout
spout_len     = 20;    // length of spout (z = 0 to z = 20)
spout_wall    = 1.6;   // wall thickness of spout
spout_id      = spout_od - 2 * spout_wall; // bore diameter (6.8 mm)

// ---- Cone ----
cone_top_od   = 60;    // outer diameter at rim (z = 50)
cone_bottom_od = 10;   // outer diameter where cone meets spout (z = 20)
cone_h        = 30;    // cone height (z = 20 to z = 50)

// ---- Join ----
overlap       = 0.5;   // spout extends into cone to fuse solids

// ---- Cut ----
cut_ext       = 0.5;   // extension of bore cut past faces

difference() {
    union() {
        // Spout
        cylinder(d = spout_od, h = spout_len + overlap);

        // Cone
        translate([0, 0, spout_len - overlap])
            cylinder(d1 = cone_bottom_od, d2 = cone_top_od, h = cone_h + overlap);
    }

    // Through-bore: straight cylinder from z = 0 past the rim
    translate([0, 0, -cut_ext])
        cylinder(d = spout_id, h = spout_len + overlap + cone_h + cut_ext);
}