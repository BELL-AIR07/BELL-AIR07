  import processing.serial.*;
  
Serial port;                //creació d'objecte serial per assignar el port COM pel que arriven les dades 
PrintWriter arxiu;          //cdreació d'objecte tiupus writer
String dades_rebudes;
float latitud,longitud,alt_gps,alt_bme,temp,pres,hum,accel;
//float altura,altura_anterior,velocitat;
float altura, altura_anterior, vel, vel_anterior;  // *************
int transmisio, sats;
int transmisio_anterior;
float temp_min = 1000; float temp_max = 0; 
float hum_min = 1000; float hum_max = 0; 
float pres_min = 1000; float pres_max = 0; 
float alt_min = 1000; float alt_max = 0; 
float vel_min = 1000; float vel_max = 0; 
float accel_min = 1000; float accel_max = 0; 
boolean ON = false;
int sv = 0;  // situació de vol

//colors:
int Rf=0,Gf=0,Bf=160;          //color fons finestra
int R1=200,G1=300,B1=400;     // color de fons rectangle zona gràfics
int R2=1000,G2=1000,B2=1000; 
int R3=200,G3=280,B3=400; 
int R4=100,G4=100,B4=100;

PImage logo; 
PImage bON;
PImage bOFF;
PImage cansat1;
PImage cansat2;
PImage cansat3;
PImage vel0;
PImage vel1;
PImage vel2;
PImage vel3;
PImage vel4;
PImage vel5;
PImage vel6;
PImage vel7;
PImage vel8;
PImage bat1;
PImage bat2;
PImage bat3;
PImage bat4;
PImage bat5;
PImage bat6;

// gràfics:
int x=110, ample=700, alt=800;
boolean pT = true; boolean pH = true; boolean pP = true;
Graf g = new Graf (ample, alt);

// temps:
int lastSecond = 0;  
int milisegons = 0; int segons = 0; int minuts = 0; int hores = 0;


void setup()
{
  println(Serial.list());
  port = new Serial(this, Serial.list()[0], 9600);
  //port = new Serial(this, "COM11", 9600);
  arxiu = createWriter("dades.csv"); 
  
  size (1366,768); background (Rf,Gf,Bf); //caracteristiques de finestra 
  fill(R1,G1,B1); stroke(1000,1000,1000); strokeWeight(3); rect(50, 50, 500 , 620,15);   //rectangle zona gràfics
  //fill(R2,G2,B2); stroke(100,100,100); strokeWeight(1); rect(730, 50, 400 , 625,15);    //rectangle zona notificacions 
  fill(R1,G1,B1); noStroke(); rect(590, 200, 740 ,470 ,15);    //rectangle zona interior
  textSize(15); fill(0, 0, 0); textAlign(LEFT); text ("MISSIÓ PRIMÀRIA",110,75); //text ("NOTIFICACIONS",860,80);
  
  logo = loadImage("logo.png"); image (logo,540,10,200,200);
  bON  =  loadImage ("bON.png");
  bOFF = loadImage ("bOFF.png");
  image (bOFF ,1230,40,97,45);
  cansat1 = loadImage("CS01.png");
  cansat2 = loadImage("CS02.png");
  cansat3 = loadImage("CS03.png");
  image (cansat1,1200,340,100,160);
  vel0 = loadImage("v0.png");
  vel1 = loadImage("v1.png");
  vel2 = loadImage("v2.png");
  vel3 = loadImage("v3.png");
  vel5 = loadImage("v5.png");
  vel6 = loadImage("v6.png");
  vel7 = loadImage("v7.png");
  vel8 = loadImage("v8.png");
  bat1 = loadImage("b1.png");
  bat2 = loadImage("b2.png");
  bat3 = loadImage("b3.png");
  bat4 = loadImage("b4.png");
  bat5 = loadImage("b5.png");
  bat6 = loadImage("b6.png");
  
  g.quadricules();
  g.text_eixos();
}
void draw ()
{
  while (port.available()>0)
  {
    dades_rebudes = port.readStringUntil('\n');
    if (dades_rebudes !=null)
    {
      String[] llista_dades = split(dades_rebudes, ',');
      //println(llista_dades);
      if (llista_dades.length==11)
      {
        if (ON==true)
        {
          arxiu.print(dades_rebudes);
          arxiu.flush();
          //println(dades_rebudes);
        }
        
        transmisio = int (llista_dades[0]);
        latitud = float (llista_dades[1]);
        longitud = float (llista_dades[2]);
        alt_gps = float (llista_dades[3]);
        alt_bme = float (llista_dades[4]);
        temp = float (llista_dades[5]);
        pres = float (llista_dades[6]);
        hum = float (llista_dades[7]);
        sats= int (llista_dades[8]);
        accel= float(llista_dades[9]);
               
        g.grafics();
        g.mostrar_dades();
        missatges();
        //notificacions();
        velocimetre();
        bateria();
        temps();
      }
      
    }
  }
}

