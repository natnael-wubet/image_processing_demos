PImage img;
PImage img2;
void setup() {
  fullScreen(P3D);
  try {
    strokeWeight(1);
    img = loadImage("input.jpg");img2 = loadImage("input.jpg");
    particles=new float[(img.width*(img.height))][5];
    float tmp=0.0;
    for(int i=0;i<img.width;i++) {
      for(int j=0;j<img.height;j++) {
        particles[(j*img.width)+i][0] = 200+sin(tmp)*200;
        particles[(j*img.width)+i][1] = 100+tan(tmp/5)*100;
        particles[(j*img.width)+i][2] = noise(i,j)*100;
        particles[(j*img.width)+i][3] = ((width/2)-(width/8))+i;
        particles[(j*img.width)+i][4] = ((height/2)-(height/4))+j;
        tmp++;
      }
    }
  } catch (Exception e) {}
  frameRate(100);
}
void skin() {
  int close[] = {
    width-200,100,  
    150,70 
  };
  if (mover(close)) {
    if (click) {
      click=!click;
      exit();
    }
    fill(255);
    rect(close[0],close[1],close[2],close[3]);
    fill(0);
    text("Exit", close[0]+(close[2]/3),close[1]+(close[3]/2));
  } else {
   
    fill(0);
    rect(close[0],close[1],close[2],close[3]);
    fill(255);
    text("Exit", close[0]+(close[2]/3),close[1]+(close[3]/2)); 
  }
}
PFont font;
int dep_def=0;
void logo(float i) {
  if (i%56 == 0)
    background(0);
  font = createFont("Arial", 56);
  textFont(font);
  fill(255);
  text("Image editor", (width/2)-150,(height/2)-10);
  float tx=f1(i)+((width/2));
  float ty=f2(i)+((height/2)+150);
  fill(crelu(tx),crelu(ty),crelu(tx+ty));
  ellipse(tx,ty,10,10);
}
float crelu(float x) {
  if (x > 255)
    return 255-(x%255);
  else if (x < 0)
    return 255-crelu(x*-1);
  return x;
}
float f1(float x){
  return sin(x/8)*80;
}
float f2(float x){
 return cos(x/8)*80;
}
boolean mover(int x[]) {
  if (((mouseX > x[0]) & (mouseX < x[0]+x[2])) & ((mouseY > x[1]) & (mouseY < x[1]+x[3])))
    return true;
  return false;
}
void keyPressed() {
  if (page == 3) {
    if (choice == 1) {
      if (keyCode == UP) z+=6;
      else if (keyCode == DOWN) z-=6;
    }
  }
  if (keyCode == LEFT) {
    if (page == 0)
      exit();
    page--;
  }
}
int tmp=0;
int z=100;
color pixel;
int choice=0;
boolean click=false;
void mousePressed() { click = true; }
float i=0;
int page=0;
float combine(float kernel[][], int x, int y) {
  float sum=0.0;
  color pix;
  for(int i=0;i <kernel.length;i++) {
    for(int j=0;j<kernel[i].length;j++) {
      if ((x+j >= img.width) | (i+y >= img.height))
        pix = color(0);
      else
        pix = img.pixels[((y+i)*img.width)+x+j];
      float gs = (red(pix) + green(pix) + blue(pix))/3;
      sum += kernel[i][j] * gs;
    }
  }
  return sum/(kernel.length*kernel[0].length);
}
void draw() {
  
  if (page ==0) {
    logo(i);
    i++;
    if (i == 60)
      page++;
  skin();
} else if (page ==1) {
    
    background(0);
    font = createFont("Arial", 30);
    textFont(font);
    fill(255);
    text(" Warrning: Insert the pictures to this directory or use the external importer exe",(width/6),(height/4));
    int btn[] = {
      (width/2)-70, (height/2)+50,
      140,70
    };
    if (mover(btn)) {
      if (click) {
        click=!click;
        page++;
      }
      fill(255);
      rect(btn[0],btn[1],btn[2],btn[3]);
      fill(0);
      text("Ok",btn[0]+(btn[2]/3), btn[1]+45);
    } else {
      
      fill(0);
      rect(btn[0],btn[1],btn[2],btn[3]);
      fill(255);
      text("Ok",btn[0]+(btn[2]/3), btn[1]+45);
    }
    skin();
  } else if(page == 2) {
    background(0);
    int btns[][] = {
      {
        (width/3),(height/8)+100,
        300,100
      },{
        (width/3),(height/8)+200,
        300,100
      },{
        (width/3),(height/8)+300,
        300,100
      },{
        (width/3),(height/8)+400,
        300,100
      },{
        (width/3),(height/8)+500,
        300,100
      },
    };
    String btns_name[] = {
      "3D visual",
      "edge detection",
      "filters",
      "particles",
    };
    for (int i=0;i<btns_name.length;i++) {
      if (mover(btns[i])) {
        if (click) {
          
          click=!click;
          page++;
          choice = i+1;
        }
        fill(255);
        rect(btns[i][0],btns[i][1],btns[i][2],btns[i][3]);
        fill(0);
        text(btns_name[i],btns[i][0]+(btns[i][2]/3),btns[i][1]+(btns[i][3]/2));
      } else {
        
        fill(0);
        rect(btns[i][0],btns[i][1],btns[i][2],btns[i][3]);
        fill(255);
        text(btns_name[i],btns[i][0]+(btns[i][2]/3),btns[i][1]+(btns[i][3]/2));
      }
    }
    skin();
  } else if (page == 3) {
    background(0);
    if (tmp < 1) {
        if (img == null) {
          fill(255,0,0);
          
          text("Error: maybe you didnt insert the image to this directory or rename it to \"input.jpg\" and remember it is case sensetive, trying again...", width/2, height/2);
          try { img = loadImage("input.jpg");img2 = loadImage("input.jpg"); } catch (Exception e) {}
        } else {
          
          fill(255);
          text("loading...",width/2,height/2);
          tmp++;
          img.loadPixels();
        }
   } else {
      if(choice ==1) {
        int dep_flag=0;
        int dep_btns[][] = {
          {120,120, 200,50},
          {120,170, 200,50},
          {120,220, 200,50},
          {120,270, 200,50},
          {120,320, 200,50},
          {120,370, 200,50},
          {120,420, 200,50}
        };
        String dep_name[] = {
          "Default/gs",
          "red",
          "green",
          "blue",
          "negetive",
          "none",
          "back"
        };
        float dep=0;
        for(int i=0;i<dep_name.length;i++) {
          if(mover(dep_btns[i])) {
            dep_flag=i;
            fill(255);
            rect(dep_btns[i][0],dep_btns[i][1],dep_btns[i][2],dep_btns[i][3]);
            fill(0);
            text(dep_name[i],dep_btns[i][0]+(dep_btns[i][2]/3),dep_btns[i][1]+(dep_btns[i][3]/2));
            if (dep_name[i].equals("back")) {
              if (click) {
                click=!click;
                page=2;
                choice=0;
              }
            }
         } else {
            
            fill(0);
            rect(dep_btns[i][0],dep_btns[i][1],dep_btns[i][2],dep_btns[i][3]);
            fill(255);
            text(dep_name[i],dep_btns[i][0]+(dep_btns[i][2]/3),dep_btns[i][1]+(dep_btns[i][3]/2));
          }
        }
        for (int i=0;i<img.width;i+=4) {
          for(int j=0;j<img.height;j+=4) {
            pixel = img.pixels[(j*img.width)+i];
            if (dep_flag == 0)
              dep = (red(pixel)+green(pixel)+blue(pixel))/3;
            else if (dep_flag == 1)
              dep = red(pixel);
            else if (dep_flag == 2)
              dep = green(pixel);
            else if (dep_flag == 3)
              dep = blue(pixel);
            else if (dep_flag == 4)
              dep = 255-((red(pixel)+green(pixel)+blue(pixel))/3);
            else if (dep_flag == 5) {
              
            }
            fill(pixel);
            pushMatrix();
            translate(((width/2) + ((i/4)*4)) -mouseX,((height/2) + ((j/4)*4))-mouseY, -100+dep+z);
            box(4);
            popMatrix();
          }
        }
      } else if (choice == 2) {
        background(0);
        int op_flag=0;
        int op_btns[][] = {
          {40,120, 400,50},
          {40,170, 400,50},
          {40,220, 400,50},
          {40,270, 400,50},
          {40,320, 400,50},
          {40,370, 400,50},
          {40,420, 400,50}
        };
        String op_name[] = {
          "Kernel combination",
          "Kernel combinationV",
          "Kernel combinationH",
          "simple subtruction",
          "simple subtruction GS",
          "none",
          "back"
        };
        float op=0;
        for(int i=0;i<op_name.length;i++) {
          if(mover(op_btns[i])) {
            op_flag=i;
            fill(255);
            rect(op_btns[i][0],op_btns[i][1],op_btns[i][2],op_btns[i][3]);
            fill(0);
            text(op_name[i],op_btns[i][0]+(op_btns[i][2]/8),op_btns[i][1]+(op_btns[i][3]/2));
            if (op_name[i].equals("back") & click) {
                click=!click;
                page--;
                choice=0;
            }
          } else {
            
            fill(0);
            rect(op_btns[i][0],op_btns[i][1],op_btns[i][2],op_btns[i][3]);
            fill(255);
            text(op_name[i],op_btns[i][0]+(op_btns[i][2]/8),op_btns[i][1]+(op_btns[i][3]/2));
          }
        }
        image(img2,(width/2)-(img2.width/6),(height/2)-(img2.height/4));
        for(int i=0;i<img.width;i++) {
          for(int j=0;j<img.height;j++) {
            if (op_flag == 0) {
              float kernel[][] = {
                {-1,-2,1},
                {-2,0,2},
                {-1,2,1},
              };
              float gs = combine(kernel, i, j) *10;
              img2.pixels[(j*img.width)+i] = color(gs);
            } else if (op_flag == 1) {
              float kernel[][] = {
                {-1,-2,1},
                {0,0,0},
                {-1,2,1},
              };
              float gs = combine(kernel, i, j) *10;
              img2.pixels[(j*(img.width))+i] = color(gs);
            } else if (op_flag == 2) {
              float kernel[][] = {
                {-1,0,1},
                {-2,0,2},
                {-1,0,1},
              };
              float gs = combine(kernel, i, j) *10;
              img2.pixels[(j*img.width)+i] = color(gs);
            
            } else if (op_flag == 3) {
              color pix1 = img.pixels[(j*img.width)+i];
              color pix2;
              if (i >= img.width-1) {
                if (j >= img.height-1) {
                  pix2 = color(0);
                } else {
                  pix2 = img.pixels[((j+1)*img.width)+i];
                }
              } else { 
                  pix2 = img.pixels[(j*img.width)+(i+1)];
              }
              float r = red(pix1)-red(pix2);
              float g = green(pix1)-green(pix2);
              float b = blue(pix1)-blue(pix2);
              if (r < -1)
                r = r*-1;
              else if (r < 1)
                r = 0;
              if (g < -1)
                g = g*-1;
              else if (g < 1)
                g = 0;
              if (b < -1)
                b = b*-1;
              else if (b < 1)
                b = 0;
              
              img2.pixels[(j*img.width)+i] = color(r,g,b);
            } else if (op_flag == 4) {
              
              color pix1 = img.pixels[(j*img.width)+i];
              color pix2;
              if (i >= img.width-1) {
                if (j >= img.height-1) {
                  pix2 = color(0);
                } else {
                  pix2 = img.pixels[((j+1)*img.width)+i];
                }
              } else { 
                  pix2 = img.pixels[(j*img.width)+(i+1)];
              }
              float g1 = (red(pix1)+green(pix1)+blue(pix1))/3;
              float g2 = (red(pix2)+green(pix2)+blue(pix2))/3;
              float gav = g1-g2;
              if (gav < -1)
                gav = gav*-1;
              else if (gav <1)
                gav = 0;
              img2.pixels[(j*img.width)+i] = color(gav);
            } else if (op_flag == 5) {
              img2.pixels[(j*img.width)+i] = img.pixels[(j*img.width)+i];
            }
          }
        }
        img2.updatePixels();
      } else if (choice == 3) {
        background(0);
        int op_flag=0;
        int op_btns[][] = {
          {40,120, 400,50},
          {40,170, 400,50},
          {40,220, 400,50},
          {40,270, 400,50},
          {40,320, 400,50},
          {40,370, 400,50},
          {40,420, 400,50}
        };
        String op_name[] = {
          "negetive",
          "gray scale",
          "2bit color",
          "64bit color",
          "face beuty",
          "none",
          "back"
        };
        float op=0;
        for(int i=0;i<op_name.length;i++) {
          if(mover(op_btns[i])) {
            op_flag=i;
            fill(255);
            rect(op_btns[i][0],op_btns[i][1],op_btns[i][2],op_btns[i][3]);
            fill(0);
            text(op_name[i],op_btns[i][0]+(op_btns[i][2]/8),op_btns[i][1]+(op_btns[i][3]/2));
            if (op_name[i].equals("back") & click) {
                click=!click;
                page--;
                choice=0;
            }
          } else {
            
            fill(0);
            rect(op_btns[i][0],op_btns[i][1],op_btns[i][2],op_btns[i][3]);
            fill(255);
            text(op_name[i],op_btns[i][0]+(op_btns[i][2]/8),op_btns[i][1]+(op_btns[i][3]/2));
          }
        }
        image(img2,(width/2)-(img2.width/6),(height/2)-(img2.height/4));
        for(int i=0;i<img.width;i++) {
          for(int j=0;j<img.height;j++) {
            color pix = img.pixels[(j*img.width)+i];
            if (op_flag == 0) {
              img2.pixels[(j*img.width)+i] = (color(255-red(pix), 255-green(pix), 255-blue(pix)));
            } else if (op_flag == 1) {
              img2.pixels[(j*img.width)+i] = color((red(pix)+green(pix)+blue(pix))/3);
            } else if (op_flag == 2) {
              img2.pixels[(j*img.width)+i] = color(255*to2bit((red(pix)+green(pix)+blue(pix))/3));
            } else if (op_flag == 3) {
              img2.pixels[(j*img.width)+i] = (color(to16bit(red(pix)), to16bit(green(pix)), to16bit(blue(pix))));
            } else if (op_flag == 4) {
              img2.pixels[(j*img.width)+i] = (color((red(pix)+green(pix))/2, to16bit((green(pix)+blue(pix))/2), to16bit((blue(pix)+red(pix))/2)));
            } else if (op_flag == 5) {
              img2.pixels[(j*img.width)+i] = img.pixels[(j*img.width)+i];
            }
          }
        }
        img2.updatePixels();
      } else if (choice == 4) {
        background(0);
        for(int i=0;i<particles.length;i++) {
          stroke(img.pixels[i]);
          point(particles[i][0],particles[i][1]);
          if (particles[i][0] < particles[i][3])
            particles[i][0]+=random(-1,15);
          else if (particles[i][0] > particles[i][3])
            particles[i][0]-=random(-1,15);
          if (particles[i][1] < particles[i][4])
            particles[i][1]+=random(-1,15);
          else if (particles[i][1] > particles[i][4])
            particles[i][1]-=random(-1,15);
        }
      }
    }
    skin();
  } 
  
}
float particles[][];
int to2bit(float x) {
  if (x > 128)
    return 1;
  return 0;
}
int to16bit(float x) {
  return int(x -(x%16));
}
