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
inner_height = tank_height - 2 * wall_thickness;

// Platform Dimensions and Positioning
platform_length = 60; // X
platform_center_offset_x = (tank_width / 2) - (platform_length / 2); // Centred on inner width
platform_top_z = 13; // Top is 10mm above inner floor (40-3=37, wait: 40-3=37. Let's re-read carefully).

// Re-evaluating Z coordinates based on "top is 10 mm above the inner floor"
inner_height = tank_height - wall_thickness - floor_thickness; // 40 - 3 - 3 = 34mm? 
// Or does it mean the platform sits on the outer bottom and rises 10mm from there?
// "spans the full inner width... is 60 mm long in X (centred), and its top is 10 mm above the inner floor"
// Inner floor height = tank_height - wall_thickness - floor_thickness = 40 - 3 - 3 = 34mm.
// So platform_top_z = 34 + 10 = 44mm? 
// Let's look at the wording again: "outer dimensions... 40 mm (Z), 3 mm walls and a 3 mm floor."
// Usually, this implies the tank is 40mm tall. The platform sits on the bottom of the tank.
// If the platform top is 10mm above the inner floor, we need to calculate where that is relative to the outer Z=0.
// Inner Floor Height = Tank_Height - Wall_Top_Z - Floor_Top_Z? No, usually walls are vertical.
// Let's assume standard construction: Outer Box (40x120x70). Walls 3mm thick. Floor 3mm thick.
// The "inner floor" is the bottom surface of the tank body.
// Height of inner floor = Tank_Height - Wall_Top_Z - Floor_Top_Z? 
// Actually, usually: Outer Bottom (Z=0) -> Floor (Z=-3) -> Inner Floor (Z=0).
// Then walls go up to Z=+3. Platform sits on the Inner Floor (Z=0)? Or does it sit on the outer bottom and rise 10mm?
// "top is 10 mm above the inner floor". This implies a vertical distance of 10mm from the bottom surface of the tank body.
// Let's calculate Z coordinates explicitly to ensure no overlap or gaps.

// Outer Bottom (Z=0)
outer_bottom_z = 0;

// Floor sits on outer bottom, thickness 3mm
floor_top_outer = outer_bottom_z + floor_thickness; // 3mm

// Walls sit on floor top, height wall_thickness
wall_top_outer = floor_top_outer + wall_thickness; // 6mm

// Inner Floor is the surface of the tank body at the bottom
inner_floor_z = wall_top_outer - wall_thickness; // 3mm (since walls are 3mm thick)

// Platform Top is 10mm above inner floor
platform_top_z = inner_floor_z + 10; // 13mm

// Let's verify: Tank Height 40. Floor 3. Walls 3. Inner height = 40 - 6 = 34. 
// Platform top at 13? That would mean the platform is very low, almost touching the floor.
// "spans the full inner width... is 60 mm long in X (centred), and its top is 10 mm above the inner floor"
// If the tank is 40mm tall, and walls are 3mm thick, the bottom of the tank body is at z=3. 
// The platform sits on this bottom surface? Or does it sit on the outer bottom (z=0) and rise to a top that is 10mm above the inner floor (which is at z=3)?
// If the platform rises 10mm from the inner floor, its height is 13mm. This seems low for a raised platform in a tank, but let's follow instructions literally.
// Wait, "spans the full inner width... spans the full inner depth". 
// Inner Width = 120 - 6 = 114. Platform Length = 60. It is centred on the inner width? 
// "centred" usually means centered on its own length (X-axis) or centered relative to the tank's center?
// "spans the full inner width (Y)" -> The platform goes from Y=0 to Y=70.
// "is 60 mm long in X (centred)" -> Centered on the X axis of the tank? Or centered on its own length? 
// If it spans the full inner depth, it covers Y=0 to Y=70. Its length is 60. It must be centered horizontally relative to the tank's centerline or its own center?
// "centred" usually implies symmetry around the X-axis (the long axis of the tank). 
// So Platform Center X = Tank Center X.
// Platform Length = 60. Tank Width = 120. Half width = 60.
// If it is centered on the tank's centerline, its X range would be -30 to +30? No, that doesn't span the full inner width (which is Y).
// "spans the full inner width" refers to the dimension along Y. The platform covers Y=0 to Y=70.
// "is 60 mm long in X". This means its extent in X is 60mm.
// "(centred)" -> Centered on what? Likely centered on the tank's centerline (X=60).
// So Platform X range: [60 - 30, 60 + 30] = [30, 90]. This leaves a gap of 30mm on each side.
// "The platform divides the bottom of the tank into two buffer chambers".
// If it is centered at X=60 and spans Y=0 to 70, and has length 60... 
// Wait, if it spans the full inner width (Y), then its Y extent is 70. Its X extent must be 60? That would mean it covers the whole tank width in X? No, "spans the full inner width" usually means the dimension along Y.
// Let's re-read: "solid raised platform... spans the full inner width (Y) of the tank". 
// This implies the platform extends from Y=0 to Y=70.
// "is 60 mm long in X". This implies its extent in X is 60mm.
// "(centred)" -> Centered on the X-axis? If it spans Y=0..70, and length is 60, then it must be centered around some X value such that it fits within 120 width? 
// If it is centered at X=60 (tank center), and extends 30mm left/right, its total X span is 60. This matches "is 60 mm long in X".
// So the platform covers X=[30, 90] and Y=[0, 70].
// Does this divide the tank into two chambers? 
// The tank has walls at X=0..120. The platform is at X=30..90.
// This leaves a gap on the left (X<30) and a gap on the right (X>90).
// "connect above the platform". Yes, there are openings in the side walls.

// Hole Dimensions: 2 mm diameter horizontal hole along X at y = 0, z = 30.
// Wait, "along X" usually means parallel to Y and Z axes? Or perpendicular?
// "drill a ... hole along X". In engineering drawings, if you drill along an axis, the hole is oriented perpendicular to that axis. 
// If it is at y=0 (the left wall), z=30 (middle height).
// The hole goes through the side wall (at Y=0) from bottom to top? Or just a horizontal cutout?
// "horizontal hole". This implies the hole's plane is perpendicular to Z. So it runs along X and Y.
// It connects above the platform. Platform top is at z=13. Hole is at z=30.
// The hole goes through the wall at y=0 from z=0 (or bottom) up to z=30? Or does it go all the way through?
// "connects above the platform". This implies an opening in the side wall that allows access to the chamber above the platform.
// Since the tank is open top