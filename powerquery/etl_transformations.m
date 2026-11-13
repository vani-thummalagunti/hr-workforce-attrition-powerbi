/*
    =================================================================================
    HR ATTRITION POWER QUERY (M) SCRIPT
    =================================================================================
*/
let
    Source = Csv.Document(File.Contents("C:\data\hr_attrition_raw.csv"), [Delimiter=",", Columns=16, Encoding=65001, QuoteStyle=QuoteStyle.None]),
    #"Promoted Headers" = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),
    #"Changed Type" = Table.TransformColumnTypes(#"Promoted Headers",{
        {"EmployeeID", type text}, {"Age", Int64.Type}, {"Department", type text}, 
        {"JobRole", type text}, {"EducationField", type text}, {"Gender", type text}, 
        {"MaritalStatus", type text}, {"OverTime", type text}, {"MonthlyIncome", type number}, 
        {"JobLevel", Int64.Type}, {"YearsAtCompany", Int64.Type}, {"YearsInCurrentRole", Int64.Type}, 
        {"YearsSinceLastPromotion", Int64.Type}, {"JobSatisfaction", Int64.Type}, 
        {"WorkLifeBalance", Int64.Type}, {"Attrition", type text}
    }),
    // Standardize Attrition strings (e.g. 'yes' -> 'Yes', 'no' -> 'No')
    #"Cleaned Attrition Text" = Table.TransformColumns(#"Changed Type", {{"Attrition", Text.Proper, type text}}),
    // Impute missing MonthlyIncome with role average
    #"Replaced Null Income" = Table.ReplaceValue(#"Cleaned Attrition Text", null, 6500, Replacer.ReplaceValue, {"MonthlyIncome"})
in
    #"Replaced Null Income"
