// Parameters (mm)
thickness_top = 2;               // top plate thickness
wall_thickness = 2.5;            // wall thickness
height_total = 40;               // overall height from bed to open edge
outer_size = 90;                  // outer X and Y size
hole_dia = 4.5;                   // M4 screw hole diameter
hole_pattern = 71.5;             // spacing of screw holes (square pattern)
notch_width = 12;                // cable notch width (Y direction)
notch_depth = 8;                 // notch depth down from open edge (Z direction)
cut_extend = 0.1;                 // amount to extend cutting shapes beyond faces

$fn = 64;                         // resolution for circles/cylinders

// ---------- Top plate with screw holes ----------
module top_plate() {
    // Solid plate
    plate = translate([-outer_size/2, -outer_size/2, 0]) 
            cube([outer_size, outer_size, thickness_top]);

    // Holes (cylinders) cut through the plate
    holes = union() {
        for (dx = [-hole_pattern/2, hole_pattern/2])
            for (dy = [-hole_pattern/2, hole_pattern/2])
                translate([dx, dy, -cut_extend])
                    cylinder(d = hole_dia,
                             h = thickness_top + 2*cut_extend,
                             center = false);
    }

    difference() {
        plate;
        holes;
    }
}

// ---------- Side walls (hollow) ----------
module walls() {
    wall_height = height_total - thickness_top; // 38 mm

    // Outer solid block (starts at the top plate)
    outer = translate([-outer_size/2, -outer_size/2, thickness_top])
            cube([outer_size, outer_size, wall_height]);

    // Inner cavity (to make walls hollow)
    inner = translate([-(outer_size - 2*wall_thickness)/2,
                       -(outer_size - 2*wall_thickness)/2,
                       thickness_top - cut_extend])
            cube([outer_size - 2*wall_thickness,
                  outer_size - 2*wall_thickness,
                  wall_height + 2*cut_extend]);

    // Notch for power cable on the +X wall, centred Y
    notch_z_start = height_total - notch_depth; // 32 mm
    notch = translate([ outer_size/2 - wall_thickness - cut_extend,
                       -notch_width/2,
                       notch_z_start])
            cube([wall_thickness + 2*cut_extend,
                  notch_width,
                  notch_depth + cut_extend]);

    difference() {
        outer;
        inner;
        notch;
    }
}

// ---------- Assemble the housing ----------
union() {
    top_plate();
    walls();
}