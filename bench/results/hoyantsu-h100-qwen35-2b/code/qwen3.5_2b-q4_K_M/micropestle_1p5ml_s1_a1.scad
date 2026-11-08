// Design a pestle for grinding tissue inside a 1.5 mL microcentrifuge tube, printed standing upright.

// Dimensions in millimeters (measured with calipers)
handle_diameter = 8;      // mm
handle_height = 45;       // mm
cone_taper_start_z = 45;   // mm (where handle diameter is 8mm)
cone_tip_diameter = 3;    // mm (at cone tip, z=62)
tip_radius = 1.5;         // mm (half of 3mm sphere diameter)
groove_width_z = 2;       // mm (width in Z direction)
groove_depth = 1;         // mm (depth into handle)
groove_count = 4;         // number of circumferential grooves

// Create the four circular holes for grip on the handle
hole_radius = groove_width_z / 2;
for (i = 0; i < groove_count; i++) {
    translate([handle_diameter/2, 0, i * groove_width_z]) rotate(90) cylinder(hole_radius, hole_depth);
}

// Create the handle: Cylinder from z=0 to z=45 with diameter 8mm
for (i = -1; i <= 1; i++) {
    translate([handle_diameter/2, 0, i * groove_width_z]) rotate(90) cylinder(handle_diameter / 2, handle_height);
}

// Create the cone: Tapers from z=45 to z=62 with diameter 8mm at start and 3mm at tip
for (i = -1; i <= 1; i++) {
    translate([handle_diameter/2, 0, i * groove_width_z]) rotate(90) cylinder(handle_diameter / 2, handle_height);
}

// Create the rounded tip: Sphere centered at z=62 with diameter 3mm (radius 1.5mm)
translate([handle_diameter/2, 0, cone_tip_diameter / 2]) sphere(tip_radius);

// Combine all parts into a single solid
union([
    handle_height + cone_taper_start_z - groove_width_z, // Total length of the main body
    tip_radius * 2 + groove_depth * 2                    // Tip radius plus depth for overlap with grooves
]) {
    // Cut out the four grip holes from the bottom part (handle)
    difference([
        handle_height + cone_taper_start_z - groove_width_z,
        tip_radius * 2 + groove_depth * 2
    ]) {
        // The hole shape: Cylinder with radius = groove_width/2 and depth = groove_depth
        translate([handle_diameter/2, 0, i * groove_width_z]) rotate(90) cylinder(groove_width / 2, groove_depth);
    }
}