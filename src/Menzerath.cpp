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


  int valid_annotations()
  {
    //return 1 when discontinued constituent delimiters are not balanced
    //return 2 when a construct delimiter is not after a constituent and a subconstituent delimiter
    //return 3 when a constituent delimiter is not after a subconstituent delimiter
    int stack = 0;
    char lag1 = '\0';
    char lag2 = '\0';
    IntegerVector error_location;
    for(int i = 0 ; i < text.length(); i++)
    {
      if(text[i] == discontinued_constituent_delimiter_begin){
        stack++;
      }else if(text[i] == discontinued_constituent_delimiter_end){
        stack--;
        if(stack < 0)
        {
          return 1;
        }
      }else if(text[i] == construct_delimiter){
        if(lag1 != constituent_delimiter || lag2 != subconstituent_delimiter)
        {
          return 2;
        }
      }else if(text[i] == constituent_delimiter){
        if(lag1 != subconstituent_delimiter)
        {
          return 3;
        }
      }
      lag2 = lag1;
      lag1 = text[i];
    }
    if(stack == 0)
    {
      return 0;
    }
    else
    {
      return 1;
    }
    return 0;
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
  int validation_result = annotated_text_instance->valid_annotations();
  if( validation_result != 0){
    return DataFrame::create(Named("Errors") = validation_result);
  }
  annotated_text_instance->calculate_menzerath();
  DataFrame result = DataFrame::create(Named("constituents") = annotated_text_instance->constituents_in_construct,
                                       Named("subconstituents") = annotated_text_instance->subconstituents_in_construct,
                                       Named("constructs") = annotated_text_instance->constructs);
  delete annotated_text_instance;
  return result;


}
