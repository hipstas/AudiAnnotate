[AudiAnnotate Home](index.md) | [Workshop Information](workshop.md)


# Getting Started: Workflow Documentation and Demonstration Videos

* [AudiAnnotate Overview](#overview)
* [Part 1: Creating a Project](#project)
* [Part 2: Exporting for Preservation and Publication](#exportprespub)
* [Part 3: Collaborative Project Scenarios](#collaborative)
* [Appendix](#appendix)
* [Supplemental Documentation](#supplemental)

* [Demonstration Videos](#vid)

    1\. [Annotating with Audacity](https://drive.google.com/file/d/1dpOkBX2-ABIzM7Z2Anle7HHQTr24mN39/view?usp=sharing)

    2\. [Creating manifests with AudiAnnotate](https://drive.google.com/file/d/1LAHGDO1fqnN3Y6emXB1FJUi1g8tSk9a7/view?usp=sharing)

    3\. [Associating annotations with AudiAnnotate](https://drive.google.com/file/d/1L_fElYnA96q4WQFVuBmSJ80hXSESYDoJ/view?usp=sharing)


<a name="overview"></a>
### AudiAnnotate Overview

The AudiAnnotate  application (AA)  uses GitHub to access data and build project repositories. It does not store data, but rather, allows you to interact easily with data in GitHub. To do this, AA creates a IIIF manifest that is stored in GitHub. This manifest includes the information you will provide when you build your project, upload a URL to an audiovisual item and associated metadata, and add annotation layers.

<a name="project"></a>
### Part 1: Creating a Project
The instructions below will guide you through building a project with the AA. For further instructions on creating annotations or creating an audio URL, please refer to our supplemental documentation here. 

#### Creating a Project
 1. You will need to have a GitHub account. To create an account on GitHub:
    - Navigate to [GitHub](https://github.com/join).
    - You will provide a username, email address, and password to create your GitHub account.
    
 2. Navigate to the AudiAnnotate Application (AA).
    - You will be prompted to log in through GitHub. (Make sure to allow the app to authorize AA. This means that AA will be allowed to manage and write files on your behalf. )
    - Enter your GitHub password to log in.
    
 3. Select “New Project.” 

On this page, you will add the metadata to allow AA to generate your project. AA creates a repository or “repo” in GitHub, which is your project’s storage space for any files related to your project.  

   - Add a “Title.” This is the project name, and the name of the GitHub repository that will be generated in this process. This title will also appear as the project name on the AA site under “My Projects.”
   - Add a description of your project.
   - Add a project slug. This becomes the GitHub repository url. Note, spaces are not recognized. Please use hyphens instead of spaces.


 4. Select “Create Project.”This contacts GitHub and generates the repository. 
Now you have created an AudiAnnotate project, with all information stored in a GitHub repository. The next step will be to build the IIIF Manifest, which allows you to associate audiovisual material and annotations with your project.

#### Adding an Audiovisual Item
 5. On the Audio Files page, select “Create Item Manifest.” This creates a new item in the IIIF manifest associated with your project. This is where you will add metadata for your audiovisual material.
    - Add a label for your audiovisual file. The label refers to the title of the audiovisual material to which you will be providing a URL and should be human-readable.
    - Add “Audio File URL.” This is the direct link to the audiovisual file.
    - Add the duration of your audiovisual file. Duration can be input in minutes:seconds or hours:minutes:seconds. 
    - Item Homepage URL is the item page where the audiovisual material was retrieved. This, and the fields below, will add provenance metadata to the IIIF manifest.
    - Provider name is the organization that made the recording available.
    - Provider URL is a link to the organization that made this audiovisual material available.

 6. Once metadata has been added, select “Save” to save reference and metadata to this item in the IIF manifest.
 

#### Adding Annotations
 
***If you are continuing from step 6 above***

Now, you’re on the annotations page, where you can manage your project’s annotations. Annotations are uploaded to AudiAnnotate via .tsv file(s). Each .tsv file uploaded to your AudiAnnotate project is one annotation layer. Your resulting project page may present one or more annotation layers.

 7. Add a label for the name of your annotation layer.
 8. Select “Choose file.” Choose the .tsv (or .txt from Audacity) that you would like to add to your project.
 9. Select  “Add” at the bottom of the page. This will generate your annotations and align them in the IIIF manifest with the audiovisual file.
 10. Select “Add” at the bottom of the page. You may now add additional annotation layers to the same audiovisual item.

***If you are accessing an existing project to add annotations:***

 1. Sign in to AudiAnnotate.
 2. Select “My Projects” in the upper right corner.
 3. Select “Edit” on the tile that corresponds to the project to which you would like to add annotations.
 4. Select the title of the audiovisual file to which you would like to associate annotations.
 5. Follow steps above to add annotations.

#### Importing an Existing IIIF Manifest

 1. Log into AudiAnnotate and select “New Project” and follow the steps above. You can also navigate to an existing project tile and select “Edit.” 
 2. Select “Import Existing Manifest”.
 3. Here, you can include an external item in your manifest by providing a manifest URL. Paste the URL into the field, then select “Save.”


<a name="exportprespub"></a>
### Part 2: Exporting for Preservation and Publication

Because AudiAnnotate project sites are built using Jekyll, a static site generator, you can export them from Github and preserve or publish elsewhere.  

To export from Github, go to the repository page and look for the green “Code” button.  Select “Download ZIP”:

<!--- [add image*] --->

#### Using the Export for Preservation

1. Unzip the file from the previous step.  In the top level directory run “jekyll build”.  This generates the static web pages as html files. Jekyll build does not create the correct filenames for IIIF manifests, so each directory within the generated site will have a manifest.json.html file instead of the correct manifest.json file.
2. Rename the files to remove the .html extension, which will allow the A/V player to work (provided that the media is still available).
3. Zip up the directory again, and place it in your preservation system.

#### Using the Export for Publication Elsewhere

You can serve a Jekyll site on a variety of web hosts or your own web server.  [This list](https://jekyllrb.com/docs/deployment/third-party/) is a good starting point, or contact the IT staff at your institution for other options.  

<a name="collaborative"></a>
### Part 3: Collaborative Project Scenarios

#### Using Hypothesis to Annotate an AudiAnnotate Project

[Hypothesis](https://web.hypothes.is/about/) is “a conversation layer over the entire web that works everywhere, without needing implementation by any underlying site.” Integrating Hypothesis with an AudiAnnotate project allows for a layer of commentary on top of AudiAnnotate annotations from multiple contributors. When annotating with Hypothesis, you can annotate in a group, individually, privately, or publicly.

***Creating a Hypothesis account***

1. Navigate to [Hypothesis](https://web.hypothes.is/about/).
2. Select “Create a Free Account” and follow the prompts.
3. You’ll also need to follow [these instructions](https://web.hypothes.is/start/) to install the chrome extension or bookmarklet.

***Creating a group on Hypothesis***

1. Navigate to Hypothesis and select “Log in”.
2. On your profile page, select the dropdown arrow next to “Groups.”
3. Select “Create new group” and name your group.
4. From the group page, you can now share the invitation link to invite others to annotate in your group.

***Annotating with Hypothesis***

1. Navigate to your AudiAnnotate project page. ([This is an example](https://tanyaclement.github.io/sexton_sweetbriar_1966/anne-sexton-class-visit-at-sweetbriar-college-1966/#?c=&m=&s=&cv=) GitHub Pages project page.)
2. Select the Hypothesis bookmarklet. <!--- [add image*] --->
3. Select the arrow on the right side of your screen to expand your view. <!--- [add image*] --->
4. If you do not see the  group, select log in at the upper right of the window. 
5. Select the  dropdown arrow next to “My Annotations,” and select your group. <!--- [add image*] --->
6. Next, highlight text on the page you would like to annotate. A small bubble will pop-up that invites you to annotate or highlight. Select “annotate.” <!--- [add image*] --->
7. In the window on the right, you can add an annotation: <!--- [add image*] --->
8. Select “Post to [Group Name]”; when you hover and select on the place you annotated, you can view the annotation in the right sidebar
9. You can also add tags in the field that says “add new tags,” by typing in text and selecting the enter key. <!--- [add image*] --->

#### Advanced AudiAnnotate Collaborative Project Scenarios

The scenarios below require some  familiarity with GitHub, but the instructions will guide you through initial setup of your collaborative projects. There are two methods of collaborative projects. The simplest method is the Shared Repository, where one user creates an AudiAnnotate project and additional users are manually invited to that project by the initial user. The Fork and Pull method is a bit more complex, and involves one user creating a repository and additional collaborators making a copy of that repository using GitHub’s fork (i.e., copy) feature, making changes,  and making pull requests which can then be merged into the original repository after being reviewed and approved by the repository owner.

***Method 1: Shared Project/Repository***

##### Creating a shared project 

To create a shared repository (i.e., project), first follow the above steps (under “Creating a Project”) to create a project in AudiAnnotate.  Once you have created an AudiAnnotate project,  you will need to give collaborators access to the generated repository. Even if collaborators have not set up a GitHub account yet, you can invite them to the shared project using their email address, which will prompt them to create an account. To do so:

1. Navigate to [GitHub](https://github.com/).
2. From your profile,  select “Your Repositories.” 
3. Select the repository to which you would like to invite others.
4. Select Settings>Manage Access> Invite a Collaborator
5. Here, you can add collaborators by email or existing username. Note that email invites expire after 7 days. If you add them by email and they do not have an account, the invite will prompt them to create one.
6. Once collaborators have access to the repository, they will be able to add annotations to the project through the AudiAnnotate application. 

***Method 2: Fork and Pull***

##### Project Creation and Sharing for Initial User

1. Follow the instructions under [“Creating a Project”](<a name="project"></a>) above. 
2. Follow the instructions to add audiovisual items and upload any annotations according to the steps above. 
3. Navigate to [GitHub](https://github.com/). 
4. From your profile,  select “Your Repositories.” 
5. Select on the repository that will be used to collaborate with other users, and copy the link to that repository. Note here that on the right side of the page under “About,” there is a tag that says “audiannotate” (see below). This tag will be added manually by collaborators in a later step. <!--- [add image*] --->
6. This link can now be shared with other users.

##### Access Instructions for Collaborators

1. Navigate to the repository link provided by the initial user.
2. Look for the button in the upper right corner of the repository that says “Fork.” <!--- [add image*] --->
3. Select Fork and the account to which you would like to copy the repository. Now you have an exact copy of the original repository.
4. Because this repository is no longer associated with AudiAnnotate, you will need to manually add this back so that AudiAnnotate knows to manage this repository as well as the original. Select the gear icon next to “About” on the repository page. <!--- [add image*] --->
5. Once you select the gear, you’ll see a window that looks like this: <!--- [add image*] --->
6. The “Website” reflects the URL details of the original project. You will want to change the username portion of the URL to your username (between https:// and .github.io). <!--- [add image*] --->
7. Notice that there are no topics associated with this project. You will need to associate the project with AudiAnnotate manually. Type “audiannotate” in the box and select enter. This tag tells GitHub that your repository is an AudiAnnotate project. It will look something like this: <!--- [add image*] --->
8. Select “Save changes.”
9. When you make a project in AudiAnnotate, a GitHub repository is created, along with a website that corresponds to it. When you fork a project, a website is not automatically created, so you will have to force GitHub to do this. The simplest way to do this is to edit the README file. 
10. On the repository page, scroll to the bottom and select README.md and select the pencil icon to edit. <!--- [add image*] --->
11. Add some text to the readme. We suggest text that shares the origins of the repository, something like: “Forked from [username of original user]/[repository name].” This text will display on the AudiAnnotate site project tile to signal that this is a forked repository. <!--- [add image*] --->
12. Select “Commit changes” at the bottom of the page.
13. Wait a minute, then check the link you just edited under “About.” You should see a site at that link.
14. Now navigate back to AudiAnnotate and sign in. You should now see the forked project tile with the note you added to the README.md file.

##### Making changes to the project

Changes are made by collaborators on their copy of the original repository (created in the steps above). This means that any changes, committed to the original repository and hence reflected on the AudiAnnotate project, will have to be approved by the original user and merged into the project. The below instructions will share how to do this.

***For collaborators***

1. Log in to AudiAnnotate and locate the project tile of the forked repository. You will see a tile for the collaborative repository you made in the above steps. The text added to the README.md file will be visible on the tile. Select “Edit.” <!--- [add image*] --->
2. Make changes! Follow steps above to add an audiovisual item or to add annotations to an existing item. 
3. After making changes, it is time to merge the changes you made in your repository copy with the original project. To do this, return to the repository page on GitHub. (You can navigate to your repository page using the dropdown in the top right corner once you log in, and selecting the repository.)
4. Select the button that says “Pull Request.” (You can also use the “Compare” button to compare changes before merging.) <!--- [add image*] --->
5. Select “Pull request” and then “Create Pull Request.”  Here you can add  a note about what you changed (i.e. “added additional field recording found at the Library of Congress site”) and then select “Create Pull Request” again. This does not actually make a change to the repository. It sends a request to the owner of the original project, which they can review before merging. 

***For the initial user***

Once a collaborator has created a pull request from their copied repository requesting a change in the original repository that you own, you will have to review it and merge the changes. 

1. You should get an email notification that a pull request has been created. This email will link you to the pull request made by the collaborator. 
2. When you open the pull request, you will see the changes being requested by the collaborator. You can select into the files where changes are being. Additions to each file appear in green with a plus (+) sign at the start of the row, while items being deleted appear in red with a minus (-) sign. 
3. To accept the changes, you select “Merge pull request.” <!--- [add image*] --->
4. If you are unsure of changes, or have questions for the collaborator, you can continue a discussion by commenting on the thread. <!--- [add image*] --->

### Appendix

#### Glossary of Terms 

- Project (Example: https://tanyaclement.github.io/znh_jacksonville_1939/)
    - Conceptually: A set of related AV materials with contextual information (e.g., front matter, explicatory prose) 
    - Materially: a GitHub repository that includes collection IIIF manifests, web annotations, and web pages generated by Jekyll that present the project and items

- Items (Example: https://tanyaclement.github.io/znh_jacksonville_1939/t86-243/)
    - Conceptually: An annotated audiovisual artifact that can be played online. 
    - Materially: An item IIIF Manifest with a reference to an audiovisual file; one or more web annotation files; a web page generated by Jekyll for the item; and a Universal Viewer javascript application

- Annotations 
    - Conceptually: might include metadata or commentary added by a user that provides additional description or explanation of an audiovisual object for a variety of purposes from facilitating access and discovery to teaching and sharing scholarship.
    - Materially: A JSON element (that is part of the AnnotationPage, see below) that includes a textual body and a target on the referenced audiovisual file.

- Layer
    - Conceptually: A means of organizing annotations by category. 
    - Materially: One or more WC3 web annotation AnnotationPage file(s) that contains the JSON annotation elements.


#### AudiAnnotate IIIF Concept Chart

| AudiAnnotate  | IIIF | Aviary | Notes | Examples |
| ---           | ---  | ------ | ------|----------|
| Item          | Canvas | File | Could have more than one media file but practically does not; Two media files would be two canvases (see example) on one manifest. | https://universalviewer.io/examples/#?c=&m=&s=&cv=&manifest=https%3A%2F%2Fiiif-commons.github.io%2Fiiif-av-component%2Fexamples%2Fdata%2Fbl%2Fsounds-tests%2Floose-ends%2FC1685_98_P3.json&rid= |  
| One or more file(s) that we annotate. | Manifest | Resource | Must have a Canvas. May contain more than one Canvas. | Three interviews by a single Holocaust survivor. Two sides of one tape. |
| Annotation: Timestamped text commentary on AV | W3C Web Annotation | User-created annotation; index point; transcript | There’s a target and there is a body. | Target might be an audio file timestamp or range; the body could be a media file; commentary; links |
| Annotation Page: A file aggregating annotations of the same layer on the same Canvas. | A W3C-compliant file aggregating annotations, associated with a manifest | | | SENT example: see video. All the annotations identifying environmental noise for one recording; another annotation page might have technical sounds |
| An annotation layer: Aggregate collection of annotation pages in one or across multiple manifests or canvases | W3C annotation collections (bag) | Annotation page type label | Conceptually: A means of organizing annotations by category. Multiple audio files have the same kinds of annotations across them. | Multiple environmental annotation pages associated with multiple Canvases or manifests. |
| Projects, editions, exhibition -- multiple Manifests associated with one GitHub repository | Collections: assembly of one or more than one manifest into a IIIF JSON file. | TBD | A set of related AV materials with contextual information (e.g., front matter, explicatory prose | https://tanyaclement.github.io/znh_jacksonville_1939/ |
| TBD | Structures -- an index or a TOC for a single manifest; a structure can span multiple canvases. | | An array with a range and a label and a list of items (which also have ranges so can be nested). | https://iiif-commons.github.io/iiif-av-component/examples/data/bl/sounds-tests/loose-ends/C1685_98_P3.json; Go to Index and “Saturday Review” on this [example](https://universalviewer.io/examples/#?c=&m=&s=&cv=1&manifest=https%3A%2F%2Fiiif-commons.github.io%2Fiiif-av-component%2Fexamples%2Fdata%2Fbl%2Fsounds-tests%2Floose-ends%2FC1685_98_P3.json&rid=https%3A%2F%2Fapi.bl.uk%2Fmetadata%2Fiiif%2Fark%3A%2F81055%2Fvdc_100052359795.0x00000e) |













<!---

1. Go to File → Export → Export Labels

2. Name your labels and save as a .txt file. You will need this file when creating your project with the AudiAnnotate application. 

<a name="audiolink"></a>
### Part 4: Getting an Audio Link for Your Project

AudiAnnotate needs a direct link to either a .mp3 or .wav audio file to add audio to your project. Below are instructions on how to get a direct link for your audio file from three common file-hosting sites: Internet Archive, Dropbox, and Box.

##### [Internet Archive](https://archive.org/)

*Uploading a file to Internet Archive*

1. Click the upload button at the top right corner of your screen.

2. Click the “Upload Files” button. 

3. Select your desired file and click the “Open” button.

4. Fill in the required fields of the metadata box and click the “Upload and Create Your Item” button. 

*Retrieving a file link from Internet Archive:*

1\. On the details page of your desired file, navigate to the “VBR MP3” download option and click the link.  

2\. The link in your browser’s search bar can be used in AudiAnnotate.

##### [Dropbox](https://www.dropbox.com/login?cont=https%3A%2F%2Fwww.dropbox.com%2Fh%3Frole%3Dpersonal)

*Uploading a file to Dropbox:*

1\. Click “Upload Files” near the top right corner of your screen under “Create New files.”

2\. Select your desired file and click the “Open” button.

3\. Select your desired file location in Dropbox and click the “Upload” button.

4\. Click the “Open” button.

*Retrieving a file link from Dropbox:*

1\. Hover over the desired file. 

2\. Click on the “Share” button. The sharing box will appear.

3\. Click “Copy Link” under “Share a link instead.” 

4\. The sharing box will close and a message reading “Link copied” will appear with the sharing link highlighted at the bottom of your screen.

*Note: This link will bring you to a page that displays the audio file, not to the audio (.mp3) itself. This sharing link cannot be used in AudiAnnotate.*

5\. Copy and paste this link somewhere you can view it in full.

6\. Change “dl=0” at the end of the link to “dl=1.” 

7\. This link can now be used in AudiAnnotate. 



##### [Box](https://account.box.com/login) (Please use either Internet Archive or Dropbox. Box is not currently cooperating for audio on AudiAnnotate.)
*Uploading a file to Box:*
1\. Click the “Upload” button in the top right corner of your screen. 
2\. Click “File.”
3\. Select your desired file and click the “Open” button. 
*Retrieving a file link from Box:*
1\. Hover over your desired file.
2\. Click the link button.
3\. Make sure the shared link button is enabled and copy the link from the highlighted.
4\. This link can now be used in AudiAnnotate. 


<a name="aa"></a>
### Part 5: Using AudiAnnotate to Save and Align Labels with Audio

1\. Navigate to the [AudiAnnotate Application](http://audiannotate.brumfieldlabs.com/)

  * This will prompt you to log in through GitHub (make sure to allow the app to authorize AudiAnnotate)

  * Enter your GitHub password to log in

2\. Click "New Project"

  * Title = repository name. 

  * Add description
  
  * Add project slug (this is the GitHub url. Please use hyphens.)

3\. Click “Create project”

  * This contacts the github page and  generates repository

4\. Now, on the Audio files page, click “New Item Manifest.” This is where you will add metadata for your audio recording.

  * Add a label for your audio file. This should be human-readable.
  
  * Add "Audio File URL" for  audio (This should be a direct link to the audio file)
  
  * Add duration in seconds or minutes:seconds
  
  * Other fields are additional provenance metadata from provider 
  
5\. Click “Save." 

6\. Now, on the  annotations page, add a label for your annotations layer. This is where you will upload your .txt labels from Audacity

7\. Click “Choose file”  (.txt labels export from Audacity) 

8\. Click “Add” at the bottom of the page. This will generate your annotations and align them in the IIIF manifest with the audio file. 

9\. From the next screen, you can use the links on the top of the  screen to access your  IIIF manifest and the github pages site. 

10\. Clicking “add” at the bottom of the page allows you to add additional annotation layers to the same audio 

<a name="vid"></a>
### Demonstration Videos
1\. [Annotating with Audacity](https://drive.google.com/file/d/1dpOkBX2-ABIzM7Z2Anle7HHQTr24mN39/view?usp=sharing)

2\. [Creating manifests with AudiAnnotate](https://drive.google.com/file/d/1LAHGDO1fqnN3Y6emXB1FJUi1g8tSk9a7/view?usp=sharing)

3\. [Associating annotations with AudiAnnotate](https://drive.google.com/file/d/1L_fElYnA96q4WQFVuBmSJ80hXSESYDoJ/view?usp=sharing)

---> 














