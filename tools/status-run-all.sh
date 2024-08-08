#!/bin/bash
TZ="EST5EDT" date
percentDone () {
    nummasks=$(ls -l $d/$1 | wc -l)
    numimgs=$(ls -l $d/images | wc -l)
    pD=$(bc <<< "scale=2;(($nummasks - 1) / ($numimgs -1 ))*100")
}
calceta () {
    a1=$(stat $d/$1/$(ls -tr $d/$1 | head -n 1) | grep "Modify")
    a2=$(stat $d/$1/$(ls -t $d/$1 | head -n 1) | grep "Modify")
    remaining=$(bc <<< "scale=2;($(($(date --date "${a2:7:20}" +%s)-$(date --date "${a1:7:20}" +%s))) * ($numimgs -$nummasks)/ ($nummasks - 1))")
    eta=$(date -d@$remaining -u +%H:%M:%S)
    eta=$(TZ="EST5EDT" date --date="$remaining sec" +%r)
}
for d in $1/*/
do
    if [ ${d: -5} == 'logs/' ]; then
        continue
    fi
    a=0
    b=0
    c=0
    ceta=
    meta=
    seta=
    dn=skymask
    if [ -d $d/$dn/ ]; then
        percentDone $dn
        c=$pD
        if [[ $nummasks -gt 1 && $nummasks -lt $numimgs ]]; then
	          calceta $dn
	          #echo $dn $eta
	          ceta=$eta
	      fi
    fi
    dn=skyMasks
    if [ -d $d/$dn/ ]; then
        percentDone $dn
	      c=$pD
        if [[ $nummasks -gt 1 && $nummasks -lt $numimgs ]]; then
	          calceta $dn
	          #echo $dn $eta
	          ceta=$eta
	      fi
    fi
    dn=masks
    if [ -d $d/$dn/ ]; then
    	  percentDone $dn
	      a=$pD
	      if [[ $nummasks -gt 1 && $nummasks -lt $numimgs ]]; then
	          calceta $dn
	          #echo $dn $eta
            meta=$eta
	      fi
    fi
    dn=segmentations
    if [ -d $d/$dn/ ]; then
        percentDone $dn
	      b=$pD
	      if [[ $nummasks -gt 1 && $nummasks -lt $numimgs ]]; then
	          calceta $dn
	          #echo $dn $eta
	          seta=$eta
 	      fi
    fi
    echo $d skymask $c% $ceta masks $a% $meta segmentations $b% $seta
done
