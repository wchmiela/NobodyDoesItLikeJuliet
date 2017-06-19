module Graphs

using StatsBase

export GraphVertex, NodeType, Person, Address,
       generate_random_graph, get_random_person, get_random_address, generate_random_nodes,
       convert_to_graph,
       bfs, check_euler, partition,
       graph_to_str, node_to_str,
       test_graph

# Types of valid graph node's values.
abstract NodeType

#= Single graph vertex type.
Holds node value and information about adjacent vertices =#
type GraphVertex
  value::NodeType	#optymalizacja
  neighbors::Vector	#optymalizacja
end


type Person <: NodeType
  name::String		#optymalizacja
end

type Address <: NodeType
  streetNumber::Int64	#optymalizacja
end


# Number of graph nodes.
const N = 800		#optymalizacja

# Number of graph edges.
const K = 10000		#optymalizacja


#= Generates random directed graph of size N with K edges
and returns its adjacency matrix.=#
function generate_random_graph()
    A = zeros((N,N))	#optymalizacja - skorzystanie z funkcji bibliotecznej

    for i in sample(1:N*N, K, replace=false)
      A[i] = 1
    end
    A
end

# Generates random person object (with random name).
function get_random_person()
  Person(randstring()::String)	#optymalizacja
end

# Generates random person object (with random name).
function get_random_address()
  Address(rand(1:100)::Int64)	#optymalizacja
end

# Generates N random nodes (of random NodeType).
function generate_random_nodes()
  nodes = Vector()
  for i= 1:N
    push!(nodes, rand() > 0.5 ? get_random_person() : get_random_address())
  end
  nodes
end

#= Converts given adjacency matrix (NxN)
  into list of graph vertices (of type GraphVertex and length N). =#
function convert_to_graph(A, nodes)
  graph = GraphVertex[]
  push!(graph, map(n -> GraphVertex(n, GraphVertex[]), nodes)...)


  for j = 1:N, i = 1:N		       #optymalizacja -  zamiana i/j
      if A[i,j] == 1
        push!(graph[j].neighbors, graph[i])
      end
  end
end

#= Groups graph nodes into connected parts. E.g. if entire graph is connected,
  result list will contain only one part with all nodes. =#
function partition()
  parts = []
  remaining = Set(graph)
  visited = bfs(graph, remaining=remaining)
  push!(parts, Set(visited))

  while !isempty(remaining)
    new_visited = bfs(graph, visited=visited, remaining=remaining)
    push!(parts, new_visited)
  end
  parts
end

#= Performs BFS traversal on the graph and returns list of visited nodes.
  Optionally, BFS can initialized with set of skipped and remaining nodes.
  Start nodes is taken from the set of remaining elements. =#
function bfs(graph::Array{GraphVertex,1}; visited=Set(), remaining=Set(graph))
  first = next(remaining, start(remaining))[1]
  q = [first]
  push!(visited, first)
  delete!(remaining, first)
  local_visited = Set([first])

  while !isempty(q)
    v = pop!(q)

    for n in v.neighbors
      if !(n in visited)
        push!(q, n)
        push!(visited, n)
        push!(local_visited, n)
        delete!(remaining, n)
      end
    end
  end
  local_visited
end

#= Checks if there's Euler cycle in the graph by investigating
   connectivity condition and evaluating if every vertex has even degree =#
function check_euler()
  if length(partition()) == 1
    return all(map(v -> iseven(length(v.neighbors)), graph))
  end
    "Graph is not connected"
end

# Optymalizacja - Podzielenie na dwie mniejsze funkcje
function graph_vertex_to_str(v::GraphVertex)
	 graph_vertex_str = "****\n"
	 graph_vertex_str *= node_to_str(v.value)
	 graph_vertex_str *= neighbours_to_str(v.neighbours)
end

#= Returns text representation of the graph consisiting of each node's value
   text and number of its neighbors. =#
function graph_to_str(graph::Array{GraphVertex,1})	#optymalizacja
  graph_str = ""
  for v in graph
      graph_str *= graph_vertex_to_str(v)
  end
  graph_str
end

#= Tests graph functions by creating 100 graphs, checking Euler cycle
  and creating text representation. =#
function test_graph()
  for i=1:100
    global graph = GraphVertex[]

    A = generate_random_graph()
    nodes = generate_random_nodes()
    convert_to_graph(A, nodes)

    str = graph_to_str(graph)
    #println(str)
    # println(check_euler())
  end
end

end

