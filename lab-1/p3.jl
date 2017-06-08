type PlaceOccupied <: Exception end

type Position
     x::Int
     y::Int
end

abstract Zwierze

type NULL <: Zwierze end

type Drapieznik <: Zwierze
     name::String
     attack::Float16
     position::Position
end

type Ofiara <: Zwierze
     name::String
     defense::Float16
     position::Position
end

type Swiat
     width::Int
     height::Int
     mapa
end

function initWorld(world::Swiat)
	 for i = 1:n
	     for j = 1:n
	         oneWorld.mapa[i,j] = NULL()
	     end
	 end
end

function printWorld(world::Swiat)
	 println("Swiat: D - drapieznik, O - ofiara")
	 for i = 1:world.width
	     for j = 1:world.height
	         if (world.mapa[i,j] == NULL())
		     print("N")
		 elseif (typeof(world.mapa[i,j]) == Ofiara)
		     print("O")
		 elseif (typeof(world.mapa[i,j]) == Drapieznik)
		     print("D")
		 end
		 print(" ")
	     end
	     println()
	 end
end

function addAnimal(animal::Zwierze, world::Swiat)
	 if world.mapa[animal.position.x, animal.position.y] != NULL()
	     throw(PlaceOccupied)
	 else
	     world.mapa[animal.position.x, animal.position.y] = animal
	 end	  
end

function seek(animal::Zwierze, world::Swiat)
	 for i = 1:world.width
	     for j = 1:world.height
	     	 if world.mapa[i,j] == NULL()
		    return Position(i,j)
		 end
	     end
	 end

	 return Position(0,0)
end


function odleglosc{T1 <: Zwierze, T2 <: Zwierze}(a1::T1, a2::T2)
	 return abs(a1.position.x - a2.position.x) + abs(a1.position.y - a2.position.y)
end


function interakcja(o::Ofiara, d::Drapieznik, world::Swiat)
  local newPositionVictim = seek(o,world)
  local newPositionPredator = o.position

  world.mapa[d.position.x, d.position.y] = NULL()
  world.mapa[o.position.x, o.position.y] = d
  world.mapa[newPositionVictim.x, newPositionVictim.y] = o
  
  d.position = newPositionPredator
  o.position = newPositionVictim

end

function interakcja(d::Drapieznik, o::Ofiara, world::Swiat)
  local newPositionVictim = o.position

  world.mapa[d.position.x,d.position.y] = NULL()
  world.mapa[o.position.x,o.position.y] = d

  d.position = newPositionVictim
  o = NULL()
end

function interakcja(d1::Drapieznik, d2::Drapieznik, world::Swiat)
	 "Wrrrr"
end

function interakcja(o1::Ofiara, o2::Ofiara, world::Swiat)
	 "Beeee"
end

#run section

n = 3

oneWorld = Swiat(n,n,Array(Zwierze,n,n))

initWorld(oneWorld)

predator = Drapieznik("lew",1.32,Position(1,1))
predator2 = Drapieznik("nosorożec",1.22,Position(1,2))

victim = Ofiara("antylopa",0.59,Position(2,3))
victim2 = Ofiara("zebra",1.09,Position(3,3))

addAnimal(predator,oneWorld)
addAnimal(predator2,oneWorld)
#addAnimal(predator2,oneWorld)

addAnimal(victim,oneWorld)
addAnimal(victim2,oneWorld)

printWorld(oneWorld)

println("Odleglosc w metryce taksowkowej miedzy (1,1) a (1,2): ",odleglosc(predator,victim))

println(interakcja(predator,predator2,oneWorld))
println(interakcja(victim, victim2, oneWorld))

println("Interakcja ofiara-drapieznik")
interakcja(victim,predator,oneWorld)
printWorld(oneWorld)

println("Interakcja drapieznik-ofiara")
interakcja(predator,victim,oneWorld)
printWorld(oneWorld)



