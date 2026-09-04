# Need to do one of these for books, code, etcx.
# description -------------------------------------------------------------

# Export as  BibTex, background export, export files

# Code for converting exported bibtex file into format that:
# 1) is read into Academic and 2) the pdfs are renamed after being copied
# into the relevant folder

# TIDYVERSE APPROACH
# =============================================================================
# CREATE QUARTO PUBLICATION PAGES FROM A BIBTEX FILE
# =============================================================================
# This script reads a BibTeX file exported from Zotero and creates a folder
# for each publication. Each folder contains:
#   - index.qmd : a Quarto markdown file with publication metadata
#   - cite.bib  : a BibTeX file for the single publication
#   - a renamed PDF (if one exists in the original Zotero export folder)
# =============================================================================

library(RefManageR)  # for reading and writing BibTeX files
library(tidyverse)   # for data manipulation and functional programming
library(here)        # for robust relative file paths

# =============================================================================
# CONFIGURATION
# Change these paths to match your local folder structure
# =============================================================================

# Path to your BibTeX file exported from Zotero
bibfile <- here("publications/better_bibtex/EMB_publications/EMB_publications.bib")

# Folder where new publication subfolders will be created
outfold <- "./publications/articles"

# Path to the Zotero "files" folder containing numbered PDF subfolders
# This is typically inside your Zotero export folder
zot_root <- "./publications/better_bibtex/EMB_publications/files"

# Set to TRUE to overwrite existing index.qmd files, FALSE to skip them
overwrite <- TRUE

# =============================================================================
# LOAD AND CLEAN BIBTEX DATA
# =============================================================================

mypubs <- ReadBib(bibfile, check = "warn", .Encoding = "UTF-8") |>
  
  # Convert BibTeX entries to a data frame
  as.data.frame() |>
  
  # Keep the BibTeX cite keys (e.g. "bruna_2004") as a column called "rowname"
  rownames_to_column() |>
  
  mutate(
    # Remove curly braces and quotes that BibTeX uses for formatting
    across(everything(), ~ str_remove_all(.x, '[{}"]')),
    
    # Fix escaped percent signs (e.g. \% -> %)
    across(everything(), ~ str_replace_all(.x, "\\\\%", "%")),
    
    # Use "year" as the date field
    date       = year,
    
    # Standardize journal names to title case
    # Add more case_when lines here for other journals that need fixing
    journal    = case_when(
      journal == "QUANTITATIVE SCIENCE STUDIES" ~ "Quantitative Science Studies",
      journal == "BIOTROPICA"                   ~ "Biotropica",
      .default = journal
    ),
    
    # Create a short journal name for use in filenames (lowercase, underscores)
    jrnl_short = journal |> tolower() |>
      str_replace_all(" ", "_") |>
      str_replace_all("&", "and") |>
      str_remove_all("'"),
    
    # Standardize page ranges to use single dash (e.g. 1--10 -> 1-10)
    pages      = str_replace_all(pages, "--", "-"),
    
    # Clean up abstract text
    abstract   = abstract |>
      str_replace_all("&gt;", ">") |>   # fix HTML-encoded >
      str_replace_all("\\\\", ""),       # remove stray backslashes
    
    # Clean up keywords: remove NAs, standardize delimiters, remove special chars
    keywords   = keywords |>
      str_replace_all("NA,?", "") |>
      str_replace_all("[//*]", ",") |>
      str_replace_all("[/*]",  ",") |>
      str_replace_all(":",     "-") |>
      stringi::stri_trans_general("latin-ascii"),  # convert accented chars to ASCII
    
    # Reformat authors from "Last, First and Last, First" to "Last, First", "Last, First"
    # Also convert accented characters to ASCII for safe filenames
    author     = str_replace_all(author, " and ", '", "') |>
      stringi::stri_trans_general("latin-ascii"),
    
    # Replace "n/a" volume with NA
    volume     = str_replace(volume, "n/a", NA_character_),
    
    # Extract the Zotero folder number from the "file" field in the BibTeX entry
    # The file field looks like: "Title:files/123/paper.pdf:application/pdf"
    # This extracts the "123" part
    zot_folder = str_extract(file, "(?<=:files/)[^/]+(?=/)"),
    
    # Build the full path to the Zotero PDF folder for this entry
    zot_path   = file.path(zot_root, zot_folder)
  ) |>
  
  # Add a numeric row ID column (used for ordering)
  rowid_to_column() |>
  
  # If the BibTeX file uses "document_type" instead of "bibtype", rename it
  rename(any_of(c(bibtype = "document_type")))