//---------------------------------------------

void mouseClicked ()
{
  if (mouseX > 1230 && mouseX < (1230+97) && mouseY > 40 && mouseY < (40+40))
  {ON = !ON;}
  if (ON==true){image (bON, 1230,40,97,45); fill(Rf,Gf,Bf); noStroke(); rect(1120,50,100,20); fill(255,255,255);textSize(15);textAlign(LEFT); text("DESANT DADES",1120,67);}
  else {image (bOFF,1230,40,97,45); fill(Rf,Gf,Bf); noStroke(); rect(1120,50,100,20);}
}



void missatges()
{
  // transmissio ..............................
  fill(R1,G1,B1); noStroke(); rect(630,230,160,20); 
  fill(0,0,0);textSize(15);textAlign(LEFT); text("NÚMERO DE TRANSMISIÓ",630,245);
  fill(R4,B4,G4);stroke(1);rect(795,230,100,20);
  fill(255,255,255); text(transmisio,832,245);
  
  fill(R1,G1,B1); noStroke(); rect(915,230,200,20);
  fill(R1,G1,B1); noStroke(); rect(785,260,500,20); 
  if(transmisio !=transmisio_anterior + 1) {fill(Rf,Gf,Bf);textSize(15);textAlign(LEFT); text("PAQUET PERDUT",920,245);}
  else
  {
   fill(Rf,Gf,Bf);textSize(15);textAlign(LEFT); text("REBENT DADES",920,245);
   fill(Rf,Gf,Bf);textSize(15);textAlign(LEFT); text(dades_rebudes,795,275);
 }
 transmisio_anterior=transmisio;
 
 // posicio ......................
  fill(R1,G1,B1); noStroke(); rect(630,305,160,20); 
  fill(0,0,0);textSize(15);textAlign(LEFT); text("POSICIO (LAT, LONG)",640,320);
  fill(R4,B4,G4);stroke(1);rect(795,305,100,20); fill(R4,B4,G4);stroke(1);rect(915,305,100,20);
  fill(255,255,255); text(latitud, 825,320); fill(255,255,255); text(longitud, 945,320);
  
  fill(R1,G1,B1); noStroke(); rect(785,335,400,20); 
  if(sats == 0)
  {fill(Rf,Gf,Bf);textSize(15);textAlign(LEFT); text("CERCANT SATÈL·LITS",795,350);}
  else
  {fill(Rf,Gf,Bf);textSize(15);textAlign(LEFT); text("TRIANGULANT POSICIÓ. SATÈL·LITS DETECTATS:"+ sats,795,350);}
  
  // altura ...............................
  //if (sats < 4) {altura = alt_bme;} else {altura = alt_gps;}
  altura = alt_bme;
  fill(R1,G1,B1); noStroke(); rect(630,380,160,20);
  fill(0,0,0);textSize(15);textAlign(LEFT); text("ALTITUD",680,395); 
  fill(R4,B4,G4);stroke(1);rect(795,380,100,20);
  fill(255,255,255); text((altura + " m"),815,395);
  
  // velocitat .............................
  if (altura_anterior > 0) {vel = (altura_anterior - altura);}
  //fill(R1,B1,G1); noStroke(); rect(640,625,100,20);
  //fill(0,0,0); textSize(16); textAlign(LEFT); text("VELOCITAT",660,640); 
  fill(R1,B1,G1); noStroke(); rect(700,625,100,20);
  fill(0,0,0); textSize(16); textAlign(LEFT); text("VELOCITAT",700,640);
  fill(R4,B4,G4);stroke(1);rect(915,625,100,20); fill(255,255,255); text(nf(abs(vel),0,2)+ " m/s ", 940,640);
  
  //print(altura_anterior); print("    "); println(altura);
  // situacions de vol (SV):
  // sv == 0 -> EN ESPERA
  // sv == 1 -> ASCENDENT
  // sv == 2 -> DESCENDENT
  // sv == 3 -> ATERRAT
  if ((sv==0) && (altura < altura_anterior+2) && (altura > altura_anterior-2)) {fill(R1,G1,B1); noStroke(); rect(795,410,350,20); fill(Rf,Gf,Bf); textSize(15); textAlign(LEFT); text ("SITUACIÓ DE VOL: EN ESPERA",795,425);}
  if ((sv==0) && (altura_anterior > 0) && (altura > altura_anterior+2)) {sv++;}
  if ((sv==1) && (altura > altura_anterior+2)) {fill(R1,G1,B1); noStroke(); rect(795,410,350,20); fill(Rf,Gf,Bf); textSize(15); textAlign(LEFT); text ("SITUACIÓ DE VOL: ASCENDENT",795,425);}
  if ((sv==1) && (altura < altura_anterior-2)) {sv++;}
  if ((sv==2) && (altura < altura_anterior-2)) {fill(R1,G1,B1); noStroke(); rect(795,410,350,20); fill(Rf,Gf,Bf); textSize(15); textAlign(LEFT); text ("SITUACIÓ DE VOL: DESCENDENT",795,425); image (cansat2,1200,340,100,160);}
  if ((sv==2) && (altura < altura_anterior+2) && (altura > altura_anterior-2)) {fill(R1,G1,B1); noStroke(); rect(795,410,350,20); fill(Rf,Gf,Bf); textSize(15); textAlign(LEFT); text ("SITUACIÓ DE VOL: ATERRAT",795,425); image (cansat3,1200,340,100,160);}
  // altitud aeroport Alguaire: 351 m --> (transmisio > 1000) & (altura < 500)
  altura_anterior = altura;
  //println(altura+"...."+sv);

  // acceleracio .................................
  fill(R1,G1,B1); noStroke(); rect(630,455,120,20);
  fill(0,0,0);textSize(15);textAlign(LEFT); text("ACCELERACIÓ",665,470);
  fill(R4,B4,G4);stroke(1);rect(795,455,100,20);
  fill(255,255,255); text(nf(abs(accel),0,2) + " m/s²", 815,470);
  
  // max-min .....................................
  if (altura < alt_min) {alt_min = altura;}
  if (altura > alt_max) {alt_max = altura;}
  fill(R1,G1,B1); noStroke(); rect(915,380,250,20); fill(Rf,Gf,Bf); textSize(15); text ("mínima = " +alt_min + " m - màxima = " + alt_max + " m",915,395);
  
  if (accel < accel_min) {accel_min = accel;}
  if (accel > accel_max) {accel_max = accel;}
  fill(R1,G1,B1); noStroke(); rect(915,455,280,20); fill(Rf,Gf,Bf); textSize(15); text ("mínima = " +accel_min + " m/s² - màxima = " + accel_max + " m/s²",915,470);

  if (abs(vel) < vel_min) {vel_min = vel;}
  if (abs(vel) > vel_max) {vel_max = vel;}
  fill(R1,G1,B1); noStroke(); rect(1035,625,280,20); fill(Rf,Gf,Bf); textSize(15); text ("mínima = " + nf(abs(vel_min),0,2) + " m/s - màxima = " + nf(abs(vel_max),0,2) + " m/s",1040,640);
  
  //fill(R1,B1,G1); noStroke(); rect(740,625,100,20);
  //if (vel<2) {fill(Rf,Gf,Bf); textSize(16); textAlign(LEFT); text("ATURAT", 750,640);}
  //else if(vel<5) {fill(0,0,0); textSize(16); textAlign(LEFT); text("INSUFICIENT", 750,640);}
  //else if (vel<=8){fill(0,0,0); textSize(16); textAlign(LEFT); text("ACEPTABLE", 750,640);}
  //else if (vel<=12){fill(0,0,0); textSize(16); textAlign(LEFT); text("EXCELENT", 750,640);}
  //else {fill(255,0,0); textSize(16); textAlign(LEFT); text("EXCESIVA",750,640);}
}


