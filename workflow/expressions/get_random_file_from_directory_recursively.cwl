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
id: list-all-files-in-a-directory-recurisvely
label: List all files in a directory recursively
doc: |
  Given a directory as an input, return a flat list of all files in that directory recursively

  # Examples
  ```bash
  cwltool --quiet \
    list_all_files_in_a_directory_recursively.cwl --input_directory "../../quotes/"
  ```

  Gives

  ```json
  {
      "all_files_list": [
          {
              "class": "File",
              "location": "file:///home/alexiswl/GitHub/ALEXISWL/cowsay-motd-cwl/workflow/expressions/delete_all_contents_to_the_right_of_the_cursor.txt",
              "basename": "delete_all_contents_to_the_right_of_the_cursor.txt",
              "size": 61,
              "checksum": "sha1$92d8917b98d41010784136d35670a030ebbcfda0",
              "path": "/home/alexiswl/GitHub/ALEXISWL/cowsay-motd-cwl/workflow/expressions/delete_all_contents_to_the_right_of_the_cursor.txt"
          },
          {
              "class": "File",
              "location": "file:///home/alexiswl/GitHub/ALEXISWL/cowsay-motd-cwl/workflow/expressions/delete_right_of_word.txt",
              "basename": "delete_right_of_word.txt",
              "size": 80,
              "checksum": "sha1$15ad5afd5ccf4b5a9a271a804c1af3466596525d",
              "path": "/home/alexiswl/GitHub/ALEXISWL/cowsay-motd-cwl/workflow/expressions/delete_right_of_word.txt"
          },
          {
              "class": "File",
              "location": "file:///home/alexiswl/GitHub/ALEXISWL/cowsay-motd-cwl/workflow/expressions/delete_left_of_word.txt",
              "basename": "delete_left_of_word.txt",
              "size": 80,
              "checksum": "sha1$83157b153b8ae5d7ee381c82e340dca8e45d898c",
              "path": "/home/alexiswl/GitHub/ALEXISWL/cowsay-motd-cwl/workflow/expressions/delete_left_of_word.txt"
          },
          {
              "class": "File",
              "location": "file:///home/alexiswl/GitHub/ALEXISWL/cowsay-motd-cwl/workflow/expressions/cursor_to_end_of_the_line.txt",
              "basename": "cursor_to_end_of_the_line.txt",
              "size": 53,
              "checksum": "sha1$141f87ebe7ceffac4e761183c88a2236ec0a2c0e",
              "path": "/home/alexiswl/GitHub/ALEXISWL/cowsay-motd-cwl/workflow/expressions/cursor_to_end_of_the_line.txt"
          },
          {
              "class": "File",
              "location": "file:///home/alexiswl/GitHub/ALEXISWL/cowsay-motd-cwl/workflow/expressions/clear_terminal_screen.txt",
              "basename": "clear_terminal_screen.txt",
              "size": 40,
              "checksum": "sha1$fbf5946c9ca5244a86f3ca9a7a4e31f60e204d1e",
              "path": "/home/alexiswl/GitHub/ALEXISWL/cowsay-motd-cwl/workflow/expressions/clear_terminal_screen.txt"
          },
          {
              "class": "File",
              "location": "file:///home/alexiswl/GitHub/ALEXISWL/cowsay-motd-cwl/workflow/expressions/delete_all_contents_to_the_left_of_the_cursor.txt",
              "basename": "delete_all_contents_to_the_left_of_the_cursor.txt",
              "size": 60,
              "checksum": "sha1$68035dc77d451834c89e45f242bdda2bd8f3851a",
              "path": "/home/alexiswl/GitHub/ALEXISWL/cowsay-motd-cwl/workflow/expressions/delete_all_contents_to_the_left_of_the_cursor.txt"
          },
          {
              "class": "File",
              "location": "file:///home/alexiswl/GitHub/ALEXISWL/cowsay-motd-cwl/workflow/expressions/yank_text.txt",
              "basename": "yank_text.txt",
              "size": 61,
              "checksum": "sha1$1aa89971dea5cef109001bd167d9801598aad56e",
              "path": "/home/alexiswl/GitHub/ALEXISWL/cowsay-motd-cwl/workflow/expressions/yank_text.txt"
          }
      ]
  }
  ```

requirements:
  # LoadListingRequirement is required to use the 'deep_listing' option
  # for recursive iteration
  LoadListingRequirement:
     loadListing: deep_listing
  InlineJavascriptRequirement:
    expressionLib:
      - function getRandomInt(max) {
          /*
          Given a integer 'max', return a random integer between 0 and max
          */
          return Math.floor(Math.random() * Math.floor(max));
        }
      - function listAllFilesInDirectoryRecursively(directory) {
          /*
          Collect all files in a directory recursively
          */
          var all_files = [];
          console.log(directory);
          directory.listing.forEach(function(file_obj) {
              if (file_obj.class == "Directory") {
                all_files = all_files.concat(listAllFilesInDirectoryRecursively(file_obj));
              } else {
                all_files.push(file_obj);
              }
            }
          );
          return all_files;
        }
      - function selectRandomFileFromDirectory(directory){
            /*
            Given a directory, return a random file from that directory
            */
            var all_files = listAllFilesInDirectoryRecursively(directory);
            return all_files[getRandomInt(all_files.length)];
        }

inputs:
  input_directory:
    type: Directory
    doc: The directory to list all files in

outputs:
  random_file:
    type: File
    doc: The random file from the directory to select from

expression: |
  ${
    return {"random_file": selectRandomFileFromDirectory(inputs.input_directory)};
  }