// ESP32-S3 Super Mini PassKey Case

/*************************************************
* Model parameters                                                                   *
*************************************************/
// Board width
board_w = 18.0; 
// Board length
board_l = 23.5; 
// PCB thickness
board_h_t = 1.25; 
// PCB + Bottom components thickness
board_h_t2 = 1.5; 
// Width on the sides of boad that should be clamped by the case
board_s = 1.75;
// Case thickness on x and y axix
thickness = 2; 
// Case thickness on z axix
thickness2 = 1.25; 
// front thickness
thickness3 = 1.5; 
// USB port width
usb_w = 9; 
// USB port thickness
usb_h = 3.2;
// buttons position on y axis (distance from PCB edge, USB port side)
button_y = 8.75; 
// buttons position on y axis (distance from nearest PCB edge)
button_x = 4.5; 
// LED position on y axis (distance from PCB edge, USB port side)
led_y = 18;
// LED position on y axis (distance from nearest PCB edge)
led_x = 3.5;  
// Buttons thickness
button_h = 1.5; 
// Gap for adjustement of interlocking parts on X and Y axis
tolerance_xy = 0.1; 
// Gap for adjustement of interlocking parts on Z axis
tolerance_z = 0.25; 
// First line of text that is engraved on the back of the case
text_line_1 = "Esp32-S3";
// Second line of text that is engraved on the back of the case
text_line_2 = "PassKey";
// case rounded corners radius
corner_radius = 3;


// space to carve in to top part of case to fit the tallest components of the top side of the PCB
board_h_b = usb_h + tolerance_z; 

epsilon=1/1000; 
bump_h=board_h_b - button_h - tolerance_z;

/*************************************************
 * Closed case and board, for preview only       *
 * Coment out this part before exporting for 3D  *
 * printing                                      *
 *************************************************/
//caseForPreview();

/*************************************************
 * Case parts, aligned for 3D printing           *
 *************************************************/
caseForPrint();


/*************************************************
 * Modules                                       *
 *************************************************/

module caseForPrint() {
    translate([-board_w / 2 - 2*thickness, 0, (board_h_t2 + thickness2) / 2]) 
        caseBottom();

    translate([board_w / 2 + 2*thickness, 0, (board_h_b + thickness2) / 2]) 
        rotate([0,-180, 0]) 
        caseTop();
}

module caseForPreview() {
    translate([40, 0, -(board_h_t2 + thickness2) / 2]) 
        caseBottom();
    translate([40, 0, (board_h_b + thickness2) / 2]) 
        caseTop();
    translate([40, 0,  -(board_h_t/2)  ]) 
        board();    
//    translate([-board_w / 2 - 2*thickness, 0, (board_h_t) / 2 + thickness2+tolerance_z + epsilon]) 
//        difference() {
//            board();    
//            translate([(board_w+1)/2,0,0])
//                color("#9F9F9F")
//                cube([board_w+1, board_l+3, 10],true);
//        }
//    translate([board_w / 2 + 2*thickness, 0, (board_h_t) / 2 + (board_h_b) + thickness2]) 
//      rotate([0,-180, 0]) 
//        difference() {
//            board();    
//            translate([(board_w+1)/2 - (board_w/2-button_x),0,0])
//                color("#9F9F9F")
//                cube([board_w+1, board_l+3, 10],true);
//        }
  
}

module caseBottom() {
    difference() {
        union() {
            difference() {
                // base plate
                translate([0, -3.5, 0])
                    color("#FFAF00")    
                    minkowski() {
                        cube([board_w + 2 * thickness - 2* corner_radius, 
                            board_l + 2*thickness3 + 7 - 2* corner_radius, 
                            board_h_t2 + thickness2 - 0.1], center=true);
                        cylinder(h=0.1, r=corner_radius, $fn=32, center=true);
                    }                    
                // cut board bottom
                translate([0, 0, (board_h_t2 + thickness2)/2])
                    cube([board_w+2*tolerance_xy, board_l+2*tolerance_xy, 2*board_h_t], center=true);
                translate([0, 0, (board_h_t2 + thickness2)/2])
                    cube([board_w-2*board_s, board_l-2*board_s, 2*board_h_t2], center=true);
            }
            translate ([0, 0,  (board_h_t2 + thickness2)/2]) 
                color("#FFAF00")    
                difference() {  
                    translate([0, -3.5, 0])
                    minkowski() {
                        cube([board_w + 2 * thickness - 2* corner_radius, 
                            board_l + 2*thickness3 + 7 - 2* corner_radius, 
                            thickness2/2 - 0.1], center=true);
                        cylinder(h=0.1, r=corner_radius, $fn=32, center=true);
                    }                    
                    translate([0, -1.5, 0])
                        cube([board_w + tolerance_xy, board_l + tolerance_xy + 3, thickness2], center=true);
                }
        }
        translate([0, board_l/2 + thickness/2, usb_h + (board_h_t2 + thickness2)/2 - tolerance_z])
            usbPort();
        // case hole
        translate([0,-( board_l + 2*thickness3)/2 - 1.75, 0])     
        union() {
            cylinder(h=max(board_h_t2,board_h_b ) + thickness + 5 + tolerance_xy, r=2.5, center=true, $fn=32);    
            translate([0, 0, -(board_h_t2 + thickness2)/2 -2.5 +  0.5 ])     
            cylinder(h=5, r1=5, r2=0, center=false, $fn=32);    
        }
        label();
    }
}

module usbPort() {
    //color("red")
    cube([usb_w+2*tolerance_xy, 2*thickness3, 2*usb_h], center=true);
}

