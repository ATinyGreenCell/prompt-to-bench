// Parámetros dimensionales
ext_w = 90;              // Ancho exterior (X)
ext_d = 90;              // Profundidad exterior (Y)
wall_t = 2.5;            // Espesor de paredes
plate_h = 2;             // Espesor placa superior
total_h = 40;            // Altura total
screw_pitch = 71.5;      // Patrón cuadrado agujeros tornillos
screw_d = 4.5;           // Diámetro agujeros tornillos M4
notch_w = 12;            // Ancho muesca cable
notch_h = 8;             // Profundidad muesca cable

$fn = 64;

difference() {
    // Caja exterior sólida (90 x 90 x 40)
    translate([0, 0, total_h/2])
        cube([ext_w, ext_d, total_h], center = true);
    
    // Restar interior para crear paredes huecas
    // El hueco debe ir desde z=2 hasta z=40
    int_w = ext_w - 2*wall_t;
    int_d = ext_d - 2*wall_t;
    int_h = total_h - plate_h;  // 38 mm
    translate([0, 0, plate_h + int_h/2])
        cube([int_w, int_d, int_h + 0.5], center = true);
    
    // Agujeros para tornillos M4 en placa superior
    for(x = [-1, 1]) {
        for(y = [-1, 1]) {
            translate([x * screw_pitch/2, y * screw_pitch/2, -0.5])
                cylinder(d = screw_d, h = plate_h + 1);
        }
    }
    
    // Muesca para cable en pared +Y
    translate([0, ext_d/2 - wall_t/2, total_h - notch_h/2])
        cube([notch_w, wall_t + 0.5, notch_h], center = true);
}