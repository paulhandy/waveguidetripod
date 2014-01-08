include <params.scad>
use <motor.scad>
use <parametric_gear.scad>
use <tripodArm.scad>
/*
   translate([0,0,-gearDistance]) tribase();
 *translate([0,-motorL1,0]) rotate(-90,[1,0,0]) faulhaber();
 *translate([0,0,-gearDistance+15+bearingH]) rotate(180,[1,0,0]) potentiometer();
 tripodArm();
 */
tribase();
module tribase(){
  difference(){
    union(){
      bevel_gear_pair(
          gear1_teeth = 18,
          gear2_teeth = 8
          );
      *translate([0,0,16.5]) union(){
        cylinder(r=bearingBW/2,h=bearingT);
        difference(){
          cylinder(r=bearingIW/2,h=bearingH+bearingT);
          translate([0,0,bearingH+bearingT]) rotate(180,[1,0,0]) potentiometer();
        }
      }
      *translate([0,0,-25]) cylinder(r=27,h=30);
    }
    *for(n=[0,1,-1]){
      rotate([-30,0,120*n]) baseleg();
    }
  }
}
module baseleg(w=legW,l=legL, h=legH){
  translate([-w/2,-l/3,-h/2]) union(){
    cube([w,30,h]);
    translate([5,30,0]) cube([10,100,10]);
  }
}
