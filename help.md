Download
========
mkdir directory; cd directory
git init
git status

## create branch and switch to it
git checkout -b feature-ccd-688
git clone https://github.com/CTSA-io/tenant-cdmh-aspe-prod -b feature-ccd-688

cd  tenant-cdmh-aspe-prod/

git submodule update --init --recursive


Update repo with changes
------------------------

cd tenant-cdmh-aspe-prod/

git status

## On branch feature-ccd-688
 Changes not staged for commit:
   (use "git add <file>..." to update what will be committed)
   (use "git checkout -- <file>..." to discard changes in working directory)

       modified:   aws/prod/ec2.tf
       modified:   aws/prod/output.tf
       modified:   aws/prod/sg.tf
       modified:   aws/prod/terraform.tfvars
       modified:   aws/prod/variables.tf

no changes added to commit (use "git add" and/or "git commit -a")

git add .

[jake@control tenant-cdmh-aspe-prod]$ git status
 On branch feature-ccd-688
 Changes to be committed:
   (use "git reset HEAD <file>..." to unstage)

       modified:   aws/prod/ec2.tf
       modified:   aws/prod/output.tf
       modified:   aws/prod/sg.tf
       modified:   aws/prod/terraform.tfvars
       modified:   aws/prod/variables.tf


git diff --staged

git commit -m "feat: Added EC2 modules CCD-688 & CCD-691"
[feature-ccd-688 431cd75] feat: Added EC2 modules CCD-688 & CCD-691
 5 files changed, 164 insertions(+)

###
##To upload changes to github

git push origin feature-ccd-688


##Delete remote repo on github (especiallly when pull request submitted)

$ git push origin --delete feature-ccd-688
To https://github.com/CTSA-io/tenant-cdmh-aspe-prod
 - [deleted]         feature-ccd-688



https://education.github.com/git-cheat-sheet-education.pdf

changes made on master  - 05/02/2020
