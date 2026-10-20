// ---------- Parameters ----------
outer_box_x = 70;        // Box outer size X (mm)
outer_box_y = 50;        // Box outer size Y (mm)
outer_box_z = 30;        // Box outer size Z (mm)
wall_thickness = 2;      // Wall thickness (mm)
floor_thickness = 2;     // Floor thickness (mm)

plate_x = 70;            // Lid plate size X (mm)
plate_y = 50;            // Lid plate size Y (mm)
plate_z = 2;             // Lid plate thickness (mm)
lip_outer_x = 65.6;      // Lip outer size X (mm)
lip_outer_y = 45.6;      // Lip outer size Y (mm)
lip_wall = 1.5;          // Lip wall thickness (mm)
lip_height = 4;          // Lip height (mm)

gap = 10;                // Gap between box and lid (mm)

// ---------- Computed placement ----------
lid_center_x = outer_box_x/2 + gap + plate_x/2;   // X centre of lid (mm)

// ---------- Rendering settings ----------
$fn = 64;   // resolution for circles/spheres

// ---------- Modules ----------
module box_part() {
    // Outer solid (resting on XY plane)
    outer = translate([-outer_box_x/2, -outer_box_y/2, 0])
        cube([outer_box_x, outer_box_y, outer_box_z]);

    // Inner cavity (cut away)
    inner = translate([
                -outer_box_x/2 + wall_thickness,
                -outer_box_y/2 + wall_thickness,
                floor_thickness
            ])
        // extend 0.01 mm beyond the outer top to avoid coplanar faces
        cube([outer_box_x - 2*wall_thickness,
              outer_box_y - 2*wall_thickness,
              outer_box_z - floor_thickness + 0.01]);

    difference() {
        outer;
        inner;
    }
}

module lid_part() {
    // Plate (bottom)
    plate = translate([-plate_x/2, -plate_y/2, 0])
        cube([plate_x, plate_y, plate_z]);

    // Lip (rectangular wall around opening)
    lip_outer = translate([-lip_outer_x/2, -lip_outer_y/2, plate_z])
        cube([lip_outer_x, lip_outer_y, lip_height + 0.01]); // +0.01 mm beyond top

    // Inner cavity of lip (slightly larger than needed to ensure cut shape extends past faces)
    inner_lip_x =