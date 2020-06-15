<?php

$connexion = mysqli_connect('localhost', 'root', '');
mysqli_set_charset($connexion, "utf8mb4");
// Choix d'une BDD
mysqli_select_db($connexion, 'oiseaudb') or die('Impossible de sélectionner la base de données oiseaudb'. mysqli_error($connexion));

?>