# aws-automation-scripts
Collection of useful scripts that help to perform a wide range of tasks on AWS.

## AWS CodeCommit

### CodeCommit Pull Request Approver

This shell script automates the process of approving pull requests in AWS CodeCommit repositories. It checks the status of each pull request listed in a CSV file and automatically approves it if it meets the approval criteria.

#### Features

- **Automated Approval**: The script automatically checks the approval status of each pull request in a CSV file and approves it if it's not already approved.
- **Approval Criteria**: Pull requests are approved based on the configured approval rules in CodeCommit.
- **Status Checking**: Before approving a pull request, the script checks if it's open and if the required number of approvals has been received.
- **AWS CLI Integration**: Utilizes the AWS CLI to interact with CodeCommit, making it easy to integrate with existing AWS environments.

#### How to Use

1. **Install Dependencies**: Ensure you have the AWS CLI installed and configured with appropriate credentials.
2. **Clone the Repository**: Clone this repository to your local machine.
3. **Prepare CSV File**: Create a CSV file containing the repository names and pull request IDs you want to approve.
4. **Run the Script**: Execute the script, providing the path to the CSV file as an argument.
   ```bash
   chmod +x approve_pr.sh
   ./approve_pr.sh my_csv_file.csv
5. **Sit Back and Relax**: The script will automatically check and approve pull requests as needed.

#### Note
- Ensure that you have reviewed the code before approving the Pull Request. 
- Make sure to review the script and customize it according to your specific requirements before using it in a production environment.
- This script assumes you have the necessary permissions to approve pull requests in the specified repositories.
- Feel free to contribute, report issues, or suggest improvements by opening an issue or pull request!