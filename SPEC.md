# RDT Cross-Domain DevSecOps Prototype 

This task is a pathfinder/prototype multi-level GitLab deployment.  The goal of the effort is to deliver to NRL a low-to-high, low-latency DevSecOps pipeline built around the GitLab product.  I’d like you to review this project plan and get me feedback, questions, and clarifications.  Keep the team cc’ed so we can get the best answers and keep the ball moving.  I’d like to start this ASAP, but there are a couple (simple) blockers we need to clear to just get you the creds and the right environment to get moving.  

Please review this carefully, especially Phase 1, and get back to us with any clarifying questions, observations, etc.   I’d also like questions on Phase 2, but that can wait some number of weeks, so no urgency.

# Phase 1:
Demonstrate an automated deployment of the GitLab suite into AWS GovCloud.  This phase is just getting you familiar with the tools, and others able to interact with the product you produce.  

-	We will provide GitLab installer media and licenses as required.
-	There is already an AWS (AWS GovCloud) environment to use, we will get you credentials to support this development.
-	Robert will share any TF/Ansible he has already created, if any, for GL config.  I think he also has some stuff from Matthew Long they used.  This is just FYI, you shouldn’t rely on it.
-	We should use the containerized version of GL if possible, in preference to the raw OS install.
-	We should use AWS ECS or other container management services.
-	You should be aware that the containerized solution may not persist, and we may eventually have to prototype a paralle install/config using only EC2 instances.
-	Automation should be built out in Terraform (for AWS infrastructure) and Ansible (for host/container deployment and configuration)
-	We will provide a SAML 2.0 identity source that will need to be integrated as identity/SSO provider.  It’ll probably be AWS SSO, with ActiveDirectory backing it.
-	The GitLab instance should be deployed in an isolated, non-routable subnet (call it “DevSecOps Low”) to emulate an air-gapped low/unclass side environment.
-	We will expose the GL instance to the internet using an ALB (Good) or multi-homed EC2 host (less good).
-	For now, automation and configuration code to do all this should be in AWS CodeCommit.  Robert and I will help get you established.
-	The goal is to demonstrate login to GitLab front page from an external users (i.e., from a Government laptop you don’t control), and walk through a series of basic GL functions:
    o	Create a new group and project
    o	Push git clone to/from a local laptop and the GL instance
    o	Import a git repo (i.e., maybe our GRM Factory repo as an example)
    o	Export a GL project using the GL exporter capability (should be able to produce a tar file export)

My “management” estimate is that this is maybe 2-4 weeks of work.  Maybe faster if you’re familiar with some of the tools already.  We can break up into some smaller milestones if that helps.  

# Phase 2:
Augment to a virtual two-level system.  In this phase, we create a second isolated subnet and deploy the identical configuration of GL into it.   Then we connect them using a “Virtual Cross Domain” solution, which is going to have to be something we make up.

-	Duplicate the existing config in a separate subnet, “DevSecOps High”
-	Demonstrate ability to separately log into the two instances.  
-	Establish an S3 bucket that will be our virtual cross-domain.  Basically, the low side should have write-only access to this bucket, and the high side should have read-only access.  
-	Manually demonstrate:
    o	Export TAR file (gitlab export) from low side to S3 bucket.  Gitlab provides an api described here: [Project Import/Export API](https://docs.gitlab.com/ee/api/project_import_export.html)
    o	Import TAR file (gitlab import) on high side, and merge with existing git state.  
    o	Flow of git branches, tags, wiki content from low to high
-	Implement, ideally in Python, REST based automation to automatically call low-to-high on low side, and produce TAR files.
    o	Time-triggered
    o	Git hook triggered, with some kind of throttle.  (i.e., every time there is a commit to “main” branch on the low side, but no more frequently than every 10 minutes, trigger an export)
-	Implement REST based automation to conduct the import high side
-	Demonstrate automated flow from git checkin  on low side to git pull on high side.

## Phase 3:
Move into U-FENCES.  This and Phase 2 might get collapsed together.  
-	U-FENCES is a separate domain hosted inside GovCloud, but with limitations.  Higher bar for user access, maybe some features in AWS at a lower level of maturity.  This is the “real” environment, from which we hope to begin development of AWS features for the high side. 
    - Account application for [FENCES access is here](https://fences.dso.mil/). Please don't apply for an account without checking with Jonathan Anderson.
-	We will get you access to a new U-FENCES environment, and get you provisioned with credentials and what you need for access.
-	May ask for some basic sysadmin/management help here – creating and managing accounts for trial users.
-	

## Phase 4:
-	Establish a “real” high side environment in FENCES.  Classification level is TBD, we are discussing with NRL.  We may establish a S or TS level instance, or go straight to our target level which is… complicated. 
-	This will require onsite time in a lab, either at NRL or BPTF, where we can get access to the classified environment.
-	Demonstration basically mimics the Phase 2-3 demos, but the CDS is instead a physical DVD that is passed through a security scan.

## Phase 5:
-	Establish, test, and accredit a “Real” CDS between U-FENCES and high side instances.  Options (a) AWS Diode, if we can make that work; (b) DoD enterprise CDS if available; and (c) locally-hosted physical guard solution if all else fails.  We can consider these in parallel if that makes sense.
-	You won’t be responsible for accreditation process, but this phase will likely bring with it new requires to automate generation of accreditation and authorization artifacts.

## Future features not yet on the roadmap
-   IDM/SSO integration 

## Trivia
Youtube videos from GL

- https://www.youtube.com/watch?v=RvZSTCbPkiE
- https://www.youtube.com/watch?v=HSfDTslLRT8

