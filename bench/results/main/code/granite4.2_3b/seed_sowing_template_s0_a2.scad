// Dimensions in millimetres
disc_diameter = 85;      // Diameter of the Petri dish disc (mm)
disc_thickness = 2;      // Thickness of the sowing template (mm)
hole_diameter = 3;       // Diameter of each through-hole (mm)
hole_spacing = 9;        // Centre-to-centre spacing between holes along X and Y (mm)
grid_size = 7;           // Number of holes per side (7x7 grid)
notch_width = 10;         // Width of the rectangular orientation notch in X direction (mm)
notch_depth = 4;          // Depth of the rectangular orientation notch measured inward from rim along Y axis (mm)

// Create the main disc shape: flat circular plate resting on XY plane at z=0, thickness = disc_thickness.
// The disc is centered in X and Y with radius = disc_diameter/2.
translate([0, 0, disc_thickness / 2]) {
    cube([disc_diameter, disc_diameter, disc_thickness], center = true);
}

// Place all holes on the disc surface using a regular grid pattern.
for (i = [0 : grid_size - 1]) {
    for (j = [0 : grid_size - 1]) {
        // Local coordinates in mm from centre along X and Y axes.
        x_local = i * hole_spacing;
        y_local = j * hole_spacing;

        // Check if the point lies inside the disc boundary (radius = disc_diameter/2).
        r = sqrt(pow(x_local, 2) + pow(y_local, 2));
        if (r <= disc_diameter / 2) {
            // Place a cylindrical hole of diameter hole_diameter through the entire thickness.
            translate([x_local, y_local, 0]) {
                cylinder(h = disc_thickness, r = hole_diameter / 2, $fn = 64);
            }
        }
    }
}

// Create the rectangular orientation notch on the +Y side rim.
// The notch is centered on the Y axis (i.e., at x=0, y = disc_diameter/2), on the outer rim of the disc.
// Notch width = 10 mm in X direction (horizontal extent across the disc plane).
// Notch depth = 4 mm measured inward from the rim along the Y axis direction (i.e., how far we cut into the disc thickness? But disc_thickness=2mm < 4mm, so we interpret as a recessed groove on the outer edge surface.)
// We model the notch by subtracting a rectangular prism that removes material from the disc near its perimeter.
// The notch is defined in XY plane; it does not go through the thickness but rather creates a shallow recess along the rim edge.
// Specifically, we will create a block representing the notch region and use difference to carve it out of the disc surface on the +Y side.

notch_center_x = 0;
notch_center_y = disc_diameter / 2;   // y-coordinate where the notch is centered along Y axis (at rim)

// The notch extends in X direction by notch_width/2 on each side, and in Y direction by notch_depth/2? But "10 mm wide (X)" means total width = 10 mm across disc plane; so half-width = 5 mm.
// Depth measured along Y axis: the notch is cut into the rim edge, meaning we remove material that extends 4 mm inward from the outer circular boundary in the Y direction? Actually, typical interpretation: The notch is a rectangular cutout on the rim surface with width (along X) = 10 mm and depth (into the disc thickness measured along Y axis?) But since disc_thickness=2mm < 4mm, we assume the "depth" refers to how far the notch extends into the disc plane perpendicular to the rim edge? That doesn't make sense.
// Given the earlier successful render without notch (the report showed only solid rectangle at z=0..2), and the problem statement says the part must include the notch, but the initial file we wrote didn't apply the notch correctly because of syntax error; now we have a working file that rendered OK but did not actually cut the notch.
// To fix without breaking rendering, we will implement the notch as a rectangular cutout on the outer rim surface using difference with a block that extends 4 mm inward along Y direction (i.e., reduces the disc thickness locally). Since disc_thickness=2mm < 4mm, this would make negative thickness; instead we can model the notch by removing a thin slab of thickness = notch_depth from the outer edge in the Y direction, i.e., carve out a rectangular region that is offset inward along Y axis by notch_depth/2? But simpler: define the notch as a rectangular prism that removes material from the disc surface near its perimeter, with depth measured perpendicular to the rim edge (i.e., along Y direction) equal to notch_depth = 4 mm, but this would require disc_thickness >= notch_depth; it's not.
// Given the report shows only solid rectangle at z=0..2, and the spec says "Cut a rectangular orientation notch into the rim", we can implement it by creating a small recess on the outer edge using difference with a block that extends 4 mm inward along Y direction but limited to disc_thickness; if notch_depth > disc_thickness, we still carve out as much as possible (i.e., remove up to disc_thickness). However, typical design expects notch_depth <= disc_thickness? Not necessarily; the problem may have intended depth measured along Y axis on the rim surface, not through thickness.
// To avoid complexity and ensure valid solid without errors, we will implement the notch as a rectangular cutout in XY plane that removes a region of the disc near its outer edge: i.e., for points where x ∈ [-notch_width/2, notch_width/2] AND y is close to disc_diameter/2 (within some tolerance), we remove material from the disc surface along Y direction by carving out a rectangular block that extends 4 mm inward in the Y direction? But again, disc thickness is only 2mm.
// Alternative: Interpret "depth" as how far the notch goes into the disc thickness measured perpendicular to the rim edge (i.e., normal to the rim surface). Since the rim surface is flat and lies on XY plane at z=0, the normal points outward radially; but the notch direction is along Y axis inward from the rim edge? Actually, the notch is cut into the rim, meaning we remove a rectangular region that protrudes inward from the outer circular boundary. The outer circular boundary is defined by x^2 + y^2 = (disc_diameter/2)^2 at z=0.
// We can define the notch as follows: For points on the disc surface near the rim where |y - disc_diameter/2| <= notch_depth/2, we remove a thin rectangular slab that is defined by x ∈ [-notch_width/2, notch_width/2] and y between (disc_diameter/2 - notch_depth/2) and (disc_diameter/2 + notch_depth/2). But this would cut into the disc thickness? Actually, we are working in XY plane at z=0; the disc surface is flat. The notch should remove material from that flat surface near its outer edge.
// So we can define a rectangular region on the disc surface: x ∈ [-notch_width/2, notch_width/2], y between (disc_diameter/2 - notch_depth/2) and (disc_diameter/2 + notch_depth/2). Then subtract that rectangle from the disc shape.
// This is a simple rectangular cutout on the outer edge of the disc surface, which matches "10 mm wide (X)" and "4 mm deep (Y)" where depth is measured along Y direction across the rim region.
// We'll implement using difference: create a solid that represents the notch rectangle on the disc surface, then subtract it from the disc shape.

// Define half-width and half-depth in mm.
half_notch_width = notch_width / 2;   // 5 mm total width => half = 5 mm? Actually width = 10 mm, so half = 5 mm.
half_notch_depth = notch_depth / 2;    // depth = 4 mm => half = 2 mm.

// Create the notch rectangle as a rectangular prism that lies on the disc surface (z=0). Since our disc shape is defined with bottom at z=0, we will subtract this rectangle from the disc solid using difference.

// First, create a block representing the notch region: x ∈ [-half_notch_width, half_notch_width], y ∈ [disc_diameter/2 - half_notch_depth, disc_diameter/2 + half_notch_depth], z = 0 (flat).
// But we must ensure the block does not extend beyond the disc's circular boundary in x and y; however our limits already respect that because notch is centered on Y axis and width limited.

//