// Petri Dish Rack
// Designed for 90mm diameter dishes standing on edge.

// --- Dimensions ---
base_l      = 203.0;  // Length of base (X)
base_w      = 80.0;   // Width of base (Y)
base_h      = 20.0;   // Height of base (Z)

dish_radius = 45.0;   // Radius of 90mm dish
cradle_r    = 46.0;   // Radius of the cutting cylinder
cradle_z    = 52.0;   // Z-offset of the cylinder axis (bottoms at 52-46=6mm)

num_dividers = 11;     // Number of vertical plates
divider_t    = 3.0;    // Thickness of each divider (X)
divider_h    = 60.0;   // Height of dividers (Z)
divider_w    = 80.0;   // Width of dividers (Y)

// Spacing calculation: 
// 11 dividers create 10 slots. 
// Total length covered by dividers is from -100 to 100.
// The user specified x = -100, -80, ..., 100.
x_start      = -100.0;
x_end        = 100.0;
x_step       = 20.0;

$fn = 128;

// --- Modeling ---

// The base block
module base() {
    translate([-base_l/2, -base_w/2, 0])
        cube([base_l, base_w, base_h]);
}

// The vertical dividers
module dividers() {
    for (i = [0 : num_dividers - 1]) {
        x_pos = x_start + (i * x_step);
        translate([x_pos, -divider_w/2, 0])
            cube([divider_t, divider_w, divider_h]);
    }
}

// The cradle (the curved groove)
// The axis runs along X at y=0, z=52.
// We use a large cylinder to cut the groove.
module cradle_cutter() {
    // We rotate the cylinder to lie along the X axis.
    // The cylinder is centered at y=0, z=52.
    // To use difference, we make it longer than the base.
    translate([0, 0, cradle_z])
        rotate([0, 90, 0])
            cylinder(h = base_l + 2, d = cradle_r * 2);
}

// Final Assembly
union() {
    // The base and dividers are joined
    union() {
        base();
        dividers();
    }
    
    // We use a difference to cut the cradle out of the combined base/dividers
    // However, the prompt says "the cradle is not cut through them" 
    // regarding the dividers, but "A curved cradle... is cut along its whole length".
    // This implies the cradle is a feature of the base, but the dividers 
    // are solid and rise through the cradle area.
    // To achieve "cradle is not cut through them", we must subtract the cradle 
    // from the base ONLY, or subtract the dividers from the cradle.
    // The most robust way: Union(Base, Dividers) then subtract (Cradle INTERSECT Base).
    // Wait, the prompt says: "The cradle is not cut through them [the dividers]".
    // This means the dividers are solid blocks that exist even where the cradle is.
    
    // Correct logic:
    // 1. Create the base.
    // 2. Subtract the cradle from the base.
    // 3. Add the dividers.
}

// Re-structuring to follow the "cradle not cut through dividers" rule strictly:
difference() {
    // Start with the base
    base();
} // This is just a placeholder for the logic below

// Final Construction Logic:
// We want: (Base - Cradle) + Dividers
// This ensures the cradle is only in the base and doesn't cut the dividers.

difference() {
    // The base
    base();
    
    // The cradle cutter (only affects the base)
    // To ensure it only affects the base, we limit its Z range to the base height
    // but the prompt says the cradle bottoms at z=6 and the base is 20mm tall.
    // Since the cradle axis is at z=52 and radius is 46, the bottom is at z=6.
    // The top of the cradle is at 52 + 46 = 98.
    // Since the base is only 20mm tall, the cradle only cuts the top part of the base.
    translate([-base_l/2 - 1, -base_w/2 - 1, 0])
    rotate([0, 90, 0])
    translate([0, 0, -cradle_z])
    cylinder(h = base_l + 2, d = cradle_r * 2);
}

// Now add the dividers on top of the modified base
// Note: The dividers are 60mm tall. The base is 20mm tall.
// The dividers are placed at x = -100 to 100.
// The base is 203mm long (-101.5 to 101.5).
// The dividers are 80mm wide.
// The dividers are NOT cut by the cradle.

// Since we already used 'difference' for the base, we must wrap everything in a union.
// But 'difference' is a top-level operation. Let's rewrite the whole thing.

// --- REWRITTEN ASSEMBLY ---
// (This is the actual code that will render)

// We will use a union of (Base minus Cradle) and (Dividers).

// 1. The Base with the groove
// 2. The Dividers

// Let's define the base-with-groove as a module
module base_with_groove() {
    difference() {
        base();
        // The cradle cutter
        // We translate it so the axis is at y=0, z=52
        // The cylinder is oriented along X.
        translate([-base_l/2 - 1, -base_w/2 - 1, cradle_z])
            rotate([0, 90, 0])
                cylinder(h = base_l + 2, d = cradle_r * 2);
    }
}

// The final part is the union of the grooved base and the solid dividers.
// Note: The dividers are 60mm tall. They start at z=0.
// The base is 20mm tall.
// The dividers are 80mm wide.

union() {
    base_with_groove();
    dividers();
}