set systemTime [clock seconds]
set usb [lindex [get_hardware_names] 0]
set device_name [lindex [get_device_names -hardware_name $usb] 0]
puts "*************************"
puts "programming cable:"
puts $usb

#IR scan codes:  001 -> set minutes
#                010 -> set hours

proc push {value {cmd}} {
global device_name usb
open_device -device_name $device_name -hardware_name $usb

set push_value [int2bits $value]

set diff [expr {32 - [string length $push_value]%32}]

if {$diff != 32} {
set push_value [format %0${diff}d$push_value 0] }

puts $push_value

device_lock -timeout 10
device_virtual_ir_shift -instance_index 0 -ir_value $cmd -no_captured_ir_value
device_virtual_dr_shift -instance_index 0 -dr_value $push_value -length 32 -no_captured_dr_value
device_unlock
close_device
}

proc int2bits {i} {    
set res ""
while {$i>0} {
set res [expr {$i%2}]$res
set i [expr {$i/2}]}
if {$res==""} {set res 0}
return $res
}

proc bin2hex bin {
## No sanity checking is done
array set t {
0000 0 0001 1 0010 2 0011 3 0100 4
0101 5 0110 6 0111 7 1000 8 1001 9
1010 a 1011 b 1100 c 1101 d 1110 e 1111 f
}
set diff [expr {4-[string length $bin]%4}]
if {$diff != 4} {
set bin [format %0${diff}d$bin 0] }
regsub -all .... $bin {$t(&)} hex
return [subst $hex]
}

puts "Writing time:"
set m [clock seconds]
set m [expr $m*1]
puts "$m"
push $m 0
puts "Done!"

puts "Writing alarm 1 time:"
set m [clock seconds]
set m [expr $m+5]
puts "$m"
push $m 1
puts "Done!"

puts "Writing alarm 2 time:"
set m [clock seconds]
set m [expr $m+10]
puts "$m"
push $m 3
puts "Done!"


puts "Writing alarm 3 time:"
set m [clock seconds]
set m [expr $m+15]
puts "$m"
push $m 5
puts "Done!"

puts "Writing alarm 4 time:"
set m [clock seconds]
set m [expr $m+20]
puts "$m"
push $m 7
puts "Done!"

puts "Writing alarm 5 time:"
set m [clock seconds]
set m [expr $m+25]
puts "$m"
push $m 9
puts "Done!"

puts "Writing alarm 6 time:"
set m [clock seconds]
set m [expr $m+30]
puts "$m"
push $m 11
puts "Done!"

puts "Writing alarm 7 time:"
set m [clock seconds]
set m [expr $m+35]
puts "$m"
push $m 13
puts "Done!"
