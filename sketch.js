// Variables globales
let gravity = 0.2;
let acceleration, bond;
let obstacleX, obstacleY, ballonX, ballonY, anneauX, anneauY;
let score = 0;
let gameState = 0; // 0:menu, 1:jeu, 2:gameover, 3:aide

// Assets
let sounds = {};
let images = {};
let fonts = {};
let ballonSkins = [];

function preload() {
  // Chargement des sons
  sounds.booo = loadSound('assets/booo.mp3');
  sounds.hop = loadSound('assets/hop.mp3');
  sounds.hit = loadSound('assets/hit.mp3');

  // Chargement des images
  images.obstacle = loadImage('assets/Obstacle.png');
  images.anneau = loadImage('assets/Anneau.png');
  images.menu = loadImage('assets/Menu.png');
  images.aide = loadImage('assets/Aide.png');
  images.jeu = loadImage('assets/Jeu.png');

  // Chargement des skins de ballon
  for (let i = 1; i <= 8; i++) {
    ballonSkins.push(loadImage(`assets/Ballon${i}.png`));
  }

  // Chargement des polices
  fonts.f12 = loadFont('assets/joystix.ttf');
  fonts.f16 = loadFont('assets/joystix.ttf');
}

function setup() {
  createCanvas(300, 500);
  initGame();
}

function draw() {
  switch(gameState) {
    case 0: drawMenu(); break;
    case 1: updateGame(); break;
    case 2: drawGameOver(); break;
    case 3: drawHelp(); break;
  }
}

function initGame() {
  resetAnneau();
  ballonX = width / 6;
  ballonY = height / 2;
  acceleration = 2;
  score = 0;
  obstacleX = 310;
  obstacleY = random(100, 400);
}

function resetAnneau() {
  anneauX = 310;
  anneauY = random(100, 400);
}

function drawMenu() {
  image(images.menu, 0, 0);
  textFont(fonts.f16);
  fill(255);
  text("> ESPACE < start", 45, 410); 
  text("> H < aide", 80, 440);
}

function updateGame() {
  image(images.jeu, 0, 0);
  
  // Affichage du score
  textFont(fonts.f12);
  fill(136, 66, 29);
  text("Score: ", 190, 44);
  text(score, 260, 44);

  // Mise à jour des positions
  updatePositions();
  moveObstacle();
  
  // Détection des collisions
  if (checkAnneauCollision()) {
    sounds.hit.play();
    acceleration += 0.1;
    score++;
    resetAnneau();
  }
  
  if (checkBorderCollision()) {
    gameOver();
    sounds.booo.play();
  }
}

function updatePositions() {
  // Mouvement du ballon
  ballonY += bond;
  bond += gravity;
  
  // Affichage du ballon (skin dépendant du score)
  let skinIndex = min(floor(score / 5), 7);
  image(ballonSkins[skinIndex], ballonX - 25, ballonY - 25);
  
  // Mouvement de l'anneau
  image(images.anneau, anneauX, anneauY, 100, 25);
  anneauX -= acceleration;
}

function moveObstacle() {
  image(images.obstacle, obstacleX, obstacleY);
  obstacleX -= 2;
  
  if (obstacleX <= -50) {
    obstacleX = 310;
    obstacleY = random(100, 400);
  }
  
  if (abs(ballonX - obstacleX) < 25 && abs(ballonY - obstacleY) < 25) {
    gameOver();
  }
}

function checkBorderCollision() {
  return (ballonY > height - 25 || ballonY < 25 || anneauX <= -50);
}

function checkAnneauCollision() {
  const collidesX = ballonX > anneauX && ballonX < anneauX + 100;
  const collidesY = ballonY > anneauY - 25 && ballonY < anneauY + 50;
  
  if (collidesX && collidesY) {
    bond = -4;
    return true;
  }
  return false;
}

function gameOver() {
  gameState = 2;
  ballonY = 600; // Sort le ballon de l'écran
}

function drawGameOver() {
  image(images.jeu, 0, 0);
  text("Score: ", 110, 150);
  text(score, 175, 150);
  
  textFont(fonts.f16);
  fill(255, 0, 0);
  text("GAME OVER", 80, 220);
  
  textFont(fonts.f12);
  fill(38, 70, 122);
  text("> ESPACE < pour recommencer", 10, 270);
  text("> m < pour retourner au menu", 10, 290);
  text("> h < pour afficher l'aide", 10, 310);
}

function drawHelp() {
  image(images.aide, 0, 0);
  
  textFont(fonts.f16);
  fill(136, 66, 29);
  text("flappy dunk", 80, 35);
  text("aide", 120, 60);
  text("Règles du jeu:", 10, 100);
  text("Commandes :", 10, 220);
  
  textFont(fonts.f12);
  fill(60);
  text("- touchez l'anneau pour", 20, 120);
  text("marquer un point !", 20, 140);
  text("- évitez les ballons blancs!", 20, 160);
  text("- évitez les bords !", 20, 180);
  
  text("touche > haut <", 20, 240);
  text("- Faire rebondir le ballon", 20, 260);
  text("touche > h <", 20, 290);
  text("- Aide/Pause", 20, 310);
  text("Touche > espace <", 20, 360);
  text("- Recommencer", 20, 380);
  text("> m < menu", 10, 420);
  text("> up < quitter l'aide", 10, 450);
  
  fill(255);
  text("By David Ngo", 170, 486);
}

function keyPressed() {
  if (keyCode === UP_ARROW && gameState !== 0) {
    sounds.hop.play();
    bond = -4;
  }
  
  if (keyCode === 32) { // ESPACE
    if (gameState === 0 || gameState === 2) {
      gameState = 1;
      initGame();
      bond = -4;
    }
  }
  
  if (key === 'h' || key === 'H') {
    gameState = gameState === 3 ? 1 : 3;
  }
  
  if (key === 'm' || key === 'M') {
    gameState = 0;
    initGame();
  }
  
  return false; // Empêche le comportement par défaut
}

// Support tactile mobile
function touchStarted() {
  if (gameState === 1) {
    sounds.hop.play();
    bond = -4;
  }
  return false;
}

// David Ngo 