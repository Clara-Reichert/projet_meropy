<?php

//Camembert.php

// Les données sont transmises via l'url du fichier.

// Inclusion des bibliothèques jpgraph
require_once ('..\jpgraph-4.2.6\src\jpgraph.php');
require_once ('..\jpgraph-4.2.6\src\jpgraph_pie.php');
require_once ('..\jpgraph-4.2.6\src\jpgraph_pie3d.php');


// Connexion à la base de données
//include("connexion_BDD.php");
$connexion = mysqli_connect('localhost', 'root', '');
mysqli_select_db($connexion, 'oiseaudb');

// Récupération des données transmises à la page PHP par la méthode GET
$id_obsv=$_GET["id_obsv"];
$id_dpt=$_GET["id_dpt"];

// requête pour connaitre le nom de l'observateur à partir de son identifiant
$req="SELECT nom_observateur
	FROM observateurs 
	WHERE observateurs.id_observateur = $id_obsv";
// Exécution de la requête
$rs=mysqli_query($connexion,$req);
$row = mysqli_fetch_array($rs);
$nom_observateur = $row["nom_observateur"];

// requête pour connaitre le nom du département à partir de son identifiant
$req="SELECT nom_dpt
	FROM Departements 
	WHERE Departements.id_dpt = $id_dpt";
// Exécution de la requête
$rs=mysqli_query($connexion,$req);
$row = mysqli_fetch_array($rs);
$nom_dpt = $row["nom_dpt"];


// création de la requete permettant de connaitre les observations et les observateurs
$req="SELECT oiseaux.nom_commun, Sum(Observations.nombre) AS 'quantite' 
		FROM Communes, oiseaux, Observations
		WHERE oiseaux.id_oiseau = Observations.id_oiseau
		AND Communes.id_commune = Observations.id_commune
		AND Communes.id_dpt = $id_dpt
		AND Observations.id_observateur = $id_obsv
		GROUP BY oiseaux.nom_commun";

// Exécution de la requête
$rs_observ=mysqli_query($connexion,$req) or die('Échec de la requête : ' . mysqli_error($connexion));

//odbc_result_all($rs_observ);

$i=0;
while ($row=mysqli_fetch_array($rs_observ))
{
	$histo[$i] = $row["quantite"];
	$nom_oiseau[$i] = $row["nom_commun"];
	
	$i = $i + 1;
}



// Initialisation du graphique
$largeur = 600;
$hauteur = 300;
$graphe = new PieGraph($largeur, $hauteur);

// Creation du camembert
$camembert = new PiePlot($histo);

// légende
$camembert->SetLegends($nom_oiseau);

// Ajout du camembert au graphique
$graphe->add($camembert);

// Ajout du titre du graphique
$graphe->title->set("Répartition des observations d'oiseaux\n de ".$nom_observateur." dans le département ".$id_dpt." (".$nom_dpt.")");

// Affichage du graphique
$graphe->stroke();

?>

