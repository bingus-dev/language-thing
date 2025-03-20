local tokenizer = {}

-- Token syntax works like this:
--
-- each_recognized_statement = 'something'
--
-- In this statement:
-- 1). Tokenizer takes note of the first keyword "each_recognized_statement".
--     It has no idea what it is there for, so keeps going while keeping knowledge of it.
--
-- 2). Tokenizer finds the equals sign and appends "set" to beginning of token table.
--     This serves as the function that the language needs to figure out what to do.
--
-- 3). Tokenizer adds what is equal to at end of table.
--
-- All together, it looks like this:
--    {"set" "each_recognized_statement", "something"}
--
-- Here's a couple special keywords it uses to do more special things
-- When a function or other operation happens in a statement, it adds it to a line
-- before to be parsed first.

function tokenizer.linetotokens(line)
    if type(line) ~= string then
        return false, "Tokenizer received non-string statement to parse"
    end

    local this_token = {"action"}

    local splitted_statement = line.split("")
    local statement_keywords = {}
    local this_keyword = ""

    local parsed_action = false

    for idx, char in splitted_statement do
        local this_action = ""

        -- Variables
        if char == "=" then
            this_action = "set"
        end

        -- Math
        if char == "+" then
            this_action = "math_add"
        end

        if char == "-" then
            this_action = "math_subtract"
        end

        if char == "*" then
            this_action = "math_multiply"
        end

        if char == "/" then
            this_action = "math_divide"
        end

        if char == "/" and this_keyword == "/" and this_action == "math_divide" then
            this_action = "math_remainder"
        end

        -- Comparison
        if char == "!=" then
            this_action = "bool_not"
        end

        if char == "==" then
            this_action = "bool_is"
        end

        if char == ">" then
            this_action = "math_greaterthan"
        end

        if char == "<" then
            this_action = "math_lessthan"
        end

        if char == ">=" then
            this_action = "math_e_greaterthan"
        end

        if char == "<=" then
            this_action = "math_e_lessthan"
        end

        if this_token[1] ~= "action" then
            this_token[3] = this_token[3] .. char
        end
    end
end

return tokenizer