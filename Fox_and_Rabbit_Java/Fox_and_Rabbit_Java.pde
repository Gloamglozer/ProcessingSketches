
  animal fox,rabbit;
  color red,white;
  PVector rabbitposition, lastposition;
  float foxspeed = .5;
  void setup()
  {
 
    size(1024,500);
    red = color(255,0,0);
    white = color(255);
    fox = new animal(width*.8,height*.5,0,0,0,0,0,red);
    rabbit = new animal(width*.4,height*.5,2,2,0,0,0,white);
    
   background(0); 
  }
  
  void draw()
  {
    //background(0);
    stroke(255);
    fill(255);
    rabbit.showline();
    stroke(Rainbow((float)(millis()%1000)/1000.0));
    fill(Rainbow((float)(millis()%1000)/1000.0));
    fox.showline();
    
    //rabbit.vel.rotate(PI/256);
    //rabbit.vel.x = random(-50,50);
    //rabbit.vel.y = random(-50,50);
    rabbitposition = rabbit.pos.copy();
    fox.vel = rabbitposition.sub(fox.pos).normalize().mult(foxspeed*rabbit.vel.mag());
    
    rabbit.update();
    fox.update();
    
  }
  