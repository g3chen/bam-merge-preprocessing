workflow test_location {
	call find_tools
}

task find_tools {
	command <<<
		ls -l $GATK_ROOT
#		module avail
#		source ~/.bashrc
#		module avail
#		whereis gatk
#		module unload gatk
#		module load gatk/3.6-0
#		whereis gatk
	>>>
	output{
		String message = read_string(stdout())
	}
	runtime {
#		docker: "g3chen/bam-merge-preprocessing:3"
		docker: "g3chen/bam-merge-preprocessing:4"
	}
}
