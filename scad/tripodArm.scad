include <params.scad>
use <motor.scad>
use <canHolder.scad>
use <parametric_gear.scad>
use <tripodBase.scad>
module tripodArm(
    w=armInnerW, 
    t = armThickness, 
    h = armHeight){
  union(){
    translate([-w/2+t/2,-8,motorD1/2+1]) brainBox();
    difference(){
      union(){
        translate([0,0,(h+2*t)/2]) difference(){
          cube([w + t, t, h+2*t],center=true);
          translate([t/2,0,t/2 + 1/2]) cube([ w, t, h+t + 1],center=true);
        }
        translate([0,0,-gearDistance+15]) cylinder(r=bearingW2/2,h=gearDistance-15);
        for(n = [0,1]){
          difference(){
            rotate(180*n,[0,0,1]) translate([0,-t/2,-t]) cube([bearingW2,t,bearingW2/2]);
            rotate(180*n,[0,0,1]) translate([bearingW2,t/2+1,-bearingW2/2]) rotate(90,[1,0,0]) cylinder(r=bearingW2/2,h=t+2);
          }
        }
        // motor mount arm
        translate([-motorD1/2,0,0]) cube([motorD1,motorL1+1,t]);
      }
      translate([0,-motorL1,0]) rotate(-90,[1,0,0]) cylinder(r=motorD1/2+1,h=motorL1+motorL2+5);
      translate([0,0,-gearDistance+15]) cylinder(r=bearingW1/2,h=bearingH+.5);
      translate([0,0,-gearDistance+15+bearingH]) rotate(180,[1,0,0]) potentiometer();
    }
    // motor mount
    rotate(180,[0,1,0]) translate([0,motorL1+1,0]) 
      rotate(-90,[1,0,0]) difference(){
        union(){
          translate([-motorD1/2-1,0,0]) cube([motorD1+2,motorD1/2+t-motorD1/2,4]);
          cylinder(r=motorD1/2+1,h=4);
        }
        translate([0,0,4]) motorHoles(d = motorScrewD+1,l=motorHoleLenTo,h = 4);
        cylinder(r=3.5,h=4);
        cylinder(r=4.8,h=1.2);
      }
  }
}

module potentiometer(t = potTh, w=potW, d = potL, r=potRad, l=potLen, s=potSlit,sl = potSlitL){
  translate([0,0,-t]) union(){
    difference(){
      color("white") translate([0,0,t]) cylinder(r=r,h=l,$fn=20);
      translate([-r,-s/2,t+l-sl]) cube([r*2,s,sl]);
    }
    color("blue", 0.9) translate([-w/2,-d/2,0]) cube([w,d,t]);
    color("silver", 0.9) translate([-w/2,0,-11+t]) cube([w,d/2,11]);
  }
}

module bearing(
    d1 = bearingW1,
    d2 = bearingW2,
    d3 = bearingIW,
    h = bearingH,
    t = bearingT){
  difference(){
    union(){
      cylinder(r=d2/2,h=t,$fn=80);
      cylinder(r=d1/2,h=h+t,$fn=80);

    }
    cylinder(r=d3/2,h=h+t);
  }
}
module brainBox(
    t = boxT,
    w = brainW,
    l = brainL,
    h = brainH
    ){
  translate([-t,-t-w/2,0]) difference(){
    cube([l+2*t,w+2*t,h+t]);
    translate([t,t,t]) cube([l,w,h]);
  }
}
module canClamp(r1 = canDiameter/2+clampThickness, r2 = canDiameter/2-canToclampTolerance, h = clampLength, sw=clampSpace){
  difference()
  {
    union(){
      translate([0,0,h-10]) cylinder(r=r1,h=10,$fn=500);
      translate([0,0,h/2-7.5]) cylinder(r=r1,h=15,$fn=500);
      cylinder(r=r1,h=10,$fn=500);
#translate([-r1,canToclampTolerance/2,0]) cube([2*r1,r1-r2,h]);
    }
    cylinder(r=r2,h=h);
    translate([0,r1/2,h/2]) cube([sw*2,r1,h],center=true);
    translate([-100,armThickness/2,0]) cube([200,100,h]);
  }
}




%translate([-canDiameter/2-10,0,0]) union(){
translate([0, clampLength/2, armHeight + 2*armThickness-clampThickness - canToclampTolerance]) rotate([90,0,0]) canClamp();
union(){
  difference(){
    rotate(90,[0,0,0]) tripodArm();
    translate([-armInnerW/2 - armThickness,-armThickness,0]) 
      translate([-250,250,armHeight  + 2*armThickness - canDiameter/2 - 2*clampThickness -  canToclampTolerance]) rotate([180,0,0]) cube([500,500,300]);
  translate([-armThickness/2+ 2.5 -armInnerW/2,-armThickness/2+2.5,armHeight  + 2*armThickness - canDiameter/2 - 2*clampThickness -  canToclampTolerance]) cube([armThickness-5,armThickness-5,8]);
  }
}
}



translate([brainW/2,0,0]) rotate([0,0,90]) union(){
  difference(){
    rotate(90,[0,0,0]) tripodArm();
    translate([-armInnerW/2 - armThickness,-armThickness,0]) 
      translate([0,0,armHeight  + 2*armThickness - canDiameter/2 - 2*clampThickness -  canToclampTolerance]) cube([500,500,300]);
  }
  translate([-armThickness/2+ 3 -armInnerW/2,-armThickness/2+ 3 ,armHeight  + 2*armThickness - canDiameter/2 - 2*clampThickness -  canToclampTolerance]) cube([armThickness-6,armThickness-6,8]);
}
