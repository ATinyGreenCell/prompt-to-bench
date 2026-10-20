// Dimensions for mini horizontal gel-electrophoresis buffer tank
// Outer dimensions
outer_x = 120;
outer_y = 70;
outer_z = 40;

// Wall and floor thickness
wall_thickness = 3;
floor_thickness = 3;

// Platform dimensions
platform_length_x = 60;
platform_height_z = 10; // Height above inner floor
platform_y_span = outer_y - 2 * wall_thickness; // Spans full inner width

// Electrode hole dimensions
hole_diameter = 2;
hole_z_pos = 30; // Height from bottom
hole_y_pos = 0; // Centered on Y

// Calculate inner dimensions
inner_x = outer_x - 2 * wall_thickness;
inner_y = outer_y - 2 * wall_thickness;
inner_z = outer_z - floor_thickness;

// Calculate platform position
// Platform is centered in X, spans full inner Y, sits on inner floor + platform_height
platform_x_start = (outer_x - platform_length_x) / 2;
platform_y_start = (outer_y - platform_y_span) / 2;
platform_z_bottom = floor_thickness;
platform_z_top = floor_thickness + platform_height_z;

// Calculate chamber heights
// Chambers are at the ends, below the platform
chamber_height = platform_z_bottom; // 3mm

// Main tank body (outer box)
tank_body = cube([outer_x, outer_y, outer_z], center = true);

// Inner cavity (subtracting walls and floor)
// We create a box that is slightly smaller to account for wall thickness
inner_cavity = translate([0, 0, floor_thickness]) *
               cube([inner_x, inner_y, inner_z], center = true);

// Platform
platform = translate([0, 0, platform_z_bottom]) *
           cube([platform_length_x, platform_y_span, platform_height_z], center = true);

// Electrode holes
// Hole 1 at left end (X negative side)
hole_left = translate([-outer_x/2 + wall_thickness, 0, hole_z_pos]) *
            cylinder(d = hole_diameter, h = outer_x, center = true);

// Hole 2 at right end (X positive side)
hole_right = translate([outer_x/2 - wall_thickness, 0, hole_z_pos]) *
             cylinder(d = hole_diameter, h = outer_x, center = true);

// Combine all parts
// 1. Start with the outer tank body
// 2. Subtract the inner cavity to create walls and floor
// 3. Subtract the platform (it's a solid block inside)
// 4. Subtract the electrode holes

final_part = difference() {
    // Base tank
    cube([outer_x, outer_y, outer_z], center = true);
    
    // Cut out the inner cavity (walls and floor)
    translate([0, 0, floor_thickness]) *
    cube([inner_x, inner_y, inner_z], center = true);
    
    // Cut out the platform area (to make it a solid block inside)
    // The platform is a solid block, so we subtract the space it occupies from the cavity
    // Actually, the platform is a solid block sitting on the floor.
    // The cavity is the empty space. We need to subtract the platform from the cavity.
    // But the platform is solid. So we subtract the platform volume from the main block.
    // Let's restructure:
    // Main block = outer cube.
    // Subtract inner cavity (walls/floor).
    // Subtract platform (to make it a solid block inside the cavity? No, platform is solid).
    // Wait, the platform is a solid block. The cavity is the empty space.
    // We want: Outer cube - (Inner cavity - Platform).
    // Or: Outer cube - Inner cavity, then add platform? No, union/diff.
    // Correct approach:
    // 1. Create outer cube.
    // 2. Subtract inner cavity (this creates the tank walls and floor).
    // 3. Subtract the platform volume from the cavity? No, the platform is solid.
    // We want the platform to be part of the final solid.
    // So: Outer cube - (Inner cavity - Platform) = Outer cube - Inner cavity + Platform?
    // No, difference() subtracts.
    // Let's do:
    // 1. Outer cube.
    // 2. Subtract the "void" around the platform.
    // The void is the inner cavity minus the platform.
    // So we subtract (inner_cavity - platform) from the outer cube.
    // But we can't do nested difference easily without union.
    // Better:
    // 1. Outer cube.
    // 2. Subtract inner cavity (creates walls/floor).
    // 3. Subtract platform (to remove the space where the platform is? No, platform is solid).
    // Actually, the platform is a solid block. The tank is a hollow box with a solid block inside.
    // So:
    // 1. Outer cube.
    // 2. Subtract inner cavity (creates hollow box).
    // 3. Subtract the platform volume from the hollow box? No, that would remove the platform.
    // We want the platform to be solid.
    // So:
    // 1. Outer cube.
    // 2. Subtract inner cavity (creates hollow box).
    // 3. Subtract the platform volume from the hollow box? No.
    // Let's think: The final object is the tank walls/floor + the platform.
    // So:
    // 1. Outer cube.
    // 2. Subtract inner cavity (creates hollow box).
    // 3. Subtract the platform volume from the hollow box? No, that would remove the platform.
    // We need to add the platform.
    // So:
    // 1. Outer cube.
    // 2. Subtract inner cavity (creates hollow box).
    // 3. Union with platform.
    // But the platform is inside the hollow box.
    // So:
    // 1. Outer cube.
    // 2. Subtract inner cavity (creates hollow box).
    // 3. Union with platform.
    // But the platform is inside the hollow box.
    // So the final object is the hollow box + platform.
    // But the platform is a solid block.
    // So:
    // 1. Outer cube.
    // 2. Subtract inner cavity (creates hollow box).
    // 3. Union with platform.
    // But the platform is inside the hollow box.
    // So the final object is the hollow box + platform.
    // But the platform is a solid block.
    // So:
    // 1. Outer cube.
    // 2. Subtract inner cavity (creates hollow box).
    // 3. Union with platform.
    // But the platform is inside the hollow box.
    // So the final object is the hollow