#!/bin/bash

SCRIPT_DIR=$(dirname "$(realpath "$0")")
PARENT_DIR=$(dirname "$SCRIPT_DIR")
echo $PARENT_DIR
WORK_DIR=$PARENT_DIR/kubespray

PLAYBOOK="cluster.yml"
INVENTORY="inventory/mycluster/hosts.yaml"
USER="ubuntu"
PRIVATE_KEY="~/.ssh/id_rsa"
# RETRY_FILE="cluster.retry"  # Default retry file name based on playbook name
MAX_RETRIES=60

MAX_ATTEMPTS=60
SLEEP_TIME=10

source $PARENT_DIR/ansible-venv/bin/activate

run_playbook() {
    cd $WORK_DIR || exit
    unbuffer ansible-playbook -i $INVENTORY -u $USER -b --become-user=root -v --private-key=$PRIVATE_KEY $PLAYBOOK | tee ansible.log
}
#
# continue_playbook() {
#     if [ -f $RETRY_FILE ]; then
#         echo "Retrying failed tasks from $RETRY_FILE..."
#         unbuffer ansible-playbook -i $INVENTORY -u $USER -b -v --private-key=$PRIVATE_KEY $PLAYBOOK --limit @$RETRY_FILE | tee ansible.log
#     else
#         echo "No retry file found. Running the playbook from the beginning..."
#         run_playbook
#     fi
# }
#
# retry_task() {
#     LAST_FAILED_TASK=$(grep -m 1 -B 1 "failed=" ansible.log | head -n 1 | cut -d' ' -f 3-)
#     if [ -n "$LAST_FAILED_TASK" ]; then
#         echo "Retrying from task: $LAST_FAILED_TASK..."
#         unbuffer ansible-playbook -i $INVENTORY -u $USER -b -v --private-key=$PRIVATE_KEY $PLAYBOOK --start-at-task="$LAST_FAILED_TASK" --retry=$RETRY_FILE | tee ansible.log
#     else
#         echo "No failed task identified. Running the playbook from the beginning..."
#         run_playbook
#     fi
# }
#
# retry_with_intelligence() {
#     attempt=1
#     while [ $attempt -le $MAX_RETRIES ]; do
#         echo "Attempt $attempt of $MAX_RETRIES..."
#         run_playbook
#         if [ $? -eq 0 ]; then
#             echo "Playbook execution completed successfully."
#             return 0
#         else
#             echo "Playbook execution failed. Attempting to continue..."
#             continue_playbook
#             if [ $? -eq 0 ]; then
#                 echo "Playbook execution completed successfully."
#                 return 0
#             else
#                 retry_task
#                 if [ $? -eq 0 ]; then
#                     echo "Playbook execution completed successfully."
#                     return 0
#                 fi
#             fi
#         fi
#         attempt=$((attempt + 1))
#     done
#     echo "Playbook execution failed after $MAX_RETRIES attempts."
#     return 1
# }

main() {
    attempt=1
    while [ $attempt -le $MAX_ATTEMPTS ]; do
        echo "Attempt $attempt of $MAX_ATTEMPTS"

        # Run Ansible playbook and capture output
        run_playbook

        # Check if playbook ran successfully
        if grep -q "PLAY RECAP" ansible.log; then
            # Check for any failed hosts
            failed_hosts=$(awk '/PLAY RECAP/{flag=1;next}/TASK/{flag=0}flag' ansible.log | grep -E 'failed=([1-9][0-9]*)')

            if [ -n "$failed_hosts" ]; then
                echo "Playbook failed on attempt $attempt"
                ((attempt++))
                sleep $SLEEP_TIME
            else
                echo "Playbook ran successfully"
                exit 0
            fi
        else
            echo "Playbook did not run successfully on attempt $attempt"
            ((attempt++))
            sleep $SLEEP_TIME
        fi
    done
}

# Main Execution
main
