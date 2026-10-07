// Define dimensions
$fn = 64; // For curved shapes

// Base plate
base_plate = translate([0, 0, 0]) * cube([50, 45, 5], center=true);

// Vertical motor plate
vertical_motor_plate = translate([-25, 0, 0]) * cube([50, 5, 50], center=true);

// Motor's centring boss hole
motor_boss_hole = translate([0, 30, 28]) * cylinder(r=4.5, h=23, center=true);

// M3 screw holes pattern
screw_holes_pattern = for (x=[-17, 17], y=[0, 0]) {
    translate([x, 30, 28]) * cylinder(r=3.4, h=5, center=true);
};

// Gussets
gusset_left = translate([-25, 5, 5]) * cube([5, 20, 5], center=true);
gusset_right = translate([25, 5, 5]) * cube([5, 20, 5], center=true);

// Combine all parts
mounting_bracket = base_plate +
                   vertical_motor_plate +
                   motor_boss_hole +
                   screw_holes_pattern +
                   Gusset_left +
                   Gusset_right;