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
  List /usr/share/cowsay/cows and return one at random

requirements:
  InlineJavascriptRequirement:
    expressionLib:
      - function getRandomInt(max) {
          return Math.floor(Math.random() * Math.floor(max));
        }
      - function getRandomCow(cows_list){
          return cows_list[getRandomInt(cows_list.length)].replace(".cow", "");
        }
  DockerRequirement:
    dockerPull: docker.io/chuanwen/cowsay:latest

# No inputs
inputs: []

# Outputs
baseCommand: [ "ls", "/usr/share/cowsay/cows" ]

stdout: stdout

outputs:
  random_cow:
    type: string
    outputBinding:
      glob: stdout
      loadContents: true
      outputEval: |
        ${ 
          return getRandomCow(self[0].contents.split("\n"));
        }