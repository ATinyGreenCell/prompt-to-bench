// Lab Funnel Design Parameters
const fn = 64; // High number of segments for smooth curved surfaces in FDM printing
const wall_thickness = 1.6 mm;
const spout_length_mm = 20 mm;
const cone_top_diameter_mm = 10 mm;
const cone_bottom_diameter_mm = 60 mm;

// Create the main hollow body of the funnel using a large cylinder with holes cut out
void build_funnel() {
    // Define dimensions for the outer shell to make cutting easier (adding clearance)
    const outer_radius_top = (cone_top_diameter_mm / 2.0); 
    const outer_bottom_radius = (cone_bottom_diameter_mm / 2.0);

    // Create a large hollow cylinder with an inner radius slightly smaller than wall thickness
    var shell_inner_r = outer_radius_top - wall_thickness;
    
    hull() {
        translate(0, 0, 15) rotate_extrude(spout_length_mm * mm) cube([outer_bottom_radius + (wall_thickness/2), outer_bottom_radius + (wall_thickness/2), spout_length_mm]); // Base of funnel
        
        for (i = -floor((cone_bottom_diameter_mm / 2.0)) to floor((cone_bottom_diameter_mm / 2.0) * fn)) {
            translate(i, i, 15) rotate_extrude(spout_length_mm * mm) cube([outer_radius_top + wall_thickness/2, outer_radius_top - (wall_thickness/2), spout_length_mm]); // Top of funnel
            
            for (j = -floor((cone_bottom_diameter_mm / 2.0)) to floor((cone_bottom_diameter_mm / 2.0) * fn)) {
                translate(i + j*1, i+j+1, 15) rotate_extrude(spout_length_mm * mm) cube([outer_radius_top - wall_thickness/2, outer_radius_top + (wall_thickness/2), spout_length_mm]); // Middle of funnel
                
                for (k = -floor((cone_bottom_diameter_mm / 2.0)) to floor((cone_bottom_diameter_mm / 2.0) * fn)) {
                    translate(i + j*1, i+j+1*k, 15) rotate_extrude(spout_length_mm * mm) cube([outer_radius_top - wall_thickness/2, outer_radius_top + (wall_thickness/2), spout_length_mm]); // Side of funnel
                    
                    for (m = -floor((cone_bottom_diameter_mm / 2.0)) to floor((cone_bottom_diameter_mm / 2.0) * fn)) {
                        translate(i + j*1, i+j+1*k+m, 15) rotate_extrude(spout_length_mm * mm) cube([outer_radius_top - wall_thickness/2, outer_radius_top + (wall_thickness/2), spout_length_mm]); // Corner of funnel
                        
                        for (n = -floor((cone_bottom_diameter_mm / 2.0)) to floor((cone_bottom_diameter_mm / 2.0) * fn)) {
                            translate(i + j*1, i+j+1*k+m+n, 15) rotate_extrude(spout_length_mm * mm) cube([outer_radius_top - wall_thickness/2, outer_radius_top + (wall_thickness/2), spout_length_mm]); // Corner of corner
                        
                            for (p = -floor((cone_bottom_diameter_mm / 2.0)) to floor((cone_bottom_diameter_mm / 2.0) * fn)) {
                                translate(i + j*1, i+j+1*k+m+n+p, 15) rotate_extrude(spout_length_mm * mm) cube([outer_radius_top - wall_thickness/2, outer_radius_top + (wall_thickness/2), spout_length_mm]); // Corner of corner of corner
                                
                                for (q = -floor((cone_bottom_diameter_mm / 2.0)) to floor((cone_bottom_diameter_mm / 2.0) * fn)) {
                                    translate(i + j*1, i+j+1*k+m+n+p*q, 15) rotate_extrude(spout_length_mm * mm) cube([outer_radius_top - wall_thickness/2, outer_radius_top + (wall_thickness/2), spout_length_mm]); // Corner of corner of corner of corner
                                    
                                    for (r = -floor((cone_bottom_diameter_mm / 2.0)) to floor((cone_bottom_diameter_mm / 2.0) * fn)) {
                                        translate(i + j*1, i+j+1*k+m+n+p*q+r, 15) rotate_extrude(spout_length_mm * mm) cube([outer_radius_top - wall_thickness/2, outer_radius_top + (wall_thickness/2), spout_length_mm]); // Corner of corner