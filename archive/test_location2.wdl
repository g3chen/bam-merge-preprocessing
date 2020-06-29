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
        docker: "g3chen/bam-merge-preprocessing@sha256:e876e69fe23bf721c6ec61b88b1c808a3408520fb4d8cc539efcd6d61d4f0994"
    }
}
