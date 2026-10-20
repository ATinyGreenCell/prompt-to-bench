$fn = 64;                     // resolution for curved surfaces

// ---------- Dimensions ----------
top_thickness   = 2;          // mm
wall_thickness  = 2.5;        // mm
box_height      = 40;         // mm
outer_size      = 90;          // mm (X and Y)
inner_size     = outer_size - 2*wall_thickness; // mm
hole_diameter  = 4.5;        // mm
hole_pattern   = 71.5;        // mm (side of square pattern centred on the plate)
notch_width    = 12;         // mm
notch_depth    = wall_thickness; // mm (full wall thickness)
notch_height   = 8;          // mm
notch_z_start  = box_height - notch_height; // 32 mm
notch_z_end    = box_height; // 40 mm

// ---------- Top plate with M4 screw holes ----------
module top_plate() {
    difference() {
        cube([outer_size, outer_size, top_thickness], center=false);
        for (i = [-1,1]) {
            for (j = [-1,1]) {
                translate([outer_size/2 + i*hole_pattern/2,
                            outer_size/2 + j*hole_pattern/2,
                            -0.01]) // extend 0.01 mm below plate
                    cylinder(h=top_thickness+0.02,
                             r=hole_diameter/2,
                             center=false);
            }
        }
    }
}

// ---------- Walls (open top) ----------
module walls() {
    outer = translate([0,0,top_thickness]) 
            cube([outer_size, outer_size, box_height - top_thickness], center=false);
    inner = translate([wall_thickness, wall_thickness, top_thickness + 0.01]) 
            cube([inner_size, inner_size, box_height - top_thickness - 0.02], center=false);
    difference() { outer; inner; }
}

// ---------- Cable notch (only in one wall) ----------
module notch() {
    translate([outer_size/2 - notch_width/2,
                -0.01,                 // extend 0.01 mm below wall
                notch_z_start]) // start at z=32
        cube([notch_width+0.02,   // extend 0.01 mm on each side
              wall_thickness+0.02, // extend 0.01 mm on each side
              notch_height+0.01], center=false);
}

// ---------- Walls with notch ----------
module walls_with_notch() {
    difference() { walls(); notch(); }
}

// ---------- Final assembly ----------
module final() {
    union() {
        top_plate();
        walls_with_notch();
    }
}

final();