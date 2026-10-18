// Lab funnel - printed upright, wide opening at the top
// Units: mm

// ---- Parameters ----
spout_od        = 10;    // outer diameter of straight spout
spout_length    = 20;    // spout runs from z = 0 to z = 20
cone_bottom_od  = 10;    // cone starts at the spout's outer diameter
cone_top_od     = 60;    // cone rim diameter at z = 50
cone_top_z      = 50;    // height of the funnel rim
wall_thickness  = 1.6;   // wall thickness everywhere (bore = 6.8 mm)
overlap         = 0.01;  // small overlap so the cone fuses with the spout

$fn = 128;

// ---- Model ----
difference() {
    union() {
        // Straight spout
        cylinder(d = spout_od, h = spout_length);

        // Cone on top, extending from z = 20 to z = 50
        translate([0, 0, spout_length - overlap])
            cylinder(d1 = cone_bottom_od, d2 = cone_top_od, h = cone_top_z - spout_length + overlap);
    }

    // Through-bore: cylinder from z = 0 to z = 50 (open bottom and top)
    translate([0, 0, -overlap])
        cylinder(d = spout_od - 2 * wall_thickness, h = cone_top_z + 2 * overlap);
}