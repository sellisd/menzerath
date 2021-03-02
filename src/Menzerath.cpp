#include <string>
#include <iostream>
#include <vector>
#include <Rcpp.h>

using namespace Rcpp;

class AnnotatedText
{
public:
  std::string text;
  char construct_delimiter;
  char constituent_delimiter;
  char subconstituent_delimiter;
  char discontinued_constituent_delimiter_begin;
  char discontinued_constituent_delimiter_end;
  IntegerVector constituents_in_construct;
  IntegerVector subconstituents_in_construct;
  std::vector<std::string> constructs;
  AnnotatedText(std::string a = "Greece* {which* is* the* most* beau*ti*ful* coun*try* +I* know* +}was* the* first* place* +we* vi*si*ted* in* Eu*ro*pe* +.",
                char b = '+',
                char c = ' ',
                char d = '*',
                char e = '{',
                char f = '}')
  {
    text = a;
    construct_delimiter = b;
    constituent_delimiter = c;
    subconstituent_delimiter = d;
    discontinued_constituent_delimiter_begin = e;
    discontinued_constituent_delimiter_end = f;
  }

  void print_values()
  {
    Rcout << "constituents\tsubconstituents\tconstruct" << std::endl;
    for (int i = 0; i < constructs.size(); i++)
    {
      Rcout << constituents_in_construct.at(i) << "\t" << subconstituents_in_construct.at(i) << "\t" << std::endl;
    }
  }

  void calculate_menzerath()
  {
    int start = 0;
    calculate_menzerath_recursive(&start);
  }

private:
  void calculate_menzerath_recursive(int *position)
  {
    int subconstituent = 0;
    int constituent = 0;
    std::string construct = "";
    while (*position < text.length() and text.at(*position) != discontinued_constituent_delimiter_end)
    {
      char character = text.at(*position);
      construct.push_back(character);
      if (character == construct_delimiter)
      {
        constituents_in_construct.push_back(constituent);
        subconstituents_in_construct.push_back(subconstituent);
        constructs.push_back(construct);
        subconstituent = 0;
        constituent = 0;
        construct = "";
      }
      else if (character == constituent_delimiter)
      {
        constituent++;
      }
      else if (character == subconstituent_delimiter)
      {
        subconstituent++;
      }
      else if (character == discontinued_constituent_delimiter_begin)
      {
        (*position)++;
        calculate_menzerath_recursive(position);
      }
      (*position)++;
    }
  }
};


//' Process annotated text
//'
//' @param text string
//' @param construct_delimiter char
//' @param constituent_delimiter char
//' @param subconstituent_delimiter char
//' @param discontinued_constituent_delimiter_begin char
//' @param discontinued_constituent_delimiter_end char
//' @return data.frame A data.frame with three columns: constituents, subconstituents and constructs
//' @examples
//' annotated_text <- paste0("Greece* {which* is* the* most* beau*ti*ful* coun*try*",
//'                         " +I* know* +}was* the* first* place* +we* vi*si*ted* in*",
//'                         "Eu*ro*pe* +.")
//'  counts_df <- process_text(annotated_text, "+", " ", "*", "{", "}")
//' @export
// [[Rcpp::export]]
DataFrame process_text(std::string text,
                       char construct_delimiter,
                       char constituent_delimiter,
                       char subconstituent_delimiter,
                       char discontinued_constituent_delimiter_begin,
                       char discontinued_constituent_delimiter_end)
{
  AnnotatedText *annotated_text_instance = new AnnotatedText(text,
                                                             construct_delimiter,
                                                             constituent_delimiter,
                                                             subconstituent_delimiter,
                                                             discontinued_constituent_delimiter_begin,
                                                             discontinued_constituent_delimiter_end);
  annotated_text_instance->calculate_menzerath();
  DataFrame result = DataFrame::create(Named("constituents") = annotated_text_instance->constituents_in_construct,
                                       Named("subconstituents") = annotated_text_instance->subconstituents_in_construct,
                                       Named("constructs") = annotated_text_instance->constructs);
  delete annotated_text_instance;
  return result;
}
