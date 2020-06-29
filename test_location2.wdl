workflow test_location {
    call find_tools
}

task find_tools {
    command <<<
        ls -l /data/HG19_ROOT/hg19_random.fa
        echo "@@@@@@@@@@@@@"
        ls -l /data/HG19_DBSNP_LEFTALIGNED_ROOT/dbsnp_138.hg19.leftAligned.vcf.gz
        echo "@@@@@@@@@@@@@"
    >>>
    output{
        String message = read_string(stdout())
    }
    runtime {
        docker: "g3chen/bam-merge-preprocessing@sha256:e177ba2ab30bf93a936e52839ea4747e8d3ad6dffcf5f7435e4e22ae240d8956"
    }
}
