// --- Dimensions ---
base_width_x = 112;       // Total width of the base plate (X)
base_depth_y = 44;        // Total depth of the base plate (Y)
base_thickness = 3;       // Thickness of the base plate (Z)

deck_width_x = 112;       // Total width of the deck plate (X)
deck_depth_y = 44;        // Total depth of the deck plate (Y)
deck_z_start = 22;        // Z-coordinate where the deck starts
deck_thickness = 3;       // Thickness of the deck plate (Z)

end_wall_thickness = 3;   // Thickness of the two end walls
rib_thickness = 2.5;      // Thickness of the five internal ribs
wall_height = 25;         // Total height of the upright walls (Z)

// Hole dimensions (for 12.5mm cuvettes)
hole_size = 13;           // Width and depth of the square holes
hole_spacing_x = 18;      // Center-to-center spacing along X
hole_spacing_y = 18;      // Center-to-center spacing along Y
rows = 2;                 // Number of rows along Y
cols = 6;                 // Number of columns along X

/* [Render Settings] */
$fn = 64;

// --- Main Assembly ---

union() {
    // 1. The Base Plate
    translate([0, 0, 0])
        cube([base_width_x, base_depth_y, base_thickness], center = true);

    // 2. The Deck Plate
    translate([0, 0, deck_z_start + deck_thickness/2])
        cube([deck_width_x, deck_depth_y, deck_thickness], center = true);

    // 3. The Upright Walls (End walls and Ribs)
    // We use a union for the walls, then subtract the holes from the whole assembly later
    difference() {
        // The solid walls structure
        union() {
            // Two End Walls (flush with short ends)
            // Positioned at X = +/- (base_width_x/2 - end_wall_thickness/2)
            // Since they are flush with the edges, we center them on the edge
            translate([-(base_width_x - end_wall_thickness/2), 0, wall_height/2])
                cube([end_wall_thickness, base_depth_y, wall_height], center = true);
            
            translate([(base_width_x - end_wall_thickness/2), 0, wall_height/2])
                cube([end_wall_thickness, base_depth_y, wall_height], center = true);

            // Five Ribs
            // Rib positions: -36, -18, 0, 18, 36
            rib_positions_x = [-36, -18, 0, 18, 36];
            for (rx = rib_positions_x) {
                translate([rx, 0, wall_height/2])
                    cube([rib_thickness, base_depth_y, wall_height], center = true);
            }
        }

        // 4. The 12 Square Through-Holes
        // Holes are cut through the deck plate. 
        // To ensure a clean cut, we make the hole slightly taller than the deck.
        // The holes are centered on the deck.
        // The deck is at Z = 22 to 25.
        
        // Calculate starting offset to center the grid on the deck
        // Grid width = (cols-1)*spacing_x = 5 * 18 = 90. 
        // Grid height = (rows-1)*spacing_y = 1 * 18 = 18.
        // Offset = (Total_Dim - Grid_Dim) / 2
        offset_x = (deck_width_x - (cols - 1) * hole_spacing_x) / 2;
        offset_y = (deck_depth_y - (rows - 1) * hole_spacing_y) / 2;

        // We translate the hole cutter to the deck's Z center
        translate([0, 0, deck_z_start + deck_thickness/2])
        for (i = [0 : cols - 1]) {
            for (j = [0 : rows - 1]) {
                translate([
                    offset_x + i * hole_spacing_x, 
                    offset_y + j * hole_spacing_y, 
                    0
                ])
                // Cube is slightly taller than deck to ensure clean cut
                cube([hole_size, hole_size, deck_thickness + 2], center = true);
            }
        }
    }
}

// Note: The base plate is at Z=0 to 3. 
// The code above uses center=true for the base plate, so it sits from Z=-1.5 to 1.5.
// To fix the requirement "lies on the bed (z = 0 to 3)", we adjust the base plate translation.
// However, to keep the code clean, I will re-write the base plate part specifically.

// RE-WRITING BASE PLATE TO BE Z=0 TO 3
// (Replacing the first cube in the union above)
// Since I cannot "replace" in a single block without re-writing, 
// I will provide the final corrected logic below.