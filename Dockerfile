FROM modulator:latest

MAINTAINER Fenglin Chen <f73chen@uwaterloo.ca>

# packages should already be set up in modulator:latest
USER root

# move in the yaml to build modulefiles from
COPY GenomeAnalysisTK.jar /modulator/GenomeAnalysisTK.jar
COPY bam-merge-preprocessing_recipe.yaml /modulator/code/gsi/recipe.yaml

# build the modules and set folder / file permissions
RUN ./build-local-code /modulator/code/gsi/recipe.yaml --initsh /usr/share/modules/init/sh --output /modules && \
	find /modules -type d -exec chmod 777 {} \; && \
	find /modules -type f -exec chmod 777 {} \;

# add the user
RUN groupadd -r -g 1000 ubuntu && useradd -r -g ubuntu -u 1000 ubuntu
USER ubuntu

# copy the setup file to load the modules at startup
# use different versions of .bashrc depending on gatk version of container
COPY .bashrc /home/ubuntu/.bashrc

# paths that are the same for both gatk versions
ENV SAMTOOLS_ROOT="/modules/gsi/modulator/sw/Ubuntu18.04/samtools-1.9"
ENV HTSLIB_ROOT="/modules/gsi/modulator/sw/Ubuntu18.04/htslib-1.9"
ENV JAVA_ROOT="/modules/gsi/modulator/sw/Ubuntu18.04/java-8"
ENV RSTATS_ROOT="/modules/gsi/modulator/sw/Ubuntu18.04/rstats-3.6"
ENV PYTHON_ROOT="/modules/gsi/modulator/sw/Ubuntu18.04/python-3.7"
ENV MANPATH="/modules/gsi/modulator/sw/Ubuntu18.04/python-3.7/share/man:/modules/gsi/modulator/sw/Ubuntu18.04/rstats-3.6/share/man:/modules/gsi/modulator/sw/Ubuntu18.04/java-8/man:/modules/gsi/modulator/sw/Ubuntu18.04/samtools-1.9/share/man:/modules/gsi/modulator/sw/Ubuntu18.04/htslib-1.9/share/man"
ENV PKG_CONFIG_PATH="/modules/gsi/modulator/sw/Ubuntu18.04/python-3.7/lib/pkgconfig:/modules/gsi/modulator/sw/Ubuntu18.04/htslib-1.9/lib/pkgconfig"
ENV PYTHONPATH="/modules/gsi/modulator/sw/Ubuntu18.04/python-3.7/lib/python3.7/site-packages"

# paths for GATK/3.6-0
#ENV GATK_ROOT="/modules/gsi/modulator/sw/Ubuntu18.04/gatk-3.6-0"
#ENV PATH="/modules/gsi/modulator/sw/Ubuntu18.04/gatk-3.6-0/bin:/modules/gsi/modulator/sw/Ubuntu18.04/python-3.7/bin:/modules/gsi/modulator/sw/Ubuntu18.04/rstats-3.6/bin:/modules/gsi/modulator/sw/Ubuntu18.04/java-8/bin:/modules/gsi/modulator/sw/Ubuntu18.04/samtools-1.9/bin:/modules/gsi/modulator/sw/Ubuntu18.04/htslib-1.9/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
#ENV LD_LIBRARY_PATH="/modules/gsi/modulator/sw/Ubuntu18.04/python-3.7/lib:/modules/gsi/modulator/sw/Ubuntu18.04/rstats-3.6/lib:/modules/gsi/modulator/sw/Ubuntu18.04/java-8/lib:/modules/gsi/modulator/sw/Ubuntu18.04/htslib-1.9/lib"
#ENV R_LIBS_SITE="/modules/gsi/modulator/sw/Ubuntu18.04/rstats-3.6/lib/R/library"

# paths for GATK/4.1.6.0
ENV GATK_ROOT="/modules/gsi/modulator/sw/Ubuntu18.04/gatk-4.1.6.0"
ENV PATH="/modules/gsi/modulator/sw/Ubuntu18.04/gatk-4.1.6.0/bin:/modules/gsi/modulator/sw/Ubuntu18.04/python-3.7/bin:/modules/gsi/modulator/sw/Ubuntu18.04/rstats-3.6/bin:/modules/gsi/modulator/sw/Ubuntu18.04/java-8/bin:/modules/gsi/modulator/sw/Ubuntu18.04/samtools-1.9/bin:/modules/gsi/modulator/sw/Ubuntu18.04/htslib-1.9/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
ENV LD_LIBRARY_PATH="/modules/gsi/modulator/sw/Ubuntu18.04/gatk-4.1.6.0/lib:/modules/gsi/modulator/sw/Ubuntu18.04/python-3.7/lib:/modules/gsi/modulator/sw/Ubuntu18.04/rstats-3.6/lib:/modules/gsi/modulator/sw/Ubuntu18.04/java-8/lib:/modules/gsi/modulator/sw/Ubuntu18.04/htslib-1.9/lib"
ENV R_LIBS_SITE="/modules/gsi/modulator/sw/Ubuntu18.04/gatk-4.1.6.0/lib/R/library:/modules/gsi/modulator/sw/Ubuntu18.04/rstats-3.6/lib/R/library"

# realignerTargetCreator requires this file in this location
COPY GenomeAnalysisTK.jar $GATK_ROOT/GenomeAnalysisTK.jar

CMD /bin/bash
