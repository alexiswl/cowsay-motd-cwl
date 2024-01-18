cwlVersion: v1.1
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
id: get-random-cow
label: Select a random cow
doc: |
  Run cowsay

requirements:
  InlineJavascriptRequirement: {}
  DockerRequirement:
    dockerPull: docker.io/chuanwen/cowsay:latest

inputs:
  cow:
    type: string
    inputBinding:
      position: 1
      prefix: -f
      valueFrom: |
        ${
          return "/usr/share/cowsay/cows/" + self + ".cow";
        }
  quote:
    type: string
    inputBinding:
      position: 2

baseCommand: [ "/usr/games/cowsay" ]

stdout: stdout

outputs:
  cow_with_quote:
    type: string
    outputBinding:
      glob: stdout
      loadContents: true
      outputEval: |
        ${
          return self[0].contents.toString().trim();
        }