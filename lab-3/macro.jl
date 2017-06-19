macro fill_series_1(expr)
  left, right = expr.args
  i = left.args[2]
  quote
    for $i in 1:(length($(left.args[1])))
      try $expr
        catch BoundsError
      end
    end
  end
end

function index_range(expr::AbstractString) 
  min = 0
  max = 0
   
  s = parse(expr)
  symbol = s.args[1].args[1]
  
  for i in s.args[2].args
    if(typeof(i) == Expr)
      tmp = i.args[2]

      if(tmp.args[1] == symbol)
        tmp = tmp.args[2]
      end

      s = string(tmp)
      s = s[3:length(s)]
      val = parse(Int64,s,10)

      if(val < min)
        min = val
      elseif(val > max)
        max = val
      end

    end
  end

  min = abs(min) + 1
  max = N - max
  return [min, max]
end

macro fill_series_2(expr)
  minval = index_range(string(expr))[1]
  maxval = index_range(string(expr))[2]
  quote
    t = $minval
    while t <= $maxval
      $expr
      t += 1
    end
  end
end


