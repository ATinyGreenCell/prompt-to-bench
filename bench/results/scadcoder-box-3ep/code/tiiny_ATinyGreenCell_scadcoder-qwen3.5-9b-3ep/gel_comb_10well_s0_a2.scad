// Agarose gel comb - a flat plate with a spine and a row of rectangular teeth for casting
// horizontal gels. NOVEL general part (a generic comb, not for any one lab).
//

plate_z = 1.5;
spine_l = 70;
spine_w = 12;
teeth_n = 10;
tooth_w = 5.0;
tooth_d = 12;
gap    = 1.5;

$fn = 48;

teeth_x_pitch = tooth_w + gap;
row_length    = teeth_n * teeth_x_pitch;
start_x       = (spine_l - row_length) / 2;

difference() {
    translate([-spine_l / 2, -spine_w / 2, 0]) cube([spine_l, spine_w, plate_z]);
    for (i = [0 : teeth_n - 1])
        translate([start_x + i * teeth_x_pitch, -spine_w / 2 - tooth_d, 0])
            cube([tooth_w, tooth_d, plate_z]);
}