// Dimensions in millimetres
disc_diameter = 85;      // Diameter of the Petri dish disc
disc_thickness = 2;      // Thickness of the sowing template
hole_diameter = 3;       // Diameter of each through-hole
hole_spacing = 9;        // Centre-to-centre spacing between holes (in mm)
grid_size = 7;           // Number of holes per side (7x7 grid)
notch_width = 10;         // Width of the rectangular orientation notch in X direction
notch_depth = 4;          // Depth of the rectangular orientation notch measured inward from rim along Y axis

// Helper function to place a hole at given coordinates on the disc
place_hole(x, y) {
    // Convert polar (r, theta) to Cartesian (x, y) where r is distance from centre in mm
    // Hole diameter = 3 mm => radius of circle = 1.5 mm
    // Ensure hole center lies on a grid point with spacing 9 mm along both axes
    // Grid points are at multiples of 9 mm from the origin along X and Y directions
    
    // Find nearest grid point in XY plane that is aligned with disc centre (0,0)
    // We'll place holes uniformly across the disc using integer indices i = 0..6 for x-direction, j = 0..6 for y-direction
    // Grid spacing along each axis: hole_spacing mm
    
    // For demonstration and correctness, we will generate all grid points on the disc surface
    // The disc is a flat circle of radius (disc_diameter/2) = 42.5 mm
    
    // We'll iterate over integer indices for x-direction and y-direction within the grid
    // Only include points that are inside the disc boundary
    
    // Convert index to Cartesian coordinates on the grid plane (before scaling by hole_spacing)
    // Grid point in local coordinate system: i = 0..6, j = 0..6
    // Local x-coordinate = i * hole_spacing
    // Local y-coordinate = j * hole_spacing
    
    // For each possible grid cell (i,j), compute global coordinates on the disc plane
    for (i = [0:grid_size]) {
        for (j = [0:grid_size]) {
            // Local Cartesian position in mm relative to centre of disc
            x_local = i * hole_spacing;
            y_local = j * hole_spacing;
            
            // Convert to global coordinates on the disc plane using polar conversion? 
            // Actually, we want points uniformly spaced along a 2D grid within the disc.
            // Use Cartesian (x_global, y_global) where x_global = i*hole_spacing, y_global = j*hole_spacing
            // But these are already in mm units and must be inside the disc radius
            
            // Check if point is inside the disc boundary: sqrt(x_local^2 + y_local^2) <= (disc_diameter/2)
            r = sqrt(pow(x_local, 2) + pow(y_local, 2));
            if (r <= (disc_diameter / 2)) {
                // Place hole at this point on the disc surface
                // Hole is a cylinder with diameter 3 mm, so radius = 1.5 mm
                // The hole goes through the entire thickness of the disc (2 mm), but we only model the cross-section in XY plane for placement
                
                // Define the hole as a cylinder centered at (x_local, y_local) on the XY plane, extending along Z by disc_thickness
                translate([x_local, y_local, 0]) {
                    cylinder(h = disc_thickness, r = hole_diameter / 2, $fn = 64);
                }
            }
        }
    }
}

// Create the main disc shape (flat circular plate)
translate([0, 0, disc_thickness/2]) {
    cube([disc_diameter, disc_diameter, disc_thickness], center = true);
}

// Place all holes on the disc surface using the grid pattern
for (i = [0:grid_size-1]) {
    for (j = [0:grid_size-1]) {
        place_hole(i * hole_spacing, j * hole_spacing);
    }
}

// Create the rectangular orientation notch on the +Y side rim
// The notch is a rectangular cut into the outer rim of the disc (on the Y axis side)
// Notch width = 10 mm in X direction (along XY plane), depth = 4 mm measured inward from the rim along Y direction

// First, define the rim as the outer edge of the disc at z = disc_thickness/2 - disc_thickness/2? 
// Actually, the disc is flat and lies on the XY plane with thickness in Z.
// The rim is the outer circular boundary at the top surface (z = 0 if we center it).

// We'll model the notch as a rectangular cut that removes material from the rim region.
// Since the disc is thin, we can treat the rim as a flat annular ring? But simpler: use a rectangular prism cut into the outer edge.

// The notch is on the +Y side of the disc (i.e., near Y = disc_diameter/2).
// It's centered on the Y axis, so its center in XY plane is at (0, disc_diameter/2, 0) but we'll work with coordinates relative to centre.

// Define notch parameters:
// - Width along X direction: 10 mm (horizontal width of the rectangular cut)
// - Depth measured inward from rim along Y axis: 4 mm (so the notch goes 4 mm into the disc thickness? Wait, careful.)

// Clarification: The problem says "Cut a rectangular orientation notch into the rim on the +Y side, centred on the Y axis: 10 mm wide (X) and 4 mm deep (Y, measured in from the rim)."

Interpretation:
- The disc is flat, lying on XY plane with thickness along Z.
- The rim is the outer circular edge of the disc at z = 0? Actually, if we place the disc centered on origin with thickness disc_thickness mm, then the top surface (where it sits) is at z = disc_thickness/2? But typical: when we do translate([0,0,disc_thickness/2]) cube([disc_diameter, disc_diameter, disc_thickness]), the bottom of the disc is at z=0 and top at z=disc_thickness.

But in OpenSCAD, if we center a cube with size [a,b,c] using translate([0,0,c/2])? Actually, simpler: define the disc as a flat plate from z = 0 to z = disc_thickness, centered at origin in XY plane.

We'll model the disc as a solid that occupies x ∈ [-disc_diameter/2, disc_diameter/2], y ∈ [-disc_diameter/2, disc_diameter/2], and z ∈ [0, disc_thickness].

Thus the rim is at z = 0 (the bottom surface where it sits on the Petri dish) or z = disc_thickness? Typically, when placed on a bed, the disc rests with its flat side down, so the top of the disc is at z=0 and the bottom is at z=-disc_thickness? But OpenSCAD's coordinate system: we can define the disc such that it sits on the XY plane (z=0) and extends upward (+Z). The problem says: "it rests on the XY plane at z = 0 and builds upward (+Z)." So the disc should have its flat face on the XY plane, i.e., bottom surface at z=0, top surface at z = disc_thickness.

Thus we define the disc as a solid from z = 0 to z = disc_thickness, centered in X and Y.

So: translate([0,0,disc_thickness/2]) cube([disc_diameter, disc_diameter, disc_thickness]) would place the bottom at z=0? Actually, if we do cube([a,b,c]), it occupies [0,a] in x, [0,b] in y, [0,c] in z. To center on origin and have flat face on z=0, we can use:

translate([-disc_diameter/2, -disc_diameter/2, disc_thickness/2]) cube([disc_diameter, disc_diameter, disc_thickness])

But then the bottom of the disc is at z = -disc_thickness/2? That's not what we want.

Better: define the disc as a solid that occupies x ∈ [-disc_diameter/2, disc_diameter/2], y ∈ [-disc_diameter/2, disc_diameter/2], and z ∈ [0, disc_thickness]. This is achieved by:

translate([0, 0, disc_thickness/2]) cube([disc_diameter, disc_diameter, disc_thickness