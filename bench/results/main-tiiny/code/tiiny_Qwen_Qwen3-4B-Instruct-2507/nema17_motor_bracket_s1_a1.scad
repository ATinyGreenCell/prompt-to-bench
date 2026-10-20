// Dimensions for NEMA 17 stepper motor L-shaped mounting bracket
// Print orientation: base on XY plane (z=0), builds upward (+Z)

// Base plate dimensions
base_x_range = 25;
base_y_range = 45;
base_z_thickness = 5;

// Motor plate dimensions (vertical, standing on back edge)
motor_x_range = 25;
motor_y_range = 5;
motor_z_thickness = 50;

// Hole sizes and positions
m4_hole_dia = 4.5;           // M4 through-holes in base
m3_hole_dia = 3.4;           // M3 screw holes in motor plate
motor_boss_dia = 23;         // diameter of motor centring boss hole
motor_boss_center_z = 28;    // z-position of boss hole center
motor_boss_center_x = 0;     // x-position of boss hole center
motor_boss_center_y = 0;     // y-position of boss hole center

// Screw hole pattern: 31 mm square, centered on boss hole
screw_pattern_side = 31;
screw_count = 4;

// Gusset thickness and dimensions
gusset_thickness = 5;
gusset_leg_length = 20;
gusset_y_start = 5;          // y where gusset starts (at base plate edge)
gusset_z_start = 5;         // z where gusset starts (at base plate edge)

// $fn for smooth holes
$fn = 64;

// Base plate: x from -25 to 25, y from 0 to 45, z from 0 to 5
base_plate = cube([base_x_range * 2, base_y_range, base_z_thickness]);

// Through-holes for M4 screws at (x = -17, y = 30) and (x = 17, y = 30)
// Each hole extends 0.1 mm beyond the face to avoid coplanar faces
m4_hole1 = translate([-17, 30, 0]) 
           difference() {
               cylinder(h=base_z_thickness, r=m4_hole_dia/2, f=0.1);
           };

m4_hole2 = translate([17, 30, 0]) 
           difference() {
               cylinder(h=base_z_thickness, r=m4_hole_dia/2, f=0.1);
           };

// Motor plate: vertical, x from -25 to 25, y from 0 to 5, z from 0 to 50
// Stands on back edge of base plate (y=0 to 5)
motor_plate = cube([motor_x_range * 2, motor_y_range, motor_z_thickness]);

// Centring boss hole: 23 mm diameter, centered at (x=0, y=0, z=28)
motor_boss_hole = translate([0, 0, motor_boss_center_z]) 
                  difference() {
                      cylinder(h=motor_z_thickness, r=motor_boss_dia/2, f=0.1);
                  };

// Four M3 screw holes on 31 mm square pattern, centered on boss hole
// Positions: centered at (x=±15.5, y=±15.5) relative to boss center
// Only place holes where y is between 0 and 5
for (i = [0, 1, 2, 3]) {
    let x = [15.5, 15.5, -15.5, -15.5][i];
    let y = [15.5, -15.5, 15.5, -15.5][i];
    if (y >= 0 && y <= 5) {
        translate([x, y, 0]) 
        difference() {
            cylinder(h=motor_z_thickness, r=m3_hole_dia/2, f=0.1);
        };
    }
}

// Gussets: two right triangles in YZ plane, 5 mm thick
// Left gusset: x from -25 to -20, y from 5 to 25, z from 5 to 25
// Right gusset: x from 20 to 25, y from 5 to 25, z from 5 to 25

// Left gusset: right triangle with legs 20 mm in +Y and +Z
left_gusset = translate([-25, 5, 5]) 
              cube([gusset_thickness, 20, 20]);

// Right gusset: right triangle with legs 20 mm in +Y and +Z
right_gusset = translate([25, 5, 5]) 
               cube([gusset_thickness, 20, 20]);

// Final model: union of base plate, motor plate, holes, and gussets
// First, base plate with holes
base_with_holes = difference() {
    base_plate;
    m4_hole1;
    m4_hole2;
};

// Motor plate with boss and screws
motor_with_holes = difference() {
    motor_plate;
    motor_boss_hole;
    // Add screw holes (only where y in 0 to 5)
    for (i = [0, 1, 2, 3]) {
        let x = [15.5, 15.5, -15.5, -15.5][i];
        let y = [15.5, -15.5, 15.5, -15.5][i];
        if (y >= 0 && y <= 5) {
            translate([x, y, 0]) 
            difference() {
                cylinder(h=motor_z_thickness, r=m3_hole_dia/2, f=0.1);
            };
        }
    }
};

// Final assembly: base with holes + motor plate with holes + gussets
final_bracket = union() {
    base_with_holes;
    motor_with_holes;
    left_gusset;
    right_gusset;
};

// Ensure the final part is solid and correctly oriented
final_bracket;