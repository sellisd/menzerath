#include <string>
#include <iostream>
#include <vector>

class Menzerath
{
public:
  std::string text;
  char construct_delimiter;
  char constituent_delimiter;
  char subconstituent_delimiter;
  char discontinued_constituent_delimiter_begin;
  char discontinued_constituent_delimiter_end;
  std::vector<int> constituents_in_construct;
  std::vector<int> subconstituents_in_construct;
  std::vector<std::string> constructs;
  Menzerath(std::string a = "Greece* {which* is* the* most* beau*ti*ful* coun*try* +I* know* +}was* the* first* place* +we* vi*si*ted* in* Eu*ro*pe* +.",
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

  void calculate_menzerath(int *position)
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
        calculate_menzerath(position);
      }
      (*position)++;
    }
  }

  void print_values()
  {
    std::cout<<"constituents\tsubconstituents\tconstruct"<<std::endl;
    for (int i = 0; i < constructs.size(); i++)
    {
      std::cout << constituents_in_construct.at(i) << "\t" << subconstituents_in_construct.at(i) << "\t"<<constructs.at(i) << std::endl;
    }
  }
};

int main()
{
  int start = 0;
  Menzerath myMenz = Menzerath();
  myMenz.calculate_menzerath(&start);
  myMenz.print_values();
  return 0;
}
