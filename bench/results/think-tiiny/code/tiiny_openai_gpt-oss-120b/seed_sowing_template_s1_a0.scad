$fn = 64;                         // smoothness for circles and cylinders

//--- Dimensions ---------------------------------------------------------
disc_diameter   = 85;   // mm, overall diameter of the petri‑dish template
disc_thickness  = 2;    // mm, thickness of the flat disc
hole_diameter   = 3;    // mm, diameter of each through‑hole
hole_spacing    = 9;    // mm, centre‑to‑centre spacing of the hole grid
grid_count      = 7;    // number of holes per side (7×7 grid)
notch_width     = 10;   // mm, width of the orientation notch (X direction)
notch_depth     = 4;    // mm, depth of the notch measured inward from the rim (Y direction)
extra           = 0.2;  // mm, amount to extend cutting shapes beyond the part (0.01–1 mm)

//--- Main part ----------------------------------------------------------
module disc() {
    // Flat cylinder, bottom at z = 0, height = disc_thickness
    cylinder(r = disc_diameter/2, h = disc_thickness, center = false);
}

//--- Hole grid -----------------------------------------------------------
module hole() {
    // Cylinder that cuts through the disc, extended a little beyond both faces
    cylinder(r = hole_diameter/2, h = disc_thickness + extra, center = false);
}

module holes_grid() {
    // Grid indices run from -(grid_count-1)/2 … +(grid_count-1)/2
    // For a 7×7 grid this is -3 … 3
    for (i = -3; i <= 3; i = i + 1)
        for (j = -3; j <= 3; j = j + 1)
            translate([ i*hole_spacing,
                        j*hole_spacing,
                       -extra/2 ])   // extend below and above the disc
                hole();
}

//--- Orientation notch ---------------------------------------------------
module notch() {
    // Cube centered, then positioned on the +Y rim
    translate([ 0,
                disc_diameter/2 - notch_depth/2,   // centre of the notch along Y
                disc_thickness/2 ])                // centre along Z
        cube([ notch_width,
               notch_depth + extra,
               disc_thickness + extra ], center = true);
}

//--- Final part -----------------------------------------------------------
difference() {
    disc();                     // solid disc
    union() {                   // all cuts
        holes_grid();           // 7×7 hole pattern
        notch();                // orientation notch on +Y side
    }
}