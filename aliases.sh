
if [ "$ENABLE_GIT_ALIASES" ]
then
  alias gs='git status';
  alias gap='git add -p';
  alias gs='git status -s';
  alias gc='git commit';
  alias gcam='git commit -a -m';
  alias gch='git checkout';
  alias gchm='git checkout master';
fi
