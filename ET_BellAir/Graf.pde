class Graf 
{
  int nX, nY, colF;
  int anteriorXT , anteriorXH, anteriorXP;
  float anteriorYT, anteriorYH, anteriorYP;
  boolean primeroT, primeroH, primeroP;
  Graf (int x, int y) { nX = x; nY = y; }
  int Rt=200, Gt=0, Bt=0;
  int Rh=0, Gh=0, Bh=200;
  int Rp=0, Gp=100, Bp=0;
  
  void quadricules()  // dibuixa les línies verticals i horitzontals de les quadrícules dels gràfics
  { 
    stroke(150);      // color línies   
    strokeWeight(1);  // gruix línies  
    // temperatura: línies des de x 110 fins a 660, des de y 100 fins a 300, cada 20 px
    for (int  j = 110 ; j <= 530; j = j + 15) {line (j, 100, j, 250);}    // línies verticals
    for (int  j = 100 ; j <= 250; j = j + 15) {line (110, j, 530, j);}    // línies horitzontals     
    // humitat; línies des de x 110 fins a 660, des de y 350 fins a 550, cada 20 px
    for (int  j = 110 ; j <= 530; j = j + 15) {line (j, 300 , j, 450);}  // línies verticals
    for (int  j = 300 ; j <= 450; j = j + 15) {line (110, j, 530, j);}   // línies horitzontals
    // pressio: línies des de x 110 fins a 660, des de y 600 fins a 800, cada 20 px
    for (int  j = 110 ; j <= 530; j = j + 15) {line (j, 500 , j, 650);}  // línies verticals
    for (int  j = 500 ; j <= 650; j = j + 15) {line (110, j, 530, j);}   // línies horitzontals
  }
  
  void text_eixos()  // text eixos verticals gràfics
  {    
    // textos eix vertical grafics
    int i = 0;
    for (int n = 250; n >= 100; n = n - 15)  // temperatura: 0 a 50
    {
      fill(0, 0, 0);
      textAlign(RIGHT);
      textSize(10);
      text(i, 95, n + 5);
      i = i + 5;
    }
    i = 0;
    for (int n = 450; n >= 300; n = n - 15)  // humitat: 0 a 100
    {
      fill(0, 0, 0);
      textAlign(RIGHT);
      textSize(10);
      text(i, 95, n + 5);
      i = i + 10;
    }
    i = 0;
    for (int n = 650; n >= 500; n = n - 15)  // pressió: 0 a 1500
    {
      fill(0, 0, 0);
      textAlign(RIGHT);
      textSize(10);
      text(i, 95, n + 5);
      i = i + 150;
    }
  }
  void grafics()
  {
    //punts:
    fill (Rt,Gt,Bt);  // color punts gràfic temperatura (vermell)
    if (temp >= 0.0 && temp <= 50.0){puntsT(x, temp, pT);}    // valors: entre 0 i 50
    pT = false;
    fill (Rh,Gh,Bh);  // color punts gràfic humitat (blau)
    if (hum >= 0.0 && hum <= 100.0){puntsH(x, hum, pH);}      // valors: entre 0 i 100
    pH = false;
    fill (Rp,Gp,Bp);  // color punts gràfic pressió (verd)
    if (pres >= 0.0 && pres <= 1500.0){puntsP(x, pres, pP);}  // valors entre 0 i 1500
    pP = false;
  
    x = x + 3;  // separació entre els punts: 5 px
    
    actualitza();
  }
    void actualitza()
  {  
    //actualitza en arrivar al final (esborra i torna a començar):
    if (x > 530)  // per comprovar, canviar 650 per 150
    {
      x = 110;
      pT = true;
      pH = true;
      pP = true;
      fill(R1,G1,B1); // caldrà canviar pel color del fons zona gràfics
      noStroke();
      rect(105 , 95, 430 , 160 ); 
      rect(105 , 295, 430 , 160 );
      rect(105 , 495, 430 , 160 );
      quadricules();
    }
  }
    void puntsT(int x, float temp, boolean primeroT)  // punts gràfic temperatura
  {
    float vT = map(temp, 0, 50, 250 , 100);
    noStroke();
    ellipse(x, vT, 3, 3);
    if (primeroT == false)
    {
      stroke(Rt,Gt,Bt);  // color temperatura
      strokeWeight(3);
      line(anteriorXT, anteriorYT, x, vT);
    }
    anteriorXT = x;
    anteriorYT = vT;      
  }
  
  void puntsH(int x, float hum, boolean primeroH)  // punts gràfic humitat
  {
    float vH = map(hum, 0, 100, 450, 300); 
    noStroke();
    ellipse(x, vH, 3, 3);
    if (primeroH == false)
    {
      stroke(Rh,Gh,Bh);  // color humitat
      strokeWeight(3);
      line(anteriorXH, anteriorYH, x, vH);
    }
    anteriorXH = x;
    anteriorYH = vH;   
  }
  
  void puntsP(int x, float pres, boolean primeroP)  // punts gràfic pressió
  {
    float vP = map(pres, 0, 1500, 650, 500); 
    noStroke();
    ellipse(x, vP, 3, 3);
    if (primeroP == false)
    {
      stroke(Rp,Gp,Bp);
      strokeWeight(3);
      line(anteriorXP, anteriorYP, x, vP);
    }
    anteriorXP = x;
    anteriorYP = vP;   
  }
  
  void mostrar_dades()
  {
    textSize(15); textAlign(LEFT);
    fill(R1, G1, B1); noStroke(); rect(110,85,430,15); fill(Rt,Gt,Bt); text("TEMPERATURA: " + temp + "°C", 110, 96);
    fill(R1, G1, B1); noStroke(); rect(110,275,430,25); fill(Rh,Gh,Bh); text("HUMITAT RELATIVA:" + hum + "%", 110, 296);
    fill(R1, G1, B1); noStroke(); rect(110,475,430,25); fill(Rp,Gp,Bp); text("PRESSIÓ:" + pres + "hPa", 110, 496);
    
    if (temp < temp_min) {temp_min = temp;}
    if (temp > temp_max) {temp_max = temp;}
    fill(Rt,Gt,Bt); textSize(13); text ("mínima = " +temp_min + "°C - màxima = " + temp_max + " °C",325,96); 
    
    if (hum < hum_min) {hum_min = hum;}
    if (hum > hum_max) {hum_max = hum;}
    fill(Rh,Gh,Bh); textSize(13); text ("mínima = " +hum_min + "% - màxima = " + hum_max + " %",330,296);
    
    if (pres < pres_min) {pres_min = pres;}
    if (pres > pres_max) {pres_max = pres;}
    fill(Rp,Gp,Bp); textSize(13); text ("mínima = " +pres_min + " hPa - màxima = " + pres_max + " hPa",285,496);
  }
}
