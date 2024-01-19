cwlVersion: v1.2
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
id: get-file-contents
label: Get file contents
doc: |
  From a file object, return the contents attribute string

requirements:
    InlineJavascriptRequirement: {}

inputs:
  input_file:
    type: File
    loadContents: true

outputs:
  output_string:
    type: string
    doc: |
      The contents of the file

expression: |
  ${
    return {
      "output_string": inputs.input_file.contents
    };
  }