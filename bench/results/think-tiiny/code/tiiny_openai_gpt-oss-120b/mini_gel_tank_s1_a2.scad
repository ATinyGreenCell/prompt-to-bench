// Parameters (mm)
outer_x   = 120;   // outer length (X)
outer_y   = 70;    // outer width  (Y)
outer_z   = 40;    // outer height (Z)
wall_thk  = 3;    // wall thickness
floor_thk = 3;    // floor thickness

inner_x   = outer_x - 2*wall_thk;          // inner cavity length
inner_y   = outer_y - 2*wall_thk;          // inner cavity width
inner_z   = outer_z - floor_thk;           // inner cavity height (from floor to top)

platform_len = 60;   // platform length (X) inside tank
platform_h   = 10;   // platform height above floor
platform_center_z = floor_thk + platform_h/2; // Z of platform centre

hole_d   = 2;        // electrode hole diameter
hole_r   = hole_d/2;
hole_y   = 0;        // hole centre Y
hole_z   = 30;       // hole centre Z
hole_extra = 1;      // extra length beyond each wall face (mm)

// Global resolution for curved shapes
$fn = 64;

// Outer tank – positioned so its bottom sits on Z = 0
module outer_tank() {
    translate([0, 0, outer_z/2])
        cube([outer_x, outer_y, outer_z], center = true);
}

// Inner cavity – to be removed from the outer tank
module inner_cavity() {
    translate([0, 0, floor_thk + inner_z/2])
        cube([inner_x, inner_y, inner_z], center = true);
}

// Raised platform for the gel tray (solid)
module platform() {
    translate([0, 0, platform_center_z])
        cube([platform_len, inner_y, platform_h], center = true);
}

// Electrode holes – two separate cylinders, each cutting through an end wall
module electrode_holes() {
    // Right (positive X) end wall
    translate([ outer_x/2 - wall_thk/2, hole_y, hole_z])
        rotate([0, 90, 0])
            cylinder(h = wall_thk + 2*hole_extra, r = hole_r, center = true);
    // Left (negative X) end wall
    translate([ -outer_x/2 + wall_thk/2, hole_y, hole_z])
        rotate([0, 90, 0])
            cylinder(h = wall_thk + 2*hole_extra, r = hole_r, center = true);
}

// Assemble the tank (outer minus inner cavity and electrode holes) and add platform
module tank_assembly() {
    difference() {
        outer_tank();
        inner_cavity();
        electrode_holes();
    }
}

// Final part
union() {
    tank_assembly();
    platform();
}