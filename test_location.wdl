workflow test_location {
	call find_tools
}

task find_tools {
	command {
		ls $SAMTOOLS_ROOT
		echo "@@@@@@@@@@@@@@@@"
		ls $HTSLIB_ROOT
		echo "@@@@@@@@@@@@@@@@"
		ls $JAVA_ROOT
		echo "@@@@@@@@@@@@@@@@"
		ls $RSTATS_ROOT
		echo "@@@@@@@@@@@@@@@@"
		ls $PYTHON_ROOT
		echo "@@@@@@@@@@@@@@@@"
		ls $GATK_ROOT
		echo "@@@@@@@@@@@@@@@@"

		echo $PATH
		echo "@@@@@@@@@@@@@@@@"
		echo $MANPATH
		echo "@@@@@@@@@@@@@@@@"
		echo $PKG_CONFIG_PATH
		echo "@@@@@@@@@@@@@@@@"
		echo $PYTHONPATH
		echo "@@@@@@@@@@@@@@@@"
		echo $LD_LIBRARY_PATH
		echo "@@@@@@@@@@@@@@@@"
		echo $R_LIBS_SITE
		echo "@@@@@@@@@@@@@@@@"

	}
	output{
		String message = read_string(stdout())
	}
	runtime {
		docker: "g3chen/bam-merge-preprocessing@sha256:e177ba2ab30bf93a936e52839ea4747e8d3ad6dffcf5f7435e4e22ae240d8956"
		modules: "samtools/1.9 gatk/3.6-0 python/3.7"
	}
}
