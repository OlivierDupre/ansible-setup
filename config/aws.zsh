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

function statusEc3(){
    echoStatus=${1:-false}

    [ -z ${AWS_REGION} ] && echo "Context unset. First run awsctx" && return 1

    ec2_instance=`aws ec2 describe-instances --region ${AWS_REGION}  --filters ${EC2_FILTERS} --query "Reservations[0].Instances[0].InstanceId" | jq -r '.'`
    [ -z ${ec2_instance} -o ${ec2_instance} = 'null' ] && echo "No instance in region $AWS_REGION found with these filters ${EC2_FILTERS}" && return 2
    ec2_state=`aws ec2 describe-instances --region ${AWS_REGION} --filters ${EC2_FILTERS} --query "Reservations[0].Instances[0].State.Name" | jq -r '.'`
    
    if [ $ec2_state = "running" ]; then 
        ec2_status=`aws ec2 describe-instance-status --instance-ids ${ec2_instance} --region ${AWS_REGION} --query "InstanceStatuses[0].InstanceStatus.Status" | jq -r '.'`;
        if [ $ec2_status != "ok" ]; then
            ec2_state=$ec2_status
        fi
    fi

    [ $echoStatus ] && echo "Instance ${ec2_instance}: $ec2_state"
}

function startEc3(){
    statusEc3 true
    result=$?
    [ ! $result -eq 0 ] && return $result
    echo "Ec2 ${ec2_instance} status: $ec2_state"

    if [ "x$ec2_state" = "xstopped" ]
    then
        echo "Starting Ec2 ${ec2_instance}"
        awsCall=$(aws ec2 start-instances  --instance-ids ${ec2_instance} --region ${AWS_REGION})
    else
        echo "Ec2 ${ec2_instance} not in a startable state"
    fi
}

function statusEc2(){
    [ -z ${AWS_REGION} ] && echo "Context unset. First run awsctx" && return 1

    export EC2_INSTANCE=`aws ec2 describe-instances --region ${AWS_REGION}  --filters ${EC2_FILTERS} --query "Reservations[0].Instances[0].InstanceId" | jq -r '.'`
    EC2_STATE=`aws ec2 describe-instances --region ${AWS_REGION}  --filters ${EC2_FILTERS} --query "Reservations[0].Instances[0].State.Name" | jq -r '.'`
    
    if [ $EC2_STATE = "running" ]; then 
        EC2_STATUS=`aws ec2 describe-instance-status  --instance-ids ${EC2_INSTANCE} --region ${AWS_REGION} --query "InstanceStatuses[0].InstanceStatus.Status" | jq -r '.'`;
        if [ $EC2_STATUS != "ok" ]; then
            EC2_STATE=$EC2_STATUS
        fi
    fi

    echo $EC2_STATE
}

function startEc2(){
    STATUS=$(statusEc2)
    RESULT=$?
    [ ! $RESULT -eq 0 ] && echo $STATUS && return $RESULT
    echo "Status: $STATUS"

    if [ "x$STATUS" != "xrunning" ]
    then
        echo "Starting Ec2 ${EC2_INSTANCE}"
        aws ec2 start-instances  --instance-ids ${EC2_INSTANCE} --region ${AWS_REGION}
    else
        echo "Ec2 ${EC2_INSTANCE} already running"
    fi
}

function stopEc2(){
    STATUS=$(statusEc2)
    RESULT=$?
    [ ! $RESULT -eq 0 ] && echo $STATUS && return $RESULT
    echo "Status: $STATUS"

    if [ "x$STATUS" = "xrunning" ]
    then
        echo "Stopping Ec2 ${EC2_INSTANCE}"
        aws ec2 stop-instances  --instance-ids ${EC2_INSTANCE} --region ${AWS_REGION}
    else
        echo "Ec2 ${EC2_INSTANCE} not running"
    fi
}

function sshEc2() {
    # export AWS_KEY=~/.ssh/mykey.pem
    # export EC2_FILTERS=file:///my/absolute/path/to/filters.json   # https://docs.aws.amazon.com/cli/latest/reference/ec2/describe-instances.html

    STATUS=$(statusEc2)
    RESULT=$?
    [ ! $RESULT -eq 0 ] && echo $STATUS && return $RESULT
    echo "Status: $STATUS"

    if [ "x$STATUS" = "xstopping" ]
    then
        echo "Cannot ssh to a stopping instance"
        return 50
    fi

    if [ "x$STATUS" = "xstopped" ]
    then
        startEc2
    fi

    while [ "x$STATUS" != "xrunning" ]
    do
        echo -n "."
        sleep 1
        STATUS=$(statusEc2)
    done

    EC2_IP=`aws ec2 describe-instances --region ${AWS_REGION}  --filters ${EC2_FILTERS} --query "Reservations[0].Instances[0].NetworkInterfaces[0].Association.PublicIp" | jq -r '.'`

    echo "ssh -i ${AWS_KEY} ubuntu@${EC2_IP}"
    ssh -i ${AWS_KEY} ubuntu@${EC2_IP}

    read -q "ANSWER?Shutdown instance? " 
    if [ "x$ANSWER" = "xy" ]
    then
        echo "\n --> Shutting down instance <--"
        stopEc2
    fi
}