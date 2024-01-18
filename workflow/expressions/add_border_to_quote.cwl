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
id: add-border-to-quote
label: Add a border to a cow quote
doc: |
  Add the border to the cow quote

requirements:
  SchemaDefRequirement:
    types:
      - $import: ../enums/border_colours.yaml
  InlineJavascriptRequirement:
    expressionLib:
      - function octal_mapping_dict(){
         /*
         Octal codes for colours (have used a double backslash to escape)
         */
         return {
           "red":"\\033[00;31m",
           "green":"\\033[00;32m",
           "yellow":"\\033[00;33m",
           "blue":"\\033[00;34m",
           "purple":"\\033[00;35m",
           "cyan":"\\033[00;36m",
           "lightgray":"\\033[00;37m",
           "lred":"\\033[01;31m",
           "lgreen":"\\033[01;32m",
           "lyellow":"\\033[01;33m",
           "lblue":"\\033[01;34m",
           "lpurple":"\\033[01;35m",
           "lcyan":"\\033[01;36m",
           "white":"\\033[01;37m",
           "reset":"\\033[0m"
         };
        }
      - function get_octal_code(colour){
            /*
            Given a colour name, return the octal code for that colour
            */
            return octal_mapping_dict()[colour];
        }
      - function get_longest_line_length(cow_with_quote){
          /*
          Get the longest line length in the quote, important for padding
          */
          var longest_line = 0;
          cow_with_quote.split("\n").forEach(
            function(line_iter){
                if (line_iter.length > longest_line){
                    longest_line = line_iter.length;
                }
            }
          );
          return longest_line;
        }
      - function pad_string(string_to_pad, padding_length){
          /*
          Adds space padding to the end of the string string
          */
          return string_to_pad.padEnd(padding_length);
        }
      - function escape_double_backslash(string_to_wrap){
          /*
          Double backslash need to be escaped, use four backslashes to emulate two, use six to emulate three
          */
          return string_to_wrap.split('\\\\').join('\\\\\\');
        }
      - function add_border_to_line(line_string, border_colour, padding_length){
          /*
          Pads the string based length of the longest string
          Escapes double backslashes by adding in an extra backslash
          */
          return
            octal_mapping_dict()[border_colour] + "|| " + octal_mapping_dict()["reset"] +
            escape_double_backslash(
                pad_string(line_string, padding_length)
            ) + " " +
            octal_mapping_dict()[border_colour] + "||" + octal_mapping_dict()["reset"]
          ;
        }
      - function add_horizontal_border(quote_length, symbol, border_colour){
          /*
          Adds the horizontal border
          We add 6 to the quote length to account for spacing either side of the quote and the two double vertical borders
          symbol is '_' for the top border and '‾' for the bottom border
          */
          return octal_mapping_dict()[border_colour] + symbol.repeat(quote_length + 6) + octal_mapping_dict()["reset"] + "\n";
        }
      - function apply_border_to_each_line(quote, border_colour){
          /*
          Add the border to each line
          */
        
          /*
          First need to figure out how much to pad each line
          */
          var longest_line_length = get_longest_line_length(quote);
          
          /*
          Start with top border ("_" followed by "-")
          */
          var quote_padded = add_horizontal_border(longest_line_length, "_", border_colour);
          quote_padded += add_horizontal_border(longest_line_length, "-", border_colour);
          
          /*
          Apply padding and border to each line in the quote
          */
          quote.split("\n").forEach(
            function(line_iter){
                quote_padded += add_border_to_line(line_iter, border_colour, longest_line_length) + "\n";
            }
          );
        
          /*
          End with bottom border
          */
          quote_padded += add_horizontal_border(longest_line_length, "-", border_colour);
          quote_padded += add_horizontal_border(longest_line_length, "‾", border_colour);
          return quote_padded;
        }


inputs:
  input_quote:
    type: string
    doc: The cow with the quote to use
  input_colour:
    type: ../enums/border_colours.yaml#border_colours
    doc: The border colour to use

outputs:
  output_quote_with_border:
    type: string
    doc: The quote (and cow) is now padded with a border

expression: |
  ${
    return {
      "output_quote_with_border": apply_border_to_each_line(inputs.input_quote, inputs.input_colour)
    };
  }