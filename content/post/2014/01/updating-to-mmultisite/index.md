---
title: "Converting to Wordpress for Course Management"
date: "2014-01-03"
categories: 
  - "bruna-lab-teaching"
tags: 
  - "teaching-2"
  - "wordpress"
---

For a number of reasons not worth going into I dislike using our university course management system (CMS). I therefore decided to follow the suggestions in [this great post](http://chronicle.com/blogs/profhacker/using-a-wordpress-multisite-network-for-class-webpages/38710) by Ryan Cordell from the Chronicle's awesome [ProfHacker blog](http://chronicle.com/blogs/profhacker/) and start using Wordpress as a CMS. One option for doing so was to use a free [wordpress.com](http://wordpress.com) site for each class, but that would mean ads pop up on pages and there is less flexibility with how pages are built. On the other hand, I could go for the ad-free wordpress.org option, but I would have to pay for hosting and a domain name for each site.  Solution?  Since our [lab website](http://brunalab.org) is already built with [wordpress.org](http://wordpress.org) and I pay for a domain name and hosting, I opted instead to test my WP skills and convert my site to a [Multisite Network](http://premium.wpmudev.org/blog/wordpress-multisite-guide/). This greatly streamlines the management of multiple sites if you want them to have different looks, plugins, and themes. It turned out to be relatively easy, though I did struggle for a bit to fix some broken links and categories.  If you are interested in using Wordpress to create course web pages, and already use a self-hosted Wordpress site for your lab or blog, then I highly recommend investing a few hours and making the switch. JUST BE SURE TO SAVE A COPY OF YOUR ORIGINAL WP-CONFIG AND HTACCESS FILES IN CASE YOU NEED TO DEBUG. Which I needed to do (the links, categories, and tags that were broken were because I made a mistake in the htaccess file).

Some resources to get started.

- From the codex: [creating a multisite network](http://codex.wordpress.org/Create_A_Network)
- A couple of multisite guides written especially for n00bs like me: [here](http://mashable.com/2012/07/26/beginner-guide-wordpress-multisite/) and [here](http://premium.wpmudev.org/blog/wordpress-multisite-guide/)
- from the codex: [debugging the installation of a multisite network](http://codex.wordpress.org/Debugging_a_WordPress_Network):

 

Good luck!

PS word to the wise - make sure you aren't violating FERPA when you opt out of your university's CMS. Don't post grades or similar on line. Even posting student names and contact info without a waiver may be a FERPA violation. [Check your institutions FERPA guidelines](http://www.registrar.ufl.edu/ferpa.html).
