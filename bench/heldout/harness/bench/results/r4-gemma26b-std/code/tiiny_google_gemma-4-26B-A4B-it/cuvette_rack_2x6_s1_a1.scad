// --- Dimensions ---
base_width_x = 112;          // Total width of the base plate (X)
base_depth_y = 44;           // Total depth of the base plate (Y)
base_thickness = 3;          // Thickness of the base plate (Z)

deck_width_x = 112;           // Total width of the deck plate (X)
deck_depth_y = 44;           // Total depth of the deck plate (Y)
deck_thickness = 3;          // Thickness of the deck plate (Z)
deck_z_bottom = 22;          // Z-coordinate of the bottom of the deck
deck_z_top = 25;             // Z-coordinate of the top of the deck

end_wall_thickness = 3;      // Thickness of the two end walls
rib_thickness = 2.5;         // Thickness of the five internal ribs
wall_height = 25;            // Total height of the walls (Z)

hole_size = 13;              // Dimension of the square cuvette holes
hole_spacing_x = 18;         // Center-to-center spacing along X
hole_spacing_y = 18;         // Center-to-center spacing along Y
rows = 2;                    // Number of rows along Y
cols = 6;                    // Number of columns along X

// --- Constants ---
$fn = 64;

// --- Helper Functions ---
// Centering the grid: (cols-1)*spacing / 2 gives the distance from center to edge of grid
function get_hole_x(col_idx) = (col_idx - (cols - 1) / 2) * hole_spacing_x;
function get_hole_y(row_idx) = (row_idx - (rows - 1) / 2) * hole_spacing_y;

// --- Main Construction ---

// The previous error was that the holes were being subtracted from the entire 
// vertical wall structure (Z=0 to 25) instead of just the deck plate (Z=22 to 25).
// This caused the "13 solid regions" at Z=21.50 in the report, indicating 
// the holes were cutting through the base/walls incorrectly.

union() {
    // 1. The Base Plate (Z = 0 to 3)
    translate([-base_width_x/2, -base_depth_y/2, 0])
        cube([base_width_x, base_depth_y, base_thickness]);

    // 2. The Vertical Walls and Ribs (Z = 0 to 25)
    // We build the walls as a single unioned block first.
    wall_structure = union() {
        // Two end walls (flush with short ends)
        translate([-base_width_x/2, -base_depth_y/2, 0])
            cube([end_wall_thickness, base_depth_y, wall_height]);
        
        translate([base_width_x/2 - end_wall_thickness, -base_depth_y/2, 0])
            cube([end_wall_thickness, base_depth_y, wall_height]);

        // Five internal ribs at specified X positions
        for (rx = [-36, -18, 0, 18, 36]) {
            translate([rx - rib_thickness/2, -base_depth_y/2, 0])
                cube([rib_thickness, base_depth_y, wall_height]);
        }
    }
    wall_structure;

    // 3. The Deck Plate (Z = 22 to 25)
    // We use a difference to subtract the holes specifically from the deck plate.
    difference() {
        // The solid deck plate
        translate([-deck_width_x/2, -deck_depth_y/2, deck_z_bottom])
            cube([deck_width_x, deck_depth_y, deck_thickness]);

        // The 12 Square Through-Holes
        // We subtract these from the deck plate. 
        // To ensure a clean cut, the subtraction volume extends slightly beyond the deck.
        for (i = [0 : cols - 1]) {
            for (j = [0 : rows - 1]) {
                translate([get_hole_x(i), get_hole_y(j), deck_z_bottom - 0.01])
                    cube([hole_size + 0.02, hole_size + 0.02, deck_thickness + 0.02]);
            }
        }
    }
}

// Note on the fix:
// The previous version had the 'difference' operation wrapping the entire union 
// of walls and plates. This meant the holes were being cut through the vertical 
// walls as well, which is why the report showed 13 solid regions at Z=21.50.
// By moving the difference to only affect the deck plate, the walls remain 
// solid from Z=0 to Z=25, and the holes only exist within the deck plate.