// Microslide clip for laboratory stand rod
// Prints lying flat (10 mm tall in Z)

$fn = 64;  // Resolution for smooth curves

// Rod grip ring dimensions
rod_hole_id = 12.7;        // Inner diameter (12.7 mm = 0.5 inch)
rod_hole_od = 18.7;        // Outer diameter
rod_slot_y_min = -5;       // Slot extends from -5 to +5 mm in Y
rod_slot_y_max = 5;

// Slide/sample ring dimensions
slide_hole_id = 6;         // Inner diameter for sample
slide_hole_od = 10;        // Outer diameter
slide_center_x = 15;       // Center position on X axis
slide_slot_y_min = -2.25;  // Slot extends from -2.25 to +2.25 mm in Y
slide_slot_y_max = 2.25;

// Bridge dimensions
bridge_x_min = 8;          // Bridge extends from 8 to 12 mm in X
bridge_x_max = 12;
bridge_y_half = 3;         // Bridge extends ±3 mm in Y (total 6 mm)

// Extrusion height
height = 10;

linear_extrude(height = height) {
    // Rod clamping ring centered at origin
    difference() {
        circle(d = rod_hole_od);
        circle(d = rod_hole_id);
        // Slot on -X side: removes x < 0 and -5 < y < 5
        translate([-100, rod_slot_y_min]) {
            square([100, rod_slot_y_max - rod_slot_y_min]);
        }
    }
    
    // Slide holding ring centered at (15, 0)
    difference() {
        translate([slide_center_x, 0]) circle(d = slide_hole_od);
        translate([slide_center_x, 0]) circle(d = slide_hole_id);
        // Slot on +X side: removes x > 15 and -2.25 < y < 2.25
        translate([slide_center_x, slide_slot_y_min]) {
            square([100, slide_slot_y_max - slide_slot_y_min]);
        }
    }
    
    // Connecting bridge from x=8 to x=12
    translate([bridge_x_min, -bridge_y_half]) {
        square([bridge_x_max - bridge_x_min, 2 * bridge_y_half]);
    }
}