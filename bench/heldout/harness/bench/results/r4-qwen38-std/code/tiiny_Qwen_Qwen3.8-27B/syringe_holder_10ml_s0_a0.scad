// Wall-mounted 10 mL syringe holder (tip-down, upright)
// Print orientation: rests on XY plane at z = 0, back face (y = 15) against wall.

// --- Block dimensions ---
block_w   = 50;   // X width
block_d   = 30;   // Y depth
block_h   = 40;   // Z height

// --- Barrel channel (16.5 mm wide, full height, half-circle back, straight sides to front) ---
ch_w      = 16.5; // channel width in X
ch_r      = ch_w / 2;   // 8.25 mm half-circle radius
ch_cx     = 0;          // channel centre in X
ch_cy     = 0;          // half-circle centre in Y (back end of channel)
ch_front  = -block_d / 2;   // front face y = -15
ch_back   =  ch_r;          // half-circle back end y = +8.25
ch_h      = block_h;        // full height

// --- Flange slot (34 mm wide, 2.6 mm tall, z 30..32.6, from front back to y = 11) ---
fl_w      = 34;   // slot width in X
fl_h      = 2.6;  // slot height in Z
fl_z0     = 30;   // slot bottom z
fl_front  = -block_d / 2;   // front face y = -15
fl_back   = 11;   // slot back end y

// --- Wall screw holes (M4 clearance, 4.5 mm dia, through front-to-back) ---
hole_d    = 4.5;
hole_r    = hole_d / 2;
hole_x    = [-19, 19];
hole_z    = 15;
hole_y0   = -block_d / 2 - 1;   // extend 1 mm past front face
hole_y1   =  block_d / 2 + 1;   // extend 1 mm past back face

$fn = 64;

// --- Base block ---
block = translate([-block_w/2, -block_d/2, 0])
    cube([block_w, block_d, block_h]);

// --- Barrel channel cutter (half-circle back + rectangular front portion) ---
// Half-circle: centred at (ch_cx, ch_cy), radius ch_r, upper half (y >= ch_cy)
// Rectangle: from y = ch_cy to y = ch_front, width ch_w, full height
channel_cutter = union() {
    // Half-circle (back end)
    translate([ch_cx, ch_cy, 0])
        linear_extrude(height = ch_h, center = false)
            circle(r = ch_r, $fn = 64);
    // Rectangle (straight sides running forward to front face)
    translate([ch_cx - ch_r, ch_front, 0])
        linear_extrude(height = ch_h, center = false)
            square([ch_w, ch_back - ch_front], center = false);
};

// --- Flange slot cutter ---
flange_cutter = translate([-fl_w/2, fl_front, fl_z0])
    linear_extrude(height = fl_h, center = false)
        square([fl_w, fl_back - fl_front], center = false);

// --- Wall screw holes (through along Y) ---
screw_holes = for (i = [0:1])
    translate([hole_x[i], hole_y0, hole_z])
        rotate([90, 0, 0])
            cylinder(h = hole_y1 - hole_y0, r = hole_r, $fn = 64);

// --- Final part ---
difference() {
    block;
    channel_cutter;
    flange_cutter;
    screw_holes;
}