module board() {
    color("#FF0000")
        translate([board_w/2-led_x,board_l/2-led_y, board_h_t/2])
        cube([2,2,1], center=true);
    color("#FF0000")
        translate([board_w/2-button_x,board_l/2-button_y, board_h_t/2])
        cylinder(h=button_h, r=.75,center=false,$fn=20);
    color("#FF0000")
        translate([-board_w/2+button_x,board_l/2-button_y, board_h_t/2])
        cylinder(h=button_h, r=.75,center=false,$fn=20);
    color("#9F9F9F")
        cube([board_w, board_l, board_h_t], center=true); 
    color("#9F9F9F")
        translate([0,board_l/2-6.2,board_h_t/2])
        union() {
            translate([-3,0,1.25])
            cube([6, 7, 0.5], center=false);
            difference() {
                union(){
                    translate([-2.9,0,1.6])
                    rotate([-90,0,0])
                    cylinder(h=7.5, r=1.6, center=false, $fn=32);    
                    translate([+2.9,0,1.6])
                    rotate([-90,0,0])
                    cylinder(h=7.5, r=1.6, center=false, $fn=32);    
                    translate([-2.9,0,0])
                    cube([5.8, 7.5,3.2], center=false);
                }
                union(){
                    translate([-2.9,1 + epsilon,1.6])
                    rotate([-90,0,0])
                    cylinder(h=6.5, r=1.25, center=false, $fn=32);    
                    translate([+2.9,1 + epsilon,1.6])
                    rotate([-90,0,0])
                    cylinder(h=6.5, r=1.25, center=false, $fn=32);    
                    translate([-2.9,1 + epsilon,0.35])
                    cube([5.8, 6.5,2.5], center=false);
                }
            }
        }
}

module caseTop() {
    union(){ 
        difference() {
            translate([0,-3.5,0])
                color("#00AFFF")    
                    minkowski() {
                        cube([board_w + 2 * thickness - 2* corner_radius, 
                            board_l + 2*thickness3 + 7 - 2* corner_radius, 
                            board_h_b + thickness2 - 0.1], center=true);
                        cylinder(h=0.1, r=corner_radius, $fn=32, center=true);
                    }                    
            // cut board top
            translate([0, 0, -(board_h_b + thickness2)/2])
                cube([board_w - 2 * board_s, board_l, 2*board_h_b], center=true);
            // cut usb port
            translate([0, board_l/2 + thickness/2,  -(board_h_b + thickness2)/2 + tolerance_z])
                usbPort();
            // cut reset button hole
            translate([board_w/2-button_x, board_l/2-button_y, board_h_b/2 ])
                cylinder(h=2*thickness2, r=0.75, center=true, $fn=32);  
            // cut led hole
            translate([board_w/2-led_x, board_l/2-led_y, board_h_b/2 ])
                cylinder(h=2*thickness2, r=1.25, center=true, $fn=32);  
            // cut boot button flex
            translate([-board_w/2+board_s+.5, -board_l/2+ (board_l - button_y + 2)/2, board_h_b/2 ])
                cube([0.5, board_l - button_y + 2, 2*thickness2], center=true);
            translate([-board_w/2+2*button_x+3 -0.5, -board_l/2+ (board_l - button_y + 2)/2, board_h_b/2 ])
                cube([0.5, board_l - button_y + 2, 2*thickness2], center=true);
            translate([-board_w/2+board_s+0.5+(2*button_x -0.5 - board_s-.5)/2+1.5, -board_l/2+ (board_l - button_y + 2), board_h_b/2 ])
                cube([2*button_x - board_s+3-.5 , 0.5, 2*thickness2], center=true);
            // cut the edges to match top case
            translate ([0, 0,  -(board_h_b + thickness2)/2]) 
            difference() {
                translate([0, -3.5, 0])
                    cube([board_w + 2 * thickness+ 1, board_l + 2*thickness3 + 1+7, thickness2/2], center=true);
                translate([0, -1.5, 0])
                    cube([board_w - tolerance_xy, board_l - tolerance_xy + 3, thickness2], center=true);
            }
            // case hole
            translate([0,-( board_l + 2*thickness3)/2 - 1.75])     
            union() {
                cylinder(h=max(board_h_t2, board_h_b) + thickness , r=2.5, center=true, $fn=32);    
                translate([0, 0, (board_h_b + thickness2)/2 - 2.5 -0.5])     
                cylinder(h=5, r1=0, r2=5, center=false, $fn=32);    
            }
        }
        // add boot button bump
        translate([-board_w/2+button_x, board_l/2-button_y, -(board_h_b + thickness2)/2 +  board_h_b-bump_h/2])
        union() {
            cylinder(h=bump_h+epsilon, r=1.1, center=true, $fn=32);  
            translate([3,0,0.3]) cube([6,1.5,bump_h+epsilon-0.6],center=true);
        }
        translate([-board_w/2+board_s+0.5+(2*button_x -0.5 - board_s-.5)/2+1.5, -board_l/2, -(board_h_b + thickness2)/2 +  board_h_b-bump_h/2])
            translate([0,.5-epsilon,0.3]) 
            cube([2*button_x - board_s+1.5,1,bump_h+epsilon-0.6],center=true);
    }
}


module label() {
    color("green") 
        translate([0,0,-(board_h_t2 + thickness2)/2 + tolerance_z])
        rotate([0, 180, 90])
        union() {
            translate([0,4,0])
                linear_extrude(1) text(text_line_1, size=4, halign="center", valign="center",$fn=32);
            translate([0,-4,0])
                linear_extrude(1) text(text_line_2, size=4, halign="center", valign="center",$fn=32);
        }
    }
