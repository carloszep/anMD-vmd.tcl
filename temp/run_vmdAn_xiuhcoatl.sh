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

sbatch << EOF
#!/bin/bash

#SBATCH --job-name=${1%.tcl}
#SBATCH --output=res.txt
#SBATCH --ntasks-per-node=1
#SBATCH --nodes=1
#SBATCH --partition=gpu_k80
#SBATCH --mail-type=BEGIN,END
#SBATCH --mail-user=carloszep@gmail.com
#SBATCH --gres=gpu:1

mkdir admon;
env > ./admon/entorno.txt
export PATH=\$PATH:/home/apps/gpu/NAMD_2.14_Linux-x86_64-multicore-CUDA/
export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:/home/apps/gpu/NAMD_2.14_Linux-x86_64-multicore-CUDA/lib



scriptCalc=$1
workName=$2
outDir=$3
name=\${scriptCalc%.tcl}
workDir=\$PWD
scratchDir=/scratch/users/czgomez/anMD/\$workName/\$name
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
#vmd -e \$scriptCalc > job-log_\$name.txt

cp -r \$scratchDir/*.txt \$scratchDir/*.dat \$scratchDir/*.log \$scratchDir/*.csv \$scratchDir/*.tsv \$scratchDir/*.agr \$scratchDir/*.dcd \$scratchDir/*.coor \$scratchDir/*.pdb \$workDir/\$outDir
#rm -r \$scratchDir/*
#cp -r \$scratchDir/* \$workDir/\$outDir

echo Termina de Ejecuentar a las: ;
rm -f mpd.hosts
exit 0

EOF

