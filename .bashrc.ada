HOSTNAME="ada"

# >>>> BASH by sroydip1
alias ada="cd /nfs/ada/ferraro/users/sroydip1"
alias sqp="squeue --Format=JobID,name,UserName,account,State,PriorityLong,tres-alloc:50,nodelist,feature,TimeLimit,timeused -t PENDING"
alias sqr="squeue --Format=JobID,name,UserName,account,State,PriorityLong,tres-alloc:50,nodelist,feature,TimeLimit,timeused -t RUNNING"
alias squ="squeue -u sroydip1"
alias wsqu="watch -n 4 squeue -u sroydip1"
alias sq="squeue"
alias wsq="watch -n 4 squeue"

export TMPDIR=/home/sroydip1/ferraro_ada/users/sroydip1/.cache/tmp
export HF_HOME="/home/sroydip1/ferraro_ada/users/sroydip1/.cache/huggingface"
# export UDOCKER_DIR="/p/work2/sroydip1/udocker"
# export LD_LIBRARY_PATH=/usr/local/cuda-12/lib64:$LD_LIBRARY_PATH
# export PATH=/usr/local/cuda-12/bin:$PATH
# export CUDA_HOME=/usr/local/cuda-12
# <<<< BASH by sroydip1


# >>>> Functions by sroydip1
srung() {
    local gpu_type=$1
    local num_gpus=${2:-1}
    local mem=${3:-100000}
    
    local constraint_arg=""
    if [ -n "$gpu_type" ]; then
        constraint_arg="--constraint=$gpu_type"
    fi
    
    cmd="srun --mem=$mem --time=240:00:00 --gres=gpu:$num_gpus --pty $constraint_arg bash"
    echo "Running: $cmd"
    $cmd
}

satt() {
    local job_id=$1
    if [ -z "$job_id" ]; then
        echo "Usage: satt <job_id>"
        return
    fi
    cmd="srun --pty --overlap --jobid $job_id bash"
    echo "Running: $cmd"
    $cmd
}

# <<<< Functions by sroydip1
