// 90 mm Petri dish rack, printed as used
// Base: 203 x 80 x 20 mm, centred on origin in X and Y
// Curved cradle: inside of a cylinder R=46 mm, axis along X at y=0, z=52
// 11 divider plates 3 mm thick, 80 mm wide, z=0..60, 20 mm apart
// 10 slots of 17 mm width, one dish per slot

$fn = 64;

// Base block dimensions
base_len  = 203;   // X
base_wid  = 80;    // Y
base_hgt  = 20;    // Z

// Cradle cylinder
cradle_r  = 46;    // radius of cradle cylinder
cradle_z  = 52;    // z of cylinder axis
cradle_y  = 0;     // y of cylinder axis

// Divider plates
div_thk   = 3;     // thickness in X
div_wid   = 80;    // width in Y (same as base)
div_hgt   = 60;    // height in Z
div_count = 11;    // number of divider plates
div_start = -100;  // x of first divider
div_step  = 20;    // spacing between dividers

// Extra margin for cutting shapes (avoid coplanar faces)
cut_margin = 0.5;

// Build the rack:
// 1. Base block with cradle cut
// 2. Union with divider plates (not cut by cradle)

union() {
    // Base block with cradle cut
    difference() {
        // Base block: 203 x 80 x 20, centered in X and Y, bottom at z=0
        cube([base_len, base_wid, base_hgt], center=[true, true, false]);
        
        // Cradle cutting cylinder: axis along X at y=0, z=52, radius 46
        // Extend past base in X by cut_margin on each side
        translate([0, 0, cradle_z])
        rotate([0, 90, 0])
        cylinder(r=cradle_r, h=base_len + 2*cut_margin, center=true);
    }
    
    // Divider plates: 11 plates at x = -100, -80, ..., 100
    for (i = 0; i < div_count; i++) {
        x_pos = div_start + i * div_step;
        translate([x_pos - div_thk/2, -base_wid/2, 0])
        cube([div_thk, div_wid, div_hgt]);
    }
}