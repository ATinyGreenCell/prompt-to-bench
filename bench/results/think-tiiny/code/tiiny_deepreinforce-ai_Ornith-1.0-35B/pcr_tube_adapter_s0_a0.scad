// Adapter sleeve for 0.2 mL PCR tube in 1.5 mL rack hole
// Printed upside down: collar on bed, sleeve rises up

// Collar dimensions
collar_d = 13;
collar_h = 1.5;

// Sleeve dimensions
sleeve_od = 10.8;
total_h = 21.5;
sleeve_h = total_h - collar_h;

// Bore dimensions
bore_d = 6.2;
bore_h = total_h + 0.1;

// Build part
difference() {
    // Collar
    cylinder(d=collar_d, h=collar_h, $fn=64);
    
    // Sleeve body
    translate([0, 0, collar_h]) {
        cylinder(d=sleeve_od, h=sleeve_h, $fn=64);
    }
    
    // Cut bore
    cylinder(d=bore_d, h=bore_h, $fn=64);
}