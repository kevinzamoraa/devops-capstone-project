::page{title="Lab: Add Continuous Integration"}

<img src="https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBM-CD0285EN-SkillsNetwork/images/IDSN-logo.png" width="200">

**Estimated time needed:** 60 minutes

A key practice in DevOps is continuous integration (CI), where developers continuously integrate their code into the main branch by making frequent pull requests. To assist them in this task, they use automation to confirm that every pull request runs the test suite to ensure that the proposed code changes will not break the build or reduce the test coverage.

Welcome to the **Add Continuous Integration** hands-on lab. In this lab, you will add a continuous integration workflow using GitHub Actions to run your tests with a PostgreSQL service. You will use the account service created in the previous lab to set up continuous integration automation using a CI pipeline. It is recommended that you complete the previous labs before beginning this one.

## Objectives

In this lab, you will:

* Create a GitHub Actions workflow to run your CI pipeline
* Add events to trigger the workflow
* Add a job to the workflow
* Add steps to a job
* Run inline commands in the steps
* Review the logs for a workflow run
* View the activity for a workflow run

::page{title="Note: Important Security Information"}

Welcome to the Cloud IDE with Docker. This is where all your development will take place. It has all the tools you will need to use Docker for deploying a PostgreSQL database.

It is important to understand that the lab environment is **ephemeral**. It only lives for a short while before it is destroyed. It is imperative that you push all changes to your own GitHub repository so that it can be recreated in a new lab environment any time it is needed.

Also note that this environment is shared and, therefore, not secure. You should not store any personal information, usernames, passwords, or access tokens in this environment for any purpose.

Finally, the environment may be recreated at any time, so you may find that you have to preform the **Initialize Development Environment** each time the environment is created.

### Note on Screenshots

Throughout this lab, you will be prompted to take screenshots and save them on your device. You will need these screenshots to either answer graded quiz questions or upload them as your submission for final assignment at the end of this course. Your screenshot must have either the .jpeg or .png extension.

To take screenshots, you can use various free screen-capture tools or your operating system\'s shortcut keys. For example:

