
FROM bioconductor/release_base
MAINTAINER Mark Dunning<mark.dunning@cruk.cam.ac.uk>


RUN apt-get update && apt-get install --fix-missing -y git samtools fastx-toolkit python-dev cmake bwa

#RUN rm -r images javascripts stylesheets params.json index.html
WORKDIR /tmp
RUN wget http://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.3.zip -P /tmp
RUN unzip fastqc_v0.11.3.zip
RUN sudo chmod 755 FastQC/fastqc
RUN ln -s $(pwd)/FastQC/fastqc /usr/bin/fastqc
RUN wget https://bootstrap.pypa.io/get-pip.py
RUN sudo python get-pip.py
RUN sudo pip install cython
RUN sudo pip install --user --upgrade cutadapt
RUN rm get-pip.py
RUN wget https://github.com/samtools/htslib/releases/download/1.3.1/htslib-1.3.1.tar.bz2
RUN apt-get install -y bzip2 tabix bedtools build-essential git-core cmake zlib1g-dev libncurses-dev
RUN bzip2 -d htslib-1.3.1.tar.bz2
RUN tar xvf htslib-1.3.1.tar
WORKDIR htslib-1.3.1
RUN make install 
RUN chmod +x ~/.local/bin/cutadapt
RUN ln -s ~/.local/bin/cutadapt /usr/bin/cutadapt
WORKDIR /tmp
RUN git clone --recursive git://github.com/ekg/freebayes.git
WORKDIR freebayes
RUN make
RUN sudo make install
WORKDIR /tmp/
RUN git clone git://github.com/genome/somatic-sniper.git
RUN mkdir somatic-sniper/build
WORKDIR somatic-sniper/build
RUN cmake ../
RUN make deps
RUN make -j
RUN make test
RUN make install
WORKDIR /tmp
RUN wget http://www.well.ox.ac.uk/bioinformatics/Software/Platypus-latest.tgz
RUN tar xvf Platypus-latest.tgz
WORKDIR Platypus_0.8.1
RUN ./buildPlatypus.sh
ENV PLATYPUS /tmp/Platypus_0.8.1/Platypus.py
WORKDIR /tmp
RUN wget https://github.com/broadinstitute/picard/releases/download/2.4.1/picard-tools-2.4.1.zip
RUN unzip picard-tools-2.4.1.zip
RUN apt-get update &&  apt-get install -y --fix-missing openjdk-8-jdk
ENV PICARD /tmp/picard-tools-2.4.1/picard.jar
WORKDIR /tmp
RUN wget http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/Trimmomatic-0.36.zip
RUN unzip Trimmomatic-0.36.zip
ENV TRIMMOMATIC /tmp/Trimmomatic-0.36/trimmomatic-0.36.jar
WORKDIR /tmp
#RUN wget http://sourceforge.net/projects/snpeff/files/snpEff_latest_core.zip
#RUN unzip snpEff_latest_core.zip
#ENV SNPEFF /tmp/snpEff/snpEff.jar
#RUN java -jar /tmp/snpEff/snpEff.jar download GRCh37.75
RUN git clone --recursive https://github.com/vcflib/vcflib.git
WORKDIR vcflib
RUN make
ENV VCFLIB /tmp/vcflib
WORKDIR /tmp
RUN wget https://github.com/tobiasrausch/delly/releases/download/v0.7.3/delly_v0.7.3_linux_x86_64bit
RUN ln -s /tmp/delly_v0.7.3_linux_x86_64bit /usr/bin/delly
WORKDIR /tmp
RUN wget https://github.com/Illumina/manta/releases/download/v0.29.6/manta-0.29.6.release_src.tar.bz2
RUN tar -xjf manta-0.29.6.release_src.tar.bz2
RUN mkdir manta-0.29.6.release_src/build/
WORKDIR manta-0.29.6.release_src/build
RUN ../configure --jobs=4 --prefix=/opt/manta
RUN make -j4 install
#RUN git clone https://github.com/markdunning/summer-school2016.git /home/participant/Course_Materials/
#RUN ls /home/participant/Course_Materials/
#WORKDIR /home/participant/Course_Materials
#RUN chmod +x ref_data/download.sh
#WORKDIR ref_data/
#RUN ./download.sh
#WORKDIR /home/participant/Course_Materials
#RUN chmod +x data/hapmap/download.sh
#WORKDIR data/hapmap
#RUN ./download.sh
#WORKDIR /home/participant/Course_Materials
#chmod +x Day1/data_for_day1.sh
#WORKDIR Day1
#RUN ./data_for_day1.sh
RUN mkdir -p /home/participant/Course_Materials
WORKDIR /home/participant/Course_Materials
#RUN chmod +x data/cell-line/downsampled
#RUN chmod +x ref_data/annovar/annovar_commands.sh
##WORKDIR data/cell-line/downsampled
#RUN ./download.sh
WORKDIR /home/participant/Course_Materials
RUN useradd participant -d /home/participant
RUN chmod -R 777 /home/participant/Course_Materials 
RUN chown participant /home/participant/Course_Materials 
RUN wget https://raw.githubusercontent.com/bioinformatics-core-shared-training/cruk-summer-school-2016/master/installBioCPkgs.R
RUN R -f installBioCPkgs.R