void velocimetre()
{ 
  if (vel<=1.5) {fill(R1,B1,G1); noStroke(); rect(675,500,220,130); image (vel0,675,500,220,130); fill(R1,B1,G1); noStroke(); rect(800,625,100,20); fill(Rf,Gf,Bf); textSize(16); textAlign(LEFT); text("ATURAT", 800,640);}
  else if (vel<3) {fill(R1,B1,G1); noStroke(); rect(675,500,220,130); image (vel1,675,500,220,130); fill(R1,B1,G1); noStroke(); rect(800,625,100,20); fill(255,127,39); textSize(16); textAlign(LEFT); text("INSUFICIENT", 800,640);}
  else if (vel<5) {fill(R1,B1,G1); noStroke(); rect(675,500,220,130); image (vel2,675,500,220,130); fill(R1,B1,G1); noStroke(); rect(800,625,100,20); fill(255,127,39); textSize(16); textAlign(LEFT); text("INSUFICIENT", 800,640);}
  else if (vel<6.5) {fill(R1,B1,G1); noStroke(); rect(675,500,220,130); image (vel3,675,500,220,130); fill(R1,B1,G1); noStroke(); rect(800,625,100,20); fill(255,127,39); textSize(16); textAlign(LEFT); text("INSUFICIENT", 800,640);}
  else if (vel<8) {fill(R1,B1,G1); noStroke(); rect(675,500,220,130); image (vel4,675,500,220,130); fill(R1,B1,G1); noStroke(); rect(800,625,100,20); fill(0,0,0); textSize(16); textAlign(LEFT); text("ACCEPTABLE", 800,640);}
  else if (vel<10) {fill(R1,B1,G1); noStroke(); rect(675,500,220,130); image (vel5,675,500,220,130); fill(R1,B1,G1); noStroke(); rect(800,625,100,20); fill(0,255,0); textSize(16); textAlign(LEFT); text("EXCELENT", 800,640);}
  else if (vel<12) {fill(R1,B1,G1); noStroke(); rect(675,500,220,130); image (vel6,675,500,220,130); fill(R1,B1,G1); noStroke(); rect(800,625,100,20); fill(0,255,0); textSize(16); textAlign(LEFT); text("ACCEPTABLE", 800,640);}
  else if (vel<13.5) {fill(R1,B1,G1); noStroke(); rect(675,500,220,130); image (vel7,675,500,220,130); fill(R1,B1,G1); noStroke(); rect(800,625,100,20); fill(255,0,0); textSize(16); textAlign(LEFT); text("EXCESIVA", 800,640);}
  else {fill(R1,B1,G1); noStroke(); rect(675,500,220,130); image (vel8,675,500,220,130); fill(R1,B1,G1); noStroke(); rect(800,625,100,20); fill(255,0,0); textSize(16); textAlign(LEFT); text("EXCESIVA", 800,640);}
}

