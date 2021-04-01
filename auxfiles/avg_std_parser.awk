#
# This file is part of JOBGEN package, it is dependent of the output ner.py
#


{
#	if( $15 ~ /[0-9]{2}:[0-9]{2}:[0-9]{2}/ ) {
#		sub(/X/,"0 0 0 0 0",$0)
#		print $0	
#
#	}
#	else {
	ekaRivi=$0
	ekaF=$15;
	getline;
	tokaRivi=$0
	tokaF=$15;
	getline;
	kolmasRivi=$0
	kolmasF=$15;
	keskiarvo=(ekaF+tokaF+kolmasF)/3;
        stdev = sqrt((1/2)*( (ekaF - keskiarvo)^2 + (tokaF - keskiarvo)^2 + (kolmasF - keskiarvo)^2 ))
	#print "R1."ekaRivi
	#print "R2."tokaRivi
	#print "R3. "kolmasRivi
	#print "1."ekaF
	#print "2."tokaF
	#print "3."kolmasF	
	#exit 1
	#print "keskiarvo:"keskiarvo
	sub(/X/, keskiarvo, ekaRivi)
	sub(/X/, stdev, ekaRivi)
	sub(/X/, keskiarvo, tokaRivi)
	sub(/X/, stdev, tokaRivi)
	sub(/X/, keskiarvo, kolmasRivi)
	sub(/X/, stdev, kolmasRivi)
	print ekaRivi
	print tokaRivi
	print kolmasRivi
#	}
}