# =============================================================================
# HELPER FUNCTION: BUILD A STANDARDIZED PDF FILENAME
# =============================================================================
# Creates a filename in the format: lastname_year_journal.pdf
# For multi-author papers: lastname_etal_year_journal.pdf

make_pdf_name <- function(x) {
  
  # Extract the first author's last name (before the first comma)
  first_author <- str_extract(x[["author"]], "^[^,]+") |>
    str_remove_all("[^a-zA-Z]") |>                          # remove non-letter characters
    stringi::stri_trans_general("latin-ascii")              # convert accents to ASCII
  
  # Count the number of authors
  n_authors  <- str_count(x[["author"]], '", "') + 1
  
  # Use "lastname" for single author, "lastname_etal" for multiple
  author_str <- if (n_authors == 1) first_author else paste0(first_author, "_etal")
  
  # Clean journal name for use in filename
  journal_str <- x[["jrnl_short"]] |>
    str_remove_all("[^a-zA-Z0-9_]")  # keep only letters, numbers, underscores
  
  
  
  # Combine into final filename
  paste0(author_str, "_", x[["year"]], "_", journal_str, ".pdf")
}


# =============================================================================
# HELPER FUNCTION: RENAME AND COPY PDF
# =============================================================================
# Looks for a PDF in the original Zotero folder, renames it using the
# standardized naming convention, then copies it to the new article folder.
# Returns the new PDF filename, or NA if no PDF was found.

move_pdf <- function(x, new_folder) {
  
  zot_path <- x[["zot_path"]]
  
  # Skip if there is no Zotero folder path or the folder doesn't exist
  if (is.na(zot_path) || !dir.exists(zot_path)) return(NA_character_)
  
  # Look for PDF files in the Zotero folder
  pdf_found <- list.files(zot_path, pattern = "\\.pdf$", full.names = TRUE)
  
  # Skip if no PDF found
  if (length(pdf_found) == 0) return(NA_character_)
  
  # Build the new standardized filename
  new_pdf_name <- make_pdf_name(x)
  
  # Rename the PDF in the original Zotero folder
  new_zot_path <- file.path(zot_path, new_pdf_name)
  file.rename(pdf_found[1], new_zot_path)
  
  # Copy the renamed PDF to the new article folder
  file.copy(new_zot_path, file.path(new_folder, new_pdf_name), overwrite = TRUE)
  
  # Return the new filename so it can be written into the YAML
  new_pdf_name
}




# =============================================================================
# MAIN FUNCTION: CREATE FOLDER, INDEX.QMD, AND CITE.BIB FOR ONE PUBLICATION
# =============================================================================
# This function is called once per row in mypubs (i.e. once per publication)

