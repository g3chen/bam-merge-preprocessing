workflow test_location {
	call findTools
#	call findToolsWithoutUnload
}

task findTools {
	command <<<
#		ls -l $GATK_ROOT
#		module avail
		source ~/.bashrc
#		module avail
#		whereis gatk
#		module unload gatk
		module load gatk/3.6-0
		echo $GATK_ROOT
		ls -l /modules/gsi/modulator/sw/Ubuntu18.04/gatk-3.6-0
		ls -l $GATK_ROOT
#		module unload gatk
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

task findToolsWithoutUnload {
	command <<<
		echo "@@@@@@@@"
		whereis gatk
	>>>
	output{
                String message = read_string(stdout())
        }
	runtime {
		docker: "g3chen/bam-merge-preprocessing:4"
	}
}