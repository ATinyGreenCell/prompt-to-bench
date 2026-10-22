// T-slot nut for aluminium extrusion
// Print orientation: flange down on XY plane, neck upward (+Z)

$fn = 64;

// ---- Dimensions (mm) ----
nut_length    = 10;    // length along X
flange_width  = 10;    // bottom flange width (Y)
flange_height = 2.5;   // flange thickness, z = 0 .. 2.5
neck_width    = 6;     // neck width (Y), centred
total_height  = 6.5;   // top of neck (z)
hole_d        = 3.4;   // vertical screw clearance hole diameter
eps           = 0.5;   // overshoot for clean boolean cuts

difference() {
    union() {
        // Bottom flange
        translate([-nut_length/2, -flange_width/2, 0])
            cube([nut_length, flange_width, flange_height]);

        // Neck (overlaps flange slightly for a clean union)
        translate([-nut_length/2, -neck_width/2, flange_height - 0.01])
            cube([nut_length, neck_width, total_height - flange_height + 0.01]);
    }

    // Vertical screw hole through the centre
    translate([0, 0, -eps])
        cylinder(d = hole_d, h = total_height + 2*eps);
}
