# to generate normalized oe matrices
print("This script takes in these following arguments.
1. the dirname of the hic files 
(such as ~/SIPG/hic/GM1k/GM12878_combined/1kb_resolution_intrachromosomal/chr22/MAPQGE30);
2. the base name of the files, such as chr22_1kb;
3. the resolution;
4. the name of the chromosome")

ARG <- commandArgs(trailingOnly=TRUE)
dir <- ARG[1]
base <- ARG[2]
res <- as.integer(ARG[3])
chr <- ARG[4]
str(res)
# dir <- "~/SIPG/hic/GM1k/GM12878_combined/5kb_resolution_intrachromosomal/chr1/MAPQGE30"
# base <- "chr1_5kb"
# chr <- "chr1"
# res <- 5000
# bin <- 
ext <- c("RAWobserved", "RAWexpected", "KRnorm", "KRexpected", "SQRTVCnorm", "SQRTVCexpected",
           "VCnorm", "VCexpected")
files <- lapply(paste0(dir, "/", base, ".", ext), function(x) {
  f <- read.table(x, as.is = TRUE)
  return(f)
})

names(files) <- ext
# as this stage, you should be worried about how NAs are represented.
# t <- read.table("~/SIPG/hic/GM1k/GM12878_combined/1kb_resolution_intrachromosomal/chr22/MAPQGE30/chr22_1kb.KRnorm", as.is = T)
# > str(t)
# 'data.frame':	51324 obs. of  1 variable:
#   $ V1: num  NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN ...
# turned out to be ok. NaN is considered as a type of number somehow.

# step 1: calculate normalized observation matrix.
# here the challenge is to divide a number by NaN. It seems fine :
# > 1/NaN
# [1] NaN

files[["oe"]] <- files[["RAWobserved"]]
files[["oe"]]$chr <- rep(chr, nrow(files[["oe"]]))
files[["oe"]] <- files[["oe"]][,c(4, 1,2,3)]
colnames(files[["oe"]]) <- c("chr", "left", "right", "RAW.obs")

files[["oe"]]$KR.obs <- files[["oe"]]$RAW.obs/(files[["KRnorm"]]$V1[files[["oe"]]$left/res+1] * files[["KRnorm"]]$V1[files[["oe"]]$right/res+1])
files[["oe"]]$VC.obs <- files[["oe"]]$RAW.obs/(files[["VCnorm"]]$V1[files[["oe"]]$left/res+1] * files[["VCnorm"]]$V1[files[["oe"]]$right/res+1])
files[["oe"]]$SQRTVC.obs <- files[["oe"]]$RAW.obs/(files[["SQRTVCnorm"]]$V1[files[["oe"]]$left/res+1] * files[["SQRTVCnorm"]]$V1[files[["oe"]]$right/res+1])

# step 2: calculate oe matrix.
files[["oe"]]$RAW.oe <- files[["oe"]]$RAW.obs/(files[["RAWexpected"]]$V1[(files[["oe"]]$right-files[["oe"]]$left)/res+1])
files[["oe"]]$KR.oe <- files[["oe"]]$KR.obs/(files[["KRexpected"]]$V1[(files[["oe"]]$right-files[["oe"]]$left)/res+1])
files[["oe"]]$VC.oe <- files[["oe"]]$VC.obs/(files[["VCexpected"]]$V1[(files[["oe"]]$right-files[["oe"]]$left)/res+1])
files[["oe"]]$SQRTVC.oe <- files[["oe"]]$SQRTVC.obs/(files[["SQRTVCexpected"]]$V1[(files[["oe"]]$right-files[["oe"]]$left)/res+1])


# check with the example offered in readme.rtf
# > files[["oe"]] %>% filter(left==40000000, right==40100000)
# chr     left    right raw.obs   KR.obs   VC.obs SQRTVC.obs   KR.oe     VC.oe SQRTVC.oe   RAW.oe
# 1 chr1 40000000 40100000      59 28.24777 13.59946   36.45752 1.48545 0.6856444  1.899706 2.935079
# correct!!

write.table(files[["oe"]], paste0(base, ".", "oe"), sep = "\t", quote = FALSE, row.names = FALSE, col.names = TRUE)
