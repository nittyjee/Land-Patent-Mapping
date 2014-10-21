Land-Patent-Mapping
===================

###Introduction
For an introduction to this effort, please read the following blog post:
http://mapstoryblog.thenittygritty.org/

If you would like to get involved with this project, or have any comments or questions, please feel free to contact:
Nitin Gadia
nitingadia@mapstory.org

###Process:
This is a repository of the sql queries needed for creating mapstories of US land patents.
Each state will be processed separately as follows:
- The Public Land Survey System (PLSS) data will be found. The following are needed: townships (township and range), sections, quarter-sections, and quarter-quarter sections (aliquots, the smallest plot of land that was sold as land patents).
- The land patent data will be downloaded for the corresponding state. The data is here:
http://www.glorecords.blm.gov/BulkData/default.aspx
For more info on this data:
http://www.glorecords.blm.gov/reference/default.aspx#id=07_Web_Services_And_Bulk_Data|01_Web_Services_Introduction
- Using SQL queries, a csv file will be generated of the Land Patent Descriptions that can be used to join to the GIS data. Each state will have a separate SQL query file.
