#!/bin/bash

usage () {
  echo "usage: run_vmdAn_xiuhcoatl.sh <analysis_script.tcl> <parentDir/workDir> <outDir>"
  echo "example: run_vmdAn_xiuhcoatl.sh calc_intEnergy.tcl DHP_mPEG-PCL/micBr2s-s1 intEnergy"
  exit 0
  }

if [[ $1 == "" ]]; then usage; fi
if [ ! -f $1 ]; then usage; fi
if [[ $2 == "" ]]; then usage; fi
if [[ $3 == "" ]]; then usage; fi

a=$1

qsub << EOF

# Las sentecnias que inician con: "#PBS"
# son comandos para el sistema de colas PBS.

## Es necesario editar este script, cambiando <nodes= # de nodos requeridos>,
## P.E. si se requieren 48 core entonecs nodes=4 ... etc. 
## Se debe dejar ppn=12 que son los cores por nodo existentes,
## Editar los Nombres de los archivos de salida
## Editar el Nombre de la tarea y <ejecutable>.
## La cantidad de memoria requerida no mayor a 22GB.
## Mantener el archivo de la lista de nodos.

## Para correr una tarea con el PBS hay que ejecutar
## qsub <nombre del script>

### Nombre de la tarea
#PBS -N ${a%.tcl}


###Opciones de ejecucion
#PBS -l nodes=1:ppn=1

### Nombre de la cola
#PBS -q CI
#PBS -e error_vmdAn.txt
#PBS -o output_vmdAn.txt


### Comandos para la ejecucion de la tarea



# source /opt/gpu/cudavars.sh 6.5;


#export PATH=\$PATH:/usr/local/NAMD-2.12/;

#export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:/usr/local/NAMD-2.12/;


##Levantando el entorno

cd  \$PBS_O_WORKDIR;



# Determina el numero de procesadores para ejecutar la tarea
NP=\$((\$PBS_NUM_NODES * \$PBS_NUM_PPN))

## Ejecutar la tarea en todos los procesadores asignados con MPI
cat \$PBS_NODEFILE |sort|uniq> mpd.hosts

NM=\$(cat mpd.hosts|wc -l |awk '{print \$1}')





###Creacion del direactorio de admministracion
mkdir \$PBS_O_WORKDIR/admon-\$PBS_JOBID;

cat mpd.hosts > \$PBS_O_WORKDIR/admon-\$PBS_JOBID/lista-nodos-\$PBS_JOBID.txt
env      > \$PBS_O_WORKDIR/admon-\$PBS_JOBID/entorno-\$PBS_JOBNAME.txt;



scriptCalc=$1
workName=$2
outDir=$3
name=\${scriptCalc%.tcl}
workDir=\$PWD
scratchDir=/scratch/user/czgomez/anMD/\$workName/\$name
echo "scratchDir: \$scratchDir"

# create directory if it does not exist
if [ ! -d \${scratchDir} ]; then
  echo "creating \${scratchDir}"
  mkdir -p \${scratchDir}
fi

if [ ! -d \$outDir ]; then
  echo "creating outDir \$outDir"
  mkdir \$outDir
fi

# copying config files
cp \${workDir}/*.tcl toppar/ \$scratchDir

cd \$scratchDir

/home/czgomez/software/vmd/inst/bin/vmd -e \$scriptCalc > job-log_\$name.txt

cp -r \$scratchDir/*.txt \$scratchDir/*.dat \$scratchDir/*.log \$scratchDir/*.csv \$scratchDir/*.tsv \$scratchDir/*.agr \$workDir/\$outDir
rm -r \$scratchDir/*
#cp -r \$scratchDir/* \$workDir/\$outDir

echo Termina de Ejecuentar a las: ;
rm -f mpd.hosts
exit 0

EOF

