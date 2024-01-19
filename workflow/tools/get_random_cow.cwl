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
id: get-random-cow
label: Select a random cow
doc: |
  List /usr/share/cows/ and return one at random

requirements:
  InlineJavascriptRequirement:
    expressionLib:
      - function getRandomInt(max) {
          return Math.floor(Math.random() * Math.floor(max));
        }
      - function get_basename(path){
          /*
          Return everything after the last /
          */
          return path.split("/")[path.split("/").length - 1];
        }
      - function trim_cow(cow_basename){
          /*
          Remove the .cow extension
          */
          return cow_basename.replace(".cow", "");
        }
      - function getRandomCow(cows_list){
          /*
          We generated a list of cows, now return one at random
          */
          
          /*
          Select an item of the list at random
          */
          var random_cow_path = cows_list[getRandomInt(cows_list.length)];
          
          /*
          Get the basename of the path
          */
          var random_cow_basename = get_basename(random_cow_path);
          
          /*
          Return the cow name without the .cow suffix
          */
          return trim_cow(random_cow_basename);
        }
  DockerRequirement:
    dockerPull: ghcr.io/alexiswl/cowsay:latest

# No inputs
inputs: []

# Outputs
baseCommand: [ "find", "/usr/share/cows/" ]

arguments:
  # A few perl scripts sit in this directory, we dont want those
  - prefix: "-type"
    valueFrom: "f"
  - prefix: "-name"
    valueFrom: "*.cow"

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