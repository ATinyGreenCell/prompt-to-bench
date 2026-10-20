// Dimensions
base_x = 50;
base_y = 45;
base_z = 5;

motor_x = 50;
motor_y = 5;
motor_z = 50;

m4_dia = 4.5;
m4_extend = 0.2;

boss_dia = 23;
boss_cx = 0;
boss_cz = 28;
boss_extend = 0.2;

m3_dia = 3.4;
m3_sq = 31;
m3_extend = 0.2;

gusset_thick = 5;
gusset_ly = 20;
gusset_lz = 20;
gusset_r_y = 5;
gusset_r_z = 5;

$fn = 64;

module bracket_body() {
    union() {
        // Base plate
        translate([-base_x/2, 0, 0])
            cube([base_x, base_y, base_z]);
            
        // Motor plate
        translate([-motor_x/2, 0, 0])
            cube([motor_x, motor_y, motor_z]);
            
        // Left gusset
        translate([-base_x/2, gusset_r_y, gusset_r_z])
            linear_extrude(height=gusset_thick)
                polygon([[0, 0], [gusset_ly, 0], [0, gusset_lz]]);
        
        // Right gusset
        translate([base_x/2 - gusset_thick, gusset_r_y, gusset_r_z])
            linear_extrude(height=gusset_thick)
                polygon([[0, 0], [gusset_ly, 0], [0, gusset_lz]]);
    }
}

module holes() {
    // M4 mounting holes
    for (i = [-1, 1]) {
        translate([i * 17, 30, 0])
            cylinder(d=m4_dia, h=base_z + m4_extend, center=false);
    }
    
    // Boss hole
    translate([boss_cx, motor_y/2, boss_cz])
        cylinder(d=boss_dia, h=motor_y + boss_extend, center=true);
        
    // M3 screw holes
    for (ix = [-1, 1]) {
        for (iz = [-1, 1]) {
            translate([ix * m3_sq/2, motor_y/2, boss_cz + iz * m3_sq/2])
                cylinder(d=m3_dia, h=motor_y + m3_extend, center=true);
        }
    }
}

difference() {
    bracket_body();
    holes();
}