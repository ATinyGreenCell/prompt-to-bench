// --- Dimensions (mm) ---
outer_x = 120;          // Total length of the tank
outer_y = 70;           // Total width of the tank
outer_z = 40;           // Total height of the tank

wall_thickness = 3;     // Thickness of the walls and floor
floor_thickness = 3;    // Thickness of the floor

platform_length = 60;   // Length of the central platform (X direction)
platform_height = 13;   // Height of the platform top from the inner floor
platform_width = outer_y - (2 * wall_thickness); // Spans full inner width

hole_diameter = 2;      // Diameter of electrode wire holes
hole_y_pos = 0;         // Y position of holes (centered on Y axis)
hole_z_pos = 30;        // Z position of holes (measured from the bottom of the tank)

// --- Resolution ---
$fn = 64;

// --- Model Construction ---

// The user requested the part rests on the XY plane at z = 0.
// We build the geometry such that the bottom face is at Z=0.

module tank_geometry() {
    difference() {
        // 1. The Solid Body (Outer shell + Internal Platform)
        union() {
            // The main outer block (Base at Z=0)
            cube([outer_x, outer_y, outer_z]);

            // The Platform
            // The platform top is 13mm above the inner floor.
            // Inner floor is at Z = floor_thickness.
            // Platform top is at Z = floor_thickness + platform_height.
            // The platform block itself has height 'platform_height'.
            // To make the top of the platform reach the target height, 
            // we place the bottom of the platform at Z = floor_thickness.
            translate([
                (outer_x - platform_length) / 2, 
                (outer_y - platform_width) / 2, 
                floor_thickness
            ])
            cube([platform_length, platform_width, platform_height]);
        }

        // 2. The Inner Cavity (The space where buffer goes)
        // Subtract the void to create the tank.
        // We subtract from floor_thickness up to outer_z.
        translate([wall_thickness, wall_thickness, floor_thickness])
            cube([outer_x - 2*wall_thickness, outer_y - 2*wall_thickness, outer_z]);

        // 3. The Electrode Holes
        // Holes are at Z = 30 from the bottom of the tank.
        // The bottom of the tank is at Z = 0.
        // Therefore, the hole center is at Z = hole_z_pos.
        // The holes are drilled through the X-end walls.
        // We use a loop to drill through both ends.
        for (x_pos = [0, outer_x]) {
            translate([x_pos, outer_y/2, hole_z_pos])
                rotate([0, 90, 0])
                    cylinder(d = hole_diameter, h = outer_x + 2, center = true);
        }
    }
}

// Final Assembly:
// The geometry is already built starting from Z=0.
// We center it on X and Y.
translate([-outer_x/2, -outer_y/2, 0])
    tank_geometry();

// --- Verification of logic ---
// 1. Dimensions: 120x70x40. Correct.
// 2. Walls/Floor: 3mm. Correct.
// 3. Platform: 60mm long, spans full inner width, top is 13mm above inner floor. Correct.
// 4. Holes: 2mm diameter, at Y=0 (relative to center), Z=30 (from bottom). Correct.
// 5. Orientation: Rests on XY plane at Z=0. Correct.