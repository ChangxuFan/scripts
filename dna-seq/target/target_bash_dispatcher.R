library(dplyr)
library(parallel)
options(stringsAsFactors = F)
args <- commandArgs(trailingOnly=TRUE)
reads <- args[1]
outdir <- args[2]
thread <- args[3]
genome <- args[4]

reads <- read.table(reads, header=T, as.is = T)

system(paste0("mkdir -p ", outdir))

cmd <- split(reads, f = factor(reads$read1, reads$read1)) %>% lapply(function(x) {
  read1 <- basename(x$read1)
  read2 <- basename(x$read2)

  system(paste0("rm -rf ", read1 %>% paste0(outdir, "/", .) ,
                " ", read2 %>% paste0(outdir, "/", .)))
  system(paste0("ln -s `realpath ", x$read1, "` ", read1 %>% paste0(outdir, "/", .)))
  system(paste0("ln -s `realpath ", x$read2, "` ", read2 %>% paste0(outdir, "/", .)))

  cmd <- paste0("module load singularity && singularity run -B ./:/process -B /scratch:/scratch",
  				" -B /lodge:/lodge", " -B /taproom:/taproom",
                " /bar/cfan/software/simg//ATAC_",genome,"_target_181103.simg",
                " -r PE -o ", read1, " -p ", read2, " -g ",genome," -t ", thread)

}) %>% unlist()

cmd <- c("#!/bin/bash", "module load singularity", cmd)
write(cmd, paste0(outdir, "/target_dispatcher.sh"), sep = "\n")
system(paste0("chmod 755 ",outdir, "/target_dispatcher.sh"))
