// T-slot nut for aluminium extrusion
// Print orientation: flange down on XY plane, neck up (+Z)

$fn = 64;

// ---- Dimensions (mm) ----
nut_length     = 10;   // length along X
flange_width   = 10;   // flange width along Y
flange_height  = 3;    // flange thickness, z = 0 .. 3
neck_width     = 8;    // neck width along Y
neck_top_z     = 6;    // top of neck (z)
hole_d         = 3.4;  // screw clearance hole diameter
overlap        = 0.5;  // cutter overshoot past faces

neck_height = neck_top_z - flange_height;  // neck height (3 mm)

difference() {
    union() {
        // Bottom flange
        translate([-nut_length/2, -flange_width/2, 0])
            cube([nut_length, flange_width, flange_height]);

        // Centred neck, overlapping the flange slightly to fuse
        translate([-nut_length/2, -neck_width/2, flange_height - 0.01])
            cube([nut_length, neck_width, neck_height + 0.01]);
    }

    // Vertical screw hole through the centre
    translate([0, 0, -overlap])
        cylinder(d = hole_d, h = neck_top_z + 2*overlap);
}
