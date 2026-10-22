// --- Dimensions ---
// Base plate dimensions
base_x = 50;      // x from -25 to 25
base_y = 45;      // y from 0 to 45
base_z = 5;       // z from 0 to 5

// Base plate mounting holes (M4)
m4_dia = 4.5;
m4_x = 17;        // x coordinate for holes (symmetric)
m4_y = 30;        // y coordinate for holes

// Vertical motor plate dimensions
motor_plate_x = 50; // x from -25 to 25
motor_plate_y = 5;  // y from 0 to 5
motor_plate_z = 50; // z from 0 to 50

// Motor centring boss hole
boss_dia = 23;
boss_x = 0;
boss_y = 0; // Centered in the 5mm thick plate (y=0 to 5, so center is y=2.5, but hole is through Y)
boss_z = 28;

// Motor mounting holes (M3)
m3_dia = 3.4;
m3_pattern = 31; // 31mm square pattern

// Triangular gussets
gusset_thickness = 5; // Flush with edges, so they occupy the full thickness of the vertical plate
gusset_leg_y = 20;    // 20mm along +Y
gusset_leg_z = 20;    // 20mm along +Z
gusset_corner_y = 5;  // Right angle corner at y=5
gusset_corner_z = 5;  // Right angle corner at z=5
gusset_x_left = -25;  // Left edge
gusset_x_right = 20;  // Right edge start (20 to 25)

// --- Helper Variables ---
// M3 screw hole positions relative to boss center (0, 28)
m3_offset = m3_pattern / 2;

// --- Main Model ---
module main_part() {
    // 1. Base Plate
    // Centered on X, starting at y=0
    base_plate = translate([0, base_y/2, 0]) {
        cube([base_x, base_y, base_z], center = true);
    };

    // Base plate M4 holes
    // Extending past the faces: z goes from -1 to base_z+1 (0 to 5)
    module m4_hole() {
        cylinder(d = m4_dia, h = base_z + 2, center = true, $fn = 64);
    }

    base_with_holes = difference() {
        base_plate;
        // Hole 1
        translate([-m4_x, m4_y, 0]) m4_hole();
        // Hole 2
        translate([m4_x, m4_y, 0]) m4_hole();
    };

    // 2. Vertical Motor Plate
    // Standing on the back edge of the base.
    // Base is y: 0 to 45. Back edge is y=0? No, usually "back" in 3D printing orientation 
    // where Y is depth. If base is y:0 to 45, the "back" edge relative to the viewer 
    // looking from +Y is y=0. The "front" is y=45.
    // However, the prompt says "standing on the back edge of the base".
    // Let's assume the base lies on XY. The vertical plate is at y=0 to 5.
    // This matches the description: "y from 0 to 5".
    
    motor_plate_body = translate([0, 0, 0]) {
        cube([motor_plate_x, motor_plate_y, motor_plate_z], center = false);
    };

    // Boss hole (through Y)
    // Center at x=0, z=28. Y center is motor_plate_y/2 = 2.5.
    // Hole extends past Y faces (0 and 5).
    module boss_hole() {
        cylinder(d = boss_dia, h = motor_plate_y + 2, center = true, $fn = 64);
    }

    // M3 holes
    // 31mm square pattern centered on boss hole (0, 28)
    // Centers: (+-15.5, 28 +- 15.5)
    module m3_hole() {
        cylinder(d = m3_dia, h = motor_plate_y + 2, center = true, $fn = 64);
    }

    motor_plate_with_holes = difference() {
        motor_plate_body;
        // Boss hole
        translate([boss_x, motor_plate_y/2, boss_z]) boss_hole();
        
        // M3 holes
        // Pattern:
        // (15.5, 12.5), (15.5, 43.5), (-15.5, 12.5), (-15.5, 43.5)
        // Relative to boss center (0, 28)
        // y_offset = +-15.5, z_offset = +-15.5
        
        for (x_off = [-m3_offset, m3_offset]) {
            for (z_off = [-m3_offset, m3_offset]) {
                translate([x_off, motor_plate_y/2, boss_z + z_off]) m3_hole();
            }
        }
    };

    // 3. Triangular Gussets
    // Right triangle in YZ plane.
    // Legs 20mm along +Y and 20mm along +Z.
    // Right angle corner at y=5, z=5.
    // This means the triangle vertices in YZ are:
    // (5, 5) [Right Angle]
    // (5+20, 5) = (25, 5) [End of Y leg]
    // (5, 5+20) = (5, 25) [End of Z leg]
    // Wait, "legs 20 mm along +Y and 20 mm along +Z".
    // If the right angle is at (5,5), and it goes along +Y and +Z:
    // Vertex 1: (5, 5)
    // Vertex 2: (5+20, 5) = (25, 5)
    // Vertex 3: (5, 5+20) = (5, 25)
    
    // The gusset is 5mm thick (in X).
    // Left gusset: x from -25 to -20.
    // Right gusset: x from 20 to 25.
    
    module gusset_triangle() {
        // Polygon in YZ plane
        polygon(points = [
            [5, 5],
            [25, 5],
            [5, 25]
        ]);
    }

    module gusset(x_start, x_end) {
        linear_extrude(height = x_end - x_start, center = false) {
            gusset_triangle();
        }
    }

    // Left Gusset
    left_gusset = translate([gusset_x_left, 0, 0]) {
        // The linear extrude creates thickness in X.
        // We want it from x=-25 to -20.
        // linear_extrude with center=false starts at 0.
        // So we need to translate it to start at -25.
        // But wait, linear_extrude builds along Z by default? No, along Z if we don't specify.
        // Wait, linear_extrude extrudes along Z axis.
        // The polygon is in XY plane by default.
        // I need to extrude along X.
        // So I should use rotate to align the extrusion direction, or use linear_extrude with twist/center?
        // Easier: Use rotate to put the triangle in XZ plane, then linear_extrude along Y? No.
        // Let's use rotate to put the triangle in the XZ plane (y=0), then linear_extrude along Y?
        // No, the gusset is along X.
        // Let's define the triangle in the YZ plane, then rotate it to be in the XZ plane?
        // No, the gusset is a solid.
        // Let's just use rotate_extrude? No, it's a prism.
        // Let's use linear_extrude on a polygon in the YZ plane, but extrude along X.
        // OpenSCAD linear_extrude only works along Z.
        // So I must rotate the polygon to be in the XY plane, then linear_extrude along Z?
        // No, I want the