# set home directory
homedir <- find_root(criterion = has_file("dev_econ_cohort_2022.Rproj"))

# set file paths to sub-directories
codedir <- file.path(homedir, "code")
datadir <- file.path(homedir, "data")
metadir <- file.path(homedir, "meta")
bibdir <- file.path(homedir, "bib")
prelimdir <- file.path(datadir, "prelim")
outputdir <- file.path(datadir, "output")
workbookdir <- file.path(codedir, "workbook")
setwd(homedir)