---
title: "Data  Management Lab Meeting"
date: "2014-09-04"
categories: 
  - "bruna-lab-teaching"
tags: 
  - "data-archiving"
  - "data-management"
  - "open-science"
---

For lab meeting next week you should read through these papers. I suggest reading them in order (you can Skim Michener and  Strasser et al. - both detail rich, but for lab meeting Borer et al. and White et al. will be the most useful.

1. Bruna, E. M. 2010. Journals can advance tropical biology and conservation by requiring data archiving.  _Biotropica_ 42(4): 399–401: [Bruna\_2010\_Biotropica\_Editorial](http://brunalab.org/wp-content/uploads/2014/09/Bruna_2010_Biotropica_Editorial.pdf)
2. Borer, E. T., E. W. Seabloom, M. B. Jones, and M. Schildhauer. 2009. Some Simple Guidelines for Effective Data Management. Bulletin of the Ecological Society of America: 205-214.:   [Borer\_etal\_2009\_BullESA](http://brunalab.org/wp-content/uploads/2014/09/Borer_etal_2009_BullESA.pdf)
3. White EP, Baldridge E, Brym ZT, Locey KJ, McGlinn DJ, Supp SR.  2013.  [Nine simple ways to make it easier to (re)use your data](http://library.queensu.ca/ojs/index.php/IEE/article/view/4608). Ideas in Ecology and Evolution. 6(2):1-10.[White\_etal\_2013\_IEE](http://brunalab.org/wp-content/uploads/2014/09/White_etal_2013_IEE.pdf)
4. MC Whitlock. 2010. Data archiving in ecology and evolution: best practices. _Trends in Ecology & Evolution_. 26 (2), p. 61-65.: [Whitlock\_2011\_TREE](http://brunalab.org/wp-content/uploads/2014/09/Whitlock_2011_TREE.pdf)
5. CA Strasser, R Cook, W Michener, and A Budden. 2012. Primer on Data Management: What You Always Wanted to Know. A DataONE publication, available via the California Digital Library.: [Strasser\_etal\_DataManagement\_2011\_DataOne](http://brunalab.org/wp-content/uploads/2014/09/Strasser_etal_DataManagement_2011_DataOne.pdf) (can also be found on Data ONE's Best Practices for Data Management [website](https://www.dataone.org/best-practices))
6. Michener, W.K., Brunt, J.W., Helly, J., Kirchner, T.B., Stafford, S.G., 1997. Non-geospatial metadata for the ecological sciences. Ecological Applications 7, 330–342.: [Michener\_etal\_1997\_EcolApplications](http://brunalab.org/wp-content/uploads/2014/09/Michener_etal_1997_EcolApplications.pdf)
7. [**Sample Metadata and Data Files**](http://datadryad.org/resource/doi:10.5061/dryad.h6t7g): Bruna EM, Izzo TJ, Inouye BD, Uriarte M, and Vasconcelos H. 2011. Data from: Asymmetric dispersal and colonization success of Amazonian plant-ants queens. PLoS ONE. Dryad Digital Repository. doi:10.5061/dryad.h6t7g)
8. [DropBox](https://www.dropbox.com/sh/ovnro8n8q24kyl6/AACGEe75dzHIXrt3FYioZ_4_a?dl=0)

(for fun you might read [this blog post](http://datapub.cdlib.org/2013/02/07/data-management-education/) by Carly Strasser, too - it's about training undergrads in Ecology in data management...strictly optional, however).

 **This is the context and some of the issues to consider regarding data management and archiving.**

Major goal of science is reproducibility. What does it take to reproduce someone’s analyses?

1. Our papers integrate different types of complex data:
    1. climate, measurements, lists of diversity, experiments, observations, gps points
    2. on these we layer analyses, statistical models, computer code, etc. THESE ARE ASLO DATA
2. What happens to these data and analyses once paper is published? Fig. 1 of Michener.
3. Who cares? Why is it important? A: CNPq, NSF, other researchers, future generations
4. The right path: data management -> data use-> data sharing (archiving) -> data reuse
5. How can data be reused by others?
    1. Validation of results
    2. Meta analyses
    3. New questions
    4. Increases in citation rates of papers
    5. New opportunities for teaching
    6. Reduces data loss
6. First key step – data collection and organization
    1. Decide on a naming scheme, create a key, make it unique for each sample
    2. Standardize! Consistent within columns: only text, only numbers, , olny dates. Use consistent codes, formats, etc.
    3. Reduce chances of errors by using excel lists to constrain choices for data entry
    4. Identify missing data with a code
    5. Create tables with codes, site data, etc.
    6. Excel is great for data analysis, terrible for data archiving
    7. Relational databases – MySQL and others are free, essential for large and complex dataset, useful for all others
    8. Use descriptive file names (organism\_site\_year\_whatmeasured). Recall to tell people about dates and how to record
7. Quality control
    1. minimize manual data entry – cuts down on mistakes
    2. use double entry or spot check records
    3. use a database, document changes
    4. after data entry, look for outliers, anomalous values, do statistical summaries
8. Metadata – must know who created the data,whatisthe content of dataset. When was it created, where was it collected, how developed, why developed?
    1. Metadata basics: Michner, Borer
    2. Metadata standards:EML, see others.   [http://knb.ecoinformatics.org/software/eml/](http://knb.ecoinformatics.org/software/eml/)
    3. Can use programs like [Morpho](https://www.dataone.org/software-tools/morpho) (EML),
9. Analysis
    1. Keep raw data raw, use scripts to manipulate. Save them with the data, be sure to annotate well.
    2. Workflows: how you get from raw data to the final product of research (flow charts)
    3. R/SAS scripts – code is great – well documented code easier to review, remember, share, and repeat
    4. Workflows enable reproducibility (can someone independently validate your findings), transparency (can others understand how you arrived at your results), executability (can others re-run or re-use your analyses)
10.  Data stewardship and reuse
    1. 20 year rule – metadata and accompanying data should be written for a user 20 years into the future
    2. Use stable, non-proprietary formats (csv, txt, tiff)
    3. Create backup copies
    4. Periodically test ability to restore information
    5. Store data in a repository: Institutional archive or discipline/specialty archive
11. Data citation – allows readers to find data products, promotes reproducibility, better measure of research impact
12. Data management plan – what is it? Why do it?
13. E notebooks, online science (notebook, ORNL eNote, Evernote, Google Docs, Blogs, Wikis, theLabNotebook.com, Notebookmaker
14. Databib- list of data repositories
15. Importance of doi: precise identification, credit data producers and publishers, link from literature to the data, research metrics for datasets
16. DataOne.org – tutorials, database of best practices and tools, primer on data managment, investigator toolkit

Image: [_Numbers_ by Andy Maguire](https://www.flickr.com/photos/andymag/10947544804/in/photolist-hFp2Eu-ZZpp-oFSiZZ-ifz6wb-DNnYH-cxQS1s-cQaNRQ-MKtqQ-6B5xnC-5pp76g-fmHjf2-5CLx4U-cQaNbG-axZ5BR-4vRmLx-e9qvGs-63Bumf-7Dpz8d-ca3dTQ-favGwY-ogCaxD-7BsRVK-4et6Ko-b8x1m2-cdkJ3L-6hkJWo-5oWtpp-5TeoHJ-bYSYDU-8cXnZa-7ixpfM-agcarV-bqa3wy-7Rw54C-dgNYry-cdkJ4A-cdkHUd-bVYosr-dVCk39-dFbyv8-dh3UaM-h3vDQN-5brvhC-26hoV8-bQojap-6JK1fN-61QCrn-fS7zyA-9Bv1ED-75WmeY) ([CC BY 2.0](https://creativecommons.org/licenses/by/2.0/))
