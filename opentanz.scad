/* [Body] */

// Number of holes
hole_num = 42; //[8:1:128]
// Depth for holes
hole_depth = 5;


rail_width = (hole_num * 5.08);

// Rail height
rail_height = 10;

// Bottom floor 
floor_thickness = 5;

// Side walls
wall_thickness = 2;


/* [Hidden] */
hole_x_pitch = 5.08; 
hole_y_pitch = 122.5;

/* [Power Unit] */
// Power Unit
include_power_unit = true; 

// Power Unit width
power_unit_width = 114;
// Power Unit height
power_unit_height = 32;
// Pitch for screw  horizontal
power_unit_screw_width = 106;
// Pitch for screw vertical
power_unit_screw_height = 25; 




module main_case() {
    $fn = 20;
    union(){
        for (x = [hole_x_pitch : hole_x_pitch : rail_width]){
            translate([x, -hole_x_pitch, 0]){
                difference(){
                    cube([hole_x_pitch,hole_x_pitch,hole_depth ]);
                    translate([hole_x_pitch/2,hole_x_pitch/2, 0]){
                    cylinder(h=hole_depth+2, d=3.2);}
                }
            }
        }
        translate([0, -hole_x_pitch, 0]){
        cube([hole_x_pitch,hole_x_pitch,hole_depth ]);
        }
        translate([rail_width, -hole_x_pitch, 0]){
        cube([hole_x_pitch,hole_x_pitch,hole_depth ]);
        }


        for (x = [hole_x_pitch : hole_x_pitch : rail_width]){
            translate([x, -hole_y_pitch-hole_x_pitch, 0]){
                difference(){
                cube([hole_x_pitch,hole_x_pitch,hole_depth ]);
                    translate([hole_x_pitch/2,hole_x_pitch/2, 0]){
                    cylinder(h=hole_depth+2, d=3.2);}
                }
            }
        }
        translate([0, -hole_y_pitch-hole_x_pitch, 0]){
        cube([hole_x_pitch,hole_x_pitch,hole_depth ]);
        }
        translate([rail_width , -hole_y_pitch-hole_x_pitch, 0]){
        cube([hole_x_pitch,hole_x_pitch,hole_depth]);
        }


        // walls

        // w
        translate([0, -hole_x_pitch, -rail_height]){
            cube([rail_width+hole_x_pitch,hole_x_pitch,rail_height ]);
        }
        translate([0 , -hole_y_pitch-hole_x_pitch,-rail_height]){
            cube([rail_width+hole_x_pitch,hole_x_pitch,rail_height ]);
        }
        
        // h
        translate([0, -hole_x_pitch-hole_y_pitch, -rail_height]){
            cube([wall_thickness,hole_y_pitch,rail_height+hole_depth-wall_thickness ]);
        }

        translate([rail_width+hole_x_pitch-wall_thickness, -hole_x_pitch-hole_y_pitch, -rail_height]){
            cube([wall_thickness,hole_y_pitch,rail_height+hole_depth-wall_thickness ]);
        }

    // floor
    
        translate([0, -hole_y_pitch-hole_x_pitch, -rail_height]){
            cube([rail_width+hole_x_pitch,hole_x_pitch+hole_y_pitch,floor_thickness ]);
        }
        
    }
}

module power_unit_holes() {
        $fn = 20;
    screw_positions = [
        [0, 0],
        [power_unit_screw_width, 0],
        [0, power_unit_screw_height],
        [power_unit_screw_width, power_unit_screw_height]
    ];
    
    for (pos = screw_positions) {
        translate([pos[0], pos[1], -1])
            cylinder(h=floor_thickness+2, d=3.2);
    }
}

module rotated_power_unit_holes() {
    translate([power_unit_height/2, power_unit_width/2, 0])
        rotate([0, 0, 90])
            translate([-power_unit_width/2, -power_unit_height/2, 0])
                power_unit_holes();
}

// Main
difference() {
    main_case();
    
    if (include_power_unit) {
        translate([(rail_width + hole_x_pitch)/2 - power_unit_width/2, -hole_y_pitch/2 -hole_x_pitch , -rail_height]) {
            if (rail_width >= 120) {
                power_unit_holes();
            } else {
                rotated_power_unit_holes();
            }
        }
    }
}
