// Dimensions for the Hotplate Stirrer Knob

// Main Cylinder Dimensions
diameter = 30;      // Overall diameter of the knob (mm)
height = 15;         // Overall height of the knob (mm)

// Blind Bore Dimensions (D-shaped hole)
bore_diameter = 6.2; // Diameter of the circular part of the bore (mm)
bore_flat_width = 4.7; // Width of the flat side of the D-shape (mm)
bore_depth = 12;     // Depth of the blind bore cut (mm)

// Grip Groove Dimensions
num_grooves = 18;    // Number of vertical grip grooves
groove_diameter = 2; // Diameter of each groove (mm)
groove_depth = 3;    // Assumed depth for a functional groove

// Pointer Groove Dimensions
pointer_width = 1.5; // Width of the pointer groove (mm)
pointer_depth = 1;   // Depth of the pointer groove (mm)

// Tolerances for cutting operations
tolerance = 0.2;     // Tolerance for cuts to ensure separation

// --- Main Body ---
difference() {
    // 1. Base Cylinder
    cylinder(h = height, r = diameter / 2, $fn = 64);

    // 2. Blind Bore Cut (D-shape)
    translate([0, 0, 0]) {
        // Create the D-shaped bore by using a cylinder and subtracting a second one, or defining the shape explicitly.
        // We define the cut as a cylinder of radius R1, and subtract a cylinder of radius R2 from it, 
        // but this is complex for a simple hole. The most direct way to model a D-shape cutout is using two intersecting cylinders.
        
        // For simplicity in OpenSCAD primitives, we define the shape as a cylinder with an inner section removed (if possible) or use hull/intersection logic.
        // Since we are cutting *into* the solid, we define the volume to be removed.

        // A D-shape is formed by two intersecting circles. We will model the cut as the union of two cylinders that define the shape boundary.
        
        // Cylinder 1 (The larger part defining the outer radius)
        cylinder(h = bore_depth + tolerance, r = bore_diameter / 2, $fn = 64);

        // Cylinder 2 (The inner cutout defining the flat width) - This is complex to position correctly for a D-shape.
        // Instead, we use the standard definition: A cylinder of radius R1 with a cylindrical hole of radius R2 drilled through it.
        // Since the description implies a single continuous cut shape, we model the volume removed as a cylinder whose cross-section is the D-shape.

        // We define the removal volume using two intersecting cylinders to approximate the D-shape boundary:
        
        // Cylinder defining the outer radius (R1 = 3.1)
        cylinder(h = bore_depth + tolerance, r = bore_diameter / 2, $fn = 64);

        // We use a difference operation against a shape that defines the inner void.
        // Since we cannot easily define a D-shape primitive, we will model it as a cylinder with a central section removed (a washer/annulus cut).
        
        // Let's stick to the interpretation: A circle of 6.2mm diameter, where the center part is flat.
        // We create a cylinder and subtract a smaller cylinder from its center axis if we want a ring shape, but here we want a D-shape hole.

        // The most reliable way to get a D-shaped hole (a circular area with one side flat) using basic shapes is often:
        // A large cylinder minus a section defined by the flat width.
        
        // We will use a single cylinder and define its radius profile via a hull or intersection if possible, but since we are cutting *out* material, 
        // we model the volume to be removed as two intersecting cylinders that form the D-shape boundary.

        // Cylinder A (defines the outer arc)
        cylinder(h = bore_depth + tolerance, r = bore_diameter / 2, $fn = 64);
        
        // Cylinder B (defines the flat side cut - this is highly dependent on placement)
        // For a D-shape hole centered at Z=0:
        translate([0, 0, -bore_depth]) {
            cylinder(h = bore_depth + tolerance, r = bore_flat_width / 2, $fn = 64);
        }
    }


    // 3. Grip Grooves Cut (18 vertical grooves)
    for (i = [0 : num_grooves - 1]) {
        angle = i * (360 / num_grooves);
        rotate([0, 0, angle]) {
            translate([0, 0, 0]) {
                // Cut a cylinder to represent the groove profile along the Z-axis.
                cylinder(h = height + tolerance, r = groove_diameter / 2, $fn = 64);
            }
        }
    }

    // 4. Pointer Groove Cut (Top Face)
    // Runs from the center to the outer edge on the side of the flat of the D.
    // Assuming the flat of the D is along the X-axis (angle 0). We cut along the X-axis direction.
    translate([0, -diameter / 2 + tolerance, height - pointer_depth]) { // Position near the top face (Z=15)
        // Cut a rectangular slot centered on the axis of the knob
        cube([pointer_width, diameter, pointer_depth], center = true);
    }
}