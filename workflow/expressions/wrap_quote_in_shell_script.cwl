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
id: wrap-quote-in-shell-script
label: Wrap quote in shell script
doc: |
  Wrap a quote in a shell script by 
  1. Adding a shebang
  2. Wrapping each line in an echo -e
  3. Escaping all single quotes by wrapping them in double quotes

requirements:
  InlineJavascriptRequirement:
    expressionLib:
      - function wrap_single_quotes(string_to_wrap){
          /*
          Single quotes inside string need to be wrapped
          Rather than using .replace we need to apply this globally, so use split + join instead
          */
          return string_to_wrap.split("'").join("'" + '"' + "'" + '"' + "'");
        }
      - function wrap_line_in_echo(line_string){
          /*
          Adds the echo -e prefix
          Wraps the single quotes in double quotes by - ending the single quote, 
          adding a single quote in double quotes, resuming the single quote
          Escapes double backslashes by adding in an extra backslash
          */
          return
            "echo -e '" + wrap_single_quotes(line_string) + "'"
          ;
        }
      - function wrap_quote_in_shell_script(input_quote){
          var input_quote_in_shell_script = "#!/usr/bin/env bash\n";
          input_quote.split("\n").forEach(
            function(line_iter){
                input_quote_in_shell_script += wrap_line_in_echo(line_iter) + "\n";
            }
          );
          return input_quote_in_shell_script;
        }


inputs:
  input_string:
    type: string
    doc: The input string to wrap in a shell script

outputs:
  output_quote_in_shell_script:
    type: string
    doc: The cow is now wrapped in a shell script

expression: |
  ${
    return {
      "output_quote_in_shell_script": wrap_quote_in_shell_script(inputs.input_string)
    };
  }