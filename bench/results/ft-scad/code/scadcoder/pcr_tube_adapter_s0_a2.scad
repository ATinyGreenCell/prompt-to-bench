// Adapter sleeve - a collar and sleeve body that lets a 0.2 mL PCR tube sit in a
// rack hole made for 1.5 mL tubes. Prints upside down with a collard collar on the
// bed (z = 0..1.5) and a sleeve body rising to z = 21.5 with a straight bore
// through it.

tube  = 0.2;
rack_h  = 1.5;
sleeve_h  = 21.5;
bore_d  = 6.2;

$fn = 72;

collar_d = 13;
sleeve_d = 10.8;

difference() {
    union() {
        cylinder(h = rack_h, d = collar_d);
        translate([0, 0, rack_h]) cylinder(h = sleeve_h, d = sleeve_d);
    }
    translate([0, 0, -1]) cylinder(h = sleeve_h + 2, d = bore_d);
}