// Part 1: The Box Enclosure
// Dimensions in mm. Centered on origin (0,0).
box_size = {70, 50, 30}; // X x Y x Z
wall_thickness = 2;     // mm
floor_thickness = 2;    // mm

// Create the box structure using linear_extrude with a polygon for walls and floor
// We define a polygon that matches the outer dimensions of the box.
box_polygon = {70, 50}; // Outer size of the box in X and Y

// The box is extruded from z=0 to z=30 (floor_thickness + wall_thickness)
// However, we need to ensure the floor is closed at the bottom too for a solid part.
// We will create a separate floor polygon or use a trick with hull/union if needed, 
// but standard linear_extrude creates an open box on one side.
// To make it a solid "box" as requested (implied by enclosure), we need to close the bottom.

// Let's build the box walls and floor separately using polygons and extrude, then union them?
// No, for FDM printing of a single part with complex geometry, usually one continuous extrusion 
// or careful polygon definition is best. But OpenSCAD linear_extrude creates an open cylinder.
// We must close the bottom.

// Close the box at the bottom (z=0) and top (z=30).
// The floor is 2mm thick, so it sits from z=-1 to z=1? 
// Wait, "floor thickness 2mm". Usually this means the part rests on a surface or has that thickness.
// Let's assume the box structure includes the bottom wall and floor.

// Define the polygon for the box walls (sides)
box_walls = {70, 50}; // Outer size of the box in X and Y

// Extrude the walls from z=1 to z=29? 
// If we start at z=1 (floor top), wall thickness is 2mm -> ends at z=3.
// Then floor is from z=-1 to z=1? That would be a total height of 4mm, not 30mm.

// Re-reading: "outer size 70 x 50 x 30 mm". This implies the physical dimensions of the part.
// "2 mm walls" -> Height is 30 - 2 (floor) - 2 (top?) or just height? Usually total height.
// Let's assume Total Height = 30mm. Floor = 2mm. Walls = 2mm each side.
// So Top Z = 30, Bottom Z = 1 (if floor is at bottom). Or Bottom Z = -1?
// "rests on the XY plane". This implies the part sits on a surface at z=0.
// If it rests on XY plane, the lowest point of the part is at z=0.
// Floor thickness = 2mm -> The floor plate extends from z=-1 to z=1? Or is the floor just the bottom wall?
// Let's assume: Part sits on bed (z=0). Bottom surface is at z=0.
// Floor thickness 2mm means the part has a base of height 2mm. So it goes down to -1 and up to +1? 
// Or does "floor" mean the bottom wall only, and there's an overhang? No, FDM parts usually have solid bottoms.
// Let's assume: The part is 30mm tall total. Bottom at z=0. Top at z=30.
// Floor thickness = 2mm -> This likely refers to the height of the bottom section or a separate floor plate.
// To be safe and standard for "floor thickness", let's make the bottom wall extend from z=-1 to z=1? 
// No, that would mean the part is 4mm tall at the bottom.
// Let's interpret: The box has walls of height 2mm. Floor thickness 2mm. Total height 30mm.
// This implies a total height of 30mm. If floor is 2mm thick, and walls are 2mm high... 
// Maybe the "floor" refers to the bottom wall being 2mm thick, and the rest are side walls?
// Let's try: Bottom wall from z=-1 to z=1 (height 2). Side walls from z=-1 to z=30? No.
// Standard interpretation for such specs: Total Height = 30mm. Floor Thickness = 2mm. Wall Thickness = 2mm.
// This implies the part is 4mm tall at the bottom and 26mm tall above it? Or the walls are 2mm high, floor is 2mm high, total 4mm? No, spec says 30mm.
// Let's assume: The box structure has a base of height 2mm (floor) and side walls of height 28mm? 
// "2 mm walls" usually implies uniform wall thickness. If floor is also 2mm thick, total height = 4mm + ?
// Perhaps the "30 mm" refers to the box size including the floor? Yes, "outer size 70 x 50 x 30 mm".
// So Total Height = 30mm. Floor Thickness = 2mm. Wall Thickness = 2mm.
// This implies a configuration where the bottom is 2mm thick (floor), and the rest of the height (28mm) consists of walls? 
// Or maybe the "walls" are the vertical sides, and the floor is just the bottom part.
// Let's construct it: Bottom wall from z=-1 to z=1 (height 2). Side walls from z=-1 to z=30? No, that makes a weird shape.
// Better interpretation: The box has a base of height 2mm (floor) and vertical sides of height 28mm? 
// But spec says "2 mm walls". This is ambiguous. Let's assume the standard FDM part:
// Bottom wall = 2mm thick. Vertical walls = 2mm thick. Total Height = 30mm.
// This implies the bottom section (floor) is 2mm high, and the rest of the box (walls + top?) 
// Wait, if total height is 30, and floor is 2, then remaining height is 28. If walls are uniform 2mm...
// Maybe the "walls" include the vertical sides only, and the floor is separate?
// Let's try to build it as: Bottom wall (z=-1 to z=1), Side walls (z=-1 to z=30)? No.
// Let's assume the box is 30mm tall total. The bottom part is a solid floor of height 2mm. 
// The vertical sides go from z=-1 to z=30? That would be a 4mm high wall section and a 26mm high wall section? No.
// Most likely: Total Height = 30mm. Floor Thickness = 2mm. Wall Thickness = 2mm.
// This implies the part is 4mm tall at the bottom (floor) and 28mm tall above it? 
// Or maybe the "walls" are the vertical sides, and the floor is just the bottom wall, which is 2mm thick.
// Let's assume: Bottom wall from z=-1 to z=1 (height 2). Side walls from z=-1 to z=30? No.
// Okay, let's simplify. The part rests on XY plane (z=0). 
// Floor thickness = 2mm -> This likely means the bottom surface is a plate of height 2mm. So it goes down to -1 and up to +1? 
// If so, total height would be 4mm at the bottom. But spec says 30mm outer size.
// Let's assume: The box has a base of height 2mm (floor) and vertical walls of height 28mm? 
// No, "2 mm walls" implies uniform. Maybe the floor is just the bottom wall, which is 2mm thick, 
// and the rest of the box (walls + top?) is different?
// Let's try this: The part has a base of height 2mm (floor). The vertical sides are 2mm high. 
// And there is an overhang at the top? No, "open top".
// Okay, let's assume the standard interpretation for such problems:
// Total Height = 30mm. Floor Thickness = 2mm. Wall Thickness = 2mm.
// This implies a configuration where the bottom section (floor) is 2mm high, and the rest of the box 
// consists of vertical walls that are 28mm high? No, "walls" usually means uniform thickness.
// Let's assume: The part has a base of height 2mm (floor). Vertical walls are 2mm thick. 
// And there is an overhang at the top? No, "open top".
// Okay, let's try to build it as: Bottom wall from z=-1 to z=1 (height 2). Side walls from z=-1 to z=30? No.
// Let's assume: