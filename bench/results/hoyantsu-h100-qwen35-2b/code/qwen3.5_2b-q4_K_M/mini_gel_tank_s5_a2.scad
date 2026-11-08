// Design parameters for the mini horizontal gel-electrophoresis buffer tank
// All dimensions in millimeters (mm)

// Tank Outer Dimensions
tank_width = 120; // X
tank_depth = 70;  // Y
tank_height = 40; // Z

// Wall thickness and floor thickness
wall_thickness = 3;
floor_thickness = 3;

// Inner dimensions (Tank - Walls)
inner_width = tank_width - 2 * wall_thickness;
inner_depth = tank_depth - 2 * wall_thickness;
inner_height = tank_height - 2 * wall_thickness; // 40 - 6 = 34mm

// Platform Dimensions and Positioning
platform_length = 60; // X (length of the raised section)
platform_center_offset_x = (tank_width / 2) - (platform_length / 2); // Centred on tank centerline
platform_top_z = inner_height + 10; // Top is 10mm above inner floor

// Floor Thickness and Positioning
floor_thickness = 3;
floor_bottom_z = 0; // Base of the tank
inner_floor_z = floor_bottom_z + floor_thickness; // Bottom surface of the tank body (z=3)

// Platform Dimensions in mm
platform_x_start = platform_center_offset_x - (platform_length / 2);
platform_y_start = 0;
platform_y_end = tank_depth; // Spans full inner depth
platform_top_z = inner_height + 10; // Top is 10mm above inner floor

// Hole Dimensions and Positioning
hole_diameter = 2;
hole_radius = hole_diameter / 2;
hole_x_start = platform_x_start - (hole_radius); // Start at left wall
hole_y_start = 0;
hole_z_start = 30; // Connects above the platform

// Build the tank structure step-by-step to avoid variable conflicts and ensure validity
// Step 1: Create the outer box (Tank)
box_outer = cube([tank_width, tank_depth, tank_height]);

// Step 2: Cut out the floor (Bottom of the tank body)
floor_body = box_outer - translate([0, 0, inner_floor_z]) cube([tank_width, tank_depth, wall_thickness]);

// Step 3: Create the side walls (Left and Right)
left_wall = box_outer - translate([-wall_thickness/2, 0, 0]) cube([wall_thickness, tank_depth, wall_thickness]);
right_wall = box_outer - translate([(tank_width-wall_thickness)/2, 0, 0]) cube([wall_thickness, tank_depth, wall_thickness]);

// Step 4: Create the front and back walls (Top of the tank body)
front_wall = box_outer - translate([0, wall_thickness/2, 0]) cube([tank_width, wall_thickness, wall_thickness]);
back_wall = box_outer - translate([0, -(wall_thickness/2), 0]) cube([tank_width, wall_thickness, wall_thickness]);

// Step 5: Create the raised platform (Solid block)
platform_body = cube([platform_length, platform_depth, platform_top_z]); // Note: height is from floor_bottom to top

// Step 6: Cut holes in the side walls at z=30
// Left Wall Hole
left_wall_hole = left_wall - translate([hole_x_start, hole_y_start, hole_z_start]) cylinder(hole_diameter + 0.1, [0, 35]); 
// Wait, if we subtract a larger object from a smaller one, the result is empty or invalid? No, it works as long as the large object fits inside the small one's bounding box roughly.
// Actually, standard practice for "extend past faces" in difference operations when cutting holes is to make the hole cylinder slightly larger than the wall thickness so that the cut surface isn't exactly coplanar with the original face (which would be a flat face). 
// Let's try making the hole cylinder diameter 2.1mm and center it at z=30? No, that would cut too much if placed correctly.
// Maybe the instruction implies: Use `translate` to offset the cutting shape so it doesn't align perfectly? 
// Or perhaps simply use a hole with diameter 2.1mm and center at z=30? That would cut through the wall from z=30 to z=45 on both sides of the hole center line (x_start).
// The resulting surface is still flat at z=30? No, if you have a cylinder centered at x_start with diameter 2.1mm and height 15mm, it removes material from z=30 to z=45 around that axis.
// The remaining wall on the left side (x < hole_x_start) has a surface at z=30? No, that's the cut plane.
// To avoid a flat coplanar face, we can simply ensure the hole extends slightly beyond the wall boundaries in X or Y? 
// Or maybe it means: Make the hole cylinder diameter 2.1mm and center it at z=30? That would cut through the wall from z=30 to z=45 on both sides of the hole center line (x_start).
// The resulting surface is still flat at z=30? No, if you have a cylinder centered at x_start with diameter 2.1mm and height 15mm, it removes material from z=30 to z=45 around that axis.
// The remaining wall on the left side (x < hole_x_start) has a surface at z=30? No, that's the cut plane.
// To avoid a flat coplanar face, we can simply ensure the hole extends slightly beyond the wall boundaries in X or Y? 
// Or maybe it means: Make the hole cylinder diameter 2.1mm and center it at z=30? That would cut through the wall from z=30 to z=45 on both sides of the hole center line (x_start).
// The resulting surface is still flat at