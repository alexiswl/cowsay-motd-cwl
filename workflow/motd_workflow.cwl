class: Workflow
cwlVersion: v1.2

id: motd_cowsay
label: Message of the day with cowsay
doc: |
  Take a random quote from the quotes directory
  Select a random 'cow'
  Print the quote from the cow
  Wrap the coat in mot.d compatible colouring
  Write out the file
  User must either set up a softlink to the mot.d directory or

requirements:
  InlineJavascriptRequirement: {}
  StepInputExpressionRequirement: {}  # Required for using valueFrom in workflow step input
  MultipleInputFeatureRequirement: {}  # Required for using pickValue in workflow step input
  SchemaDefRequirement:
    types:
      - $import: ./enums/border_colours.yaml

inputs:
  quotes_dir:
    type: Directory?
    doc: If not specified, we will grab a quote from the fortune package instead
  cow:
    type: string?
    doc: Set to null, "" or "random" to get a random cow
  border_colour:
    type: ./enums/border_colours.yaml#border_colours?
  output_file_name:
    type: string?
    default: "motd_cowsay.sh"

steps:
  # Workaround for when quotes_dir is not specified
  # and we need to get the random quote as a string
  get_default_blank_file:
    in:
      input_string:
        valueFrom: ""
      output_file_name:
        valueFrom: "default_blank_file.txt"
    out:
      - id: output_file
    run: ./expressions/write_string_to_file.cwl

  # Get quote
  # if quotes_dir is specified
  get_random_quote_from_quotes_dir:
    in:
      input_directory:
        source: quotes_dir
    out:
      - id: random_file
    run: ./expressions/get_random_file_from_directory_recursively.cwl
    when: >-
      $(
        inputs.input_directory !== null
      )

  # We need to convert to a string so that we can use pickValue in the get_cow_saying_quote_step
  # We only run this when the contents of the file aren't null
  # Because the random_file may not exist, we need to use the blank file so that we can check if the contents exist
  # Because the expression uses 'loadContents' for this input, if we do not
  # have the blank file, the expression will fail with
  # Traceback (most recent call last):
  #  File "/usr/lib/python3/dist-packages/cwltool/workflow_job.py", line 760, in try_make_job
  #    inputobj = postScatterEval(inputobj)
  #  File "/usr/lib/python3/dist-packages/cwltool/workflow_job.py", line 658, in postScatterEval
  #    if val.get("contents") is None:
  # AttributeError: 'str' object has no attribute 'get'
  get_random_quote_as_string:
    in:
      input_file:
        source:
          - get_random_quote_from_quotes_dir/random_file
          - get_default_blank_file/output_file
        pickValue: first_non_null
    out:
      - id: output_string
    run: ./expressions/get_file_contents.cwl
    when: >-
      $(
        inputs.input_file.contents !== ""
      )

  # else from fortune package
  # We always run this step, but only use the output if the quotes_dir is not specified
  get_random_quote_from_fortune_package:
    in: []
    out:
      - id: profound_quote
    run: ./tools/get_random_fortune_quote.cwl

  # Get cow
  # Likewise, we always run this step but only use the output if the cow is not specified
  get_random_cow_step:
    in: []
    out:
      - id: random_cow
    run: ./tools/get_random_cow.cwl

  # Get cow saying quote
  get_cow_saying_quote_step:
    in:
      cow:
        source:
          - cow
          - get_random_cow_step/random_cow
        pickValue: first_non_null
      quote:
        source:
          - get_random_quote_as_string/output_string
          - get_random_quote_from_fortune_package/profound_quote
        pickValue: first_non_null
    out:
      - id: cow_with_quote
    run: ./tools/cowsay_tool.cwl

  # Add border to quote
  add_border_to_quote_step:
      in:
        input_colour:
            source: border_colour
        input_quote:
            source: get_cow_saying_quote_step/cow_with_quote
      out:
      - id: output_quote_with_border
      run: ./expressions/add_border_to_quote.cwl

  # Wrap quote in shell script
  wrap_quote_in_shell_script_step:
      in:
        input_string:
          source: add_border_to_quote_step/output_quote_with_border
      out:
        - id: output_quote_in_shell_script
      run: ./expressions/wrap_quote_in_shell_script.cwl

  # Write out quote as a file
  cow_as_file_step:
    in:
      input_string:
        source: wrap_quote_in_shell_script_step/output_quote_in_shell_script
      output_file_name:
        source: output_file_name
    out:
      - id: output_file
    run: ./expressions/write_string_to_file.cwl

outputs:
  cow_with_quote:
    type: File
    outputSource: cow_as_file_step/output_file
