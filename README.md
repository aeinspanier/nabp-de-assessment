# Assessment

## Business Context
**Company Mission**

Our food safety insurance company provides specialized coverage to restaurants, cafes, and food service establishments against food-related liability claims. We operate in multiple major metropolitan areas and need robust data infrastructure to support evidence-based underwriting and premium setting.

To effectively assess risk and set competitive premiums, we require a unified analytical dataset that combines:
* Basic establishment information (location, type, operational status)
* Health inspection histories and outcomes

## Current Data Challenge
We've collected data from three cities, each with different
* Data formats and column naming conventions
* Grading/scoring systems (Pass/Fail vs Letter Grades vs Numeric Scores)
* Unique identifier systems
* Data quality standards

We've loaded this data is loaded into `<city>_food_establishments` and `<city>_inspections` tables in the `raw_data` schema of the DuckDB database in `/data/inspection_database.db`.

Our analyst needs you to transform this data into a single, unified dataset of health inspections.

## Tasks

1. Update the `staging` models for each dataset
    2. Standardize the names of important columns.
    3. Generate id-keys as needed.
    4. For each table, deduplicate records so the the output contains one record for each food_establishment or inspection (respectively).
5. Implement the `intermediate` model to join the `food_establishments` and `inspections` data from the different cities and unify these into a single dataset of health inspections, where each record contains at least
    * the establishment's id and name,
    * the inspection's id, date, and results (in a Pass/Fail form)

We would love to see:
* tests covering crucial properties,
* additional data fields standardized and unified,
* local use of git (bonus points if development is done in branches then merged back into main)
* documentation of the data defects you discovered, any analysis you performed, any decisions you made in response to ambiguity, etc.
    * Please add any documentation in the `notes/` directory.

## Deliverables

When you're happy with your models, tests, documentation, etc, please run the command below to zip up everything in the project dir except for the `data/`, `deliverable/`, `dbt_packages/`, and `venv/` directories. This will output a timestamped deliverable in the `deliverable/` directory.

```console
python main.py "Your Name"
```

## Setup

1. Ensure the `inspection_database.db` database file is in this project's `./data/` directory.
2. Make it possible to run `dbt` commands (one potential setup shown below)

### One possible env setup

Note: assumes `python` is available at the command line.

1. Create a virtual-env
```console
cd path/to/assessment_dir
python -m venv venv
```

2. Activate that virtual-env
```console
source venv/bin/activate      # if on linux/unix
venv\Scripts\activate         # if on Windows using Command Prompt
source venv/Scripts/activate  # is on Windows using GitBash
```
You should now see `(venv)` at the beginning of the line.

3. Install packages into that virtual-env
```console
pip install -r requirements.txt
```

Now you can run `dbt` commands.

# AI Assistance

Please don't share any of this proprietary code with AI companies (by pasting it into a tool, by letting an AI enabled shell or IDE load it into context, or by any other means).
Feel free to ask questions to AI tools, just include your prompts alongside your deliverable. We want to see how you think and solve problems.

