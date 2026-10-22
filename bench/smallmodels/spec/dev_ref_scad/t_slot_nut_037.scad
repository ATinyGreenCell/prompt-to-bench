// T-slot nut for aluminium extrusion
// Print orientation: flange down on the bed (z = 0), neck building upward

$fn = 64;

// ---- Dimensions (mm) ----
nut_length     = 15;    // length along X
flange_width   = 14;    // bottom flange width (Y)
flange_height  = 3;     // flange thickness, z = 0 .. 3
neck_width     = 6;     // centred neck width (Y)
total_height   = 6;     // top of neck (z)
hole_d         = 3.4;   // vertical screw clearance hole diameter
eps            = 0.5;   // overshoot for clean boolean cuts

neck_height = total_height - flange_height;  // neck height above flange

difference() {
    union() {
        // Bottom flange
        translate([-nut_length/2, -flange_width/2, 0])
            cube([nut_length, flange_width, flange_height]);

        // Centred neck (slightly overlapping flange to ensure a single solid)
        translate([-nut_length/2, -neck_width/2, flange_height - 0.01])
            cube([nut_length, neck_width, neck_height + 0.01]);
    }

    // Vertical screw hole through the centre
    translate([0, 0, -eps])
        cylinder(d = hole_d, h = total_height + 2*eps, $fn = 64);
}
