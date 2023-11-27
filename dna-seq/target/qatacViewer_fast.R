library(rnaSeqFanc)
# the stout version: 
# qatacview.jsongen(df = "qatacViewer.tsv", out.json = "qatacViewer.json", replace = T)

# use Daofeng's version:
qatacview.jsongen(df = "qatacViewer.tsv", add.to = "/bar/dli/public_html/qATACviewer/data.json")

# qatacview.jsongen <- function (df, out.json = NULL, replace = F)  {
#     if (is.character(df)) 
#         df <- read.table(df, header = T, as.is = T, sep = "\t")
#     jsongen <- list()
#     jsongen[["allOptions"]] <- lapply(df$collection %>% unique(), 
#         function(x) {
#             list(value = x, label = x, clearableValue = F)
#         })
#     jsongen[["allProducts"]] <- split(df, f = factor(df$collection, 
#         levels = df$collection %>% unique())) %>% lapply(function(x) {
#         print(x)
#         collection.df <- split(x, f = factor(x$pipedir, levels = x$pipedir %>% 
#             unique())) %>% lapply(function(y) {
#             pipe.df <- split(y, f = factor(y$sample, levels = y$sample %>% 
#                 unique())) %>% lapply(function(z) {
#                 if (nrow(z) != 1) 
#                   stop("something went wrong with the splitting of dataframe. z doesn't have exactly one row")
#                 url <- target.jsongen(z$pipedir[1], samples = list(z$samples), 
#                   prefix = "step3.2_", suffix = "normalized*bigWig", 
#                   track_type = "bigwig") %>% pull(url)
#                 file <- target.jsongen(z$pipedir[1], samples = list(z$samples), 
#                   prefix = "QC", suffix = "json", track_type = "bigwig") %>% 
#                   pull(url)
#                 data.frame(sample = z$sample, url = url, assay = "ATAC-seq", 
#                   file = file) %>% return()
#             }) %>% Reduce(rbind, .)
#         }) %>% Reduce(rbind, .)
#         collection.df$id <- 1:nrow(collection.df)
#         return(collection.df)
#     })
#     json <- jsongen %>% jsonlite::toJSON() %>% jsonlite::prettify()
#     if (!is.null(out.json)) 
#         write(json, out.json)
#     if (replace == T) 
#         # system(paste0("mv ", "~/software/browser/qATACviewer/frontend/src/data.json ", 
#         #     "~/software/browser/qATACviewer/frontend/src/data.json.bk", 
#         #     " && cp ", out.json, " ~/software/browser/qATACviewer/frontend/src/data.json"))

#         system("cp ", out.json, " /scratch/qATACViewer_shared/qatacViewer.json")
#     return(jsongen)
# }



