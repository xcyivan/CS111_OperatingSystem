#! /bin/sh
(cat) < sh.sh && cat < sh.sh
# (cat ) < sh.sh || ls
# cat <sh.sh && ls .s && echo 3
# (exec cat) < sh.sh
# (exec lss)  || echo 1 
# exec ls right || exec ls .s|| echo 2
# ls .a || echo 2


# ls -l< ./test
# ls -l && (ls && ls -a ./a)

# ls -l   && ls -l  || ls

exec ls |  grep s 
echo 1



