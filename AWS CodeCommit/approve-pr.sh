#!/bin/bash

# Function to check Pull Request status and approve if not already approved
check_and_approve() {
    repo_name="$1"
    pr_id="$2"
    profile="$3"

    # Check if Pull Request is OPEN in the first place
    pr_status=$(aws codecommit get-pull-request --pull-request-id "$pr_id" --profile "$profile" --query 'pullRequest.pullRequestStatus' --output text)

    if [ "$pr_status" != "OPEN" ]; then
        echo "Pull Request $pr_id in repository $repo_name is not OPEN. Therefore it cannot be approved."
    else
        number_of_approvals_required=$(aws codecommit get-pull-request --pull-request-id "$pr_id" --query "pullRequest.approvalRules[] | [0].approvalRuleContent" | jq -r '. | fromjson.Statements[0].NumberOfApprovalsNeeded')

        # Get the Revision ID of the Pull Request
        revision_id=$(aws codecommit get-pull-request --pull-request-id "$pr_id" --profile "$profile" --query 'pullRequest.revisionId' --output text)
        number_of_approvals_received=$(aws codecommit get-pull-request-approval-states --pull-request-id "$pr_id" --revision-id "$revision_id" | grep -c APPROVE)

        #echo "$number_of_approvals_received received vs $number_of_approvals_required required"
        #echo "Number of approvals received: $number_of_approvals_received"
        
        if [ "$number_of_approvals_required" -ne 0 ]; then
            if [ "$number_of_approvals_received" -lt "$number_of_approvals_required" ]; then
                echo "$number_of_approvals_received received vs $number_of_approvals_required approvals are required. Proceeding to approve the PR $pr_id in repository $repo_name"
                # Approve the Pull Request
                if aws codecommit update-pull-request-approval-state --pull-request-id "$pr_id" --approval-state APPROVE --revision-id "$revision_id" --profile "$profile"; then
                    echo "Pull Request $pr_id in repository $repo_name has been successfully approved."
                else
                    echo "Failed to approve Pull Request $pr_id in repository $repo_name."
                fi
            elif [ "$number_of_approvals_received" -eq "$number_of_approvals_required" ]; then
                echo "$number_of_approvals_received of $number_of_approvals_required approvals received. Therefore $pr_id in repository $repo_name is already approved."
            else
                echo "$number_of_approvals_received vs $number_of_approvals_required required PR. PR $pr_id in repository $repo_name has more than $number_of_approvals_required approvals."
            fi
        else
            echo "No approvals required for PR $pr_id in repository $repo_name."
        fi
    fi
}

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo "AWS CLI is not installed. Please install it and configure your credentials."
    exit 1
fi

# Check if CSV file is provided as argument
if [ $# -ne 1 ]; then
    echo "Usage: $0 <csv_file>"
    exit 1
fi

csv_file="$1"

# Check if CSV file exists
if [ ! -f "$csv_file" ]; then
    echo "CSV file $csv_file does not exist."
    exit 1
fi

# Check if AWS profile is provided as argument
if [ -z "$AWS_PROFILE" ]; then
    echo "AWS profile is not set. Please export AWS_PROFILE environment variable or use the --profile option."
    exit 1
fi

# Loop through each line in the CSV file
while IFS=',' read -r repo_name pr_id; do
    echo repo_name="$repo_name"
    echo pr_id="$pr_id"
    check_and_approve "$repo_name" "$pr_id" "$AWS_PROFILE"
done < "$csv_file"
