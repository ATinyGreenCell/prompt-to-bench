difference() {
            cube([120, 70, 40]); // Outer
            translate([3, 3, 0]) cube([114, 64, 37]); // Inner Cavity (Walls/Floor)
        }
        // This creates the hollow tank.
        // Now we need to add the platform.
        // We can't use union inside difference easily to add material.
        // Better: Union of (TankWalls) and (Platform).