$fn = 64;

// Base dimensions (mm)
base_length = 90;   // X length (front to back)
base_width = 45;        // Y width (left to right)
base_height = 20;     // Z height (bottom to top)

// Slot dimensions (mm)
slot_length = 77;     // X length of slot (parallel to base length)
slot_width = 1.6;     // Y width of slot (center-to-center spacing is 3.5mm)
slot_depth = 10;      // Z depth of slot (from top surface)
slot_spacing = 3.5;     // Center-to-center spacing between slots (Y direction)
num_slots = 10;         // Number of slots

// Adjusted hole depth to extend 0.01mm beyond top surface (to avoid coplanar faces)
hole_depth = slot_depth + 0.01;

// Calculate total span of all slots (from left edge of first to right edge of last)
total_span = (num_slots - 1) * slot_spacing + slot_width;

// Calculate starting Y center for first slot (to center all slots on base)
first_slot_centre_y = (base_width - total_span) / 2 + slot_width / 2;

// Create base block (from origin, resting on XY plane)
base = cube([base_length, base_width, base_height], center = false);

// Subtract slots from base (using for loop for 10 slots)
difference() {
    base;
    
    for (i = [0 : num_slots - 1]) {
        // Calculate Y center for current slot
        slot_centre_y = first_slot_centre_y + i * slot_spacing;
        
        // Calculate slot position (X centered, Y centered, Z starting at base_height - slot_depth)
        start_x = (base_length - slot_length) / 2;
        start_y = slot_centre_y - slot_width / 2;
        start_z = base_height - slot_depth;  // 10mm below top surface (Z=20)

        // Create slot hole (extended 0.01mm beyond top surface)
        translate([start_x, start_y, start_z])
        cube([slot_length, slot_width, hole_depth]);
    }
}