create_qmd <- function(x) {
  
  # Define the output folder path for this publication using its cite key
  
  folder <- file.path(outfold, str_replace_all(x[["rowname"]], "\\.", "_"))
  # Create the folder (showWarnings = FALSE suppresses warnings if it exists)
  dir.create(folder, showWarnings = FALSE, recursive = TRUE)
  
  # Define the path for the index.qmd file
  filepath <- file.path(folder, "index.qmd")
  
  # Attempt to find, rename, and copy the PDF; get back the new filename or NA
  new_pdf_name <- move_pdf(x, folder)
  
  # Build the YAML pdf field: include the path if a PDF was found, otherwise leave blank
  pdf_entry <- if (!is.na(new_pdf_name)) {
    paste0("pdf: './articles/", x[["rowname"]], "/", new_pdf_name, "'")
  } else {
    "pdf: ''"
  }
  
  # Only write the index.qmd if it doesn't exist yet, or if overwrite is TRUE
  if (!file.exists(filepath) || overwrite) {
    
    # Build the keywords section as a YAML list (one keyword per line)
    # If there are no keywords, kw_lines will be NULL and nothing is written
    kw_lines <- if (!is.na(x[["keywords"]])) {
      x[["keywords"]] |>
        str_split(",") |>        # split comma-separated keywords into a vector
        pluck(1) |>              # extract the vector from the list
        str_trim() |>            # remove leading/trailing whitespace
        paste0("  - ", ... = _)  # format each keyword as a YAML list item
    }
    
    # Assemble all YAML lines into a character vector
    # %||% is the "null coalescing" operator: returns "" if the left side is NULL
    yaml_lines <- c(
      "---",
      paste0('title: "',       x[["title"]],    '"'),
      paste0('date: "',        x[["year"]],     '"'),
      paste0('author: ["',     x[["author"]],  '"]'),
      paste0('publication: "', x[["journal"]]  %||% "", '"'),
      paste0('volume: "',      x[["volume"]]   %||% "", '"'),
      paste0('number: "',      x[["number"]]   %||% "", '"'),
      paste0('pages: "',       x[["pages"]]    %||% "", '"'),
      paste0('doi: "',         x[["doi"]]      %||% "", '"'),
      paste0('abstract: "',    x[["abstract"]] %||% "", '"'),
      "categories: ",
      kw_lines,           # inserts one line per keyword
      "url: ",
      "image: featured.png",
      'url_preprint: ""',
      'url_code: ""',
      'url_dataset: ""',
      paste0("bib: './articles/", x[["rowname"]], "/cite.bib'"),
      pdf_entry,
      "---"
    )
    
    # Write all YAML lines to index.qmd
    write(yaml_lines, filepath)
  }
  
  # Convert the row back to a data frame and write a single-entry cite.bib file
  df_entry <- as.data.frame(as.list(x), stringsAsFactors = FALSE) |>
    column_to_rownames("rowname")
  
  # Remove unwanted fields from each record before writing cite.bib ----------
  clean_bib_entry <- function(df_entry) {
    fields_to_remove <- c("file", "note", "jrnl_short", "zot_folder", "zot_path",
                          "date", "place", "type")
    df_entry |> select(-any_of(fields_to_remove))
  }
  
  # Write cite.bib, removing Zotero-specific and internal fields
  df_entry <- as.data.frame(as.list(x), stringsAsFactors = FALSE) |>
    column_to_rownames("rowname") |>
    clean_bib_entry()
  
  
  WriteBib(as.BibEntry(df_entry[1, ]), file.path(folder, "cite.bib"))
}



# =============================================================================
# RUN: APPLY create_qmd() TO EVERY ROW IN mypubs
# =============================================================================
# pwalk iterates over each row of mypubs, passing all columns as a named list
# to create_qmd(). It is used instead of pmap because we want the side effects
# (creating files and folders) rather than a return value.
mypubs |> pwalk(~ create_qmd(list(...)))





# TODO: not all abstracts being read (may be that some are called "summary")
# TODO: "strings cannot contain newlines" error in some abstracts
# TODO: is there a way to automate the copy paste of files into folder?

# http://www.pik-potsdam.de/~pichler/blog/post/set-this-up/setting-up-this-site/

#' @title bibtex_2academic
#' @description import publications from a bibtex file to a hugo-academic website
#' @author Lorenzo Busetto, phD (2017) <lbusett@gmail.com>
#' @modified Peter Paul Pichler (2019) <pichler@pik-potsdam.de>


# load libraries  ---------------------------------------------------------

library(RefManageR)
library(tidyverse)
library(anytime)
library(tibble)
library(here)
library(biblio)

