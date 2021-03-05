[AudiAnnotate Home](index.md) | [Workshop Information](workshop.md)


# Getting Started: Workflow Documentation and Demonstration Videos

* [AudiAnnotate Overview](#overview)
* [Part 1: Creating a Project](#project)
* [Part 2: Exporting for Preservation and Publication](#exportprespub)

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














