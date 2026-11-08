// Design a sowing template for a 90 mm Petri dish.
// The template sits inside the dish, resting on the XY plane at z=0.

// Dimensions in millimeters (measured with calipers)
const float D = 85;       // Diameter of the disc
const float T = 2;        // Thickness of the disc
const int GRID_SIZE = 7;  // Number of holes along one side
const float HOLE_DIAMETER = 3.0; // Size of each hole
const float SPACING = 9.0; // Centre-to-centre spacing between holes

// Create a circular polygon representing the base disc
// Radius is half the diameter (42.5 mm)
poly_base = polygon([[-D/2, -D/2], [D/2, -D/2], [D/2, D/2], [-D/2, D/2]]);

// Extrude the base disc to form a flat plate of thickness T
plate = linear_extrude(T) rotate_extrude(PI/2) union(base);

// Add through-holes using a for loop
for (i = 0; i < GRID_SIZE; i++) {
    // Calculate position: start at center, move by spacing
    pos_x = -D/2 + i * SPACING;
    pos_y = -D/2;
    
    // Create cylinder with the hole diameter
    hole = cylinder([HOLE_DIAMETER, 0, T]);
    
    // Translate to position and add to plate
    translate([pos_x, pos_y]) union(plate + hole);
}

// Cut a rectangular orientation notch on the rim (+Y side)
// The notch is centered on the Y axis.
// Width (X dimension): 10 mm
// Depth (Y dimension from rim): 4 mm
// Rim thickness: T = 2 mm
notch_width = 10;
notch_depth = 4;

// Define the rectangular face to cut
rect_face = polygon([[-D/2, -T], [D/2, -T], [D/2, D/2 + notch_depth], [-D/2, D/2 + notch_depth]]);

// Cut the notch by subtracting the rectangle from the plate
// Note: The cut extends 0.01-1 mm past faces to ensure no coplanar faces
notch = difference(plate, rect_face);

// Final assembly of the sowing template
sowing_template = union(notch);

// Optional: Add a small label or text for clarity (optional, but good practice)
text_label = translate([0, 25, -10]) string("Sowing Template");
sowing_template = hull(sowing_template + text_label);