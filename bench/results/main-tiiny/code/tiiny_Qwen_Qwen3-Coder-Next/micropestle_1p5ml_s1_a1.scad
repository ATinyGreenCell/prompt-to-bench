// Pestle for grinding tissue in 1.5 mL microcentrifuge tube
// Print orientation: upright (standing on base)

$fn = 64;

// Dimensions
handle_diameter = 8;
handle_height = 45;
cone_top_diameter = 3;
cone_height = 62 - 45; // 17 mm
sphere_diameter = 3;
groove_width = 2;
groove_depth = 1;
groove_centers = [10, 15, 20, 25];

// Calculate handle radius
handle_radius = handle_diameter / 2;

// Calculate cone radii
cone_bottom_radius = handle_radius;
cone_top_radius = cone_top_diameter / 2;

// Calculate sphere center height
sphere_center_z = 62;

// Build the pestle body without grooves
module pestle_body() {
    // (1) Handle cylinder
    translate([0, 0, 0])
        cylinder(h = handle_height, r = handle_radius, center = false);
    
    // (2) Cone (tapering from handle diameter to 3 mm)
    translate([0, 0, handle_height])
        cylinder(h = cone_height, r1 = cone_bottom_radius, r2 = cone_top_radius, center = false);
    
    // (3) Rounded tip: sphere
    translate([0, 0, sphere_center_z])
        sphere(d = sphere_diameter);
}

// Grooves: subtract cylinders from handle only
module grooves() {
    for (z_pos = groove_centers) {
        translate([0, 0, z_pos - groove_width/2])
            cylinder(h = groove_width + 0.01, r = handle_radius - groove_depth, center = false);
    }
}

// Subtract grooves from the main body
difference() {
    pestle_body();
    grooves();
}