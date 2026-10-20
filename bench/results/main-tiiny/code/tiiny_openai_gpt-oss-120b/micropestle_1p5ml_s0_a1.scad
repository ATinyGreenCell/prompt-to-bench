//---------------------------
// Parameters (mm)
handle_d = 8;               // Handle diameter
handle_r = handle_d/2;      // Handle radius
handle_h = 45;              // Handle height (z = 0 → 45)

cone_top_d = 3;             // Cone top diameter
cone_top_r = cone_top_d/2;  // Cone top radius
cone_h = 62 - handle_h;      // Cone height (45 → 62)

sphere_r = cone_top_r;      // Rounded tip sphere radius (diameter = 3 mm)
sphere_center_z = 62;       // Sphere center Z

groove_width = 2;           // Groove width in Z (mm)
groove_depth = 1;           // Groove radial depth (mm)
groove_centers = [10,15,20,25]; // Z‑centers of the four grooves (mm)

cut_extra = 0.2;            // Extra extension for cutting shapes (mm)
//---------------------------

$fn = 64; // smoothness for curved surfaces

//--- Handle with four circumferential grooves --------------------------------
module handle_with_grooves() {
    // Base solid cylinder (the handle)
    base = cylinder(r = handle_r, h = handle_h, center = false);
    
    // Grooves: subtract a ring (outer cylinder minus inner cylinder) at each center
    grooves = union()
        for (zc = groove_centers) {
            // Height of the cutting shape extends a little beyond the groove faces
            h_cut = groove_width + cut_extra;
            // Position the cutting shape so it overhangs the groove faces
            translate([0, 0, zc - groove_width/2 - cut_extra/2])
                difference() {
                    // Outer cylinder (full radius)
                    cylinder(r = handle_r, h = h_cut, center = false);
                    // Inner cylinder (leaving material untouched)
                    cylinder(r = handle_r - groove_depth, h = h_cut + cut_extra, center = false);
                }
        };
    
    // Subtract grooves from the base handle
    difference() {
        base;
        grooves;
    }
}

//--- Cone (taper from handle to tip) ----------------------------------------
module tapered_cone() {
    // The cone is a linear extrusion of a circle from radius handle_r at z=0
    // to radius cone_top_r at z=cone_h. It is placed on top of the handle.
    translate([0, 0, handle_h - cut_extra])  // slight over‑extension below handle
        linear_extrude(height = cone_h + cut_extra, center = false, twist = 0, scale = cone_top_r/handle_r)
            circle(r = handle_r, $fn = $fn);
}

//--- Rounded tip (sphere) ----------------------------------------------------
module tip_sphere() {
    translate([0, 0, sphere_center_z])
        sphere(r = sphere_r, $fn = $fn);
}

//--- Assemble full pestle ----------------------------------------------------
union() {
    handle_with_grooves();
    tapered_cone();
    tip_sphere();
}