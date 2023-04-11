{
 "cells": [
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "# Zero to Hero"
   ]
  },
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "# 1 Arranque rápido"
   ]
  },
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "En el capítulo 1 se hará un recorrido por las principales componentes del lenguaje R mínimos necesarios para resolver el problema de la asignatura, justificando las elecciones tomadas.\n",
    "<br>\n",
    "No es la idea de estos notebooks ser un manual del lenguaje R ni tampoco de los paquetes."
   ]
  },
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "## 1.01  Lectura del dataset"
   ]
  },
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "Trata sobre la motivacion de utilizar  data.table\n",
    "Simplemente se carga el dataset y se mide el tiempo que demora, el que es extremadamente alto e inexplicable."
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 16,
   "metadata": {
    "tags": []
   },
   "outputs": [
    {
     "ename": "NameError",
     "evalue": "name 'setwd' is not defined",
     "output_type": "error",
     "traceback": [
      "\u001b[1;31m---------------------------------------------------------------------------\u001b[0m",
      "\u001b[1;31mNameError\u001b[0m                                 Traceback (most recent call last)",
      "Cell \u001b[1;32mIn[16], line 1\u001b[0m\n\u001b[1;32m----> 1\u001b[0m setwd(\u001b[39m\"\u001b[39m\u001b[39mC:/Users/idott/LI/datasets\u001b[39m\u001b[39m\"\u001b[39m)  \u001b[39m#Establezco el Working Directory\u001b[39;00m\n",
      "\u001b[1;31mNameError\u001b[0m: name 'setwd' is not defined"
     ]
    }
   ],
   "source": [
    "setwd(\"C:/Users/idott/LI/datasets\")  #Establezco el Working Directory"
   ]
  },
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "Ahora vamos a cargar el dataframe como en R Base, tradicional, pero vamos a medir el tiempo\n",
    "para conocer la hora actual utilizo la fucion de R  Sys.time\n",
    "y para calcular la diferencia utilizo as.numeric(  t1 - t0, units = \"secs\")  convirtiéndolo a segundos"
   ]
  },
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "Primero veo que hace la funcion  Sys.time()"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {
    "tags": []
   },
   "outputs": [],
   "source": [
    "Sys.time()"
   ]
  },
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "devuelve fecha, hora  y huso horario  ( -03 para el caso de Argentina)\n",
    "<br>\n",
    "Leyendo la documentación  en  https://www.rdocumentation.org/packages/base/versions/3.6.2/topics/Sys.time    veo que la precisión es de 1/60 segundos,  lo cual para el tipo de medidas que tomaremos es más que suficiente."
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 17,
   "metadata": {
    "tags": []
   },
   "outputs": [
    {
     "ename": "SyntaxError",
     "evalue": "invalid syntax (3226475395.py, line 4)",
     "output_type": "error",
     "traceback": [
      "\u001b[1;36m  Cell \u001b[1;32mIn[17], line 4\u001b[1;36m\u001b[0m\n\u001b[1;33m    delta  <- as.numeric(  t1 - t0, units = \"secs\")  #calculo la diferencia de tiempos\u001b[0m\n\u001b[1;37m              ^\u001b[0m\n\u001b[1;31mSyntaxError\u001b[0m\u001b[1;31m:\u001b[0m invalid syntax\n"
     ]
    }
   ],
   "source": [
    "t0  <- Sys.time()\n",
    "dataset <- read.csv(\"./datasets/dataset_pequeno.csv\")\n",
    "t1  <- Sys.time()\n",
    "delta  <- as.numeric(  t1 - t0, units = \"secs\")  #calculo la diferencia de tiempos\n",
    "print( delta) #imprimo\n"
   ]
  },
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "#### la primer corrida da, en una antigua PC de escritorio con un hdd,  36.4 segundos !\n",
    "¿Qué tenebrosos cálculos estará haciendo para demorar 36.4 segundos?\n",
    "A lo sumo tiene que leer el archivo dos veces, para determinar si un campo es numerico o character."
   ]
  },
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "vuelvo a correr lo mismo, quizas hubo un problema de acceso al disco, y hasta quizas esta segunda vez el archivo ya esté en la memoria del sistema operativo"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {
    "tags": []
   },
   "outputs": [],
   "source": [
    "t0  <- Sys.time()\n",
    "dataset <- read.csv(\"./datasets/dataset_pequeno.csv\")\n",
    "t1  <- Sys.time()\n",
    "delta  <- as.numeric(  t1 - t0, units = \"secs\")  #calculo la diferencia de tiempos\n",
    "print(delta) #imprimo"
   ]
  },
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "### la segunda corrida da, en la  misma máquina,  30.4 segundos !"
   ]
  },
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "Se busca bibliografía sobre que alternativa hay al manejo de dataframes del R Base\n",
    "<br>\n",
    "Aparecen varias alternativas, benchmarks muestran la superioridad de data.table\n",
    "<br>\n",
    "Pasamos a probar la libreria  data.table a ver si los becnmarks están en lo cierto, o es solo marketing\n",
    "<br>\n",
    "Si no se tiene instalada la libreria,  instalarla primero con  **install.packages( \"data.table\", dependencies=TRUE )**"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {
    "tags": []
   },
   "outputs": [],
   "source": [
    "library( \"data.table\")   #cargo la libreria  data.table"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {
    "tags": []
   },
   "outputs": [],
   "source": [
    "t0  <- Sys.time()\n",
    "dataset <- fread(\"./datasets/dataset_pequeno.csv\")\n",
    "t1  <- Sys.time()\n",
    "delta  <- as.numeric(  t1 - t0, units = \"secs\")  #calculo la diferencia de tiempos\n",
    "print(delta) #imprimo"
   ]
  },
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "### la primer corrida da  0.79 segundos"
   ]
  },
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "Hagamos una segunda corrida"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {
    "tags": []
   },
   "outputs": [],
   "source": [
    "t0  <- Sys.time()\n",
    "dataset <- fread(\"./datasets/dataset_pequeno.csv\")\n",
    "t1  <- Sys.time()\n",
    "delta  <- as.numeric(  t1 - t0, units = \"secs\")  #calculo la diferencia de tiempos\n",
    "print(delta) #imprimo"
   ]
  },
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "# la segunda corrida da  1.18 segundos"
   ]
  },
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "Esta diferencia, calculada en forma muy burda (sin hacer varios experimentos)  es alrededor de 30.4 a 1.2\n",
    "<br>\n",
    "Ciertamente leer un dataset es una tarea que se hace unicamente al comienzo de los programas, pero se lee en la bibligrafía que data.table funciona más rápido para *todas* las operaciones sobre datasets, lo que se confirmará en los siguientes capítulos."
   ]
  },
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "Es una verdadera pena que los fans de tidyverse no exploren data.table, así como en Python que Pandas sea tan servilmente aceptada."
   ]
  }
 ],
 "metadata": {
  "kernelspec": {
   "display_name": "Python 3",
   "language": "python",
   "name": "python3"
  },
  "language_info": {
   "codemirror_mode": {
    "name": "ipython",
    "version": 3
   },
   "file_extension": ".py",
   "mimetype": "text/x-python",
   "name": "python",
   "nbconvert_exporter": "python",
   "pygments_lexer": "ipython3",
   "version": "3.11.2"
  }
 },
 "nbformat": 4,
 "nbformat_minor": 4
}
