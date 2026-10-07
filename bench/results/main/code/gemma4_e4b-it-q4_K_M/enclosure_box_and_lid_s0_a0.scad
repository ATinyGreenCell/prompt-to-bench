// ====================================================================
// Parameters for the Enclosure and Lid
// ====================================================================

// Box Dimensions (Outer)
box_outer_x = 70; // Outer X dimension of the box (mm)
box_outer_y = 50; // Outer Y dimension of the box (mm)
box_outer_z = 30; // Outer Z dimension of the box (mm)

// Box Wall/Floor Thickness
wall_thickness = 2; // Wall and floor thickness (mm)

// Lid Dimensions
lid_plate_x = 70;   // Plate X dimension of the lid (mm)
lid_plate_y = 50;   // Plate Y dimension of the lid (mm)
lid_plate_z = 2;    // Thickness of the main plate (mm)

lip_wall_thickness = 1.5; // Wall thickness of the lip (mm)
lip_height = 4;        // Height of the lip (mm)

// Clearance for sliding fit
clearance = 0.2; // Total clearance needed on each side (mm)

// Gap between parts when printing together
print_gap = 10; // Gap between box and lid in X direction (mm)

// Resolution setting for curves
$fn = 64;

// ====================================================================
// Part 1: The Box
// ====================================================================

module enclosure_box() {
    // Calculate inner dimensions
    inner_x = box_outer_x - (2 * wall_thickness);
    inner_y = box_outer_y - (2 * wall_thickness);
    inner_z = box_outer_z - wall_thickness; // Open top

    difference() {
        // 1. Outer shell (Solid block)
        cube([box_outer_x, box_outer_y, box_outer_z]);

        // 2. Cut out the interior space
        translate([wall_thickness, wall_thickness, wall_thickness]) {
            cube([inner_x, inner_y, inner_z]);
        }
    }
}

// ====================================================================
// Part 2: The Lid
// ====================================================================

module enclosure_lid() {
    // Calculate the dimensions of the lip structure
    // Outer size of the lip section (must fit into box opening with clearance)
    lip_outer_x = lid_plate_x - (2 * clearance); // 70 - 0.4 = 69.6? No, use specified outer size: 65.6 x 45.6
    lip_outer_y = lid_plate_y - (2 * clearance);

    // Specified outer dimensions for the lip section
    specified_lip_x = 65.6;
    specified_lip_y = 45.6;

    // Calculate inner dimensions of the lip wall
    lip_inner_x = specified_lip_x - (2 * lip_wall_thickness);
    lip_inner_y = specified_lip_y - (2 * lip_wall_thickness);

    difference() {
        // 1. Main plate body (70 x 50 x 2)
        cube([lid_plate_x, lid_plate_y, lid_plate_z]);

        // 2. Cut out the space where the lip sits on top of the main plate
        // This cut must be centered on the plate and extend through its thickness (2mm) + slightly more for safety
        translate([0, 0, lid_plate_z - 0.1]) { // Start cutting just below the surface
            cube([specified_lip_x, specified_lip_y, lip_height + 0.5]);
        }

        // 3. Cut out the hollow space inside the lip structure (to make it a wall)
        // This cut is performed on the top face of the plate
        translate([
            (lid_plate_x - specified_lip_x) / 2, // Center X offset
            (lid_plate_y - specified_lip_y) / 2, // Center Y offset
            lid_plate_z + lip_height - 0.1 // Start cutting from the top surface of the lip structure
        ]) {
            cube([lip_inner_x, lip_inner_y, lip_height + 0.5]);
        }
    }
}

// ====================================================================
// Assembly and Rendering
// ====================================================================

// The lid is printed upside down (Z=0 is the bottom of the plate)
// The box rests on Z=0. We place the lid next to it in X.

translate([box_outer_x + print_gap, 0, 0]) {
    enclosure_lid();
}

// Place the box at the origin (centered in XY plane relative to its own dimensions)
// Since we want it centered on the bed, and we are placing the lid next to it,
// we center the box around X=0 for simplicity of placement.
translate([-(box_outer_x / 2), -(box_outer_y / 2), 0]) {
    enclosure_box();
}