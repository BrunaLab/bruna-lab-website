---
title: "The opportunity cost of my #OpenScience was 36 hours + $690 (UPDATED)"
date: "2014-09-04"
categories: 
  - "bruna-lab-research"
tags: 
  - "data-archiving"
  - "data-management"
  - "ecology"
  - "github"
  - "open-access"
  - "open-science"
  - "peerj"
  - "plos-one"
  - "r"
  - "research"
---

Several years ago I made a personal commitment to [Open Science](http://en.wikipedia.org/wiki/Open_science): I try to publish papers on which I am the lead author on in [open access journals](http://brunalab.org/publications/publications/) and I [archive data](http://brunalab.org/publications/datasets/) for these papers in Dryad, Figshare and other repositories. Recently I started [posting preprints](https://peerj.com/EMBruna/) of my manuscripts as well, and I encourage authors submitting to the journal of which I am Editor [to do the same](http://biotropica.org/biotropica-will-accept-manuscripts-submitted-to-preprint-archives/).  The thing that I had been most hesitant about was posting my code - I've been programming for a long time, but I'm not the most elegant of programmers _(NB: massive understatement)_, so to be honest I was a little worried people would mock my efforts. I finally got over that, stumbled through some GitHub tutorials, and as a result you can now [go over there to see the code](https://github.com/embruna) used to do the analyses and generate figures for my two most recent articles, as well as for a few projects in progress.

 

Although I feel good about having done this, it's also become clear to me that there is a real [opportunity cost](http://en.wikipedia.org/wiki/Opportunity_cost) to Open Science about which I think we need to be honest with our students.  **There are actually multiple opportunity costs. One potential one is lost future papers**. While I often hear the about the possibility of getting scooped because we post our data, however, concrete examples seem hard to come by and I just don't buy it.  Another is lost status and opportunities: Our profession still prioritizes articles in publications like _Science,_ _Nature_, or _PNAS_, so as a candidate on the job market you are still way ahead of the pack if your paper is in one of those journals than if it is in _PeerJ_ or _PLoS ONE_ (I'm not saying that's right, only that it's true). I think this is a more legitimate OC, and one that will be with us for a while, unfortunately.  **The opportunity cost I'm talking about here is more diffuse:** **the time I devoted to archiving data and code could have been spent on other activities that have greater rewards **under the current system****. **I could have also used the money I spent on archiving fees and publishing in a journal with an OA option to advance ongoing research in the lab.**

For my most recent paper I did the math:

1. Double checking the main dataset and doing some reformatting to prepare it for submission to Dryad: **5 hours** _(NB: I had already invested a fair amount of time in reorganization of the dataset to get it in line with the suggestions of [Borer et al.](http://www.esajournals.org/doi/abs/10.1890/0012-9623-90.2.205) _because I use R for analyses and to generate (many of) the figures. Unfortunately,_ we didn't give much thought to data oranization when we originally entered the data, so the result was a very complex and inefficient set of files)._
2. Realizing I probably needed a second file to complement the first one (the main file I was going to upload includes a list of 40 demographic plots, but not the specific locations in the reserve where these plots are located), creating the CSV file using the original data set, thinking there was a mistake in a few of the points, trying to figure it out, and realizing there wasn't a mistake after all, and preparing the metadata file: **3 hours**
3. Submission of these two files and the metadata to Dryad: **45 minutes**
4. Preparing a figure of these locations (a map, since not everyone is familiar with the layout of trails at the [BDFFP](https://www.inpa.gov.br/pdbff/)): **1 hour**
5. Submission of this map to Figshare: **15 minutes**
6. Getting up the courage to post my code to GitHub, looking over my code, rewriting all the comments and annotations so that someone other than me understood them to the point they could see what I did step-by-step, deciding to take my long inefficient scripts and simplifying them by creating functions to do some of the redundant stuff (which I should have done in the first place), and uploading to GitHub: **25 hours**
7. [Freezing a version of my code on github and getting a DOI for it using Zenodo](https://guides.github.com/activities/citable-code/) (as per the suggestion of [@noamross](https://twitter.com/noamross/status/507581501395841026); the DOI makes it easier to cite in journals and allows for people to better see the changes in versions of code over time): **30 minutes**
8. Editing the Endnote output styles for Ecology to include bibliography templates for "Computer Program" and "Dataset": **30 minutes**
9. Cost of archiving in Dryad: **US$90**
10. Page Charges: Estimated article lengths 8 pages @ US$75 per page: **$600**

**TOTAL: 36 hours\* and US$690.**

**_This is not a trivial_ _amount of time_:** it's almost a full week of work spent on archiving data and code for one  paper. That was precious time I could have spent preparing for classes, working on other manuscripts, writing grant proposals, going to the gym, staring longingly at the sax I haven't played in months...whatever.  And bear in mind, this quick calculation also doesn't include any of the one-time financial and time investments that are amortized over multiple submissions, including:

1. Time spent registering with Dryad
2. Time spent registering with Figshare
3. Time spent learning how to use R/MATLAB/Python/whatever for analyses instead of Systat or JMP so that the scripts are available for others to use and reproduce results
4. Time spent learning to use Git and the RStudio/GitHub tools to that code are available.
5. Time spent learning how to organize data / metadata for the purposes of archiving (e.g., reading [Borer et al.](http://www.esajournals.org/doi/abs/10.1890/0012-9623-90.2.205) and the DataONE [primer on best practices for data management)](https://www.dataone.org/best-practices).
6. Note also that the cost could have been even higher if I had published in, for example, [_PLoS ONE_](http://www.plos.org/publications/publication-fees/)

Granted, the cost could also have been lower. I could have reduced the price US$200 by publishing in _[PeerJ](https://peerj.com/pricing/)_ or by $600 if I had published in [_Biotropica_](http://biotropica.org/), which waives page charges for ATBC members.  In addition, the time spent on these tasks will decrease as I become a better programmer and because in the future datasets we collect will be well organized at the start, diminishing the need for reorganization at the time of deposition.  Still, **this past week was a reminder of what I see as being the major hurdle to overcome when trying to convince others that we should strive for Open Science: it is a major pain in the ass and is really expensive, in terms of both the money and amount of time required**.  Without a better system of incentives from the community for archiving data and code, 35 hours and $690 may be too much effort and money for most people. We need to recognize that reality and identify creative ways to change the current system, because let's get real -  telling people "[you should because it's the right thing to do](http://isisthescientist.com/2013/08/28/the-morality-of-open-access-vs-increasing-diversity/)" and assuming that's enough just isn't going to cut it (not that [a compliment from Ethan](https://twitter.com/BrunaLab/status/507153366024474624) isn't reward enough for me, but I already have tenure, so...). [We also _really_ need to teach our students how to do this **_now_**](http://datapub.cdlib.org/2013/02/07/data-management-education/); it's much easier if you develop good habits early.  Finally, it's also important for me to remember that it will get cheaper and cheaper every time I do it (e.g., preparing metadata was a snap this time because I used the template from my prior submissions to Dryad).

Regardless, let's be mindful when advocating Open Science - it's hard, expensive, and comes with both accounting and opportunity costs.  If we want to make Open Science the norm, we need to find ways to minimize these actual and opportunity costs, not just promote incentives for doing engaging in OS.  **We need to stop telling people "You should" and get better at telling people "Here's how".**

_\[edited 4 September 2014 @ 9:44 pm for clarity and to correct some typos\]_

_\[upated 10 September 2014 @ 9:06 am for clarity and after one hour was spent on activities 7 and 8\]_

 

_**Photo by [Epsos .de](https://www.flickr.com/photos/epsos/8463683689/in/photolist-dTUAhR-dSK3tm-dUSc9a-dSZe91-9Jw4ZA-9ZA9J6-6ccS2i-7r8hxv-5tg5Pp-dmyfCP-tXnZB-bzncK1-eMn8HQ-cnchKE-9PSLHY-dAPegg-Ed22H-eLoLxb-5Zavff-5wBq3U-74Psd3-c4Cjd-fKKcRD-4Xqw51-57sTQw-8FFzkU-4G3UB9-k6jE7s-fJBFfk-7fNUg1-8vBVUB-5u4pbp-asMv8U-bkAe6L-78Pw7g-9AiEUa-6JFB4z-eEuk9H-8F1AbR-8F1Adr-8F4L71-dMQTp1-8vBW8g-eL9mU6-7E3U4g-7pM32D-621Ks1-hWQeQb-j4rtWV-5RDVrK) ([CC BY 2.0](https://creativecommons.org/licenses/by/2.0/))**_