# install.packages("remotes")
# remotes::install_github("FRBCesab/zoteror")
# library("zoteror")

# load data ---------------------------------------------------------------


# Read in the file
bibfile<-"./publications/EMB_publications/EMB_publications.bib"

# select destination folder -----------------------------------------------


# Identify the folder in which publications are kept
outfold<-"./publications/articles"

abstract = TRUE
overwrite = TRUE
# mypubs<-read_bib(here("publications/better_bibtex/EMB_publications/EMB_publications.bib"))
# Import the bibtex file and convert to data.frame

mypubs   <- ReadBib(here("publications/better_bibtex/EMB_publications/EMB_publications.bib"), check = "warn", .Encoding = "UTF-8") %>%
  as.data.frame() |> 
  rownames_to_column() %>% # retain rownames (as labels for bibtex re-export)
  mutate_all(funs(str_remove_all(.,"[{}\"]"))) %>%   ### remove {}" from bibtext entries
  mutate_all(funs(str_replace_all(.,'\\\\%', '%'))) ### some replace double escaped % for markdown


# mypubs$rowname<-gsub("_","-",mypubs$rowname)
# mypubs$rowname<-paste("pub",nrow(mypubs),sep="_")

# bt first neeed to convert from better biblatex format 
# mypubs$year<-str_split_i(mypubs$date,"-", 1)
mypubs$date<-mypubs$year
mypubs$journal
mypubs <-mypubs %>% 
  mutate(journal = case_when(
    journal == "QUANTITATIVE SCIENCE STUDIES" ~ "Quantiative Science Studies",
    journal == "BIOTROPICA" ~ "Biotropica",
    .default = as.character(journal)),
    rowname = str_replace_all(rowname, "\\.", "_"))
mypubs$jrnl_short<-gsub(" ","_",tolower(mypubs$journal))
mypubs$jrnl_short<-gsub("\\&","and",tolower(mypubs$journal))
mypubs$jrnl_short<-gsub("'","",tolower(mypubs$journal))
mypubs<-mypubs %>% rowid_to_column() 

# mypubs$rowname=paste(mypubs$jrnl_short,mypubs$year,mypubs$rowid,sep="_")


# make bibtype the name of the type column (default for WriteBib)
if (has_name(mypubs, "document_type") & !(has_name(mypubs, "bibtype"))) {
  mypubs <- mypubs %>% rename(bibtype = document_type)
}

# create a function which populates the md template based on the info
# about a publication
# x<-mypubs[3,]
# x<-mypubs[85,]
# x[85,]
x<-mypubs

# x<-x[1:10,]


