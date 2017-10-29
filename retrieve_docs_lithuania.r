##################################################################################################
# Automatically Retrieve Documents of the Lithuanian Parliament
# Seimas Transcript Homepage: http://www3.lrs.lt/pls/inter/w5_sale.kad_ses
# Authors: JP + RBS (R Script), CM (Instructions for Manual Download)
# Date: October 29, 2017
##################################################################################################

# Load packages
library(rvest)			# if package is not already installed: install.packages("rvest")

# Specify paths
path.output <- "" # please specify

# Extract the relevant higher level URLs
##################################################################################################
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

# Download a test document
##################################################################################################

## URL of stenograma site (stenograma = protocols)
url.stenograma <- read_html(url.level2.list[[1]], encoding = "latin1") %>%
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
download.file(pdf.file, destfile = paste0(path.output, "test.pdf"))


# Automate steps
##################################################################################################

# Function to extract Stenograma URLs (from higher level URLs)
extract.url.stenograma <- function(x) {
	url.stenograma <- read_html(x, encoding = "latin1") %>%
	html_node(xpath = '//a[text()="Stenograma"]') %>%
	html_attr("href")
	return(url.stenograma)
}

# Function extract PDF path
extract.pdf.path <- function(x) {
	pdf.path <- read_html(x) %>%
		html_node(xpath = '//a[contains(@href,"ISO_PDF")]') %>%
	  	html_attr('href')
	pdf.file <- paste0("https://e-seimas.lrs.lt", pdf.path)
	return(pdf.file)
}

# Empty lists to store Stenograma URLs and links to PDF files
all.url.stenograma <-NULL
all.pdf.files <- NULL

# Extract all Stenograma URLs	
all.url.stenograma <- lapply(url.level2.list[1:10], extract.url.stenograma)
all.url.stenograma

# Extract path to pdf files
all.pdf.files <- lapply(all.url.stenograma, extract.pdf.path)
all.pdf.files

# Download and save documents
for (i in 1:length(all.pdf.files)) {
	download.file(all.pdf.files[[1]], destfile = paste0(path.output, "filename", i, ".pdf"))	
}
	