void bateria()
{
  // suposant durada 4h (14.400 s) cada 1.440 s perd 10% de capacitat
  fill(Rf,Gf,Bf); noStroke(); rect(1180,110,150,50);
  //image (bat3,1230,125,100,45); fill(255,255,255); textSize(15); textAlign(LEFT); text ("60 %",1050,130);
  //fill(Rf,Gf,Bf); noStroke(); rect(750,147,200,20);
  //fill(255);textSize(15);textAlign(LEFT); text("DURADA DE LA MISSIÓ",795,165);
  
  if (transmisio<=1440) {image (bat1,1230,125,100,45); fill(255,255,255); textSize(15); textAlign(LEFT); text ("100 %",1180,150);}
  else if (transmisio<=2880) {image (bat1,1230,125,100,45); fill(255,255,255); textSize(15); textAlign(LEFT); text ("90 %",1180,150);}
  else if (transmisio<=4320) {image (bat1,1230,125,100,45); fill(255,255,255); textSize(15); textAlign(LEFT); text ("80 %",1180,150);}
  else if (transmisio<=5760) {image (bat2,1230,125,100,45); fill(255,255,255); textSize(15); textAlign(LEFT); text ("70 %",1180,150);}
  else if (transmisio<=7200) {image (bat2,11230,125,100,45); fill(255,255,255); textSize(15); textAlign(LEFT); text ("60 %",1180,150);}
  else if (transmisio<=8640) {image (bat3,1230,125,100,45); fill(255,255,255); textSize(15); textAlign(LEFT); text ("50 %",1180,150);}
  else if (transmisio<=10080) {image (bat3,1230,125,100,45); fill(255,255,255); textSize(15); textAlign(LEFT); text ("40 %",1180,150);}
  else if (transmisio<=11520) {image (bat4,1230,125,100,45); fill(255,255,255); textSize(15); textAlign(LEFT); text ("30 %",1180,150);}
  else if (transmisio<=12960) {image (bat5,1230,125,100,45); fill(255,255,255); textSize(15); textAlign(LEFT); text ("20 %",1180,150);}
  else {image (bat6,1230,125,100,45); fill(255,255,255); textSize(15); textAlign(LEFT); text ("10 %",1180,150);}
}


