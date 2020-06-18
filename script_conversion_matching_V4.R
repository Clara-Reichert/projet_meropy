
#choisir repertoire de travail
setwd("C:/Users/clare/Desktop/R_GNSS/multi")

#importer le jeu de données
pictdata <- read.delim("C:/Users/clare/Desktop/R_GNSS/multi/pictdata_29042000 (1).txt")

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

#enlever les lignes pour lesquelles il n'y a pas de coordonnées (utile?)
pictdata=subset(pictdata,Latitude!="N99:99.9999")

#Convertir les coordonées du format N45:12.1234 à 45.121234 
#pas encore pris en compte N/S ou E/O (!)
#pour la Latitude
########
L=character(length=0)
for ( i in 1:length(pictdata$Latitude)){
  A=as.character(pictdata[i,1])
  B1=substr(A,2,3)
  B2=substr(A,5,6)
  B3=substr(A,8,11)
  B4=paste(B2,B3, sep="")
  C=paste(B1,B4,sep=".")
  L[i]=as.numeric(C)
}
pictdata$Latitude=L
#######
#pour la longitude
L=character(length=0)
for ( i in 1:length(pictdata$Longitude)){
  A=as.character(pictdata[i,2])
  B1=substr(A,2,4)
  B2=substr(A,6,7)
  B3=substr(A,9,12)
  B4=paste(B2,B3, sep="")
  C=paste(B1,B4,sep=".")
  L[i]=as.numeric(C)
}
pictdata$Longitude=L
##########


#récupérer les noms des photos
Files=list.files(path="C:\\Users\\clare\\Desktop\\Données_stage\\Nettoyage\\Culture")

#garder uniquement la date et l'heure et mettre au bon format
Files2=as.POSIXlt(Files, format="chassis_%Y-%m-%d_%H.%M.%S.jpg")

#Passer la date et heure au format chaine de caractères (arriver pas à matcher autrement)
pictdata$DateTime2=as.character.Date(pictdata$DateTime)

#Chercher les lignes en commun
M=match(Files2,pictdata$DateTime2)

### construire le nouveau data frame
M2=as.data.frame(M)
M2$Latitude=pictdata[M,1]
M2$Longitude=pictdata[M,2]
M2$d_h=Files2
###

###############################
i=1
l=length(pictdata$DateTime)
for (i in 1:length(M)){
  if (is.na(M[i]==T)){
    heure=M2[i,4]
    print (heure)
    j=1
    T1=as.numeric(pictdata[1,3])
    T2=as.numeric(pictdata[l,3])              
    for (j in T1:T2){         #j est l'heure en secondes depuis le 1970-01-01
      H1=as.numeric(heure+1)
      H2=as.numeric(heure-1)
      if (H1==j+1 && H2==j-1 ){
        print("YES")
        ## l'horaire manquante est bien entouré à une seconde près de coordonnées, on peut faire la moyenne
        k=1
        for (k in 1:l) {
          
          if(as.numeric(pictdata[k+1,3])==as.numeric(heure+1) && as.numeric(pictdata[k,3])==as.numeric(heure-1)){ 
            print("Maybe")
            print(k)
            print(pictdata[k+1,3])
            print(pictdata[k,3])
            print(i)
            M2[i,2]=mean(c(as.numeric(pictdata[k-1,1]),as.numeric(pictdata[k+1,1])))
            M2[i,3]=mean(c(as.numeric(pictdata[k-1,2]),as.numeric(pictdata[k+1,2])))
            print(A)
            break
          }
        }
      }
    }
  }
}
###############################
M2$nom_images=Files
#enlever les colonnes inutiles
M2=subset(M2,select=c(2,3,5))

#enregistrer le fichier csv créé
write.csv2(D, file = "Coord_GNSS_images.csv", row.names = FALSE)