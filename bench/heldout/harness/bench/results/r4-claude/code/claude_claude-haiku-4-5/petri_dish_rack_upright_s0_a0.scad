// Dimensions in millimeters
base_length_x = 203;   // X length
base_width_y = 80;     // Y width
base_height_z = 20;    // Z height

cradle_radius = 46;    // Radius of cylindrical cradle
cradle_axis_y = 0;     // Y position of cylinder axis
cradle_axis_z = 52;    // Z position of cylinder axis

divider_thickness_x = 3;    // Thickness of divider in X
divider_width_y = 80;       // Width of divider in Y
divider_height_z = 60;      // Height of divider in Z
divider_spacing = 20;       // Center-to-center spacing of dividers

slot_width = 17;            // Width of each slot between dividers

// Resolution for smooth curved surfaces
$fn = 64;

// Main assembly
union() {
    // Base with cradle cuts in slots only
    difference() {
        // Base block, positioned from z=0 to z=20, centered in X and Y
        translate([0, 0, base_height_z / 2]) {
            cube([base_length_x, base_width_y, base_height_z], center = true);
        }
        
        // Cut cradle in each of the 10 slots
        for (i = [0 : 9]) {
            // Slot i is between divider i and divider i+1
            divider_left_x = -100 + i * divider_spacing;
            divider_right_x = -100 + (i + 1) * divider_spacing;
            slot_center_x = (divider_left_x + divider_right_x) / 2;
            
            // Cylinder aligned along X, centered at y=0, z=52
            translate([slot_center_x, cradle_axis_y, cradle_axis_z]) {
                rotate([0, 90, 0]) {
                    // Cylinder extends along X within the slot width
                    cylinder(r = cradle_radius, h = slot_width, center = true, $fn = 64);
                }
            }
        }
    }
    
    // 11 divider plates at x = -100, -80, -60, ..., 80, 100
    for (i = [0 : 10]) {
        divider_x = -100 + i * divider_spacing;
        
        // Position divider from z=0 to z=60
        translate([divider_x, 0, divider_height_z / 2]) {
            cube([divider_thickness_x, divider_width_y, divider_height_z], center = true);
        }
    }
}