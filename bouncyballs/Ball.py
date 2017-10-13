
global drag
drag = .95

class ball:
    
    def __init__(self, x, y ,vx , vy, g, col):
        self.x = x
        self.y = y 
        self.vx = vx
        self.vy = vy
        self.g = g
        self.col = col
        self.radius = 15
               
    def update(self,blist):
        self.vx *=drag
        self.vy *=drag
        self.x += self.vx
        self.y += self.vy
        self.vy += self.g
        
        #Colliding with edges
        if(self.x <= 0): 
            self.x = 0
            self.vx = -self.vx
        if(self.x >= width):
            self.x = width
            self.vx = -self.vx
        if(self.y <= 0):
            self.y = 0
            self.vy = -self.vy
        if(self.y >= height):
            self.y = height
            self.vy = -self.vy    
            
        #corners    
        if((self.x ==0)and(self.y ==0)):
            self.x += 1
            self.y += 1            
        if((self.x ==0)and(self.y ==height)):
            self.x += 1
            self.y += -1            
        if((self.x ==width)and(self.y ==0)):
            self.x += -1
            self.y += 1
        if((self.x ==width)and(self.y ==height)):
            self.x += -1
            self.y += -1
            
        unchecked = blist[:]
        for i in blist:
            unchecked.remove(i)
            for j in unchecked:
                distance = sqrt((i.x-j.x)**2+(i.y-j.y)**2)
                if((distance) < (i.radius +j.radius)):
                    i.collide(j)
                    
        if(mousePressed):
            for i in blist:
                if((sqrt((mouseX-i.x)**2 + (mouseY-i.y)**2)<=i.radius)):
                    i.x = mouseX
                    i.y = mouseY
            
                
            
        fill(self.col)
        stroke(self.col)
        ellipse(self.x,self.y,2*self.radius,2*self.radius)
        
    def collide(self, other):
        domatrix = True
        try:
            m = -(self.x-other.x)/(self.y-other.y)
        except ZeroDivisionError:  #testing if slope is infinite
            self.vx *= -1
            other.vx *= -1
            domatrix = False
        
        """vself = np.matrix([[self.vx],[self.vy]])
        vother = np.matrix([[other.vx],[other.vy]])
        transform = np.matrix([[1-m^2,2*m],[2*m,m^2-1]])
        transform = transform*(1/(1+m^2))
        vselfprime = transform*vself
        votherprime = transform*vother
        self.vx = vselfprime.tolist()[0][0]
        self.vy = vselfprime.tolist()[1][0]
        other.vx = votherprime.tolist()[0][0]
        other.vy = votherprime.tolist()[1][0]"""
        
        #doing this without numpy
        if(domatrix):
            vxprime = self.vx*(1-m**2) + self.vy*2*m
            vyprime = self.vx*2*m     + self.vy*(m**2-1)
            self.vx = vxprime
            self.vy = vyprime
            vxprime = other.vx*(1-m**2) + other.vy*2*m
            vyprime = other.vx*2*m     + other.vy*(m**2-1)
            other.vx = vxprime
            other.vy = vyprime
        
        
        
        
        
    
        