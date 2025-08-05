// importe la librairie son
import processing.sound.*;

float gravity = 0.2;  // la force de pesanteur
float acceleration;   // accélération de l'anneau
float obstacleX;      // position en X du ballon obstacle
float obstacleY;      // position en Y du ballon obstacle
float ballonX;        // position en X du ballon
float ballonY;        // position en Y du ballon   
float anneauX;        // position en X de l'anneau
float anneauY;        // position en Y de l'anneau
float bond;           // la vitesse de saut du ballon
int i;                // compteur du score

// etat représente l'état du jeu: menu principal, ingame, game Over ou help
int etat;

// Les différents sons pour le game Over, le bond et le son lorsque l'anneau touche le ballon
SoundFile sonBooo;
SoundFile sonHop;
SoundFile sonHit;

// déclare des variables de type PFont
PFont fonte16;
PFont fonte12;

// déclare des variables de type PImage
PImage obstacle;
PImage ballon2;
PImage ballon3;
PImage ballon4;
PImage ballon5;
PImage ballon6;
PImage ballon7;
PImage ballon8;
PImage ballon;
PImage anneau;
PImage menu;
PImage aide;
PImage jeu;

void setup() 
{
  // taille de la fenêtre, 300 pixels en horizontal par 500 pixels en vertical
  size(300, 500);
  
  // charge les sons en mémoire 
  sonBooo = new SoundFile(this, "booo.mp3");  // son lorsqu'il y a game Over
  sonHop = new SoundFile(this, "hop.mp3");    // son des rebonds
  sonHit = new SoundFile(this, "hit.mp3");    // son lorsque le ballon touche l'anneau
  
  // crée les fontes
  fonte12 = createFont("joystix.ttf", 12);
  fonte16 = createFont("joystix.ttf", 16);
  
  // charge le skin de l'obstacle en mémoire, c'est un petit ballon blanc
  obstacle = loadImage("Obstacle.png");
  // charge les skins du ballon en mémoire
  ballon = loadImage("Ballon.png");
  ballon2 = loadImage("Ballon2.png");
  ballon3 = loadImage("Ballon3.png");
  ballon4 = loadImage("Ballon4.png");
  ballon5 = loadImage("Ballon5.png");
  ballon6 = loadImage("Ballon6.png");
  ballon7 = loadImage("Ballon7.png");
  ballon8 = loadImage("Ballon8.png");
  anneau = loadImage("Anneau.png");    // charge le skin de l'anneau
  menu = loadImage("Menu.png");        // charge le skin du fond du menu principal
  aide = loadImage("Aide.png");        // charge le skin de l'écran d'aide
  jeu = loadImage("Jeu.png");          // charge le fond de l'intérieur du jeu
  
  // initialisation des positions du ballon et de l'anneau
  init();
}

void draw() {
  // etat == 0 représente le menu principal
  if (etat == 0) {
    image(menu, 0, 0);      // image de fond Menu.png
    textFont(fonte16);      // choisit la fonte, ici taille 16
    fill(255);              // couleur de l'écriture: blanche pour le menu
    // on affiche sur le menu principal les commandes pour démarrer le jeu et l'aide
    text("> ESPACE < start", 45, 410); 
    text("> H < aide", 80, 440); 
  }
  
  // etat == 1 représente l'intérieur du jeu en marche (ingame)
  if (etat == 1) {
    updateDisplay();
  }
  
  // etat == 2 représente l'écran game Over
  if (etat == 2) {
  image(jeu,0,0);                 // image de fond Jeu.png
  text("Score: ", 110, 150);      // on remet le mot score en haut au centre
  text(i, 175, 150);              // on remet le chiffre du score à côté du mot score
  textFont(fonte16);              // le mot GAME OVER sera plus gros 
  fill(255, 0, 0);                // couleur rouge pour le mot GAME OVER
  text("GAME OVER", 80, 220);     
  textFont(fonte12);
  fill(38, 70, 122);              // couleur bleue pour les textes en dessous
  text("> ESPACE < pour recommencer", 10, 270);
  text("> m < pour retourner au menu", 10, 290); 
  text("> h < pour afficher l'aide", 10, 310); 
  }

  // etat == 3 représente l'écran d'aide
  if (etat == 3) {
    image(aide, 0, 0);            // image de fond Aide.png
    textFont(fonte16);            // les 4 "text" qui vont suivre seront plus gros
    fill(136, 66, 29);            // les textes en dessous sont en marron
    text("flappy dunk", 80, 35); 
    text("aide", 120, 60); 
    text("Règles du jeu:", 10, 100); 
    text("Commandes :", 10, 220); 
    
    textFont(fonte12);            // on repasse en 12 (la taille normale)
    fill(60);                     // gris pour le texte dessous 
    
    // textes sous la partie "règles du jeu"
    text("- touchez l'anneau pour", 20, 120); 
    text("marquer un point !", 20, 140);
    text("- évitez les ballons blancs!", 20, 160);
    text("- évitez les bords !", 20, 180);
    
    // textes sous la partie "commandes"
    text("touche > haut <", 20, 240); 
    text("- Faire rebondir le ballon", 20, 260);
    text("touche > h <", 20, 290);
    text("- Permet d'afficher l'aide", 20, 310);
    text("ou mettre en pause le jeu", 20, 330);
    text("Touche > espace <", 20, 360); 
    text("- Permet de recommencer", 20, 380);  
    text("> m < pour retourner au menu", 10, 420);
    text("> up < quitter l'aide", 10, 450); 
    
    fill(255);
    text("By David Ngo", 170, 486);
  }
}

