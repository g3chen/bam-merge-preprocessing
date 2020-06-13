workflow test_location {
	call find_tools
}

task find_tools {
	command {
		whereis samtools
		whereis htsfile
		whereis gatk
		whereis java
		whereis R
		whereis python
                echo "@@@@@@@@@@@@@@@@"
		echo $MANPATH
		echo "@@@@@@@@@@@@@@@@"
		echo $PKG_CONFIG_PATH
		echo "@@@@@@@@@@@@@@@@"
		echo $PYTHONPATH
                echo "@@@@@@@@@@@@@@@@"
		echo $GATK_ROOT
                echo "@@@@@@@@@@@@@@@@"
		echo $PATH
                echo "@@@@@@@@@@@@@@@@"
		echo $LD_LIBRARY_PATH
		echo "@@@@@@@@@@@@@@@@"
		echo $R_LIBS_SITE
	}
	output{
		String message = read_string(stdout())
	}
	runtime {
#		docker: "g3chen/bam-merge-preprocessing:3"
		docker: "g3chen/bam-merge-preprocessing:4"
	}
}
