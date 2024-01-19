cwlVersion: v1.2
class: CommandLineTool


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
id: get-random-fortune-quote
label: Get a random fortune quote
doc: |
  Run the fortune command and return the output

requirements:
  InlineJavascriptRequirement: {}
  DockerRequirement:
    dockerPull: ghcr.io/alexiswl/cowsay:latest

# No inputs
inputs: []

# Outputs
baseCommand: [ "fortune" ]

stdout: stdout

outputs:
  profound_quote:
    type: string
    outputBinding:
      glob: stdout
      loadContents: true
      outputEval: |
        ${
          return self[0].contents.trim();
        }