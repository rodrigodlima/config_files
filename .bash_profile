# get current branch in git repo
function parse_git_branch() {
BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
if [ ! "${BRANCH}" == "" ]
then
STAT=`parse_git_dirty`
echo "[${BRANCH}${STAT}]"
else
echo ""
fi
}

# get current status of git repo
function parse_git_dirty {
status=`git status 2>&1 | tee`
dirty=`echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`
untracked=`echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`
ahead=`echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?"`
newfile=`echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`
renamed=`echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`
deleted=`echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`
bits=''
if [ "${renamed}" == "0" ]; then
bits=">${bits}"
fi
if [ "${ahead}" == "0" ]; then
bits="*${bits}"
fi
if [ "${newfile}" == "0" ]; then
bits="+${bits}"
fi
if [ "${untracked}" == "0" ]; then
bits="?${bits}"
fi
if [ "${deleted}" == "0" ]; then
bits="x${bits}"
fi
if [ "${dirty}" == "0" ]; then
bits="!${bits}"
fi
if [ ! "${bits}" == "" ]; then
echo " ${bits}"
else
echo ""
fi
}

export PS1="\[\e[31m\]\u\[\e[m\]@\[\e[34m\]\h\[\e[m\]:\[\e[32m\]\w\[\e[m\]\`parse_git_branch\` "

# MacPorts Installer addition on 2016-10-06_at_18:44:51: adding an appropriate PATH variable for use with MacPorts.
export PATH="/opt/local/bin:/opt/local/sbin:$PATH:/Users/rodrigo.lima/bin:/Library/Frameworks/Python.framework/Versions/2.7/bin/"
# Finished adapting your PATH environment variable for use with MacPorts.

# bash-completion
if [ -f /opt/local/etc/profile.d/bash_completion.sh ]; then
    . /opt/local/etc/profile.d/bash_completion.sh
fi
