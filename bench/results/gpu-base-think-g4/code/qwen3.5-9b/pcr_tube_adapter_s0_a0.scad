$fn = 64;

        // Variables
        collar_od = 13;
        collar_h = 1.5;
        sleeve_od = 10.8;
        total_h = 21.5;
        bore_d = 6.2;
        cut_overhang = 0.1;

        // Main Body
        union() {
            // Collar
            cylinder(d=collar_od, h=collar_h, center=[0,0,0]);
            // Sleeve Body
            translate([0, 0, collar_h])
            cylinder(d=sleeve_od, h=total_h - collar_h, center=[0,0,0]);
        }