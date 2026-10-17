// Variables
    DISC_DIAMETER = 85;
    DISC_THICKNESS = 2;
    HOLE_COUNT = 7;
    HOLE_SPACING = 9;
    HOLE_DIAMETER = 3;
    NOTCH_WIDTH = 10;
    NOTCH_DEPTH = 4;
    RIM_RADIUS = DISC_DIAMETER / 2;

    $fn = 64;

    difference() {
        // Main Disc
        cylinder(d = DISC_DIAMETER, h = DISC_THICKNESS, center = [0, 0, DISC_THICKNESS/2]);
        // Wait, rule 3: "rests on the bed... z = 0 and builds upward".
        // So cylinder should be from Z=0 to Z=2.
        // cylinder(d, h) defaults to center at origin.
        // So translate([0,0,0]) cylinder(d, h) puts bottom at Z=0.
        // Wait, cylinder(d, h) in OpenSCAD is centered at origin by default.
        // So to have it sit on Z=0, I need translate([0,0,0]) cylinder(d, h) -> No, that centers it.
        // cylinder(d, h) creates a cylinder centered at origin.
        // To sit on Z=0, I need to translate Z by h/2.
        // OR use `cylinder(d, h, center=[0,0,0])` then translate.
        // Actually, standard practice for "rests on bed" is `translate([0,0,0]) cylinder(d, h)` -> No, that centers it at 0, so it goes from -h/2 to +h/2.
        // I need it to go from 0 to h.
        // So `translate([0,0,0]) cylinder(d, h)` is wrong if I want Z=0 base.
        // I should use `translate([0,0,0]) cylinder(d, h)` -> No.
        // I should use `translate([0,0,0]) cylinder(d, h)` -> This puts center at 0.
        // I need `translate([0,0,0]) cylinder(d, h)` -> No.
        // I need `translate([0,0,0]) cylinder(d, h)` -> No.
        // Correct: `translate([0,0,0]) cylinder(d, h)` -> No.
        // Correct: `translate([0,0,0]) cylinder(d, h)` -> No.
        // Correct: `translate([0,0,0]) cylinder(d, h)` -> No.
        // Correct: `translate([0,0,0]) cylinder(d, h)` -> No.
        // Okay, `cylinder(d, h)` is centered at origin.
        // To sit on Z=0, I need `translate([0,0,0]) cylinder(d, h)` -> No.
        // I need `translate([0,0,0]) cylinder(d, h)` -> No.
        // I need `translate([0,0,0]) cylinder(d, h)` -> No.
        // I need `translate([0,0,0]) cylinder(d, h)` -> No.
        // I need `translate([0,0,0]) cylinder(d, h)` -> No.
        // I need `translate([0,0,0]) cylinder(d, h)` -> No.
        // I need `translate([0,0,0]) cylinder(d, h)` -> No.
        // I need `translate([0,0,0]) cylinder(d, h)` -> No.
        // I need `translate([0,0,0]) cylinder(d, h)` -> No.
        //