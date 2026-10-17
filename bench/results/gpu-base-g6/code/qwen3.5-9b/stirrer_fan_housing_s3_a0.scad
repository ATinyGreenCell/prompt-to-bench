// DIY Magnetic Stirrer Housing for 80mm PC Fan
// Print Orientation: Upside down (Top plate on bed, walls rising up)
// Units: mm

// --- Dimensions ---
// Outer size of the box
W = 90;
H = 90;

// Thickness of the top plate (resting on bed)
T_top = 2;

// Height of the walls
H_wall = 40;

// Wall thickness
T_wall = 2.5;

// Fan mounting hole pattern
// Pattern is 71.5mm square, centred on the plate
PATTERN_SIZE = 71.5;
HOLE_SIZE = 4.5; // M4 screw hole

// Cable notch dimensions
NOTCH_WIDTH = 12;
NOTCH_DEPTH = 8; // Reaches from z=32 to z=40 (40-8=32)
NOTCH_WALL = 0; // Index of the wall to cut (0:Front, 1:Right, 2:Back, 3:Left)

// --- Configuration ---
// Fan is 80mm. Outer box is 90mm.
// Wall thickness is 2.5mm.
// Inner width = 90 - 2*2.5 = 85mm.
// Fan (80mm) fits inside 85mm inner space with 2.5mm clearance on each side.
// This matches the user's description of covering the fan.

$fn = 128; // High resolution for smooth curves and accurate hole sizes

// --- Helper Functions ---

// Create the solid base (top plate)
module create_base() {
    translate([0, 0, 0]) {
        cube([W, H, T_top]);
    }
}

// Create the four walls rising from the base
// We construct the walls as a single block with internal cavities to save memory and ensure watertightness
// The walls are 2.5mm thick.
// The inner void starts at z = T_top.
module create_walls() {
    // Define the outer profile of the walls (including the base footprint)
    // The walls sit on top of the base, so their bottom is at z = T_top.
    // However, to make one solid object, we can extrude a profile that includes the base thickness.
    
    // Let's build the walls as a hollow box starting from z = T_top
    // Outer dimensions of the wall structure: W x H
    // Inner dimensions of the wall structure: (W - 2*T_wall) x (H - 2*T_wall)
    
    translate([0, 0, T_top]) {
        // Outer block of the walls
        cube([W, H, H_wall]);
        
        // Cut out the inner cavity
        translate([T_wall, T_wall, T_top]) {
            cube([W - 2*T_wall, H - 2*T_wall, H_wall]);
        }
        
        // Cut out the cable notch
        // Notch is in one wall. Let's assume Wall 0 (Front, facing +Y) for simplicity in modeling,
        // then we can rotate if needed, but the prompt says "In one wall". 
        // Let's place it on the wall at Y = H/2 - T_wall (Front face).
        // Notch width: 12mm. Centred along the wall.
        // Notch depth: 8mm from the open edge (z=40) down to z=32.
        
        // Position of the notch:
        // X: Centred on the wall width (W). Wall is from x=0 to x=W.
        // Y: At the front face of the wall. The wall face is at y = H - T_wall.
        // Z: From 32 to 40.
        
        translate([
            (W - NOTCH_WIDTH)/2, 
            H - T_wall, 
            32
        ]) {
            cube([NOTCH_WIDTH, T_wall, NOTCH_DEPTH]);
        }
    }
}

// Create the screw holes
// Pattern: 71.5mm square, centred on the plate.
// The plate is 90x90.
// The pattern is centred on the plate, so the holes are at:
// x = +/- (71.5/2 - 4.5/2) = +/- 33.5
// y = +/- (71.5/2 - 4.5/2) = +/- 33.5
// Wait, "71.5 mm square pattern centred on the plate".
// Usually this means the distance between hole centers is 71.5mm.
// Center of plate is (0,0).
// Hole centers: (33.5, 33.5), (33.5, -33.5), (-33.5, 33.5), (-33.5, -33.5).

module create_screw_holes() {
    translate([0, 0, T_top]) {
        // We need to cut holes through the top plate (z=0 to z=2)
        // And potentially through the walls if they align, but the prompt says "through the top plate".
        // The walls are 2.5mm thick. The holes are 4.5mm.
        // If we cut a cylinder of 4.5mm diameter through the top plate, it will stop at z=2.
        // The walls are attached to the top plate.
        // To ensure the screws go through the top plate and into the wall (or just through the top),
        // we cut the cylinder. Since the walls are 2.5mm thick and the hole is 4.5mm,
        // the hole will pass through the top plate and enter the wall cavity if the wall is thin enough?
        // No, the wall is 2.5mm thick. The hole is 4.5mm diameter.
        // The hole will pass through the top plate (2mm) and then hit the wall material?
        // Actually, the wall is 2.5mm thick. The hole is 4.5mm wide.
        // The hole will pass through the top plate and cut into the wall.
        // This is fine for M4 screws; they will go through the top plate and thread into the wall or the fan mount.
        
        // Let's just cut the cylinder. It will go through the top plate and into the wall.
        // To ensure clean cuts, we extend slightly past the bottom of the wall if needed, 
        // but the prompt says "through the top plate". 
        // Let's cut exactly through the top plate (z=0 to z=2) and maybe a tiny bit into the wall to ensure clearance.
        // Actually, standard practice: cut through the top plate. The wall is 2.5mm.
        // If we cut a cylinder of height 2mm, it stops at z=2.
        // The wall starts at z=2. The hole is 4.5mm. The wall is 2.5mm thick.
        // The hole will be 4.5mm wide. The wall is 2.5mm thick.
        // The hole will pass through the top plate and cut a 4.5mm hole in the 2.5mm wall.
        // This is acceptable.
        
        // Coordinates:
        // Pattern size 71.5mm. Half size = 35.75mm.
        // Hole radius = 2.25mm.
        // Offset = 35.75 - 2.25 = 33.5mm.
        
        offset = (PATTERN_SIZE / 2) - (HOLE_SIZE / 2);
        
        for (i = [-1, 1]) {
            for (j = [-1, 1]) {
                translate([
                    i * offset,
                    j * offset,
                    0
                ]) {
                    cylinder(
                        h = T_top + 0.1, // Extend slightly past top plate to ensure clean cut
                        r = HOLE_SIZE / 2,
                        $fn = 32
                    );
                }
            }
        }
    }
}

// --- Main Assembly ---
union() {
    create_base();
    create_walls();
    create_screw_holes();
}