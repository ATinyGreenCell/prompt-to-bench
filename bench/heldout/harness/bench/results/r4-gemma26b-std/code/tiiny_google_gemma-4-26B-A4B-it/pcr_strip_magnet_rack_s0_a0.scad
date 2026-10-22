// Magnetic Bead Rack for 8-tube PCR strip
// Designed for FDM 3D printing

// --- Dimensions ---
block_x = 80.0;          // Total length of the block
block_y = 24.0;          // Total width of the block
block_z = 20.0;          // Total height of the block

tube_count = 8;          // Number of tubes
tube_spacing = 9.0;      // Center-to-center distance between tubes
tube_hole_dia = 6.4;     // Diameter of the top part of the tube seat
tube_bottom_dia = 3.0;   // Diameter of the bottom part of the tube seat
tube_z_top = 20.0;       // Top face of the block (Z)
tube_z_mid = 12.0;       // Z height where the cone starts
tube_z_bottom = 2.0;     // Z height where the cone ends
tube_floor = 2.0;        // Thickness of the floor at the bottom of the seat

magnet_count = 2;        // Number of magnets
magnet_len = 60.4;       // Length of the magnet (X)
magnet_wid = 3.3;        // Width of the magnet (Y)
magnet_h = 10.2;         // Height of the magnet (Z)
magnet_y_pos1 = -6.0;    // Y position of first magnet center
magnet_y_pos2 = 6.0;     // Y position of second magnet center

// --- Parameters ---
$fn = 64;                // Smoothness for cylinders
eps = 0.1;              // Overlap for difference operations

// --- Main Assembly ---
difference() {
    // The main block
    translate([-block_x/2, -block_y/2, 0])
        cube([block_x, block_y, block_z]);

    // 1. Tube Seats
    // Calculated to be centered on the block along X and at y = 0
    for (i = [0 : tube_count - 1]) {
        // Calculate X position: 
        // Total distance between first and last tube is (7 * 9) = 63mm.
        // To center 63mm in an 80mm block, start at (80-63)/2 = 8.5
        x_pos = (-block_x/2 + tube_spacing/2) + (i * tube_spacing);
        
        // Tube Seat Geometry:
        // A cylinder for the top part, and a cone for the bottom part.
        // We use a hull of two cylinders to create the conical transition.
        translate([x_pos, 0, tube_z_bottom]) {
            union() {
                // Top cylinder (the hole)
                cylinder(h = tube_z_mid - tube_z_bottom, d = tube_hole_dia);
                
                // Conical section (using hull of two cylinders)
                hull() {
                    // Bottom of cone
                    translate([0, 0, 0])
                        cylinder(h = 0.01, d = tube_bottom_dia);
                    // Top of cone
                    translate([0, 0, tube_z_mid - tube_z_bottom])
                        cylinder(h = 0.01, d = tube_hole_dia);
                }
            }
        }
    }

    // 2. Magnet Pockets
    // Pockets are open at the bottom (z=0) and centered at y = -6 and y = 6
    for (m_y = [magnet_y_pos1, magnet_y_pos2]) {
        translate([0, m_y, -eps]) // -eps to ensure it cuts through the bottom
            cube([magnet_len, magnet_wid, magnet_h + eps]);
    }
}

// Note: The tube seats are subtracted from the block. 
// The magnet pockets are subtracted from the block.
// The block is centered on X and Y at Z=0.