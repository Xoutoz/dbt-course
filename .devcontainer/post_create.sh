#!/bin/bash

# Add commands to .bashrc file
add_to_bashrc() {
    echo "$1" >> ~/.bashrc
}

# Creates a python virtual environment
if [ ! -d ".venv" ]; then
  python -m venv .venv
fi

# Activate virtual environment on new terminal
add_to_bashrc 'source .venv/bin/activate'

# Activate virtual environment
source .venv/bin/activate

# Update pip
pip install --upgrade pip

# Install dbt snowflake package
pip install dbt-snowflake==1.7.1

# Create dbt location file
mkdir ~/.dbt

# Prepare dbt profiles.yml with Snowflake configurations
read -p "Enter your Snowflake account name: " account_name
sed -e "s/\${snowflake-account-name}/$account_name/" example.profiles.yml > ~/.dbt/profiles.yml

# Initialize dbt
dbt init dbtlearn --profile dbtlearn

# Move dbt project content to repository root
cd dbtlearn
for dir in */
do
    mv $dir ../$dir
done
head -n -3 dbt_project.yml > ../dbt_project.yml
cd ..

dbt debug

# Remove unnecessary directory
rm -r dbtlearn/
rm -r models/example/

# Create a .gitkeep file for models directory
touch models/.gitkeep