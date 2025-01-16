proc hbEnergyPlot {selId {cutoff 3.9} {angleCutoff 30.0} {out stdout} } {
  global selInfo trajInfo userInfo_version anMD_version
  namespace import trajSelId::getFrame trajSelId::getDatX
  set epsilon 5.0
  set rmin 1.9
  getSelInfo $selId selTxt id frag frm frst lst stp upd ldstp selLbl des
  set selComp [atomselect $id $selTxt]
  set plots {}
  set l_xDat {}
  set l_yDat {}
  while {[trajSelId::iterate $selId log $out]} {
    animate goto [getFrame]
    $selComp frame [getFrame]
    lassign [measure hbonds $cutoff $angleCutoff $selComp] l_d l_a l_h
    set sum 0.0
    set distHAmin $cutoff
    foreach d $l_d a $l_a h $l_h {
      set seld [atomselect $id "index $d"]
      set sela [atomselect $id "index $a"]
      set selh [atomselect $id "index $h"]
      if {([$seld get carbon]) || ([$sela get carbon])} {continue}
      # distance hydorgen - acceptor
      set distHA [measure bond "$a $h"]
      if {$distHA <= $distHAmin} {set distHAmin $distHA; puts "distHAmin: $distHAmin"}
      if {$distHA < 1.6 } {continue}
      # HB energy (LJ 12-10 potential)
      set sum [expr {$sum + 4.0*$epsilon*((($rmin*1.2**-0.5)/$distHA)**12-(($rmin*1.2**-0.5)/$distHA)**10)}]
      $seld delete
      $sela delete
      $selh delete
      }
    puts "No. HB: [llength $l_d] frm: [getFrame] time: [getDatX] ns Energy = [format "%.3f" $sum] kcal/mol"
    lappend l_xDat [getDatX]
    lappend l_yDat $sum
    }
  $selComp delete
  lappend plots [list $l_xDat $l_yDat "$selLbl"]
  agrXY $plots "hbEnergyTraj" \
  title "Trajectory Hydrogen bond energy" \
  xLabel "Time (ns)" yLabel "Hydrogen bond energy (kcal/mol)" loSt $out
  }

