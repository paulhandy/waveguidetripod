include <params.scad>


module motorAttachment(rA,rB,h,mH,rC,d){
  difference()
  {
    cylinder(r=rA,h=h,$fn=30);
    translate([0,0,h-mH]) cylinder(r=rB,h=mH,$fn=50);
    translate([0,0,h-d]) rotate([90,0,0]) cylinder(r=rC,h=rA, $fn=40); 
    translate([0,0,h-d]) rotate([-90,0,0]) cylinder(r=rC,h=rA, $fn=40); 
    translate([0,0,h-d-rC*1.5]) rotate([0,90,0]) cylinder(r=rC,h=rA, $fn=40); 
    translate([0,0,h-d-rC*1.5]) rotate([0,-90,0]) cylinder(r=rC,h=rA, $fn=40); 
  }
}
