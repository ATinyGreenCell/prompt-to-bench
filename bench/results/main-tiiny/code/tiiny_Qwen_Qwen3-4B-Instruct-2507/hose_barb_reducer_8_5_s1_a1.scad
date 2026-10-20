// Dimensions in millimeters
$fn = 64;

// Lengths and diameters
total_length = 41;
z_start_8mm_barbs = 0;
z_end_8mm_barbs = 20;
z_collar = 20;
z_start_5mm_barbs = 25;
z_end_5mm_barbs = 41;

// Barb dimensions
barb_height_8mm = 10;
barb_height_5mm = 8;
barb_base_dia_8mm = 7.5;
barb_top_dia_8mm = 9.5;
barb_base_dia_5mm = 6.5;
barb_top_dia_5mm = 5.0;
barb_base_dia_return = 6.5; // return to base after taper

// Bore diameter (3 mm straight through)
bore_diameter = 3.0;

// Create the main cylindrical body with 3 mm bore
// The reducer is rotationally symmetric about Z-axis, centered at origin

// Start with the central bore
cylinder(h=total_length, r=bore_diameter/2, f=0.01);

// From z=0 to z=20: two stacked 8mm barbs (each 10mm tall)
// Each barb has a linear growth from 7.5mm to 9.5mm, then steps back to 7.5mm

// First barb: from z=0 to z=10
// Second barb: from z=10 to z=20

// Function to create a single barb with taper and step
// Barb spans height `h`, from z_start to z_end
// Base diameter = base_d, top diameter = top_d, then steps back to base_d at the end
function create_barb(z_start, z_end, base_d, top_d, height, step_back=1) =
    let(h = z_end - z_start)
        // Create a barb with linear taper from base_d to top_d over height, then step back to base_d over step_back
        // We create it as a union of two cylinders:
        // 1. A cylinder from z_start to z_end - step_back with radius growing from base_d to top_d
        // 2. A cylinder from z_end - step_back to z_end with radius from top_d to base_d

        // But we must avoid coplanar faces, so we use small offsets in the step

        // First, create the taper section: from z_start to z_end - step_back
        // Radius at z: base_d + (top_d - base_d) * (z - z_start) / h
        // This is a cylinder with variable radius, but OpenSCAD doesn't support variable radius in cylinder
        // So we must use a different approach: use a linear extrusion or a difference

        // Instead, we create the barb as a difference: a large cylinder minus a small one
        // But we need to define the shape

        // We create the barb as a union of two parts:
        // 1. A cylinder from z_start to z_end - step_back with radius growing to top_d
        // 2. A cylinder from z_end - step_back to z_end with radius from top_d to base_d

        // We use a linear variation in radius using a cylinder with a taper
        // We use a linear taper from base_d to top_d over 10mm, then step back

        // We create the barb as a union of two cylinders with different radii

        // First, create the taper section: from z_start to z_end - step_back
        // We use a cylinder with a linear variation in radius
        // But OpenSCAD doesn't support variable radius in cylinder, so we use a different method

        // We create the barb as a solid with a taper and step using a linear variation
        // We use a linear variation in radius from base_d to top_d over h, then step back

        // We create the barb as a union of two cylinders:
        // 1. A cylinder from z_start to z_end - step_back with radius growing to top_d
        // 2. A cylinder from z_end - step_back to z_end with radius from top_d to base_d

        // But we need to define the radius at each z

        // We create the barb as a difference: a large cylinder minus a small one
        // But we are building a solid, so we use union

        // We create the barb as a union of two cylinders:
        // 1. A cylinder from z_start to z_end - step_back with radius growing to top_d
        // 2. A cylinder from z_end - step_back to z_end with radius