void updateDisplay() {
  image(jeu, 0, 0);           // image de fond Jeu.png
  textFont(fonte12);          // choisit la fonte, ici taille 12
  fill(136, 66, 29);          // couleur de l'écriture du score en marron
  text("Score: ", 190, 44);   // le mot score sera affiché en haut à droite durant le jeu
  text(i, 260, 44);           // i est un compteur qui est variable car le score n'est pas fixe et c'est donc la valeur du i qui est affichée
  // met à jour les positions du ballon et des anneaux
  updatePositions();          // on appelle cette fonction pour l'affichage et le mouvement de la balle et pareil pour l'anneau
  obstacle();                 // l'obstacle est un petit ballon blanc qui défile à vitesse constante durant le jeu
    
  // condition "lorsque le ballon touche l'anneau" est vraie
  // donc si collisionAnneau() retourne true car la condition est respectée
  if (collisionAnneau()) {
    newAnneau();                            // on appelle la fonction hit pour générer un nouveau anneau
    sonHit.play();                          // joue le son hit.mp3
    acceleration = acceleration + (0.1);    // l'anneau accélère légérement à chaque fois que le ballon le touche
  }
      
  // condition "lorsque le ballon touche les bords ou lorsque le centre de l'anneau sort de la fenêtre" est vraie
  // donc si collisionBords() retourne true
  if (collisionBords()) {
    gameOver();                     // on appelle la fonction gameOver
    sonBooo.play();                 // on joue le son booo.mp3
  }
}

void keyPressed() {
  if (key == CODED) 
    if (keyCode == UP) {
      if (etat != 0) {     // condition empêchant la touche haut de démarrer le jeu dans le menu principal car on doit démarrer avec espace
        sonHop.play();     // son à chaque fois que la touche haut est appyé donc à chaque rebond
        etat=1;            // permet de retourner dans le jeu quand on est dans l'aide 
        // on fait rebondir la balle dans l'autre sens avec la même hauteur de saut
        bond = 4*(-1);     // 4 est la hauteur du saut et -1 car la balle part dans l'autre sens
      }
    }
   
    if (keyCode == ' ') {
      etat = 1;            // permet de démarrer le jeu dans le menu principal ou quand game over
      init();              // on initialise la position de l'anneau
      bond = 4*(-1);       // rebond permettant au ballon de ne pas tomber très (trop) vite dès le début
    }
     
    if (key == 'h' || key == 'H') {
      etat = 3;            // la touche h active l'écran d'aide
    }
     
    if (key == 'm' || key == 'M') {
      etat = 0;            // la touche m permet de retourner au menu principal
      init();              // au menu principal on réinitialise tout
    }
}

// initialisation du jeu
void init() {
  newAnneau();            // appelle la fonction qui va générer un nouveau anneau
  ballonX = width / 6;    // position d'origine en X (horizontal) du ballon, il sera à gauche
  ballonY = height / 2;   // position d'origine en Y (vertical) du ballon, il sera au centre
  acceleration = 2;       // vitesse de défilement de l'anneau d'origine
  i = 0;                  // le score est (re)mis à 0
  updatePositions();      // affichage des skins du ballon et de l'anneau et mouvements de ceux-ci
}

