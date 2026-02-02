// RP2350 USB-A PassKey Case

/*************************************************
* Model parameters                                                                   *
*************************************************/
// Board width
board_w = 18.1; 
// Board length
board_l = 25.6; 
// PCB thickness
board_h = 2.0; 
// Bottom components max thickness
board_c_b = 0.25;
// Top components max thickness
board_c_t = 3.25;
// Width on the sides of boad that should be clamped by the case
board_s = 1.75;
// Case thickness on x and y axix
thickness = 2; 
// Case thickness on z axix
thickness2 = 1.25; 
// front thickness
thickness3 = 1.5; 
// USB port width
usb_w = 12.25; 
// USB port thickness
usb_l = 12.7;
// buttons position on y axis (distance from PCB edge, USB port side)
button_y = 23.2; 
// buttons position on y axis (distance from nearest PCB edge)
button_x = 4.0; 
// Buttons thickness
button_h = 1.3; 
// Button travel distance
button_t = 0.5; 
// LED position on y axis (distance from PCB edge, USB port side)
led_y = 4.0;
// LED position on y axis (distance from nearest PCB edge)
led_x = 8;  
// Gap for adjustement of interlocking parts on X and Y axis
tolerance_xy = 0.15; 
// Gap for adjustement of interlocking parts on Z axis
tolerance_z = 0.25; 
// First line of text that is engraved on the back of the case
text_line_1 = "RP2350";
// Second line of text that is engraved on the back of the case
text_line_2 = "PassKey";
// case rounded corners radius
corner_radius = 3;
// height of otional feets
feet_h1 = 6.5;
feet_h2 = 6.2;

epsilon=1/1000; 
bump_h=board_c_t + button_t - button_h - tolerance_z;

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
translate([6,-28,0])
caseFeet1();
translate([20,-28,0])
caseFeet2();
translate([-12,-25,0])
casecap();  

  
/*************************************************
 * Modules                                       *
 *************************************************/

module caseForPrint() {
    translate([-board_w / 2 - 2*thickness, 0, (board_h/2 + board_c_b + thickness2 + tolerance_z) ]) 
        caseBottom();
    
    translate([board_w / 2 + 2*thickness, 0, (board_h/2 + board_c_t + tolerance_z + thickness2 + button_t)]) 
        rotate([0,-180, 0]) 
        caseTop();
}

module caseForPreview() {
    translate([40, 0, 0]) 
        caseBottom();
    translate([40, 0, 0]) 
        caseTop();
    translate([40, 0,  0 ]) 
        board();  
    
//    translate([-board_w / 2 - 2*thickness, 0,  (board_h/2 + board_c_b + thickness2 + tolerance_z)]) 
//        difference() {
//            board();    
//            translate([(board_w+1)/2,0,0])
//                color("#9F9F9F")
//                cube([board_w+1, board_l+25, 11],true);
//        }
//
//    translate([board_w / 2 + 2*thickness, 0, board_h / 2 + board_c_t + button_t + thickness2]) 
//        rotate([0,-180, 0]) 
//        difference() {
//            board();    
//            //translate([(board_w+1)/2 - (board_w/2-button_x),0,0])
//            translate([0,(board_l+25)/2 + (board_l/2-button_y),0])
//                color("#9F9F9F")
//                cube([board_w+1, board_l+25, 11],true);
//        }
}

module casecap() {
    translate([0, 0, (usb_l + thickness)/2])
        color("#FFAF00")    
            union() {
                difference() {
                    cube([usb_w + 2 * thickness, 
                        board_h + 2* thickness2, 
                        usb_l + thickness], center=true);
                    translate([0, 0, thickness + epsilon] )
                    cube([usb_w+2*tolerance_xy, 
                        board_h+2*tolerance_xy, 
                        usb_l + thickness], center=true);
                }
                translate([0, (board_h+2*tolerance_xy)/2, -(usb_l + thickness)/2 + 7 + thickness])
                cylinder(h=usb_l -7, r=tolerance_xy, $fn=32, center=false);
                translate([0, -(board_h+2*tolerance_xy)/2, -(usb_l + thickness)/2 + 7 + thickness])
                cylinder(h=usb_l - 7, r=tolerance_xy, $fn=32, center=false);
            }
}
            
module caseFeet1() {
    translate([0, 0, feet_h1/2])
        color("#FFAF00")    
        minkowski() {
            cube([8 - 2* corner_radius, 
                8 - 2* corner_radius, 
                feet_h1-0.1], center=true);
            cylinder(h=0.1, r=corner_radius, $fn=32, center=true);
        }            
}
module caseFeet2() {
    translate([0, 0, feet_h2/2])
        color("#FFAF00")    
        minkowski() {
            cube([8 - 2* corner_radius, 
                8 - 2* corner_radius, 
                feet_h2-0.1], center=true);
            cylinder(h=0.1, r=corner_radius, $fn=32, center=true);
        }            
}
            
