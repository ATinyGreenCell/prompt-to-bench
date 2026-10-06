// Hose barb reducer: 8 mm to 5 mm silicone tubing
// Print orientation: standing upright along Z-axis (Z=0 to Z=41)
// Central bore: 3 mm diameter, runs entire length

// Bore dimensions
bore_diameter = 3;
bore_radius = bore_diameter / 2;
bore_height = 41;

// 8 mm tubing barbs (two stacked, each 10 mm tall)
// Outer diameter grows from 7.5 mm to 9.5 mm (linear), then steps back
barb8_od_min = 7.5;
barb8_od_max = 9.5;
barb8_r_min = barb8_od_min / 2;
barb8_r_max = barb8_od_max / 2;
barb8_height = 10;  // per barb

// Transition collar (5 mm tall, 12 mm diameter)
collar_od = 12;
collar_r = collar_od / 2;
collar_height = 5;

// 5 mm tubing barbs (two stacked, each 8 mm tall)
// Outer diameter shrinks from 6.5 mm to 5.0 mm (linear), then steps out
barb5_od_max = 6.5;
barb5_od_min = 5.0;
barb5_r_max = barb5_od_max / 2;
barb5_r_min = barb5_od_min / 2;
barb5_height = 8;  // per barb

difference() {
    // Create outer profile and rotate around Z-axis
    rotate_extrude(angle=360, $fn=64) {
        polygon([
            // Base (center)
            [0, 0],
            
            // First 8mm barb (Z = 0 to 10)
            [barb8_r_min, 0],
            [barb8_r_max, barb8_height],
            [barb8_r_min, barb8_height],
            
            // Second 8mm barb (Z = 10 to 20)
            [barb8_r_max, 2*barb8_height],
            [barb8_r_min, 2*barb8_height],
            
            // Collar (Z = 20 to 25)
            [collar_r, 2*barb8_height],
            [collar_r, 2*barb8_height + collar_height],
            
            // First 5mm barb (Z = 25 to 33)
            [barb5_r_max, 2*barb8_height + collar_height],
            [barb5_r_min, 2*barb8_height + collar_height + barb5_height],
            [barb5_r_max, 2*barb8_height + collar_height + barb5_height],
            
            // Second 5mm barb (Z = 33 to 41)
            [barb5_r_min, 2*barb8_height + collar_height + 2*barb5_height],
            [barb5_r_max, bore_height],
            
            // Top (center)
            [0, bore_height]
        ]);
    }
    
    // Subtract central bore (3 mm diameter)
    cylinder(r=bore_radius, h=bore_height, $fn=64);
}