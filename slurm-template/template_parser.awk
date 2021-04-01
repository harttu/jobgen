{
	#sub(/#BATCH --mem=/,"#BATCH --mem=32G")
	#print
	if(/#SBATCH --mem=/) { print $0""mem  }
	else if(/#SBATCH -p/) { print $0" "gputype } 
	else if(/#SBATCH -t/) { print $0" "time }	
	else if(/#SBATCH -o logs/) { print "#SBATCH -o runs/"dir"/%j.out" }
	else if(/#SBATCH -e logs/) { print "#SBATCH -e runs/"dir"/%j.err" }
else { print $0 }
}

