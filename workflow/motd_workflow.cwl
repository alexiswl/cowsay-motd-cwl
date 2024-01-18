class: Workflow
cwlVersion: v1.1

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
  SchemaDefRequirement:
    types:
      - $import: ./enums/border_colours.yaml

inputs:
  quotes_dir:
    type: Directory
  cow:
    type: string?
  border_colour:
    type: ./enums/border_colours.yaml#border_colours?
  output_file_name:
    type: string?
    default: "motd_cowsay.sh"

steps:
  # Get quote
  get_random_quote:
    in:
      input_directory:
        source: quotes_dir
    out:
      - id: random_file
    run: ./expressions/get_random_file_from_directory_recursively.cwl

  # Get cow
  get_random_cow_step:
    in: []
    out:
      - id: random_cow
    run: ./tools/get_random_cow.cwl

  # Get cow saying quote
  get_cow_saying_quote_step:
    in:
      cow:
        source: get_random_cow_step/random_cow
      quote:
        source: get_random_quote/random_file
        loadContents: true
        valueFrom: |
          ${
            return self.contents.toString().trim();
          }
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
