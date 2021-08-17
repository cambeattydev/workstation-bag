param ([boolean]$deleteRemotes = $false)

# get default branch name
$defaultBranch = (git symbolic-ref refs/remotes/origin/HEAD) -split '/' | select -Last 1
Write-Host "DefaultBranchName: $defaultBranch"
# update local list of pruned branches on the remote to local:
git fetch --prune 

# delete branches on remote origin that have been merge to master
if ($deleteRemotes){
git branch --merged remotes/origin/$defaultBranch -r | %{$_.trim().replace('origin/', '')} | ?{$_ -notmatch $defaultBranch} | %{git push --delete origin $_}
}

# delete local branches that have been merged to master
git branch --merged remotes/origin/$defaultBranch | %{$_.trim()} | ?{$_ -notmatch $defaultBranch} | %{git branch -d $_}

# remove stale refs (local refs to branches that are gone on the remote)
git remote prune origin