create_qmd <- function(x) {
  
  #
  # foldername <- paste(x[["date"]], x[["title"]] %>%
  #                       str_replace_all(fixed(" "), "_") %>%
  #                       str_remove_all(fixed(":")) %>%
  #                       str_sub(1, 20), sep = "_")
  #
  # define a date and create filename by using the rowname for each article
  foldername <- x[["rowname"]]
  
  folder = paste0(outfold, "/", foldername)
  sapply(folder, dir.create)
  
  # dir.create(file.path(outfold, foldername), showWarnings = TRUE)
  filename = "index.qmd"
  # start writing
  outsubfold = paste(outfold, foldername, sep="/")
  
  if (!file.exists(file.path(outsubfold, filename)) | overwrite) {
    fileConn <- file.path(outsubfold, filename)
    write("---", fileConn)
    # write(fileConn)
    
    # Title 
    write(paste0("title: \"", x[["title"]], "\""), fileConn, append = T)
    # Year
    write(paste0("date: \"", x[["year"]], "\""), fileConn, append = T)
    
    # Authors. Comma separated list, e.g. `["Bob Smith", "David Jones"]`.
    auth_hugo <- str_replace_all(x["author"], " and ", "\", \"")
    auth_hugo <- stringi::stri_trans_general(auth_hugo, "latin-ascii")
    write(paste0("author: [\"", auth_hugo,"\"]"), fileConn, append = T)
    
    # Journal
    publication <- x[["journal"]]
    x[["publication"]] <- x[["journal"]]
    if (is.na(x[["journal"]])==FALSE) {
      write(paste0("publication: \"", x[["journal"]], "\""), fileConn, append = T)
    } else {
      write("publication: ", fileConn, append = T)
    }
    
    x[is.na(x)] <- "none"
    
    # Volume
    
    x[["volume"]]<-str_replace(x[["volume"]], "n/a", "")
    # write(paste0("volume: \"", x[["volume"]], "\""), fileConn, append = T)
    
    
    
    if (is.na(x[["volume"]])==FALSE) {
      write(paste0("volume: \"", x[["volume"]], "\""), fileConn, append = T)
    } else {
      write("volume: ", fileConn, append = T)
    }
    # 
    # 
    # Number
    if ((is.na(x[["number"]]))==FALSE) {
      write(paste0("number: \"", x[["number"]], "\""), fileConn, append = T)
    } else {
      write("number: 'No number'", fileConn, append = T)
    }
    
    # Pages
    x[["pages"]]<-gsub("--","-",x[["pages"]])
    
    if ((is.na(x[["pages"]]))==FALSE) {
      write(paste0("pages: \"", x[["pages"]], "\""), fileConn, append = T)
    } else {
      write("pages: ", fileConn, append = T)
    }
    
    
    # DOI
    if ((is.na(x[["doi"]]))==FALSE) {
      write(paste0("doi: \"", x[["doi"]], "\""), fileConn, append = T)
    } else {
      write("doi: ", fileConn, append = T)
    }
    
    
    # Abstract and optional shortened version.
    x[["abstract"]]<-gsub("&gt;",">",x[["abstract"]])
    x[["abstract"]]<-gsub("\\\\","",x[["abstract"]])
    
    
    
    if ((is.na(x[["abstract"]]))==FALSE) {
      write(paste0("abstract: \"", x[["abstract"]], "\""), fileConn, append = T)
    } else {
      write("abstract: ", fileConn, append = T)
    }
    
    
    x[["keywords"]]<-str_replace_all(x[["keywords"]], c("NA,"=""))
    x[["keywords"]]<-str_replace_all(x[["keywords"]], c("NA"=""))
    x[["keywords"]]<-str_replace_all(x[["keywords"]], c("[//*]"=","))
    x[["keywords"]]<-str_replace_all(x[["keywords"]], "[/*]", ",")
    x[["keywords"]]<-str_replace_all(x[["keywords"]], "[:]", "-")
    # x[["keywords"]]<-str_replace_all(x[["keywords"]], "[ //n]", "")
    x[["keywords"]]<- stringi::stri_trans_general(x[["keywords"]], "latin-ascii")
    
    if ((is.na(x[["keywords"]]))==TRUE) {
      write("categories: ", fileConn, append = T)
    } else {
      write("categories: ", fileConn, append = T)
      kw<-as.data.frame(x[["keywords"]])
      
      names(kw)<-"kw"
      cat_hugo<-kw %>% separate_longer_delim(kw, delim = ",")
      cat_hugo$prefix<-'  - '
      cat_hugo$kw<-paste0(cat_hugo$prefix,cat_hugo$kw,sep="")
      write(cat_hugo$kw,fileConn, append = T)
    
    }
    
    
    write("url: ", fileConn, append = T)
    
    
    
    
    
    # Image
    write(paste0("image: featured.png"),fileConn, append = T)
    # Preprint
    write("url_preprint: \"\"", fileConn, append = T)
    # Code
    write("url_code: \"\"", fileConn, append = T)
    # Data set
    write("url_dataset: \"\"", fileConn, append = T)
    
    
    
    # OTHER STUFF
    
    # keywords<-x[["keywords"]] 
    # keywords <- str_replace_all(x["keywords"], ",", "\", \"")
    # keywords <- stringi::stri_trans_general(keywords, "latin-ascii")
    # write(paste0("keywords = [\"", keywords,"\"]"), fileConn, append = T)
    
    # write("image_preview: \"\"", fileConn, append = T)
    
    # write("selected: false", fileConn, append = T)
    
    # write("projects = []", fileConn, append = T)
    
    # write("tags: []", fileConn, append = T)
    
    # write("url_project: \"\"", fileConn, append = T)
    
    # write("url_slides: \"\"", fileConn, append = T)
    
    # write("url_video: \"\"", fileConn, append = T)
    
    # write("url_poster: \"\"", fileConn, append = T)
    
    # write("url_source: \"\"", fileConn, append = T)
    
    # toc: false
    
    # title-block-style: none
    
    # write("highlight = true", fileConn, append = T)
    
    
    # 
    # 
    # pdf_folder <- x[["file"]]
    # pdf_folder<-as.data.frame(pdf_folder) 
    # 
    # # pdf_info<-pdf_folder %>%
    # #   separate(value,c("value","folder"),extra="drop") %>%
    # #   mutate(value=paste("./publications/articles/files",folder,"*.pdf",sep = "/")) %>%
    # #   replace_na(list(folder="missing"))
    # # pdf_folder<-as.vector(pdf_info$value)
    # # folder<-as.vector(pdf_info$folder)
    # 
    # pdf_info<-pdf_folder |> mutate(pdf_folder=str_extract(pdf_folder, "(?<=files/)[^/]+(?=/)")) 
    # # |> replace_na(list(pdf_folder="missing"))
    # pdf_folder<-as.vector(pdf_info$pdf_folder) 
    # 
    # # current.folder <-paste("./publications/better_bibtex/EMB_publications/files/",folder,"/",sep = "")
    # current.folder <-paste("./publications/better_bibtex/EMB_publications/files/",pdf_folder,"/",sep = "")
    # new.folder <- paste("./publications/articles/",foldername,"/",sep="")
    # 
    # # find the files that you want
    # 
    # 
    # 
    # current.folder <- list.dirs("./publications/better_bibtex/EMB_publications/files", recursive = FALSE)
    # 
    # pdf_files <- map_chr(subfolders, ~ {
    #   pdfs <- list.files(.x, pattern = "\\.pdf$", full.names = FALSE)
    #   if (length(pdfs) == 0) NA_character_ else pdfs[1]
    # })
    # 
    # list.of.files<-tibble(subfolder = current.folder, pdf = pdf_files)
    # 
    # 
    # 
    # new_name<-list.of.files |> separate_wider_delim(pdf,delim=" - ", names=c("x1","x2","x3"),too_few = "align_start",cols_remove=FALSE) |> 
    #   mutate(new_name=paste(x1,x2,sep="_"))
    # new_name<-new_name |> mutate(new_name=gsub("et al.", "etal",new_name),
    #                  new_name=     gsub(" ", "_",new_name),
    #                  new_name=gsub("[.]", "",new_name),
    #                  new_name=paste(new_name,".pdf",sep="")) |> 
    #   mutate(new_name=if_else(new_name=="NA_NA.pdf",NA,new_name)) |> 
    #   distinct(new_name, .keep_all=TRUE)
    # # new_name<-as.vector(new_name$new_name) 
    # new_name$new_name
    # 
    # new_name<-new_name |> 
    #   mutate(from=paste(current.folder,pdf,
    #                             sep="/"),.before=1) |> 
    #   mutate(from=paste(current.folder,pdf,
    #                     sep="/"),.before=1) |> 
    #   mutate(to=new.folder,.after=1)
    # 
    # file.rename(from = (paste(current.folder,list.of.files$pdf,
    #                           sep="/")), 
    #             to = new.folder)
    # 
    # # copy the files to the new folder
    # file.copy(paste(current.folder,"/",new_name,sep=""), new.folder)
    # 
    # 
    write(paste0("bib: './articles/", x[["rowname"]],"/cite.bib'",sep="",collapse="|"),fileConn, append = T)
    write(paste0("pdf: './articles/",  x[["rowname"]],"/",new_name,"'",sep="",collapse="|"),fileConn, append = T)
    
    write("---", fileConn, append = T)
    
    
  }
  
  # convert entry back to data frame
  df_entry = as.data.frame(as.list(x), stringsAsFactors=FALSE) %>%
    column_to_rownames("rowname")
  
  # write cite.bib file to outsubfolder
  WriteBib(as.BibEntry(df_entry[1,]), paste(outsubfold, "cite.bib", sep="/"))
  
  
  
  # Move the pdf files
  # identify the folders
  
  
  # '", pdf_folder,"'",sep=""),fileConn, append = T)
  
}
# apply the "create_qmd" function over the publications list to generate
# the different "qmd" files.
# x<-mypubs


