// Pestle for 1.5 mL microcentrifuge tube
// Designed to be printed standing upright (Z-axis)

// --- Dimensions ---
handle_d      = 8.0;    // Diameter of the cylindrical handle
handle_h      = 45.0;   // Height of the handle
cone_base_d   = 8.0;    // Diameter at the start of the taper (z=45)
cone_tip_d    = 3.0;    // Diameter at the end of the taper (z=62)
cone_h        = 17.0;   // Height of the cone (62 - 45)
tip_d         = 3.0;    // Diameter of the spherical tip
tip_radius    = tip_d / 2;

// Grip Groove Dimensions
groove_width   = 2.0;   // Width of each groove in Z
groove_depth   = 1.0;   // Depth of the cut into the handle
groove_centers = [10, 15, 20, 25]; // Z-heights of the groove centers

$fn = 64;

// --- Geometry Construction ---

module main_body() {
    union() {
        // 1. Handle
        cylinder(h = handle_h, d = handle_d);
        
        // 2. Tapered Cone
        translate([0, 0, handle_h])
        cylinder(h = cone_h, d1 = cone_base_d, d2 = cone_tip_d);
        
        // 3. Rounded Tip
        translate([0, 0, handle_h + cone_h])
        sphere(d = tip_d);
    }
}

module grooves() {
    // We create the grooves as a single object to subtract
    for (z_pos = groove_centers) {
        translate([0, 0, z_pos])
        rotate([0, 90, 0])
        // rotate_extrude creates a ring. 
        // We translate the square away from the center to create the ring shape.
        // The square's width is the groove width (Z-direction in local coords).
        // The square's depth is the groove depth.
        rotate_extrude($fn = 64)
        translate([handle_d/2 - groove_depth, -groove_width/2])
        square([groove_depth + 0.1, groove_width]);
    }
}

// Final Assembly
// We take the main body and subtract the grooves from it.
difference() {
    main_body();
    grooves();
}