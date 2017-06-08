function types(typed::DataType)
  println(typed)
  while typed != Any
    typed = supertype(typed)
      println(typed)
  end
end

types(Float16)
