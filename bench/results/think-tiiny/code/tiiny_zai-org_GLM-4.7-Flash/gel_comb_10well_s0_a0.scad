$fn = 64;

// Dimensions (mm)
thickness_z = 1.5;
spine_length_x = 70;
spine_width_y = 12;
tooth_width_x = 5.0;
tooth_length_y = 12;
tooth_gap = 1.5;
tooth_count = 10;

// Calculated dimensions
tooth_total_width = tooth_width_x + tooth_gap;
total_teeth_width = (tooth_count * tooth_width_x) + ((tooth_count - 1) * tooth_gap);

// Spine centered at origin
spine = cube([spine_length_x, spine_width_y, thickness_z], center=true);

// Teeth centered at origin
teeth = [
    for (i = [0 : tooth_count - 1])
        translate([
            -total_teeth_width / 2 + (i * tooth_total_width),
            -spine_width_y / 2,
            thickness_z / 2
        ])
        cube([tooth_width_x, tooth_length_y, thickness_z])
];

// Union and position on bed (Z=0)
translate([0, 0, thickness_z / 2])
    union() {
        spine;
        teeth;
    }