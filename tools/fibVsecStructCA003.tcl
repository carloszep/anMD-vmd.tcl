#|-fibVsecStructCA.tcl :
#|  -script for updating the structure field of all CA atoms in the structure
#|   _ bao2i.psf for the current frame ;
#|  -version :-0.0.3 ;
#|  -author :-Carlos Z. Gómez Castro ;
#|  -date :-2018-01-29.Thu ;
#|  -version information :
#|    -avoid writting in disk the coordinates of the tmpTrimer .
#|    -still pending to improve or to incorporate this script into anMD ;
#|    -finished version ;
#|  -global variables :
#|    -fibVMolId :-molId of the bao2i-* simulation ;;
#|  -notes :
#|    -this script is called by anMD-v.0.5.9 or later .
#|    -this procedure fragments the full fibril in small pieces to obtain the
#|     _ secondary structure codes of the small pieces separately and complete
#|     _ the codes for the full fibril .
#|    -this is necessary because STRIDE cannot process the full fibril bao2i ;;

global fibVMolId fibVSaveTrimer fibVTmpTrimerId fibVTmpTrimerSel

# user-defined parameters
set fibLayers [list A B]
set nStrandsPl 94   ;# strands per layer (expected to be greater than 10)
#set fibVMolId 0   ;# uncomment if no global declaration is used

if {$fibVSaveTrimer} {
# first save a temporal trimer to create a new molecule containing the structure
# NOTE: the segids will not change even loading coordinates from other segids
  set trimer0 [atomselect $fibVMolId "protein and segid A01 to A03"]
  $trimer0 writepsf "tmpTrimer.psf"
  $trimer0 writepdb "tmpTrimer.pdb"
  set fibVTmpTrimerId [mol new "tmpTrimer.psf"]
  mol addfile "tmpTrimer.pdb" molid $fibVTmpTrimerId waitfor all
  set fibVTmpTrimerSel [atomselect $fibVTmpTrimerId "all"]
  $trimer0 delete
  set fibVSaveTrimer 0
  }


# run over each fibril strand
foreach lay $fibLayers {
  for {set str 1} {$str <= $nStrandsPl} {incr str} {
    if {$str == 1} {
      set iCut 1
      set nCut 3
      set segCut 1
      set segTmp 1
    } elseif {$str == $nStrandsPl} {
      set iCut [expr $str - 2]
      set nCut $str
      set segCut $str
      set segTmp 3
    } else {
      set iCut [expr $str - 1]
      set nCut [expr $str + 1]
      set segCut $str
      set segTmp 2
      }   ;# this selects the neighbor strands
    if {$iCut < 10} {set iCut 0$iCut}
    if {$nCut < 10} {set nCut 0$nCut}
    if {$segCut < 10} {set segCut 0$segCut}
    set fibTrimer [atomselect $fibVMolId \
                   "protein and segid $lay$iCut to $lay$nCut"]
    $fibVTmpTrimerSel set {x y z} [$fibTrimer get {x y z}]
    mol ssrecalc $fibVTmpTrimerId   ;#secondary strucute only for the trimer
    set fibStrand [atomselect $fibVMolId \
                   "protein and segid $lay$segCut and name CA"]
    set trimerStrand [atomselect $fibVTmpTrimerId \
                      "protein and segid A0$segTmp and name CA"]
    $fibStrand set structure [$trimerStrand get structure]   ;# fib strand ss
    $fibStrand delete
    $trimerStrand delete
    $fibTrimer delete
    }
  }


