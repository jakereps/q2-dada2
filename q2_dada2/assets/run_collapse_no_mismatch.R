#!/usr/bin/env Rscript

###################################################
# This R script takes an input directory of .fastq.gz files
# and outputs a tsv file of the dada2 processed sequence
# table. It is intended for use with the QIIME2 plugin
# for DADA2.
#
# Ex: Rscript run_dada_single.R input_dir output.tsv filtered_dir 200 0 2.0 2 Inf pooled 1.0 0 1000000 NULL 32
####################################################

####################################################
#             DESCRIPTION OF ARGUMENTS             #
####################################################
# NOTE: All numeric arguments should be zero or positive.
# NOTE: All numeric arguments save maxEE are expected to be integers.
# NOTE: Currently the filterered_dir must already exist.
# NOTE: ALL ARGUMENTS ARE POSITIONAL!
#
### FILE SYSTEM ARGUMENTS ###
#
# 1) File path to directory with the .fastq.gz files to be processed.
#    Ex: path/to/dir/with/tsv
#
# 2) File path to output tsv file. If already exists, will be overwritten.
#    Ex: path/to/output_file.tsv
#
### FILTERING ARGUMENTS ###
#
#
### CHIMERA ARGUMENTS ###
#
#
### SPEED ARGUMENTS ###
#
#
### GLOBAL OPTION ARGUMENTS ###
#

cat(R.version$version.string, "\n")
args <- commandArgs(TRUE)

inp.path <- args[[1]]
out.path <- args[[2]]

### VALIDATE ARGUMENTS ###

# Input file is expected to a tsv file containing at least
# two samples and two features
if(!file.exists(inp.path)) {
  errQuit("Input file does not exist.")
} else {
  seqtab <- read.table(inp.path, sep="\t", row.names=1,
                       header=TRUE, comment.char="")
  if(ncol(seqtab) < 2 || nrow(seqtab) < 2) {
    errQuit("Table does not have at least 2 samples, or 2 features.")
  }
}



# Output path is to be a filename (not a directory) and is to be
# removed and replaced if already present.
if(dir.exists(out.path)) {
  errQuit("Output filename is a directory.")
} else if(file.exists(out.path)) {
  invisible(file.remove(out.path))
}

### LOAD LIBRARIES ###
suppressWarnings(library(methods))
suppressWarnings(library(dada2))
cat("DADA2 R package version:", as.character(packageVersion("dada2")), "\n")

### TRIM AND FILTER ###
seqtab <- makeSequenceTable(list(sample1=seqtab))
collapseNoMismatch(seqtab)

### WRITE OUTPUT AND QUIT ###
# Formatting as tsv plain-text sequence table table
write.table(seqtab, out.path, sep="\t",
            row.names=TRUE, col.names=True, quote=FALSE)

q(status=0)
