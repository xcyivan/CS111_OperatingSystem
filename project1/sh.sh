#! /bin/sh
# (cat) < sh.sh && cat < sh.sh

#(exec cat) < sh.sh



# ls -l< ./test
# ls -l && (ls && ls -a ./a)

# ls -l   && ls -l  ./a|| ls

# ls |  grep s  && exec ls

# #exec echo left && exec echo right
#ls | grep s && exec echo shut
#echo hello


exec ls | grep s
echo hello