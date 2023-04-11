#Arbol elemental con libreria  rpart
#Debe tener instaladas las librerias  data.table  ,  rpart  y  rpart.plot

#cargo las librerias que necesito
require("data.table")
require("rpart")
require("rpart.plot")

#Aqui se debe poner la carpeta de la materia de SU computadora local
setwd("C:/Users/idott/LI")  #Establezco el Working Directory

#cargo el dataset
dataset  <- fread("./datasets/dataset_pequeno.csv")
dataset
dtrain  <- dataset[ foto_mes==202107 ]  #defino donde voy a entrenar
dapply  <- dataset[ foto_mes==202109 ]  #defino donde voy a aplicar el modelo

# Define hyperparameter search space
cp_range <- seq(0, 0.1, by = 0.01)
minsplit_range <- seq(1, 5, by = 1)
minbucket_range <- seq(1, 5, by = 1)
maxdepth_range <- seq(1, 5, by = 1)
maxdepth_range
# Create grid of hyperparameters
hyperparameters <- expand.grid(cp = cp_range,
                               minsplit = minsplit_range,
                               minbucket = minbucket_range,
                               maxdepth = maxdepth_range)


# Initialize variables to store best hyperparameters and performance
best_hyperparameters <- NULL
best_performance <- -Inf

# Loop through all hyperparameter combinations
for (i in 1:nrow(hyperparameters)) {
  # Fit model with current hyperparameters
  modelo <- rpart(formula = "clase_ternaria ~ .",
                  data = dtrain,
                  xval = 0,
                  cp = hyperparameters$cp[i],
                  minsplit = hyperparameters$minsplit[i],
                  minbucket = hyperparameters$minbucket[i],
                  maxdepth = hyperparameters$maxdepth[i])
  
  # Evaluate model on test set
  prediccion <- predict(object = modelo,
                        newdata = dapply,
                        type = "prob")
  performance <- mean(prediccion == dapply$clase_ternaria)
  
  # Update best hyperparameters and performance
  if (performance > best_performance) {
    best_hyperparameters <- hyperparameters[i, ]
    best_performance <- performance
  }
}

# Fit final model with best hyperparameters
modelo <- rpart(formula = "clase_ternaria ~ .",
                data = dtrain,
                xval = 0,
                cp = best_hyperparameters$cp,
                minsplit = best_hyperparameters$minsplit,
                minbucket = best_hyperparameters$minbucket,
                maxdepth = best_hyperparameters$maxdepth)


# #genero el modelo,  aqui se construye el arbol
# modelo  <- rpart(formula=   "clase_ternaria ~ .",  #quiero predecir clase_ternaria a partir de el resto de las variables
#                  data=      dtrain,  #los datos donde voy a entrenar
#                  xval=      0,
#                  cp=       cp_range,   #esto signicfica no limitar la complejidad de los splits
#                  minsplit=  0,     #minima cantidad de registros para que se haga el split
#                  minbucket= 1,     #tamaño minimo de una hoja
#                  maxdepth=  3 )    #profundidad maxima del arbol


#grafico el arbol
prp(modelo, extra=101, digits=-5, branch=1, type=4, varlen=0, faclen=0)


#aplico el modelo a los datos nuevos
prediccion  <- predict( object= modelo,
                        newdata= dapply,
                        type = "prob")
prediccion
#prediccion es una matriz con TRES columnas, llamadas "BAJA+1", "BAJA+2"  y "CONTINUA"
#cada columna es el vector de probabilidades 

#agrego a dapply una columna nueva que es la probabilidad de BAJA+2
dapply[ , prob_baja2 := prediccion[, "BAJA+2"] ]

#solo le envio estimulo a los registros con probabilidad de BAJA+2 mayor  a  1/40
dapply[ , Predicted := as.numeric( prob_baja2 > 1/40 ) ]

#genero el archivo para Kaggle
#primero creo la carpeta donde va el experimento
dir.create( "./exp/" )
dir.create( "./exp/KA2001" )

fwrite( dapply[ , list(numero_de_cliente, Predicted) ], #solo los campos para Kaggle
        file= "./exp/KA2001/K101_001.csv",
        sep=  "," )

