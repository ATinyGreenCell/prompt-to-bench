// --- Dimensions ---

base_x = 112;      // Base plate length along X
base_y = 44;       // Base plate width along Y
base_z = 3;        // Base plate thickness
deck_z_bottom = 22; // Deck plate bottom Z position
deck_z_top = 25;   // Deck plate top Z position
deck_thickness = deck_z_top - deck_z_bottom;

cuvette_size = 12.5; // Side length of cuvettes (for reference, not directly used in structure)

wall_depth = base_y;  // Depth of the upright walls (same as base Y dimension)
end_wall_thickness = 3; // Thickness of the two end walls
rib_thickness = 2.5;   // Thickness of the five ribs
total_height = deck_z_top; // Total height of the structure

hole_size = 13;     // Side length of the square holes in the deck
spacing_x = 18;     // Center-to-center spacing along X for holes
spacing_y = 18;     // Center-to-center spacing along Y for holes
num_holes_x = 6;    // Number of holes along X
num_holes_y = 2;    // Number of holes along Y

$fn = 64; // High resolution for curves, though mostly rectilinear here

// --- Calculations and Offsets ---

// Center coordinates for the hole grid on the deck (centered on origin)
hole_x_coords = [
    (num_holes_x - 1) / 2 * spacing_x + ((num_holes_x - 1) * spacing_x) / 2 // Simplified centering logic based on required pattern
];

// Recalculating hole centers to ensure they are centered relative to the plate center (0,0)
// For N items spaced S apart, the total span is (N-1)*S. The center of this span is at ((N-1)/2)*S.
// We need the coordinates for 6 holes along X and 2 holes along Y centered on the origin.

// X coordinates: Span = 5 * 18 = 90 mm. Center should be 0. Start point must be -45.
x_start_offset = -(num_holes_x - 1) / 2 * spacing_x;
hole_x_centers = [
    x_start_offset + i * spacing_x for i in [0 : num_holes_x - 1]
];

// Y coordinates: Span = 1 * 18 = 18 mm. Center should be 0. Start point must be -9.
y_start_offset = -(num_holes_y - 1) / 2 * spacing_y;
hole_y_centers = [
    y_start_offset + j * spacing_y for j in [0 : num_holes_y - 1]
];


// --- Modules ---

// Module to create the base plate (Z=0 to Z=3)
module base_plate() {
    cube([base_x, base_y, base_z], center = true);
}

// Module to create the deck plate (Z=22 to Z=25)
module deck_plate() {
    translate([0, 0, deck_z_bottom]) {
        cube([base_x, base_y, deck_thickness], center = true);
    }
}

// Module for the upright walls/ribs (Z=0 to Z=25)
module upright_wall(x_pos, thickness, is_end_wall) {
    height = total_height;
    if (is_end_wall) {
        // End walls run along Y direction (thickness in X)
        translate([x_pos, 0, 0]) {
            cube([thickness, base_y, height], center = true);
        }
    } else {
        // Ribs run along Y direction (thickness in X)
        translate([x_pos, 0, 0]) {
            cube([thickness, base_y, height], center = true);
        }
    }
}

// Module to cut holes from the deck plate
module hole_cutter() {
    difference() {
        // The solid deck plate (we will subtract from this)
        deck_plate();

        // Subtracting all 12 square holes
        for (i = [0 : num_holes_x - 1]) {
            for (j = [0 : num_holes_y - 1]) {
                translate([hole_x_centers[i], hole_y_centers[j], deck_z_bottom - 0.5]) {
                    // Extend slightly past the plate thickness for clean cutting
                    cube([hole_size + 0.1, hole_size + 0.1, deck_thickness + 1], center = true);
                }
            }
        }
    }
}

// --- Assembly ---

difference() {
    // 1. Base Plate (Z=0 to Z=3)
    base_plate();

    // 2. Upright Walls/Ribs (Z=0 to Z=25) - These form the structure connecting base and deck
    union() {
        // Two end walls flush with short ends (X = +/- base_x/2). Thickness = 3mm.
        // They span the full Y dimension (base_y).
        upright_wall(0, end_wall_thickness, true); // X=0 is center of thickness for this wall if we treat it as a slab cut from origin
        translate([base_x/2 - end_wall_thickness/2, 0, 0]) { upright_wall(0, end_wall_thickness, true); } // Positive X end wall

        // The description implies the two end walls are flush with the short ends (Y = +/- base_y/2).
        // Let's redefine the end walls to be along Y axis, spanning X dimension.
        // End Wall 1 (Negative Y): Thickness=3mm, spans X=base_x, Z=0..25
        translate([0, -base_y/2 + end_wall_thickness/2, 0]) {
            cube([base_x, end_wall_thickness, total_height], center = false);
        }
        // End Wall 2 (Positive Y): Thickness=3mm, spans X=base_x, Z=0..25
        translate([0, base_y/2 - end_wall_thickness/2, 0]) {
            cube([base_x, end_wall_thickness, total_height], center = false);
        }


        // Five ribs centered at X = -36, -18, 0, 18, 36. Thickness = 2.5mm. Span Y=base_y.
        for (i = [0 : 4]) {
            x_rib = [-36, -18, 0, 18, 36][i];
            // Ribs are centered on the X coordinate and span the full Y dimension
            translate([x_rib, 0, 0]) {
                cube([rib_thickness, base_y, total_height], center = true);
            }
        }
    }

    // 3. Deck Plate (Z=22 to Z=25) - This is the part that gets holes cut out of it
    hole_cutter();
}