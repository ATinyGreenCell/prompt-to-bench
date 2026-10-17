// --- Dimensions (mm) ---
outer_x = 120;          // Total length of the tank
outer_y = 70;           // Total width of the tank
outer_z = 40;           // Total height of the tank

wall_thickness = 3;     // Thickness of the walls and floor
floor_thickness = 3;    // Thickness of the floor

platform_length = 60;   // Length of the central platform (X direction)
platform_height = 13;   // Height of the platform top from the inner floor
platform_width = outer_y - (2 * wall_thickness); // Spans full inner width

hole_diameter = 2;      // Diameter of electrode wire holes
hole_y_pos = 0;         // Y position of holes (centered on Y axis)
hole_z_pos = 30;        // Z position of holes (from bottom of tank)

// --- Resolution ---
$fn = 64;

// --- Main Construction ---

// The tank is built by taking the outer volume and subtracting the inner volume
// and the electrode holes.

difference() {
    // 1. The main outer block
    cube([outer_x, outer_y, outer_z], center = true);

    // 2. The inner cavity (the space where buffer goes)
    // We subtract this to create the hollow tank
    translate([0, 0, floor_thickness])
        cube([outer_x - 2*wall_thickness, outer_y - 2*wall_thickness, outer_z], center = true);

    // 3. The electrode holes
    // These are drilled through the X-end walls. 
    // Since the tank is centered, the walls are at +/- (outer_x/2 - wall_thickness/2)
    // We make the cylinder long enough to pass through the whole object.
    translate([0, hole_y_pos, hole_z_pos])
        rotate([0, 90, 0])
            cylinder(d = hole_diameter, h = outer_x + 2, center = true);
}

// 4. The internal platform
// The platform is a solid raised part in the middle.
// It is placed inside the tank.
// The platform top is at z = floor_thickness + platform_height.
// The platform itself is a solid block.
// Note: Since we used a difference() for the tank, we must "add" the platform 
// back in or build the tank differently. 
// Let's use a union approach for clarity: 
// [Outer Shell] + [Platform] - [Inner Cavity (excluding platform area)]

// RE-STRUCTURING FOR CLEANER BOOLEAN OPERATIONS:
// We will build the tank as a union of the shell and the platform, 
// then subtract the "empty" space.

// Let's restart the logic to ensure the platform is truly "solid" and part of the tank.

// --- RE-WRITTEN MODEL LOGIC ---

module tank_assembly() {
    union() {
        // The Outer Shell (Walls + Floor)
        difference() {
            // Outer Box
            cube([outer_x, outer_y, outer_z], center = true);
            
            // Inner Void (The space to be filled with buffer)
            // We leave the floor thickness at the bottom
            translate([0, 0, floor_thickness - 0.01])
                cube([outer_x - 2*wall_thickness, outer_y - 2*wall_thickness, outer_z], center = true);
        }

        // The Platform (Solid piece in the middle)
        // It spans the full inner width (Y)
        // It is 60mm long in X, centered.
        // Top is 13mm above inner floor.
        // Inner floor is at z = -outer_z/2 + floor_thickness
        // Platform top z = (-outer_z/2 + floor_thickness) + platform_height
        // Platform bottom z = -outer_z/2 + floor_thickness
        
        translate([0, 0, -outer_z/2 + floor_thickness + platform_height/2])
            cube([platform_length, outer_y - 2*wall_thickness, platform_height], center = true);
    }
}

// Final Assembly with Holes
difference() {
    tank_assembly(),
    // Subtract the electrode holes from the final assembly
    translate([0, hole_y_pos, hole_z_pos])
        rotate([0, 90, 0])
            cylinder(d = hole_diameter, h = outer_x + 2, center = true);
}

// Note: The platform is modeled as a solid block that sits on the floor.
// Because the platform is "inside" the inner void, the difference() 
// between the outer shell and the inner void would normally remove it.
// However, by using union() of the shell and the platform, 
// and then subtracting the void, the platform remains.