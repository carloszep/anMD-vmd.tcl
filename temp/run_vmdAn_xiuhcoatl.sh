#!/bin/bash
# script for launching vmd analysis jobs in xiuhcoatl (using Slurm)

usage () {
  echo "usage: run_vmdAn_xiuhcoatl.sh <analysis_script.tcl> [<parentDir/workDir>] [<outDir>]"
  echo "example: run_vmdAn_xiuhcoatl.sh calc_intEnergy.tcl DHP_mPEG-PCL/micBr2s-s1 intEnergy"
  exit 0
  }

# check for arguments (at least one must be specified)
if [[ $1 == "" ]]; then usage; fi
if [ ! -f $1 ]; then usage; fi

# arg 1: name of the analysis script
scriptCalc=$1
name=${scriptCalc%.tcl}
workDir=${PWD}

# arg 2: working path for the scratch directory
if [[ ("$2" == "") || ("$2" == "auto") ]]; then
  workName="$( basename ${PWD} )/${name}"
else
  workName=$2
fi
scratchDir="/scratch/users/czgomez/vmdAn/${workName}"
if [ ! -d ${scratchDir} ]; then
  echo "creating scratch dir: $scratchDir"
  mkdir -p ${scratchDir}
fi

# arg 3: name of the output directory
if [[ ("$3" == "") || ("$3" == "auto") ]]; then
  outDir="${name}"
else
  outDir=$3
fi
if [ ! -d $outDir ]; then
  echo "creating outDir: $outDir"
  mkdir $outDir
fi

sbatch << EOF
#!/bin/bash

#SBATCH --job-name=${name}
#SBATCH --output=res.txt
#SBATCH --ntasks-per-node=1
#SBATCH --nodes=1
#SBATCH --partition=gpu_k40m
#SBATCH --mail-type=BEGIN,END
#SBATCH --mail-user=carloszepgc@gmail.com
#SBATCH --gres=gpu:1

mkdir admon;
env > ./admon/entorno.txt
export PATH=\$PATH:/home/apps/gpu/NAMD_2.14_Linux-x86_64-multicore-CUDA/
export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:/home/apps/gpu/NAMD_2.14_Linux-x86_64-multicore-CUDA/lib


# copying config files
cp ${workDir}/*.tcl $scratchDir

cd $scratchDir

/home/czgomez/software/vmd/inst/bin/vmd -dispdev text -e $scriptCalc > job-log_$name.txt
#vmd -dispdev text -e $scriptCalc > job-log_$name.txt

#cp -r $scratchDir/*.txt $scratchDir/*.dat $scratchDir/*.log $scratchDir/*.csv $scratchDir/*.tsv $scratchDir/*.agr $scratchDir/*.dcd $scratchDir/*.coor $scratchDir/*.pdb $workDir/$outDir
cp -r $scratchDir/* $workDir/${outDir}/
rm -r $scratchDir/*

echo Termina de Ejecuentar a las: ;
rm -f mpd.hosts
exit 0

EOF

