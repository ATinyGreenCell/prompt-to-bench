// Open-sided cuvette rack for twelve 12.5mm square cuvettes
// Designed for FDM printing, standing on its base.

// --- Dimensions ---
base_x      = 112.0;  // Length of base plate (X)
base_y      = 44.0;   // Width of base plate (Y)
base_z      = 3.0;    // Thickness of base plate
deck_z_min  = 22.0;   // Bottom of deck plate (Z)
deck_z_max  = 25.0;   // Top of deck plate (Z)
wall_thick  = 3.0;    // Thickness of the end walls
rib_thick   = 2.5;    // Thickness of the internal ribs
hole_size   = 13.0;   // Size of the square holes (13x13mm)
hole_pitch  = 18.0;   // Center-to-center spacing of holes
rows        = 2;      // Number of rows of holes (Y)
cols        = 6;      // Number of columns of holes (X)

// Rib X-positions (centered on origin)
rib_x_pos   = [-36, -18, 0, 18, 36];

$fn = 64;

// --- Modules ---

module walls_and_base() {
    // Base Plate
    translate([-base_x/2, -base_y/2, 0])
        cube([base_x, base_y, base_z]);

    // Deck Plate
    translate([-base_x/2, -base_y/2, deck_z_min])
        cube([base_x, base_y, deck_z_max - deck_z_min]);

    // End walls (flush with short ends)
    // Left end wall
    translate([-base_x/2, -base_y/2, 0])
        cube([wall_thick, base_y, deck_z_max]);
    
    // Right end wall
    translate([base_x/2 - wall_thick, -base_y/2, 0])
        cube([wall_thick, base_y, deck_z_max]);
    
    // Internal ribs
    for (rx = rib_x_pos) {
        translate([rx - (rib_thick/2), -base_y/2, 0])
            cube([rib_thick, base_y, deck_z_max]);
    }
}

module hole_grid() {
    grid_x_span = (cols - 1) * hole_pitch;
    grid_y_span = (rows - 1) * hole_pitch;
    
    for (i = [0 : cols - 1]) {
        for (j = [0 : rows - 1]) {
            // Calculate center of each hole relative to origin (0,0)
            cx = (i - (cols - 1) / 2.0) * hole_pitch;
            cy = (j - (rows - 1) / 2.0) * hole_pitch;
            
            // Subtract from the deck (Z = 22 to 25)
            // We extend the hole slightly in Z to ensure a clean cut
            translate([cx - hole_size/2, cy - hole_size/2, deck_z_min - 0.1])
                cube([hole_size, hole_size, (deck_z_max - deck_z_min) + 0.2]);
        }
    }
}

// --- Final Assembly ---

difference() {
    // The main body of the rack
    walls_and_base();
    
    // Subtract the holes from the deck
    hole_grid();
}