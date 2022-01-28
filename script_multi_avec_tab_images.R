#yyysans enlever les tabs du jeu de donn�es
#importer le jeu de donn�es
pictdata <- read.delim("C:/Users/clare/Desktop/R_GNSS/multi/pictdata_29042000 (1).txt")
t
#concatener date et heure
pictdata$DateTime=paste(pictdata$Date,pictdata$X)

#passer dans le format date heure
pictdata$DateTime=as.POSIXct(pictdata$DateTime , format = "%d:%m:%Y %H:%M:%S")

#mettre dans le bon fuseau horaire
pictdata$DateTime=pictdata$DateTime+3600

#renommer les colonnes
pictdata$Latitude=pictdata$GPS
pictdata$Longitude=pictdata$AEX

#choisir les bonnes colonnes
pictdata=subset(pictdata,select=c(8,9,25))

#enlever les lignes pour lesquelles il n'y a pas de coordonn�es (utile?)
#pictdata=subset(pictdata,Latitude!="N99:99.9999")

#r�cup�rer les noms des photos
Files=list.files(path="C:\\Users\\clare\\Desktop\\Donn�es_stage\\Nettoyage\\Culture")

#garder uniquement la date et l'heure et mettre au bon format
Files2=as.POSIXlt(Files, format="chassis_%Y-%m-%d_%H.%M.%S.jpg")

#Passer la date et heure au format chaine de caract�res
Files3=as.character.Date(Files2)
pictdata$DateTime2=as.character.Date(pictdata$DateTime)

#Chercher les lignes en commun
M=match(Files2,pictdata$DateTime2)
D=pictdata[M,]
D$nom_images=Files
#enlever les colonnes inutiles
D=subset(D,select=c(1,2,5))

#enregistrer le fichier csv cr��
write.csv2(D, file = "Coord_GNSS_images.csv", row.names = FALSE)