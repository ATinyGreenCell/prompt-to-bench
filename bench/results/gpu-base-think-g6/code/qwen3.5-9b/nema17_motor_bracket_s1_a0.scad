// Base Plate
        base_x_min = -25;
        base_x_max = 25;
        base_y_min = 0;
        base_y_max = 45;
        base_z_max = 5;
        base_thickness = base_z_max - 0;

        // Vertical Plate
        vert_x_min = -25;
        vert_x_max = 25;
        vert_y_max = 5;
        vert_z_max = 50;
        vert_thickness = vert_y_max - 0; // Wait, Y is 0 to 5. Thickness is 5.

        // Holes
        m4_diameter = 4.5;
        m4_x1 = -17;
        m4_y1 = 30;
        m4_x2 = 17;
        m4_y2 = 30;

        boss_diameter = 23;
        boss_center_x = 0;
        boss_center_z = 28;
        boss_thickness = vert_y_max; // Through the plate (Y direction)

        m3_diameter = 3.4;
        m3_pattern_size = 31;
        m3_count = 4;

        // Gussets
        gusset_thickness = 5;
        gusset_leg_y = 20;
        gusset_leg_z = 20;
        gusset_corner_y = 5;
        gusset_corner_z = 5;
        gusset_x_start_left = -25;
        gusset_x_end_left = -20;
        gusset_x_start_right = 20;
        gusset_x_end_right = 25;