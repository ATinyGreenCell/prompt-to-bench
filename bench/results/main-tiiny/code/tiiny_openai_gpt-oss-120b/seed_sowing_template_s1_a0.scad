// Parameters (mm)
disc_diameter = 85;          // Overall disc diameter
disc_thickness = 2;           // Disc thickness
hole_diameter = 3;            // Diameter of each through‑hole
hole_spacing = 9;             // Centre‑to‑centre spacing of holes
grid_count = 7;               // Number of holes per side (odd for centering)
notch_width = 10;             // Width of orientation notch (X direction)
notch_depth = 4;              // Depth of notch into rim (Y direction)
cut_extra = 0.5;              // Extra length for cutting shapes beyond faces

// Derived values
disc_radius = disc_diameter/2;
hole_radius = hole_diameter/2;
$fn = 64;                     // Resolution for circles and cylinders

module disc() {
    // Solid disc (cylinder) placed on the build plate (bottom at z=0)
    cylinder(h = disc_thickness, r = disc_radius, center = false);
}

module hole_grid() {
    // 7×7 grid of through‑holes
    for (i = [-3:3], j = [-3:3]) {
        translate([i*hole_spacing, j*hole_spacing, -cut_extra])
            cylinder(h = disc_thickness + 2*cut_extra,
                     r = hole_radius,
                     center = false);
    }
}

module orientation_notch() {
    // Rectangular notch cut from the +Y rim, centred on the Y‑axis
    // Notch extends from Y = disc_radius‑notch_depth to Y = disc_radius
    translate([
        -notch_width/2,
        disc_radius - notch_depth - cut_extra,
        -cut_extra
    ])
        cube([notch_width,
              notch_depth + cut_extra,   // extend a bit beyond the rim
              disc_thickness + 2*cut_extra],
             center = false);
}

// Final part: disc minus holes and notch
difference() {
    disc();
    union() {
        hole_grid();
        orientation_notch();
    }
}