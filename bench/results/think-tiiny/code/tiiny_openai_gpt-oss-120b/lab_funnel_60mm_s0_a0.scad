// Parameters (mm)
outer_d_spout = 10;          // outer diameter of the straight spout
outer_d_cone_top = 60;       // outer diameter at the funnel rim
height_spout = 20;           // height of the straight spout
height_cone = 30;            // height of the conical section
wall_thickness = 1.6;        // uniform wall thickness
extra = 0.1;                 // amount to extend cutting shapes beyond faces

// Derived inner diameters (mm)
inner_d_spout = outer_d_spout - 2*wall_thickness;          // bore of the spout
inner_d_cone_top = outer_d_cone_top - 2*wall_thickness;   // inner diameter at rim

// Global resolution for curved features
$fn = 64;

// Outer solid (spout + cone)
module outer_funnel() {
    union() {
        // Straight spout (outer cylinder)
        cylinder(h = height_spout,
                 r = outer_d_spout/2);
        // Conical section (outer frustum)
        cylinder(h = height_cone,
                 r1 = outer_d_spout/2,
                 r2 = outer_d_cone_top/2);
    }
}

// Inner bore (cylinder + cone) – extended slightly beyond the outer faces
module inner_bore() {
    union() {
        // Spout bore (cylinder) extending -extra below z=0 and +extra above its top
        translate([0, 0, -extra])
            cylinder(h = height_spout + 2*extra,
                     r = inner_d_spout/2);
        // Conical bore (frustum) extending -extra below its start (z=height_spout) and +extra above its top (z=height_spout+height_cone)
        translate([0, 0, height_spout - extra])
            cylinder(h = height_cone + 2*extra,
                     r1 = inner_d_spout/2,
                     r2 = inner_d_cone_top/2);
    }
}

// Final part: outer shape minus inner bore
difference() {
    outer_funnel();
    inner_bore();
}