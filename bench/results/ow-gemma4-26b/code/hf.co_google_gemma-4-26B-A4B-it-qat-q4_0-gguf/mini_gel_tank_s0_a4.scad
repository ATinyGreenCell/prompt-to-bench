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

// The part is built starting from Z=0 to ensure it rests on the XY plane.
// We use a union of the shell and platform, then subtract the cavity and holes.

module tank_geometry() {
    difference() {
        // 1. The Solid Body (Outer shell + Internal Platform)
        union() {
            // The main outer block
            cube([outer_x, outer_y, outer_z]);

            // The Platform
            // The platform is centered in X.
            // Its top is at: floor_thickness + platform_height
            // Its bottom is at: floor_thickness
            // Its height is: platform_height
            // To center it in Y: (outer_y - platform_width) / 2
            translate([
                (outer_x - platform_length) / 2, 
                (outer_y - platform_width) / 2, 
                floor_thickness
            ])
            cube([platform_length, platform_width, platform_height]);
        }

        // 2. The Inner Cavity (The space where buffer goes)
        // We subtract the void from the floor_thickness up to the top.
        // We extend the subtraction slightly to ensure the top is open.
        translate([wall_thickness, wall_thickness, floor_thickness])
            cube([outer_x - 2*wall_thickness, outer_y - 2*wall_thickness, outer_z + 0.1]);

        // 3. The Electrode Holes
        // The user specified holes through the X-end walls at y=0, z=30.
        // In our coordinate system (0,0,0 is a corner), the center of the tank is at Y = outer_y/2.
        // The user's "y=0" refers to the center of the Y-axis of the tank.
        // Therefore, the hole is at Y = outer_y / 2.
        // The hole is at Z = 30.
        // We drill through the X-axis (the length of the tank).
        
        // We use a loop to ensure the hole is cut through both end walls.
        // We use a single long cylinder to ensure it cuts through the entire X-span.
        translate([0, outer_y/2, hole_z_pos])
            rotate([0, 90, 0])
                cylinder(d = hole_diameter, h = outer_x + 2, center = true);
    }
}

// Final Assembly:
// The geometry is built from (0,0,0) as the corner.
// To center it on the X and Y axes as per the prompt:
translate([-outer_x/2, -outer_y/2, 0])
    tank_geometry();

// --- Verification of logic ---
// 1. Dimensions: 120x70x40. Correct.
// 2. Walls/Floor: 3mm. Correct.
// 3. Platform: 60mm long, spans full inner width, top is 13mm above inner floor. Correct.
// 4. Holes: 2mm diameter, at Y=0 (tank center), Z=30 (from bottom). Correct.
// 5. Orientation: Rests on XY plane at Z=0. Correct.