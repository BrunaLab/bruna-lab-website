
# description -------------------------------------------------------------


# Code for converting exported bibtex file into format that:
# 1) is read into Academic and 2) the pdfs are renamed after being copied
# into the relevant folder
# TODO: not all abstracts being read (may be that some are called "summary")
# TODO: "strings cannot contain newlines" error in some abstracts
# TODO: is tehre a way to automate the copy paste of files into folder?

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


# load data ---------------------------------------------------------------


# Read in the file
bibfile<-"./EMB_publications/EMB_publications.bib"


# select destination folder -----------------------------------------------


# Identify the folder in which publications are keps
# outfold<-paste(getwd(),"outfold", sep="/")
outfold<-"./content/publication"
#
# bibtex_2academic <- function(bibfile,
#                              outfold,
#                              abstract = FALSE,
#                              overwrite = TRUE) {


  abstract = TRUE
  overwrite = TRUE

  # Import the bibtex file and convert to data.frame
  mypubs   <- ReadBib(bibfile, check = "warn", .Encoding = "UTF-8") %>%
    as.data.frame() %>%
    rownames_to_column() %>% # retain rownames (as labels for bibtex re-export)
    mutate_all(funs(str_remove_all(.,"[{}\"]"))) %>%   ### remove {}" from bibtext entries
    mutate_all(funs(str_replace_all(.,'\\\\%', '%')))  ### some replace double escaped % for markdown

  mypubs$rowname<-gsub("_","-",mypubs$rowname)

  # make bibtype the name of the type column (default for WriteBib)
  if (has_name(mypubs, "document_type") & !(has_name(mypubs, "bibtype"))) {
    mypubs <- mypubs %>% rename(bibtype = document_type)
  }

  # assign "categories" to the different types of publications
  mypubs   <- mypubs %>%
    dplyr::mutate(
      pubtype = dplyr::case_when(bibtype == "Article" ~ "2",
                                 bibtype == "Article in Press" ~ "2",
                                 bibtype == "InProceedings" ~ "1",
                                 bibtype == "Proceedings" ~ "1",
                                 bibtype == "Conference" ~ "1",
                                 bibtype == "Conference Paper" ~ "1",
                                 bibtype == "MastersThesis" ~ "3",
                                 bibtype == "PhdThesis" ~ "3",
                                 bibtype == "Manual" ~ "4",
                                 bibtype == "TechReport" ~ "4",
                                 bibtype == "Book" ~ "5",
                                 bibtype == "InCollection" ~ "6",
                                 bibtype == "InBook" ~ "6",
                                 bibtype == "Misc" ~ "0",
                                 TRUE ~ "0"))

  # create a function which populates the md template based on the info
  # about a publication
  # x<-mypubs[2,]
  # x<-mypubs
  create_md <- function(x) {

    # define a date and create filename by appending date and start of title
    if (!is.na(x[["year"]])) {
      x[["date"]] <- paste0(x[["year"]], "-01-01")
    } else {
      x[["date"]] <- "2999-01-01"
    }
    #
    #
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
    filename = "index.md"
    # start writing
    outsubfold = paste(outfold, foldername, sep="/")

    # start writing

    if (!file.exists(file.path(outsubfold, filename)) | overwrite) {
      fileConn <- file.path(outsubfold, filename)
      write("+++", fileConn)
      # write(fileConn)

      # Title and date
      write(paste0("title = \"", x[["title"]], "\""), fileConn, append = T)
      write(paste0("date = \"", anydate(x[["date"]]), "\""), fileConn, append = T)

      # Authors. Comma separated list, e.g. `["Bob Smith", "David Jones"]`.
      auth_hugo <- str_replace_all(x["author"], " and ", "\", \"")
      auth_hugo <- stringi::stri_trans_general(auth_hugo, "latin-ascii")
      write(paste0("authors = [\"", auth_hugo,"\"]"), fileConn, append = T)

      # Publication type. Legend:
      # 0 = Uncategorized, 1 = Conference paper, 2 = Journal article
      # 3 = Manuscript, 4 = Report, 5 = Book,  6 = Book section
      write(paste0("publication_types = [\"", x[["pubtype"]],"\"]"),
            fileConn, append = T)

      # Publication details: journal, volume, issue, page numbers and doi link
      publication <- x[["journal"]]
      if (!is.na(x[["volume"]])) publication <- paste0(publication,
                                                       ", (", x[["volume"]], ")")
      if (!is.na(x[["number"]])) publication <- paste0(publication,
                                                       ", ", x[["number"]])
      if (!is.na(x[["pages"]])) publication <- paste0(publication,
                                                      ", _pp. ", x[["pages"]], "_")
      if (!is.na(x[["doi"]])) publication <- paste0(publication,
                                                    ", ", paste0("https://doi.org/",
                                                                 x[["doi"]]))

      write(paste0("publication = \"", publication,"\""), fileConn, append = T)
      write(paste0("publication_short = \"", publication,"\""),fileConn, append = T)


      # TODO: FOR SOME REASON ABSTRACT IS NOT BEING READ IN from mypubs
      # Abstract and optional shortened version.
      if (abstract) {
        write(paste0("abstract = \"", x[["abstract"]],"\""), fileConn, append = T)
      } else {
        write("abstract = \"\"", fileConn, append = T)
      }
      write(paste0("abstract_short = \"","\""), fileConn, append = T)



      # other possible fields are kept empty. They can be customized later by
      # editing the created md

      write("image_preview = \"\"", fileConn, append = T)
      write("selected = false", fileConn, append = T)
      write("projects = []", fileConn, append = T)
      write("tags = []", fileConn, append = T)
      #links
      write(paste0("url_pdf = \"", x[["url"]],"\""), fileConn, append = T)
      write("url_preprint = \"\"", fileConn, append = T)
      write("url_code = \"\"", fileConn, append = T)
      write("url_dataset = \"\"", fileConn, append = T)
      write("url_project = \"\"", fileConn, append = T)
      write("url_slides = \"\"", fileConn, append = T)
      write("url_video = \"\"", fileConn, append = T)
      write("url_poster = \"\"", fileConn, append = T)
      write("url_source = \"\"", fileConn, append = T)
      #other stuff
      write("math = true", fileConn, append = T)
      write("highlight = true", fileConn, append = T)
      # Featured image
      write("[header]", fileConn, append = T)
      write("image = \"\"", fileConn, append = T)
      write("caption = \"\"", fileConn, append = T)

      write("+++", fileConn, append = T)
      # write(fileConn, append = T)
    }
    # convert entry back to data frame
    df_entry = as.data.frame(as.list(x), stringsAsFactors=FALSE) %>%
      column_to_rownames("rowname")

    # write cite.bib file to outsubfolder
    WriteBib(as.BibEntry(df_entry[1,]), paste(outsubfold, "cite.bib", sep="/"))
  }
  # apply the "create_md" function over the publications list to generate
  # the different "md" files.
  # x<-mypubs
  apply(mypubs, FUN = function(x) create_md(x), MARGIN = 1)