void notificacions()
{
  fill(0,G1,B1); noStroke(); rect(915,230,100,20);
  fill(0,G1,B1); noStroke(); rect(785,260,500,50); 
  
  if(transmisio !=transmisio_anterior + 1)
 {fill(Rf,Gf,Bf);textSize(15);textAlign(LEFT); text("PAQUET PERDUT",795,275);}

 else
 {
   fill(Rf,Gf,Bf);textSize(15);textAlign(LEFT); text("REBENT DADES",795,300);
   fill(Rf,Gf,Bf);textSize(15);textAlign(LEFT); text(dades_rebudes,795,275);
 }
 transmisio_anterior=transmisio;
 // ....................................

 
  fill(R1,G1,B1); noStroke(); rect(785,350,500,20); 
  if(sats == 0)
  {fill(Rf,Gf,Bf);textSize(15);textAlign(LEFT); text("CERCANT SATÈL·LITS",795,365);}
  else
  {fill(Rf,Gf,Bf);textSize(15);textAlign(LEFT); text("TRIANGULANTPISICIÓ. SATÈL·LITS DETECTATS:"+ sats,795,365);}
 // ...........................................
  
  fill(R1,G1,B1); noStroke(); rect(785,440,500,20);
  if (altura > altura_anterior)
  {fill(Rf,Gf,Bf);textSize(15);textAlign(LEFT); text("SITUACIÓ DE VOL:ASCENDENT",795,455);}
  
  else if (altura < altura_anterior)
  {fill(Rf,Gf,Bf);textSize(15);textAlign(LEFT); text("SITUACIÓ DE VOL:DECENDENT",790,455);}
  
  else
 {fill(Rf,Gf,Bf);textSize(15);textAlign(LEFT); text("SITUACIÓ DE VOL:ATERRAT",795,455);}
 altura_anterior=altura;
    
    
  fill(R1,G1,B1); noStroke(); rect(1025,530,250,20);
  fill(Rf,Gf,Bf);textSize(15);textAlign(LEFT); text("NOTIFICACIÓ ACCELERACIÓ",1035,545);
  
  // .................................................
  if (altura < alt_min) {alt_min = altura;}
  if (altura > alt_max) {alt_max = altura;}
  fill(R1,B1,G1); noStroke(); rect(910,410,300,20);  // altitud
  fill(Rf,Gf,Bf); textSize(15); text("mínima = " +alt_min + "m - màxima = " + alt_max + " m",915,425);
  
  if (accel < accel_min) {accel_min = accel;}
  if (accel > accel_max) {accel_max = accel;}
  fill(R1,G1,B1); noStroke(); rect(1095,500,195,20);  // acceleració
  fill(Rf,Gf,Bf); textSize(15); text("mínima = " +accel_min + "m/s2 - màxima = " + accel_max + " m/s2", 1095,515);
  
  if (vel < vel_min) {vel_min = accel;}
  if (vel > vel_max) {vel_max = accel;}
  fill(R1,B1,G1); noStroke(); rect(1035,625,250,20);  // velocitat
  fill(Rf,Gf,Bf); textSize(15); text("mínima = " + nf(abs(vel_min),0,2) + "m/s - màxima = " + nf(abs(vel_max),0,2) + " m/s", 1040,640);
}

void temps()
{
  int d = day();
  int mes = month();
  int a = year();
  int s = second();
  int m = minute();
  int h = hour();
  if (s != lastSecond)
  {
    fill(0,Gf,Bf); noStroke(); rect(750, 147, 300, 20);   
    fill(255);  textSize(15); text(("Són les " + h + ":" + m + ":" + s + " del dia " + d+"-"+mes+"-"+a+" "),795,165);
    lastSecond = s;
  }
  
  // durada del vol
  if (ON==true)
  {
    long temps_referencia = 0;
    if((millis()-temps_referencia)>=1000)
    segons++;
    if (segons >= 59) { segons = 0; minuts++;}
    if (minuts >= 59) { minuts = 0; hores++;}
    fill(0,Gf,Bf); noStroke(); rect(750, 122, 300, 25); 
    fill(255);  textSize(15); text(("DURADA DE L MISSIÓ: " +hores + ":"+ minuts + ":" + segons + " h"),795,140);
  }
}
