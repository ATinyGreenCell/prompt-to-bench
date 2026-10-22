// Petri Dish Rack
// Designed for 90mm diameter dishes standing on edge.

// Dimensions
L         = 203;    // Base length (X)
W         = 80;     // Base width (Y)
H_base    = 20;     // Base height (Z)
dish_rad  = 45;     // Radius of 90mm dish
cradle_r  = 46;     // Radius of the cradle cutout
cradle_z  = 52;    // Z-coordinate of the cylinder axis
cradle_y  = 0;     // Y-coordinate of the cylinder axis (centered)
divider_t = 3;      // Thickness of divider plates
divider_h  = 60;    // Height of divider plates
num_divs  = 11;     // Number of divider plates

$fn = 128;

// Modules
module base_part() {
    translate([-L/2, -W/2, 0])
        cube([L, W, H_base]);
}

module cradle_cutout() {
    // The cradle is a cylinder axis along X.
    // Axis is at y = 0, z = 52.
    // Radius is 46.
    // Bottom of cradle: 52 - 46 = 6mm.
    // We extend the cylinder in X to ensure a clean cut.
    translate([-L/2 - 1, -cradle_r, cradle_z - cradle_r])
        rotate([0, 90, 0])
            cylinder(h = L + 2, r = cradle_r);
}

module divider_part(x_pos) {
    // Dividers are 3mm thick in X, 80mm wide in Y, 60mm tall in Z.
    // They are centered on the x_pos.
    translate([x_pos - divider_t/2, -W/2, 0])
        cube([divider_t, W, divider_h]);
}

// Final Assembly
// We use union to ensure it is a single solid body.
// We subtract the cradle from the base only, then add the dividers.
union() {
    // The Base with the cradle cut out
    difference() {
        base_part();
        cradle_cutout();
    }
    
    // The 11 Divider plates
    // Spaced 20mm apart from -100 to 100
    for (i = [0 : num_divs - 1]) {
        x_pos = -100 + (i * 20);
        divider_part(x_pos);
    }
}