# }


  # To rename the pdfs
  # directory<-"./EMB_publications/files"
  path = "./content/publication/"
  folder_names<-list.files(path)
  file_paths<-paste(path,folder_names,sep="")
    # directory<-as.data.frame(directory)
  # list.files(file_paths) # only file name
  # list.files(file_paths, full.names=TRUE) # full path
  old_file_names<-list.files(file_paths, full.names=TRUE) # full path
  # get only the ones that are pdf
  old_file_names<-Filter(function(x) str_detect(x, "pdf$"), old_file_names)
  pathsplit<-str_split(old_file_names, "/", simplify = TRUE)
  new_file_names<-paste(pathsplit[,1],pathsplit[,2],pathsplit[,3],pathsplit[,4],pathsplit[,4],sep="/")
  new_file_names<-paste(new_file_names,".pdf",sep="")
  file.rename(old_file_names,new_file_names)



  #
  # new_name_fcn <- function(x) {
  #   new_name<-paste(x, list.files(x),sep="/")
  #   return(new_name)
  # }
  #
  # library(purrr)
  # x <- nrow(directory)
  #  <- map(1:x, paste(directory, list.files[.directory,sep="/"))
  #
  # file_names_new<-new_name_fcn(directory)
  # new_name_fcn(x)<-paste(x, list.files(x),sep="/")
  # file_names_new<-sapply(directory,new_name_fcn)
  directory<-directory[10]
  file_names_old<-list.files(directory)
  file_names_new <- paste0(folder_names,".pdf")
  file.rename(
    paste0(directory,file_names_old,sep="/"),       # Rename files
              paste0(directory[10], "/",file_names_new[10])

  file.rename("./EMB_publications/files/3739/3739.pdf",
              "./EMB_publications/files/3739/Araujo_etal_2013_PlantEcology.pdf")


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
