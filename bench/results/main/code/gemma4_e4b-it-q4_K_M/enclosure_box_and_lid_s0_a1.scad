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

// Clearance for sliding fit: Total clearance on each side is 0.2 mm, so total reduction is 0.4 mm.
clearance_total = 0.4; // Total required clearance (2 * 0.2 mm)
specified_lip_x = 65.6; // Outer size of the lip section X (mm) - This was specified as the outer dimension for sliding fit
specified_lip_y = 45.6; // Outer size of the lip section Y (mm)

// Gap between parts when printing together
print_gap = 10; // Gap between box and lid in X direction (mm)

// Resolution setting for curves
$fn = 64;

// ====================================================================
// Part 1: The Box
// ====================================================================

module enclosure_box() {
    // Calculate inner dimensions
    inner_x = box_outer_x - (2 * wall_thickness); // 70 - 4 = 66
    inner_y = box_outer_y - (2 * wall_thickness); // 50 - 4 = 46
    inner_z = box_outer_z - wall_thickness;      // 30 - 2 = 28

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
    // Calculate the dimensions of the lip structure based on specified outer size (65.6 x 45.6)
    
    // Lip Outer Dimensions (as specified for sliding fit)
    lip_outer_x = specified_lip_x; // 65.6 mm
    lip_outer_y = specified_lip_y; // 45.6 mm

    // Calculate inner dimensions of the lip wall
    lip_inner_x = lip_outer_x - (2 * lip_wall_thickness); // 65.6 - 3.0 = 62.6
    lip_inner_y = lip_outer_y - (2 * lip_wall_thickness); // 45.6 - 3.0 = 42.6

    // Center offset calculation for the lip structure on the plate
    center_offset_x = (lid_plate_x - lip_outer_x) / 2; // (70 - 65.6) / 2 = 2.2
    center_offset_y = (lid_plate_y - lip_outer_y) / 2; // (50 - 45.6) / 2 = 2.2

    difference() {
        // 1. Main plate body (70 x 50 x 2)
        cube([lid_plate_x, lid_plate_y, lid_plate_z]);

        // 2. Cut out the space where the lip sits on top of the main plate
        // This cut must be centered and extend through its thickness (2mm) + slightly more for safety
        translate([center_offset_x, center_offset_y, lid_plate_z - 0.1]) { // Start cutting just below the surface
            cube([lip_outer_x, lip_outer_y, lip_height + 0.5]);
        }

        // 3. Cut out the hollow space inside the lip structure (to make it a wall)
        // This cut is performed on the top face of the plate, starting at Z = lid_plate_z + lip_height - 0.1
        translate([center_offset_x, center_offset_y, lid_plate_z + lip_height - 0.1]) {
            cube([lip_inner_x, lip_inner_y, lip_height + 0.5]);
        }
    }
}

// ====================================================================
// Assembly and Rendering
// ====================================================================

// The lid is printed upside down (Z=0 is the bottom of the plate)
// We place the lid next to it in X, starting at box_outer_x + print_gap.
translate([box_outer_x + print_gap, 0, 0]) {
    enclosure_lid();
}

// Place the box centered on the bed (X=0, Y=0)
translate([-(box_outer_x / 2), -(box_outer_y / 2), 0]) {
    enclosure_box();
}