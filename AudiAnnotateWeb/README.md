# README

## AudiAnnotate is a project to publish and share annotations on audiovisual files. 
More on the project is available at the [HiPSTAS](http://hipstas.org/audiannotate/) website.

Documentation on using AudiAnnotate is available here: https://hipstas.github.io/audi-annotate/

## To install

* If you want to run your own AudiAnnotate server, clone this repository. 

* AudiAnnotate requires ruby-2.6.5.

* Because AudiAnnotate stores all data as IIIF manifests and Web Annotations within static sites on Github, you won't need a database. 

* You will need to setup a GitHub OAuth App in your GitHub account, and add the key and secret to the `config\initializer\01audiannotate.rb` file.
