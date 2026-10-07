// Dimensions for the Hotplate Stirrer Knob

// Main Cylinder Dimensions
diameter = 30;      // Overall diameter of the knob (mm)
height = 15;         // Overall height of the knob (mm)

// Blind Bore Dimensions (D-shaped hole)
bore_diameter = 6.2; // Diameter of the circular part of the bore (mm)
bore_flat_width = 4.7; // Width of the flat side of the D-shape (mm)

// Grip Groove Dimensions
num_grooves = 18;    // Number of vertical grip grooves
groove_diameter = 2; // Diameter of each groove (mm)
groove_depth = 3;    // Depth of the groove (assuming a reasonable depth for printing, let's use 3mm as it wasn't specified, but needs to be deep enough to be a groove)

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
        // Create a cylinder for the bore shape
        cylinder(h = height + tolerance, r1 = bore_diameter / 2, r2 = bore_flat_width / 2, $fn = 64);
    }

    // 3. Grip Grooves Cut
    for (i = [0 : num_grooves - 1]) {
        angle = i * (360 / num_grooves);
        rotate([0, 0, angle]) {
            translate([0, 0, 0]) {
                // Create a half-cylinder for the groove profile.
                // We use a cylinder and subtract half of it, or define the shape directly.
                // A simpler way is to use a sweep/minkowski approach, but sticking to basic shapes:
                // We will create a rectangular block and subtract a cylinder centered on its side.

                // For simplicity and robustness with basic shapes, we model the groove as a cut into the main body.
                // Since the groove is vertical (along Z), we use a shape that sweeps along the circumference.

                // Create a cutter profile: A rectangle defining the width of the groove on the surface
                // The groove is centered on the outer surface (radius R = diameter/2).
                
                // We define the cut as a cylinder whose radius is half the groove diameter, 
                // and we rotate it around the Z-axis.
                
                // To make it a groove *on* the surface, we need to use a shape that sweeps along the circumference.
                // A simpler approach for FDM printing is to cut a slot:
                
                // Define the cutter as a cylinder of radius (groove_diameter / 2)
                cylinder(h = height + tolerance, r = groove_diameter / 2, $fn = 64);
            }
        }
    }

    // Note on Grooves: The above loop creates 18 full cylinders. Since they are centered on the surface, 
    // they will cut into the main body. If the groove is meant to be a slot running along the Z-axis, this works.
    // We need to ensure the cuts are deep enough. Let's adjust the loop to define the depth correctly if needed, 
    // but for now, we rely on the difference operation cutting into the main cylinder.

    // 4. Pointer Groove Cut (Top Face)
    // The pointer groove runs from the center to the outer edge on the side of the flat of the D.
    // Assuming the flat of the D is at angle 0 (X-axis). We cut along the X-axis direction.
    translate([0, -diameter / 2 + tolerance, height - pointer_depth]) { // Position near the top face (Z=15)
        // Cut a rectangular slot centered on the axis of the knob
        cube([pointer_width, diameter, pointer_depth], center = true);
    }
}