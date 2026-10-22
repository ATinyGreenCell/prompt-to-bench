// T-slot nut for aluminium extrusion
// Print orientation: flange down on the bed (z = 0), neck builds upward.

$fn = 64;

// ---- Dimensions (mm) ----
nut_length     = 20;   // length along X
flange_width   = 14;   // bottom flange width (Y)
flange_thick   = 2;    // flange thickness, z = 0 .. 2
neck_width     = 7;    // centred neck width (Y)
total_height   = 6;    // top of neck (z)
hole_d         = 4.5;  // vertical screw hole diameter
eps            = 0.5;  // cutter overshoot past faces

difference() {
    union() {
        // Bottom flange
        translate([-nut_length/2, -flange_width/2, 0])
            cube([nut_length, flange_width, flange_thick]);
        // Neck (overlaps flange slightly to ensure a single solid)
        translate([-nut_length/2, -neck_width/2, flange_thick - 0.01])
            cube([nut_length, neck_width, total_height - flange_thick + 0.01]);
    }
    // Vertical screw hole through the centre
    translate([0, 0, -eps])
        cylinder(d = hole_d, h = total_height + 2*eps);
}
