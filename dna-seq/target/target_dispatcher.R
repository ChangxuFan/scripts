library(dplyr)
library(parallel)
options(stringsAsFactors = F)
args <- commandArgs(trailingOnly=TRUE)
reads <- args[1]
outdir <- args[2]
thread <- args[3]
genome <- args[4]
reads <- read.table(reads, header=T, as.is = T)

split(reads, f = factor(reads$read1, reads$read1)) %>% lapply(function(x) {
  read1 <- basename(x$read1)
  read2 <- basename(x$read2)

  system(paste0("rm -rf ", read1 %>% paste0(outdir, "/", .) ,
                " ", read2 %>% paste0(outdir, "/", .)))
  system(paste0("ln -s ", x$read1, " ", read1 %>% paste0(outdir, "/", .)))
  system(paste0("ln -s ", x$read2, " ", read2 %>% paste0(outdir, "/", .)))

  cmd <- paste0("cd ",outdir,
                " && /opt/apps/singularity/2.4.2/bin/singularity run -B ./:/process -B /scratch:/scratch",
                " /bar/cfan/software/simg//ATAC_",genome, "_target_181103.simg",
                " -r PE -o ", read1, " -p ", read2, " -g ",genome," -i 0 -t ", thread)
  print(cmd)
  system(cmd)
})
