[AudiAnnotate Home](index.md) | [Workshop Information](workshop.md)


# Getting Started: Workflow Documentation and Demonstration Videos

* [Part 1: Downloading Audacity](#aud)
* [Part 2: Creating Labels in Audacity](#labels)
* [Part 3: Exporting Labels From Audacity](#export)
* [Part 4: Getting an Audio Link for Your Project](#audiolink)
* [Part 5: Using AudiAnnotate to Save and Align Labels with Audio](#aa)
* [Demonstration Videos](#vid)

    1\. [Annotating with Audacity](https://drive.google.com/file/d/1dpOkBX2-ABIzM7Z2Anle7HHQTr24mN39/view?usp=sharing)

    2\. [Creating manifests with AudiAnnotate](https://drive.google.com/file/d/1LAHGDO1fqnN3Y6emXB1FJUi1g8tSk9a7/view?usp=sharing)

    3\. [Associating annotations with AudiAnnotate](https://drive.google.com/file/d/1L_fElYnA96q4WQFVuBmSJ80hXSESYDoJ/view?usp=sharing)


<a name="aud"></a>
### Part 1: Downloading Audacity

* If you have a Mac, navigate to [Audacity's Mac download page](https://www.audacityteam.org/download/mac/). There, you'll download the .dmg file and double-click to follow instructions for downloading Audacity to your machine. We recommend downloading the latest version, 2.3.3.

* If you have a PC, navigate to [Audacity's PC download page](https://www.audacityteam.org/download/windows/). There, you'll download the installer and follow instructions for downloading Audacity to your machine. We recommend downloading the latest version, 2.3.3.

<a name="labels"></a>
### Part 2: Creating Labels in Audacity

1. Open Audacity, and in the top left, navigate to file→ Open → file name

2. On the warning screen, make sure the make a copy choice is selected, then click ok.

3. There are multiple ways to annotate a stanza. First, we’ll try ranges. To insert a range, you’ll pause the poem by clicking the “p” key when you hear the first line of the stanza begin. 

4. Click the time marker line to mark the place in time where you want to add the label. This typically will correspond to the place where you paused the audio (see image below)

    ![image](Pages-Images/workflowclickimage.png) 

5. Then, you’ll click command + b to add a label. A field will pop up, and you can type your annotation. (Example: You may add “Stanza1” to mark the first stanza of a poem.)

    ![image](Pages-Images/workflowlabeltypeimage.png)

6. To create the range, you’ll click and drag the right edge of the point to the end of the stanza. You’ll have to play the recording to know where to end the stanza. A completed range will look like this: 

    ![image](Pages-Images/workflowrangeimage.png)

7. Those are the basics. Feel free to annotate as you wish, thinking about the issues you run into and what works or doesn’t work for you. 

#### Another way to add labels in Audacity

1. When you open the app and add audio, go to Edit → Labels, then click “Type to create a label”

2. Now as you’re listening, when you type any key, a label will begin

3. Using this method, to pause the audio, you need to use the pause button on the upper left of the interface

<a name="export"></a>
### Part 3: Exporting Labels from Audacity

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

<!---
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
--->

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













