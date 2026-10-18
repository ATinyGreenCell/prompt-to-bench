// Pestle for grinding tissue inside a 1.5 mL microcentrifuge tube
// Print orientation: standing upright on the bed (z = 0), centred on origin in X/Y

// ---------------- Parameters ----------------
handle_d      = 8;    // handle diameter (mm)
handle_h      = 45;   // handle height (mm), z = 0..45
cone_d_top    = 8;    // cone diameter at handle junction (mm)
cone_d_tip    = 3;    // cone diameter at tip (mm)
cone_top_z    = 45;   // cone top height (mm)
cone_tip_z    = 62;   // cone tip height (mm)
tip_d         = 3;    // rounded tip diameter (mm)
tip_centre_z  = 62;   // tip sphere centre height (mm)
groove_count  = 4;    // number of circumferential grip grooves
groove_w      = 2;    // groove width (mm), measured in Z
groove_depth  = 1;    // groove depth (mm)
groove_z      = [10, 15, 20, 25]; // groove centre heights (mm)
overcut       = 0.5;  // extra length of cutters past faces (mm)

$fn = 96;             // facet count for round features

// ---------------- Model ----------------
difference() {
    union() {
        // (1) Cylindrical handle
        cylinder(d = handle_d, h = handle_h);

        // (2) Tapering cone from handle top to tip
        translate([0, 0, cone_top_z])
            linear_extrude(height = cone_tip_z - cone_top_z)
                circle(d = cone_d_tip);

        // (3) Rounded tip: 3 mm sphere centred at z = 62
        translate([0, 0, tip_centre_z])
            sphere(d = tip_d);
    }

    // Grip grooves cut into the handle
    for (g = groove_count) {
        rotate([0, 0, groove_z[g - 1] > 0 ? 0 : 90])
            translate([0, -groove_w / 2, groove_z[g - 1] - overcut])
                cube([handle_d + 1, groove_w, groove_w + 2 * overcut]);
    }
}