void updatePositions() {
  ballonY = ballonY + bond; // mouvement du ballon vers le bas car le ballon tombe si on appuie sur rien
  
  // affiche le skin du ballon en fonction du score, changement tous les 5 points, pour cela on utilise différentes conditions
  //  un nouveau skin tous les 5 points
  if (i <= 5) {
    image(ballon, ballonX -25, ballonY -25);
  }
  
  if (i > 5 && i <= 10) {
    image(ballon2, ballonX -25, ballonY -25);
  }
  
  if (i > 10 && i <= 15) {
    image(ballon3, ballonX -25, ballonY -25);
  }
  
  if (i > 15 && i <= 20) {
    image(ballon4, ballonX -25, ballonY -25);
  }
  
  if (i > 20 && i <= 25) {
    image(ballon5, ballonX -25, ballonY -25);
  }
  
  if (i > 25 && i <= 30) {
    image(ballon6, ballonX -25, ballonY -25);
  }
  
  if (i > 30 && i <= 35) {
    image(ballon7, ballonX -25, ballonY -25);
  }
  
  if (i > 35) {
    image(ballon8, ballonX -25, ballonY -25);
  }

  bond = bond + gravity;  // la gravité permet au ballon de tomber
  // skin de l'anneau de longueur 100 et de largeur 25 pixels
  image(anneau, anneauX, anneauY, 100, 25);
  // défilement de l'anneau de droite à gauche en décrémentant de 2 ( +(0.1) à chaque fois que l'anneau est touché par le ballon) 
  anneauX = anneauX - acceleration;
}

void obstacle() {
  image(obstacle, obstacleX, obstacleY);    // skin du petit ballon blanc qui représente l'obstacle
  obstacleX = obstacleX - 2;                // défilement de droite à gauche en décrémentant de 2
  
  if (obstacleX <= -50) {                   // si le ballon obstacle sort de la fenêtre
    obstacleX = 310;                        // le ballon revient à droite en dehors de la fenêtre puis défile à gauche
    obstacleY = random(100, 400);           // position aléatoire en Y (en vertical) du ballon obstacle entre 100 et 400 pixels
  }
  
  // si le ballon touche le ballon obstacle (quand leur postion se rejoignent) on affiche le gameO Over
  if (ballonY+25 >= obstacleY-12.5 && ballonY-25 <= obstacleY+12.5 && ballonX == obstacleX) {
    gameOver();
  }
}

boolean collisionBords() {
  //  lorsque le  ballon  touche  le  haut  ou  le  bas  de  la  fenêtre  
  //  ou lorsque le centre  de  l’anneau  touche  le  bord  gauche  de  la  fenêtre   
  if ((ballonY > height - 25 || ballonY < 25)||(anneauX <= -50)) {
    return true;   // si la condition est respectée alors on renvoie true (vraie)
  } 
  return false;    // si la condition n'est pas respectée alors on renvoie false (faux)
}

boolean collisionAnneau() {
  // le ballon touche l'anneau et rebondit (lorsque le bas du ballon touche le haut de l'anneau) et lorsque le haut du ballon touche le bas de l'anneau en Y
  // et lorsque la balle est entre anneauX et anneauX + 100 (entre l'avant et l'arrière de l'anneau sachant que la longueur de l'anneau est 100) en X  
  if (ballonY > anneauY - 25 && ballonY < anneauY + 50 && ballonX > anneauX && ballonX < anneauX + 100) {
    hit();            // on appelle fonction hit qui permet le rebond en cas de contact avec l'anneau
    i++;              // le score augmente de 1, i est un compteur
    return true;      // quand il y a collision du ballon avec l'anneau, on renvoie true
  }
  return false;       // s'il ne se passe rien, on renvoie false
}

void hit() {
  bond = 4*(-1);      // la balle rebondit sur l'anneau
}

void newAnneau() {
  //position de départ des anneaux
  anneauX = 310;                // on réinitialise l'anneau à droite en dehors de la fenêtre donc caché pendant son apparition
  anneauY = random(100, 400);   // position aléatoire en Y de l'anneau entre 100 et 400 pixels
}

void gameOver() {
  ballonY = 600;     // le ballon est en dehors de la fenêtre pour ne pas pouvoir le faire revenir dans le jeu pendant un game Over
  etat = 2;          // affiche l'écran game Over
}
