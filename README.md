# Cowsay MOTD CWL

A CWL Workflow to generate a message of the day with helpful hints (from a cow!)

## Usage

```bash
# Set variables
QUOTES_DIR="quotes"
BORDER_COLOUR="red"
OUTPUT_FILENAME="motd.sh"

# Run CWL Workflow
cwltool "workflow/motd_workflow.cwl" <( \
    jq --null-input --raw-output \
     --arg quotes_dir "${QUOTES_DIR}" \
     --arg border_colour "${BORDER_COLOUR}" \
     --arg output_filename "${OUTPUT_FILENAME}" \
     '
       {
         "quotes_dir": {
           "class": "Directory",
           "location": $quotes_dir
         },
         "border_colour": $border_colour,
         "output_file_name": $output_filename
       }
     '
  );

# Change permissions
chmod 755 "${OUTPUT_FILENAME}"

# Execute output
bash "${OUTPUT_FILENAME}"
```

Yields (imagine the border is red)

```
_________________________________________________
-------------------------------------------------
|| _________________________________________   ||
|| / Use Alt+D to delete the contents of the \ ||
|| \ current word to the right of the cursor / ||
||  -----------------------------------------  ||
||   \                                         ||
||    \   \                                    ||
||         \ /\                                ||
||         ( )                                 ||
||       .( o ).                               ||
-------------------------------------------------
‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
```

## Adding to your MOTD

In Ubuntu 22.04, the file must be added as an executable (with no suffix) to `/etc/update-motd.d/`.  
The order of execution is determined by the prefix number, I would recommend '98' to ensure it is close to the bottom of your motd.  

An example of running and adding to your motd is shown under [scripts/update_motd_hint.sh](scripts/update_motd_hint.sh)

## Adding as a cronjob

To add as a cronjob, you can use the [scripts/update_motd_through_cron.sh](scripts/update_motd_through_cron.sh) script with
the following cronjob entry (note you will need to run this as the root user). Use `crontab -e` to edit your crontab.

### On reboot

```
@reboot bash /path/to/update_motd_through_crontab.sh
```

### Run hourly

```bash
0 * * * * bash /path/to/update_motd_through_crontab.sh
```

## Contributing

To add more quotes, simply add a new file to the [quotes](quotes) directory.

PRs to the workflow are also always welcome :) 