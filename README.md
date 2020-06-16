# bamMergePreprocessing

WDL workflow to filter, merge, mark duplicates, indel realign and base quality score recalibrate groups of related (e.g. by library, donor, project) lane level alignments.

## Overview

## Dependencies

* [samtools 1.9](http://www.htslib.org/)
* [gatk 4.1.6.0](https://gatk.broadinstitute.org)
* [gatk 3.6-0](https://gatk.broadinstitute.org)
* [python 3.7](https://www.python.org)


## Usage

### Dockstore
Make a runtime JSON template and fill in desired inputs, outputs, and other parameters
```
dockstore workflow convert entry2json --entry github.com/g3chen/bam-merge-preprocessing/BamMergePreprocessing:master > Dockstore.json   
vim Dockstore.json
```
Run locally with the Dockstore CLI
```
dockstore workflow launch --entry github.com/g3chen/bam-merge-preprocessing/BamMergePreprocessing:master --json Dockstore.json
```

### Cromwell
```
java -jar cromwell.jar run bamMergePreprocessing.wdl --inputs inputs.json
```

### Inputs

#### Required workflow parameters:
Parameter|Value|Description
---|---|---
`inputGroups`|Array[InputGroup]|Array of objects describing sets of bams to merge together and the merged file name. These merged bams will be cocleaned together and output separately (by merged name).
`intervalsToParallelizeByString`|String|Comma separated list of intervals to split by (e.g. chr1,chr2,chr3+chr4).
`reference`|String|Path to reference file.
`realignerTargetCreator.knownIndels`|Array[String]|Array of input VCF files with known indels.
`indelRealign.knownAlleles`|Array[String]|Array of input VCF files with known indels.
`baseQualityScoreRecalibration.knownSites`|Array[String]|Array of VCF with known polymorphic sites used to exclude regions around known polymorphisms from analysis.


#### Optional workflow parameters:
Parameter|Value|Default|Description
---|---|---|---
`doFilter`|Boolean|true|Enable/disable Samtools filtering.
`doMarkDuplicates`|Boolean|true|Enable/disable GATK4 MarkDuplicates.
`doSplitNCigarReads`|Boolean|false|Enable/disable GATK4 SplitNCigarReads.
`doIndelRealignment`|Boolean|true|Enable/disable GATK3 RealignerTargetCreator + IndelRealigner.
`doBqsr`|Boolean|true|Enable/disable GATK4 BQSR.
`preprocessingBamRuntimeAttributes`|Array[RuntimeAttributes]|[]|Interval specific runtime attributes to use as overrides for the defaults.


#### Optional task parameters:
Parameter|Value|Default|Description
---|---|---|---
`splitStringToArray.lineSeparator`|String|","|Interval group separator - these are the intervals to split by.
`splitStringToArray.recordSeparator`|String|"+"|Interval interval group separator - this can be used to combine multiple intervals into one group.
`splitStringToArray.jobMemory`|Int|1|Memory allocated to job (in GB).
`splitStringToArray.cores`|Int|1|The number of cores to allocate to the job.
`splitStringToArray.timeout`|Int|1|Maximum amount of time (in hours) the task can run for.
`splitStringToArray.modules`|String|"python/3.7"|Environment module name and version to load (space separated) before command execution.
`preprocessBam.temporaryWorkingDir`|String|""|Where to write out intermediary bam files. Only the final preprocessed bam will be written to task working directory if this is set to local tmp.
`preprocessBam.filterSuffix`|String|".filter"|Suffix to use for filtered bams.
`preprocessBam.filterFlags`|Int|260|Samtools filter flags to apply.
`preprocessBam.minMapQuality`|Int?|None|Samtools minimum mapping quality filter to apply.
`preprocessBam.filterAdditionalParams`|String?|None|Additional parameters to pass to samtools.
`preprocessBam.markDuplicatesSuffix`|String|".deduped"|Suffix to use for duplicate marked bams.
`preprocessBam.removeDuplicates`|Boolean|false|MarkDuplicates remove duplicates?
`preprocessBam.opticalDuplicatePixelDistance`|Int|100|MarkDuplicates optical distance.
`preprocessBam.markDuplicatesAdditionalParams`|String?|None|Additional parameters to pass to GATK MarkDuplicates.
`preprocessBam.splitNCigarReadsSuffix`|String|".split"|Suffix to use for SplitNCigarReads bams.
`preprocessBam.refactorCigarString`|Boolean|false|SplitNCigarReads refactor cigar string?
`preprocessBam.readFilters`|Array[String]|[]|SplitNCigarReads read filters
`preprocessBam.splitNCigarReadsAdditionalParams`|String?|None|Additional parameters to pass to GATK SplitNCigarReads.
`preprocessBam.defaultRuntimeAttributes`|DefaultRuntimeAttributes|{"memory": 24, "overhead": 6, "cores": 1, "timeout": 6, "modules": "samtools/1.9 gatk/4.1.6.0"}|Default runtime attributes (memory in GB, overhead in GB, cores in cpu count, timeout in hours, modules are environment modules to load before the task executes).
`realignerTargetCreator.downsamplingType`|String?|None|Type of read downsampling to employ at a given locus (NONE|ALL_READS|BY_SAMPLE).
`realignerTargetCreator.additionalParams`|String?|None|Additional parameters to pass to GATK RealignerTargetCreator.
`realignerTargetCreator.jobMemory`|Int|24|Memory allocated to job (in GB).
`realignerTargetCreator.overhead`|Int|6|Java overhead memory (in GB). jobMemory - overhead == java Xmx/heap memory.
`realignerTargetCreator.cores`|Int|1|The number of cores to allocate to the job.
`realignerTargetCreator.timeout`|Int|6|Maximum amount of time (in hours) the task can run for.
`realignerTargetCreator.modules`|String|"gatk/3.6-0"|Environment module name and version to load (space separated) before command execution.
`realignerTargetCreator.gatkJar`|String|"$GATK_ROOT/GenomeAnalysisTK.jar"|Path to GATK jar.
`indelRealign.additionalParams`|String?|None|Additional parameters to pass to GATK IndelRealigner.
`indelRealign.jobMemory`|Int|24|Memory allocated to job (in GB).
`indelRealign.overhead`|Int|6|Java overhead memory (in GB). jobMemory - overhead == java Xmx/heap memory.
`indelRealign.cores`|Int|1|The number of cores to allocate to the job.
`indelRealign.timeout`|Int|6|Maximum amount of time (in hours) the task can run for.
`indelRealign.modules`|String|"python/3.7 gatk/3.6-0"|Environment module name and version to load (space separated) before command execution.
`indelRealign.gatkJar`|String|"$GATK_ROOT/GenomeAnalysisTK.jar"|Path to GATK jar.
`baseQualityScoreRecalibration.intervals`|Array[String]|[]|One or more genomic intervals over which to operate.
`baseQualityScoreRecalibration.additionalParams`|String?|None|Additional parameters to pass to GATK BaseRecalibrator.
`baseQualityScoreRecalibration.outputFileName`|String|"gatk.recalibration.csv"|Recalibration table file name.
`baseQualityScoreRecalibration.jobMemory`|Int|24|Memory allocated to job (in GB).
`baseQualityScoreRecalibration.overhead`|Int|6|Java overhead memory (in GB). jobMemory - overhead == java Xmx/heap memory.
`baseQualityScoreRecalibration.cores`|Int|1|The number of cores to allocate to the job.
`baseQualityScoreRecalibration.timeout`|Int|6|Maximum amount of time (in hours) the task can run for.
`baseQualityScoreRecalibration.modules`|String|"gatk/4.1.6.0"|Environment module name and version to load (space separated) before command execution.
`gatherBQSRReports.additionalParams`|String?|None|Additional parameters to pass to GATK GatherBQSRReports.
`gatherBQSRReports.outputFileName`|String|"gatk.recalibration.csv"|Recalibration table file name.
`gatherBQSRReports.jobMemory`|Int|24|Memory allocated to job (in GB).
`gatherBQSRReports.overhead`|Int|6|Java overhead memory (in GB). jobMemory - overhead == java Xmx/heap memory.
`gatherBQSRReports.cores`|Int|1|The number of cores to allocate to the job.
`gatherBQSRReports.timeout`|Int|6|Maximum amount of time (in hours) the task can run for.
`gatherBQSRReports.modules`|String|"gatk/4.1.6.0"|Environment module name and version to load (space separated) before command execution.
`analyzeCovariates.additionalParams`|String?|None|Additional parameters to pass to GATK AnalyzeCovariates
`analyzeCovariates.outputFileName`|String|"gatk.recalibration.pdf"|Recalibration report file name.
`analyzeCovariates.jobMemory`|Int|24|Memory allocated to job (in GB).
`analyzeCovariates.overhead`|Int|6|Java overhead memory (in GB). jobMemory - overhead == java Xmx/heap memory.
`analyzeCovariates.cores`|Int|1|The number of cores to allocate to the job.
`analyzeCovariates.timeout`|Int|6|Maximum amount of time (in hours) the task can run for.
`analyzeCovariates.modules`|String|"gatk/4.1.6.0"|Environment module name and version to load (space separated) before command execution.
`applyBaseQualityScoreRecalibration.outputFileName`|String|basename(bam,".bam")|Output files will be prefixed with this.
`applyBaseQualityScoreRecalibration.suffix`|String|".recalibrated"|Suffix to use for recalibrated bams.
`applyBaseQualityScoreRecalibration.additionalParams`|String?|None|Additional parameters to pass to GATK ApplyBQSR.
`applyBaseQualityScoreRecalibration.jobMemory`|Int|24|Memory allocated to job (in GB).
`applyBaseQualityScoreRecalibration.overhead`|Int|6|Java overhead memory (in GB). jobMemory - overhead == java Xmx/heap memory.
`applyBaseQualityScoreRecalibration.cores`|Int|1|The number of cores to allocate to the job.
`applyBaseQualityScoreRecalibration.timeout`|Int|6|Maximum amount of time (in hours) the task can run for.
`applyBaseQualityScoreRecalibration.modules`|String|"gatk/4.1.6.0"|Environment module name and version to load (space separated) before command execution.
`collectFilesBySample.jobMemory`|Int|1|Memory allocated to job (in GB).
`collectFilesBySample.cores`|Int|1|The number of cores to allocate to the job.
`collectFilesBySample.timeout`|Int|1|Maximum amount of time (in hours) the task can run for.
`collectFilesBySample.modules`|String|"python/3.7"|Environment module name and version to load (space separated) before command execution.
`mergeSplitByIntervalBams.additionalParams`|String?|None|Additional parameters to pass to GATK MergeSamFiles.
`mergeSplitByIntervalBams.jobMemory`|Int|24|Memory allocated to job (in GB).
`mergeSplitByIntervalBams.overhead`|Int|6|Java overhead memory (in GB). jobMemory - overhead == java Xmx/heap memory.
`mergeSplitByIntervalBams.cores`|Int|1|The number of cores to allocate to the job.
`mergeSplitByIntervalBams.timeout`|Int|6|Maximum amount of time (in hours) the task can run for.
`mergeSplitByIntervalBams.modules`|String|"gatk/4.1.6.0"|Environment module name and version to load (space separated) before command execution.


### Outputs

Output | Type | Description
---|---|---
`outputGroups`|Array[OutputGroup]|Array of objects with outputIdentifier (from inputGroups) and the final merged bam and bamIndex.
`recalibrationReport`|File?|Recalibration report pdf (if BQSR enabled).
`recalibrationTable`|File?|Recalibration csv that was used by BQSR (if BQSR enabled).


## Niassa + Cromwell

This WDL workflow is wrapped in a Niassa workflow (https://github.com/oicr-gsi/pipedev/tree/master/pipedev-niassa-cromwell-workflow) so that it can used with the Niassa metadata tracking system (https://github.com/oicr-gsi/niassa).

* Building
```
mvn clean install
```

* Testing
```
mvn clean verify \
-Djava_opts="-Xmx1g -XX:+UseG1GC -XX:+UseStringDeduplication" \
-DrunTestThreads=2 \
-DskipITs=false \
-DskipRunITs=false \
-DworkingDirectory=/path/to/tmp/ \
-DschedulingHost=niassa_oozie_host \
-DwebserviceUrl=http://niassa-url:8080 \
-DwebserviceUser=niassa_user \
-DwebservicePassword=niassa_user_password \
-Dcromwell-host=http://cromwell-url:8000
```

## Support

For support, please file an issue on the [Github project](https://github.com/oicr-gsi) or send an email to gsi@oicr.on.ca .

_Generated with generate-markdown-readme (https://github.com/oicr-gsi/gsi-wdl-tools/)_
