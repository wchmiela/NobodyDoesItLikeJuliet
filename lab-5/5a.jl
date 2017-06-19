function numbersYield(n::Integer)
  @sync begin
    for i in 1:3
      @async begin
        for a in 1:n
          print(i)
          yield()
        end
      end
    end
  end
end


function produceNumber(number::Integer, n::Integer)
  for i = 1:n
    produce(number)
  end
end

function consumeNumber(p::Task)
  print(consume(p))
  print(" ")
end

function numbersProdCon(n::Integer)
  p1 = @task produceNumber(1,n)
  p3 = @task produceNumber(3,n)
  p2 = @task produceNumber(2,n)
  for i = 1:n
    consumeNumber(p1)
    consumeNumber(p2)
    consumeNumber(p3)
  end
end