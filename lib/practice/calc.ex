defmodule Practice.Calc do
  def parse_float(text) do
    {num, _} = Float.parse(text)
    num
  end

  def calc(expr) do
    expr
    |> String.split(~r/\s+/)
    |> evaluate

    #expr
    #|> String.split(~r/\s+/)
    #|> tagTokens
    #|> convertPostfix
    #|> reversePrefix
    #|> eval

    # Hint:
    # expr
    # |> split
    # |> tag_tokens  (e.g. [+, 1] => [{:op, "+"}, {:num, 1.0}]
    # |> convert to postfix
    # |> reverse to prefix
    # |> evaluate as a stack calculator using pattern matching

  end

  defp tagTokens(list) do
    if (length(list) > 0) do
      value = hd(list)
      tag = value
            |> getTag

      if (tag == :num), do: value = parse_float(value)
      [{tag, value}] ++ tagTokens(tl(list))
    else
      []
    end
  end

  defp getTag(value) do
    case value do
      o when o in ["+", "-", "*", "/"] -> :op
      _ -> :num
    end
  end

  # credit to: https://www.geeksforgeeks.org/convert-infix-prefix-notation/
  defp convertPostfix(list) do
    # '@' here is a placeholder for the bottom of the stack
    convertPostfixHelper(list, ["@"])
  end

  defp isOperator(value) do
    value == "+"
    || value == "-"
    || value == "*"
    || value == "/"
  end

  # TODO: finish
  defp convertPostfixHelper(list, stack) do
    if (length(list) > 0) do
      tag = list
            |> hd
            |> elem(0)
      value = list
              |> hd
              |> elem(1)
      if (tag == :num) do
        [{tag, value} | convertPostfixHelper(tl(list), stack)]
      else # operator
        # TODO: handle operator case

        top = hd(stack)
        if (isOperator(top)) do
          if (getPriority(value) < getPriority(top)) do
            [{tag, top} | convertPostfixHelper(tl(list), tl(stack))]
          else
          end
        else
        # else not an operator (bottom of the stack) - push onto stack
          [{tag, top} | convertPostfixHelper(tl(list), [value | stack])]
        end

        [{tag, value} | convertPostfixHelper(tl(list), tl(stack))]
      end
    else
      list
    end

  end

  # done
  defp getPriority(rator) do
    if (rator == "*" || rator == "/"), do: 2
    if (rator == "+" || rator == "-"), do: 1
    0
  end

  # done
  defp reversePrefix(list) do
    Enum.reverse(list)
  end

  # TODO: finish
  defp eval(stack) do
  end


  # does not take into account operator precedence
  defp evaluate(stack) do
    result = 0
    if (length(stack) >= 3) do
      rand1 = stack
              |> hd
              |> parse_float
      rator = stack
              |> tl
              |> hd
      rand2 = stack
              |> tl
              |> tl
              |> hd
              |> parse_float
      result = to_string(calc(rand1, rator, rand2))
      [
        result | (
          stack
          |> tl
          |> tl
          |> tl)
      ]
      |> evaluate
    else
      stack
      |> hd
      |> Float.parse
      |> elem(0)
    end
  end


  defp calc(rand1, rator, rand2) do
    case rator do
      "+" -> rand1 + rand2
      "-" -> rand1 - rand2
      "*" -> rand1 * rand2
      "/" -> rand1 / rand2
      _ -> raise "Unknown operator"
    end
  end

  # idea for getPrimes() was taken from here:
  # https://www.geeksforgeeks.org/print-all-prime-factors-of-a-given-number/
  def factor(x) do
    getPrimes(x, [])
  end

  defp getPrimes(number, factors) do
    if (rem(number, 2) == 0) do
      getPrimes(div(number, 2), factors ++ [2])
    else
      doOddPrimes(number, factors, 3)
    end
  end

  defp doOddPrimes(number, factors, i) do
    if (i <= :math.sqrt(number)) do
      if (rem(number, i) == 0) do
        doOddPrimes(div(number, i), factors ++ [i], i)
      else
        doOddPrimes(number, factors, i + 2)
      end
    else
      if (number != 1) do
        factors ++ [number]
      else
        factors
      end
    end
  end

  def palindrome(word) do
    if (String.reverse(word) == word) do
      "is a palindrome!"
    else
      "is not a palindrome!"
    end
  end

end
