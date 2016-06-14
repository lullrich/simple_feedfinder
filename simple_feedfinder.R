library("rvest")
library("lubridate")

urls <- c('http://wsj.com',
          'http://www.allure.com',
          'http://www.theinsider.com',
          'http://cnet.com',
          'http://venturebeat.com',
          'http://www.topspeed.com',
          'http://thedailyworld.com',
          'http://games.com',
          'http://www.religionnews.com',
          'http://blogs.berkeley.edu',
          'http://www.sbnation.com',
          'http://www.polygon.com',
          'http://nytimes.com',
          'http://www.thefrisky.com',
          'http://telegram.com',
          'http://yahoo.com',
          'http://www.nbcnews.com',
          'http://thedailypage.com',
          'http://www.popsci.com',
          'http://www.pbs.org')

###########################################

get_links <- function(base_url) {
  message(paste("getting", base_url))
  
  res <- try(read_html(base_url), TRUE)
  
  if (is.list(res)) {
    message("response ok, looking for feeds")
    
    res <- html_nodes(res, xpath = "//link[contains(@type, 'rss') or c
                      ontains(@type, 'atom') or contains(@type, 'rdf')]") %>% 
      sapply(html_attr, "href") %>% 
      Filter(is.character, .) %>% 
      sapply(url_absolute, base_url) %>% 
      unique()
    
    return(res)
  }
  else {
    message("skipping")
    warning(paste("skipped", base_url, "- not responding in time."), call. = FALSE)
    
    return(NULL)
  }
}

st <- now()
feeds <- lapply(urls, get_links) %>% Filter(is.character, .) %>% unlist()  
et <- now()
et-st
message(paste("Found", length(feeds), "feeds in", length(urls), "URLs."))
feeds
