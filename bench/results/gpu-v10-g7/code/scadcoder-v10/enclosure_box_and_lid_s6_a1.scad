// Two-part enclosure: box (left) + lid (right), printed together
// Units: mm

// ---- Box ----
box_x = 70;    // outer length (X)
box_y = 50;    // outer width (Y)
box_z = 30;    // outer height (Z)
box_w = 2;     // wall thickness
box_f = 2;     // floor thickness

// ---- Lid ----
lip_x   = 65.6;  // lip outer length (X)
lip_y   = 45.6;  // lip outer width (Y)
lip_w   = 1.5;   // lip thickness
lip_h   = 4;     // lip height
plate_t = 2;     // lid plate thickness
gap     = 10;    // gap between box and lid

// ---- Misc ----
eps = 0.5;       // cut overshoot
$fn = 64;

difference() {
    union() {
        // Box
        translate([-box_x/2, -box_y/2, 0])
            cube([box_x, box_y, box_z]);
        // Lid (upside down: lip on top, plate below)
        translate([box_x/2 + gap, -box_y/2, 0])
            union() {
                translate([-lip_x/2, -lip_y/2, plate_t])
                    cube([lip_x, lip_y, lip_w]);   // lip
                translate([-lip_x/2 - 1, -lip_y/2 - 1, 0])
                    cube([lip_x + 2, lip_y + 2, plate_t]); // plate
            }
    }
    // Box opening (through the top face)
    translate([-box_x/2, -box_y/2, box_f])
        cube([box_x, box_y, box_z - box_f + eps]);
}