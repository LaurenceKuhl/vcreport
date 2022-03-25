#!/usr/bin/env Rscript

library(rmarkdown)
library(optparse)

option_list = list(
  make_option(c("-r", "--report"), type="character", default="./assets/VC_report.Rmd", help="report template file", metavar="character"),
  make_option(c("-o", "--output"), type="character", default="RNAseq_report.html", help="output file name", metavar="character"),
  make_option(c("-s", "--proj_summary"), type="character", default=NULL, help="project summary file", metavar="character"),
  make_option(c("-m", "--metadata"), type="character", default=NULL, help="metadata file", metavar="character")
)

opt_parser = OptionParser(option_list=option_list)
opt = parse_args(opt_parser)

wd=getwd()


rmarkdown::render(opt$report, output_file = opt$output, knit_root_dir = wd, output_dir = wd,
                  params = list(path_proj_summary = opt$proj_summary,
                                path_metadata = opt$metadata,
                                path_wd = wd
                                ))
