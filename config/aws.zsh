#!/bin/zsh

function awsall() {
    credentialFileLocation=${AWS_SHARED_CREDENTIALS_FILE};
    if [ -z $credentialFileLocation ]; then
        credentialFileLocation=~/.aws/credentials
    fi

    while read line; do
        line=$(trim "$line")
        if [[ $line == "["* ]]; then echo ${line:1:$((${#line}-2))}; fi;
    done < $credentialFileLocation;
};

function awx() {
   if [ -z $1 ]; then aws configure list; return; fi

   exists="$(aws configure get aws_access_key_id --profile $1)"
   if [[ -n $exists ]]; then
       export AWS_DEFAULT_PROFILE=$1;
       export AWS_PROFILE=$1;
       export AWS_REGION=$(aws configure get region --profile $1);
       echo "Switched to AWS Profile: $1";
       aws configure list
   fi
};

alias awsctx=awx

function statusEc2(){
    EC2_INSTANCE=`aws ec2 describe-instances --region ${EC2_REGION}  --filters ${EC2_FILTERS} --query "Reservations[0].Instances[0].InstanceId" | jq -r '.'`
    
    echo `aws ec2 describe-instance-status  --instance-ids ${EC2_INSTANCE} --region ${EC2_REGION} --query "InstanceStatuses[0].InstanceStatus.Status" | jq -r '.'`
}

function startEc2(){
    EC2_INSTANCE=`aws ec2 describe-instances --region ${EC2_REGION}  --filters ${EC2_FILTERS} --query "Reservations[0].Instances[0].InstanceId" | jq -r '.'`

    status=$(statusEc2)
    echo "Status: $status"

    if [ "x$status" != "xok" ]
    then
        echo "Starting Ec2 ${EC2_INSTANCE}"
        aws ec2 start-instances  --instance-ids ${EC2_INSTANCE} --region ${EC2_REGION}
    else
        echo "Ec2 ${EC2_INSTANCE} already running"
    fi
}


function stopEc2(){
    EC2_INSTANCE=`aws ec2 describe-instances --region ${EC2_REGION}  --filters ${EC2_FILTERS} --query "Reservations[0].Instances[0].InstanceId" | jq -r '.'`

    status=$(statusEc2)

    if [ "x$status" = "xok" ]
    then
        echo "Stopping Ec2 ${EC2_INSTANCE}"
        aws ec2 stop-instances  --instance-ids ${EC2_INSTANCE} --region ${EC2_REGION}
    else
        echo "Ec2 ${EC2_INSTANCE} already stopped"
    fi
}

function sshEc2() {
    # export EC2_FILTERS=file:///my/absolute/path/to/filters.json   # https://docs.aws.amazon.com/cli/latest/reference/ec2/describe-instances.html

    startEc2

    status=$(statusEc2)

    while [ "x$status" != "xok" ]
    do
        echo -n "."
        sleep 1
        status=$(statusEc2)
    done

    EC2_IP=`aws ec2 describe-instances --region ${EC2_REGION}  --filters ${EC2_FILTERS} --query "Reservations[0].Instances[0].NetworkInterfaces[0].Association.PublicIp" | jq -r '.'`

    echo "ssh -i ${AWS_KEY} centos@${EC2_IP}"
    ssh-tmux -i ${AWS_KEY} centos@${EC2_IP}

    read -p "Shutdown instance? " answer
    if [ "x$answer" != "xn" ]
    then
        echo "Shutting down instance"
        stopEc2
    fi
}