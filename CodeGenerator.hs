module CodeGenerator where

functionCall :: [String] -> [String] -> [String]
functionCall [] output = output
functionCall intRep output
    -- Opening tags
    | token == "sTag" && attribute == "document" = functionCall (tail intRep) (output ++ "\\documentclass[11pt]{article}\n\n\\begin{document}")
    | token == "sTag" && attribute == "bold" = functionCall (tail intRep) (output ++ "\\textbf{")
    | token == "sTag" && attribute == "p" = functionCall (tail intRep) (output ++ "\\n")
    | token == "sTag" && attribute == "italics" = functionCall (tail intRep) (output ++ "\\textit{")
    | token == "sTag" && attribute == "em" = functionCall (tail intRep) (output ++ "\\textit{")
    | token == "sTag" && attribute == "pre" = functionCall (tail intRep) (output ++ "\\begin{verbatim}")
// ...
// ...

    -- Closing tags
    | token == "eTag" && attribute == "pre" = functionCall (tail intRep) (output ++ "\\end{verbatim}")
    | token == "eTag" &&
        attribute == "bold" ||
        attribute == "i" ||
        attribute == "em" = functionCall (tail intRep) (output ++ "}")
    | token == "eTag" && attribute == "pre" = functionCall (tail intRep) (output ++ "\\end{document}")

    where
        token = fst $ head intRep
        attribute = snd $ head intRep

construct :: [[Char]] -> [Char] -> [Char] -> [Char]
construct [] storedValue final = []
construct (x:xs) storedValue final
    | x == "<" = construct xs "<" final
    | storedValue ++ x == "</" = construct xs "</" final

    -- new lines
    | x == "\\" = construct xs "\\" final
    | storedValue ++ x == "\n" = construct xs "" final

    -- bold
    | storedValue ++ x == "<b" = construct xs "<b" final
    | storedValue ++ x == "<b>" = "\\textbf{" ++ construct xs "" final

    | storedValue ++ x == "</b" = construct xs "</b" final
    | storedValue ++ x == "</b>" = "}" ++ construct xs "" final

    -- italics
    | storedValue ++ x == "<i" = construct xs "<i" final
    | storedValue ++ x == "<i>" = "\\textit{" ++ construct xs "" final

    | storedValue ++ x == "</i" = construct xs "</i" final
    | storedValue ++ x == "</i>" = "}" ++ construct xs "" final

    -- emphasis
    | storedValue ++ x == "<e" = construct xs "<e" final
    | storedValue ++ x == "<em" = construct xs "<em" final
    | storedValue ++ x == "<em>" = "\\textit{" ++ construct xs "" final

    | storedValue ++ x == "</e" = construct xs "</e" final
    | storedValue ++ x == "</em" = construct xs "</em" final
    | storedValue ++ x == "</em>" = "}" ++ construct xs "" final

    -- paragraph
    | storedValue ++ x == "<p" = construct xs "<p" final
    | storedValue ++ x == "<p>" = "\n" ++ construct xs "" final

    | storedValue ++ x == "</p" = construct xs "</p" final
    | storedValue ++ x == "</p>" = "\n" ++ construct xs "" final

    -- body
    | storedValue ++ x == "<b" = construct xs "<b" final
    | storedValue ++ x == "<bo" = construct xs "<bo" final
    | storedValue ++ x == "<bod" = construct xs "<bod" final
    | storedValue ++ x == "<body" = construct xs "<body" final
    | storedValue ++ x == "<body>" = construct xs "" final

    | storedValue ++ x == "</b" = construct xs "</b" final
    | storedValue ++ x == "</bo" = construct xs "</bo" final
    | storedValue ++ x == "</bod" = construct xs "</bod" final
    | storedValue ++ x == "</body" = construct xs "</body" final
    | storedValue ++ x == "</body>" = construct xs "" final

    -- pre
    | storedValue ++ x == "<p" = construct xs "<p" final
    | storedValue ++ x == "<pr" = construct xs "<pr" final
    | storedValue ++ x == "<pre" = construct xs "<pre" final
    | storedValue ++ x == "<pre>" = "\\begin{verbatim}" ++ construct xs "" final

    | storedValue ++ x == "</p" = construct xs "</p" final
    | storedValue ++ x == "</pr" = construct xs "</pr" final
    | storedValue ++ x == "</pre" = construct xs "</pre" final
    | storedValue ++ x == "</pre>" = "\\end{verbatim}" ++ construct xs "" final

    -- head
    | storedValue ++ x == "<h" = construct xs "<h" final
    | storedValue ++ x == "<he" = construct xs "<he" final
    | storedValue ++ x == "<hea" = construct xs "<hea" final
    | storedValue ++ x == "<head" = construct xs "<head" final
    | storedValue ++ x == "<head>" = construct xs "" final

    | storedValue ++ x == "</h" = construct xs "</h" final
    | storedValue ++ x == "</he" = construct xs "</he" final
    | storedValue ++ x == "</hea" = construct xs "</hea" final
    | storedValue ++ x == "</head" = construct xs "</head" final
    | storedValue ++ x == "</head>" = construct xs "" final

    -- html
    | storedValue ++ x == "<h" = construct xs "<h" final
    | storedValue ++ x == "<ht" = construct xs "<ht" final
    | storedValue ++ x == "<htm" = construct xs "<htm" final
    | storedValue ++ x == "<html" = construct xs "<html" final
    | storedValue ++ x == "<html>" = construct xs "" final

    | storedValue ++ x == "</h" = construct xs "</h" final
    | storedValue ++ x == "</ht" = construct xs "</ht" final
    | storedValue ++ x == "</htm" = construct xs "</htm" final
    | storedValue ++ x == "</html" = construct xs "</html" final
    | storedValue ++ x == "</html>" = construct xs "" final

    -- maths mode
    | x == ">" = "$>$" ++ construct xs "" final
    | x == "=" = "$=$" ++ construct xs "" final
    | storedValue ++ x == "< " = "$<$ " ++ construct xs "" final

    | otherwise = x ++ construct xs "" final
