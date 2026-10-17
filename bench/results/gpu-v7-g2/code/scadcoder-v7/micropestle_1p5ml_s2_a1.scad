// Pestle for grinding tissue in a 1.5 mL microcentrifuge tube
// Print orientation: standing upright on the XY plane (z = 0)

// ---------------- Parameters ----------------
handle_d      = 8;     // handle diameter (mm)
handle_h      = 45;    // handle height (mm), z = 0 to 45
cone_start_d  = 8;     // cone diameter at z = 45 (mm)
cone_end_d    = 3;     // cone diameter at z = 62 (mm)
cone_top_z    = 62;    // cone top / sphere centre (mm)
sphere_d      = 3;     // tip sphere diameter (mm)
groove_w      = 2;     // groove width in Z (mm)
groove_depth  = 1;     // groove depth from surface (mm)
groove_zs     = [10, 15, 20, 25]; // groove centre heights (mm)
overcut       = 0.5;   // extra length on cutters past faces (mm)

$fn = 96;

// ---------------- Model ----------------
union() {
    // (1) Cylindrical handle
    cylinder(d = handle_d, h = handle_h);

    // (2) Tapering cone (45 to 62)
    translate([0, 0, handle_h])
        cylinder(d1 = cone_start_d, d2 = cone_end_d, h = cone_top_z - handle_h);

    // (3) Rounded tip: sphere centred at z = 62
    translate([0, 0, cone_top_z - sphere_d / 2])
        sphere(d = sphere_d);
}

// Grip grooves: circumferential cuts, 2 mm wide in Z, 1 mm deep
for (gz = groove_zs)
    translate([0, 0, gz - groove_w / 2])
        cylinder(d = handle_d + 2 * groove_depth,
                 h = groove_w,
                 $fn = 96);