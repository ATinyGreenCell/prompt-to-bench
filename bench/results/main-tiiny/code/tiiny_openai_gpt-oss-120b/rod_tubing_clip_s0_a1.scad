// Parameters (mm)
rod_inner_d = 12.7;          // inner diameter of the stand rod ring
rod_wall = 3;                // wall thickness of the stand rod ring
rod_outer_d = rod_inner_d + 2*rod_wall; // outer diameter of the stand rod ring
rod_open_w = 10;             // opening width on the -X side of the rod ring
tube_inner_d = 6;             // inner diameter of the tubing ring
tube_wall = 2;               // wall thickness of the tubing ring
tube_outer_d = tube_inner_d + 2*tube_wall; // outer diameter of the tubing ring
tube_center_x = 15;          // X position of the tubing ring centre
tube_open_w = 4.5;           // opening width on the +X side of the tubing ring
part_h = 10;                 // total height of the part (extrusion Z)
bridge_x_start = 8;          // left X of the solid bridge
bridge_x_end = 12;           // right X of the solid bridge
bridge_y_w = 6;              // Y width of the bridge

// Rendering quality
$fn = 64;

// Main model
union() {
    // 1) Stand rod ring with opening
    difference() {
        // Outer cylinder
        cylinder(d = rod_outer_d, h = part_h);
        // Inner hole (extends 0.2 mm beyond the top/bottom)
        cylinder(d = rod_inner_d, h = part_h + 0.2);
        // Opening cut on the -X side (x < 0, |y| < rod_open_w/2)
        translate