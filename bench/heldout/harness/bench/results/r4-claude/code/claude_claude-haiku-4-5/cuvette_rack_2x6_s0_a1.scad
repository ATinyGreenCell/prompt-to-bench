// Cuvette Rack - 12 slots (2 rows × 6 columns)
// Dimensions in millimeters

// Base and deck dimensions
base_x = 112;           // Base plate width (X)
base_y = 44;            // Base plate depth (Y)
base_z = 3;             // Base plate thickness
deck_z = 3;             // Deck plate thickness
deck_bottom_z = 22;     // Deck bottom position (z)
deck_top_z = 25;        // Deck top position (z)

// Wall dimensions
wall_height = 25;       // Height from bottom to top
end_wall_thick = 3;     // Thickness of end walls (Y direction)
rib_thick = 2.5;        // Thickness of ribs (X direction)

// Rib positions (X coordinates)
rib_x_positions = [-36, -18, 0, 18, 36];

// Hole dimensions and spacing
hole_size = 13;         // Square hole side length (mm)
hole_spacing_x = 18;    // X spacing between hole centers
hole_spacing_y = 18;    // Y spacing between hole centers

// Set resolution for curved shapes
$fn = 64;

difference() {
    // Positive geometry: base, deck, and walls
    union() {
        // Base plate (z = 0 to 3)
        translate([-base_x/2, -base_y/2, 0])
            cube([base_x, base_y, base_z]);
        
        // Deck plate (z = 22 to 25)
        translate([-base_x/2, -base_y/2, deck_bottom_z])
            cube([base_x, base_y, deck_z]);
        
        // Back end wall (at y = 22, 3 mm thick, extends inward to y = 19)
        translate([-base_x/2, base_y/2 - end_wall_thick, 0])
            cube([base_x, end_wall_thick, wall_height]);
        
        // Front end wall (at y = -22, 3 mm thick, extends inward to y = -19)
        translate([-base_x/2, -base_y/2, 0])
            cube([base_x, end_wall_thick, wall_height]);
        
        // Five vertical ribs (2.5 mm thick each)
        for (x = rib_x_positions) {
            translate([x - rib_thick/2, -base_y/2, 0])
                cube([rib_thick, base_y, wall_height]);
        }
    }
    
    // Negative geometry: through-holes in deck plate
    // 2 rows (Y) × 6 columns (X) of 13 × 13 mm square holes
    // 18 mm center-to-center spacing, centered on deck
    for (i = [0:5]) {
        for (j = [0:1]) {
            x = -45 + i * hole_spacing_x;    // X positions: -45, -27, -9, 9, 27, 45
            y = -9 + j * hole_spacing_y;     // Y positions: -9, 9
            // Cutting box extends beyond deck to ensure clean holes
            translate([x - hole_size/2, y - hole_size/2, deck_bottom_z - 0.5])
                cube([hole_size, hole_size, deck_top_z - deck_bottom_z + 1]);
        }
    }
}