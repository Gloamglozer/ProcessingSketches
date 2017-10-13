from Ball import ball
height = 480
width = 480
global number
global speed
speed = 10
number = 3
B = []

def setup():
    size(height,width)
    for i in range(0, number):
        clr = color (random(255),random(255),random(255))
        B.append(ball(random(0,width),random(width),random(-speed,speed),random(-speed,speed),1,clr))
    
def draw():
    background(0)
    for i in range (0, number):
        B[i].update(B)
        print(B[i].x,B[i].y)
        
        

    