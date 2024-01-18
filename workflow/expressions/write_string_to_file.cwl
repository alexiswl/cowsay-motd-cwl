cwlVersion: v1.1
class: ExpressionTool

# Extensions
$namespaces:
  s: https://schema.org/
$schemas:
  - https://schema.org/version/latest/schemaorg-current-http.rdf

# Metadata
# Add any additional contributors with 's:contributor'
s:author:
  class: s:Person
  s:name: Alexis Lucattini
  s:email: Alexis.Lucattini@umccr.org
  s:identifier: https://orcid.org/0000-0001-9754-647X

# ID / Docs
id: write-string-to-file
label: Write string to file
doc: |
  From a string, populate a file object with the contents of that string,
  assign the file basename to the input output_file_name

requirements:
    InlineJavascriptRequirement: {}

inputs:
  input_string:
    type: string
  output_file_name:
    type: string

outputs:
  output_file:
    type: File
    doc: |
      The output file containing the contents provided by input_string

expression: |
  ${
    return {
      "output_file": {
        "class": "File",
        "basename": inputs.output_file_name,
        "contents": inputs.input_string
      }
    };
  }