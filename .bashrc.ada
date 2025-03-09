# >>>> BASH by sroydip1
alias ada="cd /nfs/ada/ferraro/users/sroydip1"
alias sqp="squeue --Format=JobID,Jobname,User,userid,account,State,PriorityLong,tres-alloc:50,nodelist,feature -t PENDING"
alias sqr="squeue --Format=JobID,Jobname,User,userid,account,State,PriorityLong,tres-alloc:50,nodelist,feature -t RUNNING"
alias squ="squeue -u sroydip1"
alias sq="squeue"


export TMPDIR=/home/sroydip1/ferraro_ada/users/sroydip1/.cache/tmp
export HF_HOME="/umbc/ada/ferraro/users/sroydip1/.cache/huggingface"
# export UDOCKER_DIR="/p/work2/sroydip1/udocker"
# export LD_LIBRARY_PATH=/usr/local/cuda-12/lib64:$LD_LIBRARY_PATH
# export PATH=/usr/local/cuda-12/bin:$PATH
# export CUDA_HOME=/usr/local/cuda-12
# <<<< BASH by sroydip1