# run it ------------------------------------------------------------------



apply(x, FUN = function(x) create_qmd(x), MARGIN = 1)
# }


# # To rename the pdfs
# # directory<-"./EMB_publications/files"
# path = "./publications/articles/"
# folder_names<-list.files(path)
# file_paths<-paste(path,folder_names,sep="")
# directory<-as.data.frame(directory)
# list.files(file_paths) # only file name
# list.files(file_paths, full.names=TRUE) # full path
# old_file_names<-list.files(file_paths, full.names=TRUE) # full path


# DO I NEED THIS?
# 
# # get only the ones that are pdf
# old_file_names<-Filter(function(x) str_detect(x, "pdf$"), old_file_names)
# pathsplit<-str_split(old_file_names, "/", simplify = TRUE)
# new_file_names<-paste(pathsplit[,1],pathsplit[,2],pathsplit[,3],pathsplit[,4],pathsplit[,4],sep="/")
# new_file_names<-paste(new_file_names,".pdf",sep="")
# file.rename(old_file_names,new_file_names)











#
#
#   #
#   # new_name_fcn <- function(x) {
#   #   new_name<-paste(x, list.files(x),sep="/")
#   #   return(new_name)
#   # }
#   #
#   # library(purrr)
#   # x <- nrow(directory)
#   #  <- map(1:x, paste(directory, list.files[.directory,sep="/"))
#   #
#   # file_names_new<-new_name_fcn(directory)
#   # new_name_fcn(x)<-paste(x, list.files(x),sep="/")
#   # file_names_new<-sapply(directory,new_name_fcn)
#   directory<-directory[10]
#   file_names_old<-list.files(directory)
#   file_names_new <- paste0(folder_names,".pdf")
#   file.rename(
#     paste0(directory,file_names_old,sep="/"),       # Rename files
#               paste0(directory[10], "/",file_names_new[10])
#
#   file.rename("./EMB_publications/files/3739/3739.pdf",
#               "./EMB_publications/files/3739/Araujo_etal_2013_PlantEcology.pdf")


# # option 2 ----------------------------------------------------------------
#
# #
# # NOT AS COOL
#
# # https://amirdjv.netlify.app/post/converting-bibtex-files-to-md-files/
# # https://github.com/petzi53/bib2academic
# devtools::install_github("petzi53/bib2academic")
# library(bib2academic)
# library(bibtex)
# bib2acad(bibfile = "./EMB_publications/EMB_publications.bib", copybib = TRUE, abstract = TRUE,overwrite = FALSE)
#
# bib2acad(
#   paste(
#     getwd(),
#     "./EMB_publications.bib",
#     sep = "/"),
#   copybib = TRUE, abstract = TRUE, overwrite = TRUE)
#
# bibFiles <- list.files("my-bib-folder", full.names = TRUE)
# mdFiles <- list.files("my-md-folder", full.names = TRUE)
#
#
# file.copy(from = bibFiles, to = "static/files/citations/")
# file.copy(from = mdFiles, to = "content/publication/")
#
# blogdown::serve_site()
# #
# #
# #
