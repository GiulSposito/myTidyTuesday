---
title: "week02 - Analytics Technologies"
output:
  html_document:
    keep_md: yes
---

# Analytical Technologies

## Data Storage and Databases

+ Each source systems usually has its own storage, but ...
  + Optimized for functional performance, not data extraction & analysis
    + Online Transactional Processing (OLTP)  vs.
    + Online Analytical Processing (OLAP) 
  + Typically has a lot more stuff than we are interested in
  + Risky to access directly; ‘back end’ load can impact ‘front end’ stability
  + Retention times vary; data may not be stored locally for very long
+ Sometimes we actually do connect directly to source systems, or even intercept data as it ‘streams’ through a connection
+ However, the solution is usually to gather data into a separate storage location
May be centralized, semi-centralized, or ‘virtualized’

### File Systems

+ Think of your own computer; can essentially put anything we want in there and just note it’s name and location
+ Handles all sorts of information, including ‘unstructured’ data really well
+ Primary limitation is in ‘readiness’ for use and the ability to interconnect different elements in a meaningful way
+ The Hadoop Distributed File System (HDFS) is a ‘Big Data’ manifestation of the idea, using massively parallel processing on relatively inexpensive infrastructure to efficiently store large amounts of varied information

+ Delimited Text Files
  + Data stored as text, with breaks between fields & rows defined by  ‘delimiters’ - specific characters or formatting codes
  + Comma-separated value (CSV), Tab-delimited and Pipe-delimited (|) most common
+ Extensible Markup Language (XML) Files
  + Flexible structure for encoding documents & data, especially for Web applications
+ Log Files
  + Largely nonstandard output from machine data sources, including the Web
  + Generally require some sort of parser to interpret
+ Application-Specific Files
  + Excel Files
  + Specialized files like SAS,SPSS or Tableau files