module caseBottom() {
    difference() {
        difference() {  
            // base plate
            translate([0, -3.5, -(board_h/2 + board_c_b + tolerance_z + thickness2)/2])
                color("#FFAF00")    
                minkowski() {
                    cube([board_w + 2 * thickness - 2* corner_radius, 
                        board_l + 2*thickness3 + 7 - 2* corner_radius, 
                        board_h/2 + board_c_b + tolerance_z + thickness2 - 0.1], center=true);
                    cylinder(h=0.1, r=corner_radius, $fn=32, center=true);
                }            
            // cut board bottom
            minkowski() {
                cube([board_w-3+2*tolerance_xy, board_l-3+2*tolerance_xy, board_h], center=true);
                cylinder(h=tolerance_z, r=1.5, $fn=32);
            }
            cube([board_w-2*board_s, board_l-2*board_s, board_h + 2*tolerance_z + board_c_b], center=true);
        }
        translate([0, board_l/2 + thickness/2, 0])
            usbPort();
        // case hole
        translate([0,-(board_l + 2*thickness3)/2 - 2.5, 3-board_h/2-board_c_b - tolerance_z-thickness2])
        union() {
            cylinder(h=10, r=2.5, center=true, $fn=32);    
            translate([0, 0, -5])     
            cylinder(h=5, r1=5, r2=0, center=false, $fn=32);    
        }
        label();
    }
}

module caseTop() {
    union(){ 
        difference() {
            translate([0,-3.5,(board_h/2 + board_c_t + tolerance_z + thickness2 + button_t)/2])
                color("#00AFFF")    
                minkowski() {
                    cube([board_w + 2 * thickness - 2* corner_radius, 
                        board_l + 2*thickness3 + 7 - 2* corner_radius, 
                        board_h/2 + board_c_t + tolerance_z + thickness2 + button_t - 0.1], center=true);
                    cylinder(h=0.1, r=corner_radius, $fn=32, center=true);
                }
            // cut board top
            cube([board_w - 2* board_s, board_l+2*tolerance_xy, board_h + 2*board_c_t + 2*tolerance_z + 2*button_t], center=true);
            minkowski() {
                cube([board_w-3+2*tolerance_xy, board_l-3+2*tolerance_xy, board_h], center=true);
                cylinder(h=tolerance_z, r=1.5, $fn=32);
            }
            // cut usb port
            translate([0, board_l/2 + thickness/2, 0])
                usbPort();
            // cut reset button hole
            translate([board_w/2-button_x, board_l/2-button_y, (board_h/2 + board_c_t + tolerance_z + thickness2/2) ])
                cylinder(h=2*thickness2, r=0.75, center=true, $fn=32);  
            // cut led hole
            translate([board_w/2-led_x, board_l/2-led_y, (board_h/2 + board_c_t + tolerance_z + thickness2/2) ])
                cylinder(h=2*thickness2, r=1.25, center=true, $fn=32);  
            // cut boot button flex
            translate([-board_w/2+board_s+.5, -(button_y + 2 - 7)/2+board_l/2 - 7, (board_h/2 + board_c_t + tolerance_z + thickness2/2) ])
                cube([0.75, button_y + 1.75 - 7, 2*thickness2], center=true);
            translate([-board_w/2+2*button_x+3 -0.5, -(button_y + 2 - 7)/2+board_l/2 - 7, (board_h/2 + board_c_t + tolerance_z + thickness2/2) ])
                cube([0.75, button_y + 1.75 - 7, 2*thickness2], center=true);
            translate([-board_w/2+board_s+0.5+(2*button_x -0.5 - board_s-.5)/2+1.5, 
                board_l/2 - button_y - 1.5, 
                (board_h/2 + board_c_t + tolerance_z + thickness2/2) ])
                cube([2*button_x - board_s+3-.5 , 0.75, 2*thickness2], center=true);
            // case hole
            translate([0,-( board_l + 2*thickness3)/2 - 2.5,(-8 + board_h/2 +board_c_t+thickness2+button_t+tolerance_z)])
            union() {
                cylinder(h=10, r=2.5, center=false, $fn=32);    
                translate([0, 0, 5])     
                    cylinder(h=5, r1=0, r2=5, center=false, $fn=32);    
            }
        }
        // add boot button bump
        translate([-board_w/2+button_x, board_l/2-button_y, (board_h/2 +board_c_t + button_t + tolerance_z)-bump_h ])
            cylinder(h=bump_h+epsilon, r=1.1, center=false, $fn=32);  
    }
}

module label() {
    color("green") 
        translate([0,0,-(board_h/2 + board_c_b + thickness2 + tolerance_z)+ tolerance_z])
        rotate([0, 180, 90])
        union() {
            translate([0,4,0])
                linear_extrude(1) text(text_line_1, size=4, halign="center", valign="center",$fn=32);
            translate([0,-4,0])
                linear_extrude(1) text(text_line_2, size=4, halign="center", valign="center",$fn=32);
        }
}

module usbPort() {
    //color("red")
    cube([usb_w+2*tolerance_xy, usb_l, board_h+2*tolerance_z], center=true);
}

module board() {
    union() {
        color("#FF0000")
            translate([board_w/2-led_x,board_l/2-led_y, board_h/2])
            cube([2,2,1], center=true);
        color("#FF0000")
            translate([board_w/2-button_x,board_l/2-button_y, board_h/2])
            cylinder(h=button_h, r=.75,center=false,$fn=20);
        color("#FF0000")
            translate([-board_w/2+button_x,board_l/2-button_y, board_h/2])
            cylinder(h=button_h, r=.75,center=false,$fn=20);
        color("#EFEFEF")
            translate([0,4.5/2 - board_l/2, board_c_t/2 + board_h/2])
            cube([8,4.5,board_c_t], center=true);
        color("#9F9F9F")
            minkowski() {
                cube([board_w-4, board_l-4, board_h], center=true); 
                cylinder(h=epsilon,r=2, $fn=32);
            }            
        color("#9F9F9F")
            translate([0,board_l/2+usb_l/2 -1,0])
            minkowski() {
                cube([usb_w-1, usb_l, board_h], center=true);
                cylinder(h=epsilon,r=.5, $fn=32);
            }            
    }
}
