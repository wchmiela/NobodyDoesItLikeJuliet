function f1()
	 m = 10000
	 for i=1:m
	     k = 6
	     d = k + 2
	     str = string(d,"test")
	 end
end

function f2()
	 m = 100000
	 for i=1:m
	     k = 6
	     d = k + 2
	     str = string(d,"test")
	 end
end

#run section

function runner()
	 local n = 500

	 for i = 1:n
	     f1()
	     f2()
	 end
end	 