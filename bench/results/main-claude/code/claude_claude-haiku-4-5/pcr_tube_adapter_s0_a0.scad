// PCR tube adapter sleeve
// Allows a 0.2 mL PCR tube to sit in a 1.5 mL tube rack hole

// Dimensions (all in mm)
collar_od = 13;         // Collar outer diameter (sits in 1.5mL hole)
collar_h = 1.5;         // Collar height on bed
sleeve_od = 10.8;       // Sleeve body outer diameter
sleeve_h = 20;          // Sleeve body height (21.5 - 1.5)
bore_d = 6.2;           // Central bore diameter (for 0.2mL tube)
total_height = 21.5;    // Total height from bed

$fn = 64;               // Resolution for smooth circles

// Create the adapter
difference() {
    union() {
        // Collar - wide base that rests on rack
        cylinder(h = collar_h, d = collar_od, center = false);
        
        // Sleeve - main body for holding tube
        translate([0, 0, collar_h])
        cylinder(h = sleeve_h, d = sleeve_od, center = false);
    }
    
    // Central bore - extends past both ends for clean cuts
    translate([0, 0, -0.5])
    cylinder(h = total_height + 1, d = bore_d, center = false);
}