
# commit & push
  system("git add /home/mihai/ownCloud/PACKAGES/DataEntry -A && git commit -a -m '-' && git push")

# install from git repo
 devtools::install_git('/ds/raw_data_kemp/GIT/DataEntry', dependencies = FALSE)