* **Mac:** you can use `Shift + Command + 3` (&#8679; + &#8984; + 3) on your keyboard to capture your entire screen, or `Shift + Command + 4` (&#8679; + &#8984; + 4) to capture a window or area. They will be saved as a file on your Desktop.

* **Windows:** you can capture your active window by pressing `Alt + Print Screen` on your keyboard. This command copies an image of your active window to the clipboard. Next, open an image editor, paste the image from your clipboard to the image editor, and save the image.

::page{title="Initialize Development Environment"}

Because the Cloud IDE with Docker environment is ephemeral, it may be deleted at any time. The next time you come into the lab, a new environment may be created. Unfortunately, this means that you will need to initialize your development environment every time it is recreated. This should not happen too often as the environment can last for several days at a time but when it is removed; this is the procedure to recreate it.

## Overview

Each time you need to set up your lab development environment, you will need to run three commands. 

Each command will be explained in further detail, one at a time, in the following section.

 `{your_github_account}` represents your GitHub account username.

The commands include:

```
git clone https://github.com/{your_github_account}/devops-capstone-project.git
cd devops-capstone-project
bash ./bin/setup.sh
exit
```

Now, let\'s discuss each of these commands and explain what needs to be done.

## Task Details

Initialize your environment using the following steps:

1. Open a terminal with `Terminal` -> `New Terminal` if one is not open already.

1. Next, use the `export GITHUB_ACCOUNT=` command to export an environment variable that contains the name of your GitHub account.
> Note: Substitute your GitHub username for the `{your_github_account}` place holder below:

	```text
	export GITHUB_ACCOUNT={your_github_account}
	```

1. Then, use the following commands to clone your repository, change into the `devops-capstone-project` directory, and execute the `./bin/setup.sh` command.

	```bash
	git clone https://github.com/$GITHUB_ACCOUNT/devops-capstone-project.git
	cd devops-capstone-project
	bash ./bin/setup.sh
	```

	You should see the following at the end of the setup execution:

	![capstone_setup_complete](https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBM-CD0285EN-SkillsNetwork/images/capstone_setup_complete.png "Capstone Environment Setup Complete message")

1. Finally, use the `exit` command to close the current terminal. The environment will not be fully active until you open a new terminal in the next step.

	```bash
	exit
	```

## Validate

In order to validate that your environment is working correctly, you must open a new terminal because the Python virtual environment will only activate when a new terminal is created. You should have ended the previous task by using the `exit` command to exit the terminal.

1. Open a terminal with `Terminal` -> `New Terminal` and check that everything worked correctly by using the `which python` command:

	Your prompt should look like this:

	![Setup Prompt](https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBM-CD0285EN-SkillsNetwork/images/env_setup_prompt.png "Setup Prompt")

	Check which Python you are using:
	```bash
	which python
	```

	You should get back:

	![Which Python](https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBM-CD0285EN-SkillsNetwork/images/env_which_python.png "Which Python")

	Check the Python version:
	```bash
	python --version
	```

	You should get back some patch level of Python 3.9:

	![Python Version](https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBM-CD0285EN-SkillsNetwork/images/env_python_version.png "Python Version")

This completes the setup of the development environment. Anytime your environment is recreated, you will need to follow this procedure.

You are now ready to start working.


::page{title="Exercise 1: Pick Up the First Story"}

The first thing you need to do is get a story to work on. You should never start coding without placing the story that you are working on into the **In Progress** column on the kanban board and assign it to yourself so that everyone knows you are working on it.

## Your Task

1. Go to your kanban board and take the first story from the top of `Sprint Backlog`. It should be titled: \"*Need the ability to automate continuous integration checks*\".

1. Move the story to `In Progress`.

1. Open the story and assign it to *yourself*.

1. Read the contents of the story.

## Results

The story should look like this:

### Need the ability to automate continuous integration checks

**As a** Developer
**I need** automation to build and test every pull request
**So that** I do not have to rely on manual testing of each request, which is time-consuming

#### Assumptions
* GitHub Actions will be used for the automation workflow
* The workflow must include code linting and testing 
* The Docker image should be postgres:alpine for the database
* A GitHub Actions badge should be added to the README.md to reflect the build status

#### Acceptance Criteria
```gherkin
Given code is ready to be merged
When a pull request is created
Then GitHub Actions should run linting and unit tests
And the badge should show that the build is passing
```
---

You are now ready to begin working on your story.


::page{title="Exercise 2: Create a Workflow"}

The first thing you need to do is create a workflow for your GitHub Action. This should define the name and when to run the workflow.

## Your Task

1. Take the first story \"Need the ability to automate continuous integration checks\" from `Sprint Backlog` and move it into `In Progress` and assign it to *yourself*.

1. Create a new branch named `add-ci-build` to work on in the development environment.

	<details>
		<summary>Click here for a hint.</summary>

	```text
	git checkout -b {branch name here}
	```

	</details>

	<details>
		<summary>Click here for the answer.</summary>

	```bash
	git checkout -b add-ci-build
	```

	</details>


1. Create a GitHub Actions workflow in the `.github/workflows` folder of your GitHub repository called `ci-build.yaml`

1. Give the workflow the name: `CI Build`.

	<details>
		<summary>Click here for a hint.</summary>

	```yaml
	name: {name here}
	```

	</details>

1. Set up the `on:` statement to run this workflow on every `push` and `pull_request` to the `main` branch of the repository.

	<details>
		<summary>Click here for a hint.</summary>
	Here is a template:

	```yaml
	name: {name here}
	on:
	  push:
		branches:
		  - {branch_name}
	  pull_request:
		branches:
		  - {branch_name}
	```

	</details>

## Validate

Your workflow trigger definition should look like this:

<details>
	<summary>Click here to check your answer.</summary>

```yaml
name: CI Build
on:
  push:
	branches:
	  - main
  pull_request:
	branches:
	  - main

```
</details>


You are now ready to create a job.


::page{title="Exercise 3: Create a Job"}

Now that you know when to run the workflow, you need to create a job to contain your services and steps. You need to define a job runner, and you want this job to run inside a Python 3.9 Docker container.

## Your Task

1. Create a job called `build`.

	<details>
		<summary>Click here for a hint.</summary>
	Here is a template:

	```yaml
	jobs:
	  build:
	```

	</details>

1. Specify that the build job runs on `ubuntu:latest`.

	<details>
		<summary>Click here for a hint.</summary>
	Here is a template:

	```yaml
	jobs:
	  build:
		runs-on: {runner_name}
	```

	</details>

1. Define a `container:` for the build job to run it that uses a `python:3.9-slim` image.

	<details>
		<summary>Click here for a hint.</summary>
	Here is a template:

	```yaml
	jobs:
	  build:
		runs-on: {runner_name}
		container: {image_name}
	```

	</details>

## Validate

Your job section should look like this:

<details>
	<summary>Click here to check your answer.</summary>

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    container: python:3.9-slim

```
</details>

You are now ready to create a database service.


::page{title="Exercise 4: Define Required Services"}

Now that you have defined your job, you need to define any required services like databases. The account service uses a Postgres service to store its data. When running tests, it needs to have access to a Postgres database for testing. Luckily, GitHub Actions supports Docker containers, which allow you to start a database service in a Docker container, just like you do when you are developing.

## Reference

This is the Docker command from your `Makefile` that is used for testing while developing locally. You can use the parameters from it to define a Postgres service for your workflow.

```text
docker run -d --name postgres -p 5432:5432 \
		-e POSTGRES_PASSWORD=pgs3cr3t \
		-v postgres:/var/lib/postgresql/data \
		postgres:alpine
```

## Your Task

1. Create a `services:` section in your workflow file at the same level of indentation as the `container:` section.

	<details>
		<summary>Click here for a hint.</summary>
	Here is a template:

	```yaml
	jobs:
	  build:
		runs-on: {runner_name}
		container: {image_name}

		services:
	```

	</details>

1. Under the `services:` section, define a service called `postgres:`.

	<details>
		<summary>Click here for a hint.</summary>
	Here is a template:

	```yaml
	jobs:
	  build:
		runs-on: {runner_name}
		container: {image_name}

		services:
		  postgres:
	```

	</details>

1. Create an `image:` tag under the Postgres service with a value of `postgres:alpine`.

	<details>
		<summary>Click here for a hint.</summary>
	Here is a template:

	```yaml
	jobs:
	  build:
		runs-on: {runner_name}
		container: {image_name}

		services:
		  postgres:
			image: {image name here...}
	```

	</details>

1. Create a `ports:` tag under the Postgres service that is listening on port `5432` (which is the default Postgres port).

	<details>
		<summary>Click here for a hint.</summary>
	Here is a template:

	```yaml
	jobs:
	  build:
		runs-on: {runner_name}
		container: {image_name}

		services:
		  postgres:
			image: {image name here...}
			ports:
			  - {port}:{port}
	```

	</details>

1. Add an `env:` environment variable tag and define values for `POSTGRES_PASSWORD` and `POSTGRES_DB`. Use the values `pgs3cr3t` and `testdb`, respectively.

	<details>
		<summary>Click here for a hint.</summary>
	Here is a template:

	```yaml
	jobs:
	  build:
		runs-on: {runner_name}
		container: {image_name}

		services:
		  postgres:
			image: {image name here...}
			ports:
			  - {port}:{port}
			env:
			  POSTGRES_PASSWORD: {password here...}
			  POSTGRES_DB: {database name here...}
	```

	</details>

1. Add an `options:` tag to check for a `health-cmd` of `pg_isready`, `health-interval` of `10s`, `health-timeout` of `5s`, and `health-retries` of `5`.

	<details>
		<summary>Click here for a hint.</summary>
	Here is a template:

	```yaml
	jobs:
	  build:
		runs-on: {runner_name}
		container: {image_name}

		services:
		  postgres:
			image: {image name here...}
			ports:
			  - {port}:{port}
			env:
			  POSTGRES_PASSWORD: {password here...}
			  POSTGRES_DB: {database name here...}
			options: >-
			  --health-cmd pg_isready
			  --health-interval 10s
			  --health-timeout 5s
			  --health-retries 5
	```

	</details>

## Validate

Your service definition should look like this:

<details>
	<summary>Click here to check your answer.</summary>

```yaml
jobs:
  build:
	runs-on: ubuntu-latest
	container: python:3.9-slim

	services:
	  postgres:
		image: postgres:alpine
		ports:
		  - 5432:5432
		env:
		  POSTGRES_PASSWORD: pgs3cr3t
		  POSTGRES_DB: testdb
		options: >-
		  --health-cmd pg_isready
		  --health-interval 10s
		  --health-timeout 5s
		  --health-retries 5

```

</details>


You are now ready to start adding steps.


::page{title="Exercise 5: Check Out Code and Install Dependencies"}

You are now ready to define the steps for your workflow. The first steps are to check out the code and install the dependencies. For checking out code, you will use an action from the GitHub Actions Marketplace.

To install the dependencies, you can use the same statements as if you were doing this locally on your computer.

## Reference

You can use the following commands to install the Python package dependencies in your workflow steps.

```text
python -m pip install --upgrade pip wheel
pip install -r requirements.txt
```

## Your Task

1. Add a step named `Checkout` to check out the code using the `actions/checkout@v2` action.

<details>
	<summary>Click here for a hint.</summary>
Substitute the step name and action name from the instructions.

```yaml
    steps:
      - name: {checkout step name here...}
        uses: {action name here...}
```
</details>

2. Add a step named `Install dependencies` that upgrades `pip` and `wheel` and then uses the `pip` command to install the Python packages from the `requirements.txt` file.

<details>
	<summary>Click here for a hint.</summary>
Substitute the step name and command name from the instructions.

```yaml
    steps:
      - name: {checkout step name here...}
        uses: {action name here...}

	  - name: {install step name here...}
        run: |
         {commands to install dependencies here...}
```
</details>

## Validate

Your first two step definitions should look like this:

<details>
	<summary>Click here to check your answer.</summary>

```yaml
jobs:
  build:
	services:
	# ...

    steps:
      - name: Checkout
        uses: actions/checkout@v2

	  - name: Install dependencies
        run: |
          python -m pip install --upgrade pip wheel
          pip install -r requirements.txt

```

</details>


You are now ready to move on to the next step.

::page{title="Exercise 6: Add Linting"}

In the **Assumptions** section of the story, it says:

* The workflow must include code linting and testing

In this step, you will add linting, which is checking your code for syntactical and stylistic issues. Some examples are line spacing, using spaces or tabs for indentation, locating uninitialized or undefined variables, and missing parentheses. 

It is always a good idea to add quality checks to your CI pipeline. This is especially true if you are working on an open source project with many different contributors. This makes sure that everyone who contributes follows the same style guidelines.

Now, you will use `flake8` to lint the source code.
> Note: The flake8 library was installed as a dependency in the requirements.txt file.

## Reference

You can use the following commands to run the `flake8` linter in your workflow steps.

```text
flake8 service --count --select=E9,F63,F7,F82 --show-source --statistics
flake8 service --count --max-complexity=10 --max-line-length=127 --statistics
```
> Note: You should run these commands on your code before you add them to your workflow to ensure that your code passes the tests. You can use the `make lint` command to do this.

## Your Task

1. Add a new step named `Lint with flake8` after the `Install dependencies` step that runs the `flake8` commands from the above reference.

<details>
	<summary>Click here for a hint.</summary>
Substitute the step name and command name from the instructions.

```yaml
    steps:

	  {... other steps here ...}

	  - name: {step name here...}
        run: |
         {commands to run flake8 here...}
```
</details>


## Validate

Your lint step definition should look like this:

<details>
	<summary>Click here to check your answer.</summary>

```yaml
jobs:
  build:
	services:
	# ...

    steps:
      # ...previous steps here

      - name: Lint with flake8
        run: |
		  flake8 service --count --select=E9,F63,F7,F82 --show-source --statistics
		  flake8 service --count --max-complexity=10 --max-line-length=127 --statistics

```

</details>

You are now ready to move on to the next step.

::page{title="Exercise 7: Add Unit Testing"}

To satisfy the testing requirements, you will use Nose in this step to unit test the source code. Nose is configured via the included `setup.cfg` file to automatically include the flags `--with-spec` and `--spec-color` so that red-green-refactor is meaningful. If you are in a command shell that supports colors, passing tests will be green and failing tests will be red.

Nose is also configured to automatically run the coverage tool, and you should see a percentage of coverage report at the end of your tests.

## Reference

You can use the following commands to run the `nosetests` in your workflow steps.

```text
nosetests -v --with-spec --spec-color --with-coverage --cover-package=service
```
> Note: You should run these commands on your code before you add them to your workflow to ensure that your code passes the tests. You can use the `make test` command to do this.

## Your Task

1. Add a new step named `Run unit tests with Nose` after the `Lint with flake8` step that runs the `nosetests` commands from the above reference.

	<details>
		<summary>Click here for a hint.</summary>
	Substitute the step name and command name from the instructions. Since you are running a single command, you do not have to use the pipe (|) operator with run.

	```yaml
		steps:

		  {... other steps here ...}

		  - name: {step name here...}
			run: {command to run nosetests here...}
	```
	</details>

1. Use the `env:` tag to add an environment variable named `DATABASE_URI` that will configure the tests to use the PostgreSQL database that you created in the `service:` section.

	<details>
		<summary>Click here for a hint.</summary>
	Substitute the step name and command name from the instructions. Since you are running a single command, you do not have to use the pipe | operator with run.

	```yaml
		steps:

		  {... other steps here ...}

		  - name: {step name here...}
			run: {command to run nosetests here...}
			env:
			  DATABASE_URI: "postgresql://postgres:{password}@{service}:{port}/{database}"
	```
	</details>


## Validate

Your test step definition should look like this:

<details>
	<summary>Click here to check your answer.</summary>

```yaml
jobs:
  build:
	services:
	# ...

    steps:
      # ...previous steps here

      - name: Run unit tests with nose
        run: nosetests
        env:
          DATABASE_URI: "postgresql://postgres:pgs3cr3t@postgres:5432/testdb"

```

</details>

That completes your workflow definition.

## Check your final work

Try and run the workflow that you put together yourself. If anything goes wrong, here is the complete solution so that you can check how it may differ from yours.

<details>
	<summary>Click here to check the complete solution.</summary>

```yaml
name: CI Build
on:
  push:
	branches:
	  - main
  pull_request:
	branches:
	  - main

jobs:
  build:
	runs-on: ubuntu-latest
	container: python:3.9-slim

	services:
	  postgres:
		image: postgres:alpine
		ports:
		  - 5432:5432
		env:
		  POSTGRES_PASSWORD: pgs3cr3t
		  POSTGRES_DB: testdb
		options: >-
		  --health-cmd pg_isready
		  --health-interval 10s
		  --health-timeout 5s
		  --health-retries 5

    steps:
      - name: Checkout
        uses: actions/checkout@v2

	  - name: Install dependencies
        run: |
          python -m pip install --upgrade pip wheel
          pip install -r requirements.txt

      - name: Lint with flake8
        run: |
		  flake8 service --count --select=E9,F63,F7,F82 --show-source --statistics
		  flake8 service --count --max-complexity=10 --max-line-length=127 --statistics

      - name: Run unit tests with nose
        run: nosetests
        env:
          DATABASE_URI: "postgresql://postgres:pgs3cr3t@postgres:5432/testdb"

```


</details>


::page{title="Exercise 8: Create a Badge"}

One of the last requirements listed in the story under **Assumptions** is:

* A GitHub Actions badge should be added README.md to reflect the build status

Now, it\'s time to add that badge.

The format of a GitHub Actions badge looks like this:

```
![Build Status](https://github.com/<OWNER>/<REPOSITORY>/actions/workflows/<WORKFLOW_FILE>/badge.svg)
```

* Where `<OWNER>` is the account name or organization name of the repository.
* `<REPOSITORY>` is the name of the repository, which you already know is `devops-capstone-project`.
* `<WORKFLOW_FILE>` is the name of the GitHub Actions workflow file that the badge represents, which you already know is `ci-build.yaml`.

## Your Task

1. Edit the `README.md` file.

1. On a line below the title and separated from the title by a blank line above and below, add the following markdown:

	```text

	![Build Status](https://github.com/<OWNER>/devops-capstone-project/actions/workflows/ci-build.yaml/badge.svg)

	```
* Where `<OWNER>` is the name of your GitHub account.

3. Save the file and commit your changes using the message `Added badge for GitHub Actions`.

Once you make a pull request, the badge will show everyone the status of the build.

::page{title="Exercise 9: Make a Pull Request"}

Now that you have completed your GitHub Action, you are ready to commit your changes, push code to your GitHub repository, and make a pull request.

## Your Task

1. Commit your changes locally in the development environment with the message `"completed ci build"`.



	<details>
		<summary>Click here for a hint.</summary>

	```text
	git commit -am "{message here}"
	```

	</details>

	<details>
		<summary>Click here for the answer.</summary>

	```bash
	git commit -am "completed ci build"
	```

	</details>

1. Push your local changes to a remote branch.

	<details>
		<summary>Click here for the answer.</summary>

	```bash
	git push
	```

	</details>

1. Go to GitHub and make a pull request, which should kick off the GitHub Action that you just wrote.

::page{title="Exercise 10: View the Workflow Run"}

When your workflow is triggered, a *workflow run* is created that executes the workflow. After a workflow run has started, you can see a visualization graph of the run\'s progress and view each step\'s activity on GitHub.

## Your Task

1. On GitHub.com, navigate to the main page of the repository.
1. Under your repository name, click Actions.
1. In the left sidebar, click the workflow you want to see.
1. Under \"Workflow runs,\" click the name of the run you want to see.
1. Under Jobs or in the visualization graph, click the job you want to see.
1. View the results of each step.
1. If everything worked, merge your pull request.

## Evidence

1. Open the results of your GitHub Actions workflow run in the terminal.
Copy the complete terminal output showing all workflow steps and save it in a file named **ci-workflow-done**.

<details>
	<summary>Click here for instruction to save terminal output</summary>
	

Follow the steps given below
 
1. Start by installing the GitHub CLI (`gh`) using the commands below:
 
```bash
sudo apt update
```

```bash
sudo apt install gh
```
 
2. Authenticate GitHub CLI using command `gh auth login`
 
Run the following command in your terminal:
 
```shell
gh auth login
```
 
When prompted, choose the options shown below:

1. What account do you want to log into?

>   Select **GitHub.com**
 
2. What is your preferred protocol for Git operations?

>   Select **HTTPS**
 
3. Authenticate Git with your GitHub credentials?

>  Type **Y**
 
4. How would you like to authenticate GitHub CLI?

   Select **Paste an authentication token**
 
   > If you haven\'t already you can generate a Personal Access Token (PAT) by following the instructions given in the [Hands-on Lab: Generate GitHub personal access token](https://author-ide.skills.network/render?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJtZF9pbnN0cnVjdGlvbnNfdXJsIjoiaHR0cHM6Ly9jZi1jb3Vyc2VzLWRhdGEuczMudXMuY2xvdWQtb2JqZWN0LXN0b3JhZ2UuYXBwZG9tYWluLmNsb3VkL0lCTS1DRDAxMzFFTi1Ta2lsbHNOZXR3b3JrL2xhYnMvY3JlYXRlLXBlcnNvbmFsLXRva2VuL2luc3RydWN0aW9ucy5tZCIsInRvb2xfdHlwZSI6Imluc3RydWN0aW9uYWwtbGFiIiwiYWRtaW4iOmZhbHNlLCJpYXQiOjE2OTMyMDM0NzZ9.trhrHYxgdMIc-UW_NwcM9WeUOGzIfaIJMAcENksvrHg) and be sure to include these scopes: `repo`, `read:org` and `workflow`
 
5. Paste your authentication token

   Paste your PAT into the terminal
> Note: If you see an `error validating token: missing required scope` error after entering your PAT, generate a new token and be sure to include these scopes: `repo`, `read:org` and `workflow`
 
Once done, you should see messages confirming:
 
* Git protocol configured

* Logged in with your GitHub username
 
 
3. Use the following commands to change directory:

```shell
cd devops-capstone-project
```

4. To get the list of workflow runs for your GitHub repository run the following command from your project directory in the terminal:

```bash
gh run list
```

After the list of workflow runs is displayed, pick the top most `run-id` from the output and view its details using command below:

```bash
gh run view <run-id> --verbose
```
> Replace `<run-id>` with the ID shown in the list.

This will give you detailed information about that workflow run.

> Note: Ensure you are inside the correct repository directory and have successfully authenticated using ```gh auth login``` before running these commands.

Your output should appear similar to the image below:

<img src="https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/6Qb4sNhERZV7wUs3MyUqqw/Screenshot%202025-11-24%20at%202-01-52%E2%80%AFPM.png">


5. Copy and paste the terminal output that shows your GitHub Actions workflow running successfully and save it in a text file named `ci-workflow-done` for the final project submission and evaluation. The output should clearly display the steps executed in the workflow.

</details>


2. If not done as part of question 1, Copy and paste the the public Github URL of `README.md` and save it in a text file that shows the updated badge.

2. Move the story **“Need the ability to automate continuous integration checks”** to the **Done** column on your Kanban board.
Take a screenshot of your Kanban board and save it as `ci-kanban-done.jpeg` or `ci-kanban-done.png`.

3. Copy and paste the the public Github URL of `ci-build.yaml` and save it in a text file.
---


::page{title="Conclusion"}

Congratulations! You have implemented the automation of unit testing during continuous integration using GitHub Actions. From this point on, you won\'t have to worry if the code you are merging will break the build.

## Next Steps

In another lesson, you will implement the next story in Sprint 2 that will make more code changes and put your hard work creating a GitHub Action to good use.

## Author(s)

Tapas Mandal
[John J. Rofrano](https://www.linkedin.com/in/johnrofrano)


<!--
## Change Log

| Date | Version | Changed by | Change Description |
|------|--------|--------|---------|
| 2022-10-10 | 0.1 | Tapas Mandal | Initial version created |
| 2022-10-11 | 0.2 | John Rofrano | Added more details and reformatted |
| 2022-10-14 | 0.3 | John Rofrano | Updated screenshot image names |
| 2022-10-24 | 0.4 | Beth Larsen  | QA pass  |
| 2022-10-28 | 0.5 | John Rofrano | Updated markdown in story text |
| 2022-11-04 | 0.6 | John Rofrano | Added more hints and answers |
| 2023-03-16 | 0.7 | Lavanya Rajalingam | Updated SN Logo |
| 2025-08-26 | 0.8 |Manvi Gupta| New version created for edX Mark |
2025-12-15|0.9 | Ritika | Latest update as per Mark|
-->

