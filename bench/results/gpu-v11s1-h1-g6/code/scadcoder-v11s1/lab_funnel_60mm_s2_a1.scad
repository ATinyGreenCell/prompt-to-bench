// Small lab funnel, printed upright (wide opening at the top)
// All dimensions in millimetres

// ---- Parameters ----
spout_od      = 10;    // spout outer diameter
spout_length  = 20;    // spout runs from z = 0 to z = 20
cone_bottom_d = 10;    // cone outer diameter at z = 20
cone_top_d    = 60;    // cone outer diameter at the rim (z = 50)
rim_z         = 50;    // height of the funnel rim
wall          = 1.6;   // wall thickness everywhere

$fn = 128;             // smoothness of curved surfaces

// ---- Derived ----
spout_id = spout_od - 2 * wall;   // spout bore = 6.8 mm
cone_h   = rim_z - spout_length;  // cone height = 30 mm

// ---- Model ----
difference() {
    union() {
        // Straight spout tube from z = 0 to z = 20
        cylinder(d = spout_od, h = spout_length);

        // Cone widening from 10 mm (at z = 20) to 60 mm (at z = 50)
        translate([0, 0, spout_length])
            cylinder(d1 = cone_bottom_d, d2 = cone_top_d, h = cone_h);
    }

    // Open bottom: bore through the spout along the full height
    translate([0, 0, -1])
        cylinder(d = spout_id, h = rim_z + 2);
}