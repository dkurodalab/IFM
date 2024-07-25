proc solvation_shell {name nwat} {
set n $nwat
set nfr [molinfo top get numframes]
set sel1 [atomselect top "resname WAT and name O"];
set sel2 [atomselect top "index 5"];
set file1 [open "$name.dat" a]
for {set i 0} {$i < $nfr} {incr i 1} {
$sel1 frame $i
$sel1 update
$sel2 frame $i
$sel2 update
set lists [measure contacts 9.65 $sel1 $sel2] 
set wlist [lindex $lists 0] 
set slist [lindex $lists 1]
foreach satom $slist watom $wlist {
set sel3 [atomselect top "index $watom" frame $i]
set wresnum [$sel3 get residue] 
set d [measure bond "$watom $satom" frame $i] 
lappend l1 [list $wresnum $d]
$sel3 delete
} 
set l2 [lrange [lsort -index 1 [lsort -unique -index 0 [lsort -index 1 -decreasing $l1]]] 0 [expr $n - 1]] 
foreach water $l2 { 
lappend l3 "[lindex $water 0]" 
}
puts $l2
set sel_write [atomselect top "resname ACE NME or same residue as residue $l3" frame $i]
$sel_write frame $i
$sel_write update
$sel_write writexyz $i.xyz
$sel_write delete

puts $file1 "$l2"
unset l1 l2 l3 lists wlist slist d  
clear
}
flush $file1
close $file1
}
