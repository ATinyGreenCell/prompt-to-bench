// Dimensions for Hotplate Stirrer Knob
$fn = 64;

// Knob Geometry
knob_diameter = 30;      // mm
knob_height = 15;        // mm
knob_shaft_diameter = 6.2; // mm
knob_shaft_flat_width = 4.7; // mm (distance from flat to opposite edge)
knob_shaft_depth = 12;   // mm (depth of blind bore)

// Grip Grooves
num_grooves = 18;        // evenly spaced
groove_diameter = 2;     // mm (radius is 1)

// Pointer Groove
pointer_width = 1.5;     // mm
pointer_depth = 1;       // mm
pointer_length = 15;     // mm (from center to edge)

// Derived Dimensions
knob_radius = knob_diameter / 2;
groove_radius = groove_diameter / 2;
pointer_radius = knob_radius;

module knob() {
    union() {
        // Main Cylinder Body
        cylinder(h = knob_height, r = knob_radius, center = false);
        
        // Grip Grooves
        // Grooves are half-cylinders centered on the outer surface
        for (i = [0 : num_grooves - 1]) {
            angle = i * (360 / num_grooves);
            rotate([0, 0, angle]) {
                translate([knob_radius, 0, 0]) {
                    rotate([90, 0, 0]) {
                        cylinder(h = knob_height, r = groove_radius, center = false);
                    }
                }
            }
        }
    }
}

module shaft_bore() {
    // D-shaped blind bore
    // The flat is on the side facing the hotplate (negative X in this orientation)
    // We cut a cylinder and a box to create the D shape
    translate([-knob_shaft_depth / 2, 0, 0]) {
        // Cylinder part
        cylinder(h = knob_shaft_depth, r = knob_shaft_diameter / 2, center = false);
        
        // Flat part (Box)
        // Width is the flat width specified (4.7mm)
        // We cut a box that extends slightly past the cylinder to ensure clean cut
        translate([-knob_shaft_diameter / 2, 0, 0]) {
            cube([knob_shaft_diameter, knob_shaft_diameter, knob_shaft_depth + 0.1]);
        }
    }
}

module pointer_groove() {
    // Pointer groove on the top face
    // Runs from center to edge
    // Width is 1.5mm, Depth is 1mm
    // Located on the same side as the flat (negative X)
    
    // We cut a rectangular slot into the top face
    // The slot is 1.5mm wide and 15mm long (radius)
    // We cut it 1mm deep
    translate([-pointer_length / 2, 0, 0]) {
        cube([pointer_width, pointer_length, pointer_depth + 0.1]);
    }
}

// Main Assembly
difference() {
    knob();
    
    // Cut the D-shaped shaft bore
    shaft_bore();
    
    // Cut the pointer groove on the top face
    // We translate it up by knob_height - 0.1 to ensure it cuts the top face
    translate([0, 0, knob_height - 0.1]) {
        pointer_groove();
    }
}