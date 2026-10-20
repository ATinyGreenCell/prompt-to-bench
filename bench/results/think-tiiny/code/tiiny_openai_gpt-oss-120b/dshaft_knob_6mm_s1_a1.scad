// Parameters (mm)
R_knob = 15;               // radius of the knob
H_knob = 15;               // height of the knob

d_bore_dia = 6.2;          // diameter of the blind bore
d_bore_rad = d_bore_dia/2; // radius of the blind bore
d_bore_height = 12;        // depth of the blind bore (from bottom)

flat_offset = 1.6;         // distance from the centre to the flat plane of the D‑shape

groove_count = 18;         // number of vertical grip grooves
groove_dia = 2;             // diameter of each groove
groove_rad = groove_dia/2;  // radius of each groove

pointer_width = 1.5;       // width of the pointer groove (Y direction)
pointer_depth = 1;         // depth of the pointer groove (into the knob)
pointer_start = flat_offset;               // start of the pointer groove along X
pointer_len = R_knob - flat_offset;        // length from flat plane to outer edge

// Rendering quality
$fn = 64;

// -------------------------------------------------
// D‑shaped blind bore (cylinder with a flat side)
module d_shaped_bore() {
    union() {
        // Full cylinder (extends slightly beyond the bore height)
        translate([0,0,0])
            cylinder(r=d_bore_rad, h=d_bore_height+0.02, $fn=$fn);
        // Flat side cut (extends slightly beyond the bore height)
        intersection() {
            // Rectangular block that defines the flat plane
            translate([flat_offset, -R_knob-1, -0.01])
                cube([R_knob+2, 2*R_knob+2, d_bore_height+0.02]);
            // Same cylinder to limit the cut to the bore volume
            translate([0,0,0])
                cylinder(r=d_bore_rad, h=d_bore_height+0.02, $fn=$fn);
        }
    }
}

// -------------------------------------------------
// Single vertical grip groove (half‑cylinder on the outer surface)
module grip_groove(angle) {
    rotate([0,0,angle])
        intersection() {
            // Half‑cylinder (full cylinder placed at outer radius)
            translate([R_knob,0,0])
                cylinder(r=groove_rad, h=H_knob+0.02, $fn=$fn);
            // Sphere defines the interior of the knob; only the part inside remains
            sphere(r=R_knob+0.01, $fn=$fn);
        }
}

// -------------------------------------------------
// Pointer groove on the flat side of the D‑shape
module pointer_groove() {
    // Runs from the flat plane outward to the outer edge
    translate([pointer_start, -pointer_width/2, H_knob-pointer_depth-0.01])
        cube([pointer_len+0.02, pointer_width, pointer_depth+0.02]);
}

// -------------------------------------------------
// Main knob model
module knob() {
    difference() {
        // Outer cylinder (the knob itself)
        cylinder(r=R_knob, h=H_knob, $fn=$fn);

        // Remove the D‑shaped blind bore
        d_shaped_bore();

        // Remove the 18 vertical grip grooves
        for (i = 0; i < groove_count; i = i + 1) {
            angle = i * 360 / groove_count;
            grip_groove(angle);
        }

        // Remove the pointer groove
        pointer_groove();
    }
}

// Render the part
knob();