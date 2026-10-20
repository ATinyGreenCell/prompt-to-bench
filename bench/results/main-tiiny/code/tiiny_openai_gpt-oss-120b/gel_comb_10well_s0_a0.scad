// Parameters (mm)
thickness = 1.5;          // Plate thickness
spine_length = 70;       // Length of the back bar (X direction)
spine_width = 12;        // Width of the back bar (Y direction)
tooth_width = 5.0;        // Width of each tooth (X direction)
tooth_length = 12;       // Length of each tooth (Y direction, extends -Y)
gap = 1.5;               // Gap between neighbouring teeth (X direction)
num_teeth = 10;         // Number of teeth

// Derived values
total_tooth_span = num_teeth*tooth_width + (num_teeth-1)*gap; // total X span of teeth+gaps
offset_x = (spine_length - total_tooth_span)/2;               // X offset to centre teeth on spine
y_center_tooth = -(spine_width/2 + tooth_length/2);        // Y centre of a tooth (extends -Y)
fn = 64;               // resolution for circles/cylinders

// Main model (lies flat on the build plate, bottom at Z=0)
translate([0,0,thickness/2])  // lift everything so bottom is at Z=0
union() {
    // Spine (back bar)
    cube([spine_length, spine_width, thickness], center=true);
    
    // Teeth
    for (i = [0 : num_teeth-1]) {
        // X centre of the i‑th tooth
        x_center = -spine_length/2 + offset_x + tooth_width/2 + i*(tooth_width + gap);
        translate([x_center, y_center_tooth, 0])
            cube([tooth_width, tooth_length, thickness], center=true);
    }
}