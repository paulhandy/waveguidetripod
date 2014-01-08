include <params.scad>

faulhaber();
module faulhaber(d1 = motorD1, d2 = motorD2 ,d3 = motorDsh,df3 = motorDfl,l1 = motorL1,l2 = motorL2, l3 = motorL3){
  union(){
    color("black") cylinder(r=d1/2,h=l1);
    difference(){
      color("blue",0.9) translate([0,0,l1]) cylinder(r=d2/2,h=l2);
      translate([0,0,l1+l2]) motorHoles();
    }
    color("silver") translate([0,0,l1+l2]) motorShaft();
  }
}
module motorShaft(d=motorDsh,df=motorDfl,h=motorL3){
  difference(){ 
    cylinder(r=d/2,h=h,$fn=80);
    translate([-d/2,d/2-(d-df),0]) cube([d,d,h+2]);
    echo(d-df);
  }
}

module motorHoles(d = motorScrewD,l=motorHoleLenTo,h = motorScrewL){
  translate([0,0,-h])  union(){
    translate([l,0,0]) cylinder(r=d/2,h=h,$fn=40);
    rotate([0,0,120]) translate([l,0,0]) cylinder(r=d/2,h=h,$fn=40);
    rotate([0,0,-120]) translate([l,0,0]) cylinder(r=d/2,h=h,$fn=40);
  }
}

