##################################################################################################
# Downloading documents from:
# Seimas Transcript Homepage: http://www3.lrs.lt/pls/inter/w5_sale.kad_ses
# Author: JP + RBS
# Date: October 29, 2017
##################################################################################################

# Load packages
library(rvest)

# Download a test document
##################################################################################################

# Extract the relevant URLs

## First level URLs (actually not needed because IDs on second level seem to be systematic)
# url.level1.list <- NULL
# for (i in 1:110) {
#		url.level1.list[[i]] <- paste0("http://www3.lrs.lt/pls/inter/w5_sale.ses_pos?p_ses_id=", i)
#}

## Second level URLs
url.level2.list <- NULL
for (i in 500000:501187) {
		url.level2.list[[i-499999]] <- paste0("http://www3.lrs.lt/pls/inter/w5_sale.fakt_pos?p_fakt_pos_id=-", i)
}
url.level2.list 

## URL of stenograma site
url.overview <- url.level2.list[[2]]
url.stenograma <- read_html(url.overview, encoding = "latin1") %>%
  html_node(xpath = '//a[text()="Stenograma"]') %>%
  html_attr("href")
url.stenograma

# Extract path to pdf file
pdf.path <- read_html(url.stenograma) %>%
  html_node(xpath = '/html/body/form/div[2]/div[2]/div[4]/div[1]/a[3]') %>%
  html_attr('href')
pdf.path
pdf.file <- paste0("https://e-seimas.lrs.lt", pdf.path)

# Download and save document
download.file(pdf.file, destfile = paste0("/Users/partheym/Desktop/Downloaded_Documents/", "test.pdf"))


# Automate steps
##################################################################################################

# Lists for Stenograma URLs and PDF paths
all.url.stenograma <-NULL

# Function to extract URLs (from level 2 URLs)
extract.url.stenograma <- function(x) {
	url.stenograma <- read_html(x, encoding = "latin1") %>%
	html_node(xpath = '//a[text()="Stenograma"]') %>%
	html_attr("href")
	return(url.stenograma)
}

# Extract all URLs	
all.url.stenograma <- lapply(url.level2.list[1:10], extract.url.stenograma)
all.url.stenograma

# Function extract PDF path
extract.pdf.path <- function(x) {
	pdf.path <- read_html(x) %>%
		html_node(xpath = '//a[contains(@href,"ISO_PDF")]') %>%
	  	html_attr('href')
	pdf.file <- paste0("https://e-seimas.lrs.lt", pdf.path)
	return(pdf.file)
}

# Extract path to pdf files
all.pdf.files <- lapply(all.url.stenograma, extract.pdf.path)
all.pdf.files

# Download and save document
for (i in 1:length(all.pdf.files)) {
	download.file(all.pdf.files[[1]], destfile = paste0("/Users/partheym/Desktop/Downloaded_Documents/", "filename", i, ".pdf"))	
}
	












