// Generated by using Rcpp::compileAttributes() -> do not edit by hand
// Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

#include <Rcpp.h>

using namespace Rcpp;

// process_text
DataFrame process_text(std::string text, char construct_delimiter, char constituent_delimiter, char subconstituent_delimiter, char discontinued_constituent_delimiter_begin, char discontinued_constituent_delimiter_end);
RcppExport SEXP _menzerath_process_text(SEXP textSEXP, SEXP construct_delimiterSEXP, SEXP constituent_delimiterSEXP, SEXP subconstituent_delimiterSEXP, SEXP discontinued_constituent_delimiter_beginSEXP, SEXP discontinued_constituent_delimiter_endSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< std::string >::type text(textSEXP);
    Rcpp::traits::input_parameter< char >::type construct_delimiter(construct_delimiterSEXP);
    Rcpp::traits::input_parameter< char >::type constituent_delimiter(constituent_delimiterSEXP);
    Rcpp::traits::input_parameter< char >::type subconstituent_delimiter(subconstituent_delimiterSEXP);
    Rcpp::traits::input_parameter< char >::type discontinued_constituent_delimiter_begin(discontinued_constituent_delimiter_beginSEXP);
    Rcpp::traits::input_parameter< char >::type discontinued_constituent_delimiter_end(discontinued_constituent_delimiter_endSEXP);
    rcpp_result_gen = Rcpp::wrap(process_text(text, construct_delimiter, constituent_delimiter, subconstituent_delimiter, discontinued_constituent_delimiter_begin, discontinued_constituent_delimiter_end));
    return rcpp_result_gen;
END_RCPP
}

static const R_CallMethodDef CallEntries[] = {
    {"_menzerath_process_text", (DL_FUNC) &_menzerath_process_text, 6},
    {NULL, NULL, 0}
};

RcppExport void R_init_menzerath(DllInfo *dll) {
    R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
}